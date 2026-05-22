import { Conversation, ConversationInfo } from "../entries/conversation"
import { relationalStore } from "@kit.ArkData"
import { JimUtil } from "../commons/jimutil"
import { JimDbUtil } from "./dbutil"
import { Message } from "../entries/message";
import { JimDbManager } from "./dbmanager";
import { MsgHandler } from "../entries/msghandler";
import { GetConversationDirection, GetConversationOptions } from "../interfaces/conversationtypes";
import { ConverTagDao } from "./convertagdao";

export class ConversationDao{
  static instance:ConversationDao = new ConversationDao()
  private tableName:string = "conversations"
  private constructor() {
  }

  queryConversations(start:number,count:number,isPositive:boolean):ConversationInfo[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE `
    if(isPositive){
      sql = sql + ` conver_time > ? order by conver_time asc`
    }else{
      sql = sql + ` conver_time < ? order by conver_time desc`
    }
    sql = sql + ` LIMIT ${count}`
    let args:Array<relationalStore.ValueType> = []
    args.push(start)
    let resultSet:relationalStore.ResultSet|undefined
    let converList:ConversationInfo[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let conver = this.toConver(resultSet)
        converList.push(conver)
      }
    }catch (e) {
      console.error("jimsdk_db_failed. ",this.tableName,`err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return converList
  }

  queryConversationsWithOptions(options:GetConversationOptions):ConversationInfo[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE `
    let args:Array<relationalStore.ValueType> = []
    let time = options.time
    if(time <= 0){
      time = new Date().getTime()
    }
    if(options.direction == GetConversationDirection.Forward){
      sql = sql + ` conver_time > ?`
    }else{
      sql = sql + ` conver_time < ?`
    }
    args.push(time)
    if(options.conversationTypes.length > 0){
      let placeholders:string[] = []
      options.conversationTypes.forEach((conversationType:number)=>{
        placeholders.push('?')
        args.push(conversationType)
      })
      sql = sql + ` AND conver_type IN (${placeholders.join(', ')})`
    }
    if(options.tagId != ''){
      sql = sql +
        ` AND EXISTS (SELECT 1 FROM conversation_tags tags WHERE tags.conver_type=${this.tableName}.conver_type AND tags.conver_id=${this.tableName}.conver_id AND tags.tag_id=?)`
      args.push(options.tagId)
    }
    sql = sql + ` ORDER BY is_top DESC, top_time DESC, conver_time DESC LIMIT ${options.count}`
    let resultSet:relationalStore.ResultSet|undefined
    let converList:ConversationInfo[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let conver = this.toConver(resultSet)
        converList.push(conver)
      }
    }catch (e) {
      console.error("jimsdk_db_failed. ",this.tableName,`err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return converList
  }

  upsert(conver:ConversationInfo):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (conver_id,conver_type,draft,conver_time,last_msg_id,last_msg_time,last_msg_seq_no,last_read_msg_index,last_msg_index,last_msg_type,last_msg_content,last_msg_client_id,last_msg_direction,last_msg_state,last_msg_has_read,last_msg_sender_id,is_top,top_time,is_mute,unread_tag,mention_info,last_msg_mention_info) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`
    let args:Array<relationalStore.ValueType> = []
    let draft = conver.draft
    if(draft == ''){
      let oldConver = this.getConver(conver.conversation)
      if(oldConver != undefined){
        draft = oldConver.draft
      }
    }
    args.push(conver.conversation.conversationId)
    args.push(conver.conversation.conversationType)
    args.push(draft)
    // args.push(conver.syncTime)
    args.push(conver.converTime)
    args.push(conver.lastMessage.messageId)
    args.push(conver.lastMessage.sentTime)
    args.push(conver.lastMessage.msgSeqNo)
    args.push(conver.lastReadMsgIndex)
    args.push(conver.lastMessage.msgUnreadIndex)
    args.push(conver.lastMessage.msgContent.getMsgType())
    args.push(JimUtil.uint8ArrayToString(conver.lastMessage.msgContent.encode()))
    args.push(conver.lastMessage.clientId)
    args.push(conver.lastMessage.direction)
    args.push(conver.lastMessage.state)
    args.push(conver.lastMessage.hasRead)
    args.push(conver.lastMessage.senderId)

    args.push(conver.isTop?1:0)
    args.push(conver.topTime)
    args.push(conver.isMute?1:0)
    args.push(conver.unreadTag)

    args.push('')//mention info
    args.push('') //last mention info
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  setDraft(conver:Conversation,draft:string):ConversationInfo|undefined{
    let normalizedDraft = draft
    let converInfo = this.getConver(conver)
    if(converInfo != undefined){
      let sql = `UPDATE ${this.tableName} SET draft=? WHERE conver_id=? AND conver_type=?`
      let args:Array<relationalStore.ValueType> = [normalizedDraft, conver.conversationId, conver.conversationType]
      try{
        JimDbManager.instance.getDb()?.executeSync(sql,args)
        converInfo.draft = normalizedDraft
        return converInfo
      }catch (e) {
        console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
        return converInfo
      }
    }
    if(normalizedDraft == ''){
      return undefined
    }
    let newConverInfo = new ConversationInfo()
    newConverInfo.conversation = conver
    newConverInfo.draft = normalizedDraft
    newConverInfo.converTime = new Date().getTime()
    newConverInfo.lastMessage.conversation = conver
    this.upsert(newConverInfo)
    return this.getConver(conver)
  }

  existByConver(conver:Conversation):boolean{
    let sql = `SELECT id FROM ${this.tableName} WHERE conver_type=? and conver_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(conver.conversationType)
    args.push(conver.conversationId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        let id=JimDbUtil.toNumber(resultSet,"id")
        if(id>0){
          return true
        }
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}], err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return false
  }

  getConver(c:Conversation):ConversationInfo|undefined{
    let sql = `SELECT * FROM ${this.tableName} WHERE conver_type=? and conver_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(c.conversationType)
    args.push(c.conversationId)
    let resultSet:relationalStore.ResultSet|undefined
    let converInfo:ConversationInfo|undefined = undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        converInfo = this.toConver(resultSet)
      }
    }catch (e) {
      console.error("failed to query conver ",this.tableName)
    }finally {
      resultSet?.close()
    }
    return converInfo
  }

  queryUnreadCountByTag(tagId:string):number{
    if(tagId == ''){
      return 0
    }
    let sql = `SELECT SUM(CASE WHEN conver.last_msg_index > conver.last_read_msg_index THEN conver.last_msg_index - conver.last_read_msg_index ELSE 0 END) AS unread_count
      FROM ${this.tableName} conver
      INNER JOIN conversation_tags tags ON tags.conver_type = conver.conver_type AND tags.conver_id = conver.conver_id
      WHERE tags.tag_id = ?`
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,[tagId])
      if(resultSet?.goToNextRow()){
        return JimDbUtil.toNumber(resultSet,'unread_count')
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return 0
  }

  delConver(converId:string,converType:number):number{
    let delPre = new relationalStore.RdbPredicates(this.tableName)
    delPre.equalTo("conver_id",converId)
    delPre.equalTo("conver_type",converType)
    try{
      let row = JimDbManager.instance.getDb()?.deleteSync(delPre)
      if(row!==undefined){
        ConverTagDao.instance.clearTags(new Conversation(converId, converType))
        return row
      }
    }catch (e) {
      console.error(`jimsdk_del [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  clearLastMessage(conver:Conversation):ConversationInfo|undefined{
    let sql = `UPDATE ${this.tableName} SET last_msg_id='',last_msg_time=0,last_msg_seq_no=0,last_msg_index=last_read_msg_index,last_msg_type='',last_msg_content='',last_msg_client_id='',last_msg_direction=0,last_msg_state=0,last_msg_has_read=0,last_msg_sender_id='',mention_info='',last_msg_mention_info='',unread_tag=0 WHERE conver_id=? AND conver_type=?`
    let args:Array<relationalStore.ValueType> = [conver.conversationId, conver.conversationType]
    try{
      JimDbManager.instance.getDb()?.executeSync(sql,args)
      return this.getConver(conver)
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
      return this.getConver(conver)
    }
  }

  updateByMessage(msg:Message):number{
    let sql = `UPDATE ${this.tableName} SET conver_time=?,last_msg_id=?,last_msg_time=?,last_msg_seq_no=?,last_msg_client_id=?,last_msg_type=?,last_msg_content=?,last_msg_state=?,last_msg_sender_id=? WHERE conver_id=? AND conver_type=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msg.sentTime)
    args.push(msg.messageId)
    args.push(msg.sentTime)
    args.push(msg.msgSeqNo)
    args.push(msg.clientId)
    args.push(msg.msgContent.getMsgType())
    args.push(JimUtil.uint8ArrayToString(msg.msgContent.encode()))
    args.push(msg.state)
    args.push(msg.senderId)

    args.push(msg.conversation.conversationId)
    args.push(msg.conversation.conversationType)

    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  private getValuesBucket(conver:ConversationInfo):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "conver_id":conver.conversation.conversationId,
      "conver_type":conver.conversation.conversationType,
      "draft":conver.draft,
      "conver_time":conver.converTime,
      "last_msg_id":conver.lastMessage.messageId,
      "last_msg_time":conver.lastMessage.sentTime,
      "last_msg_seq_no":conver.lastMessage.msgSeqNo,
      "last_read_msg_index":conver.lastReadMsgIndex,
      "last_msg_index":conver.lastMessage.msgUnreadIndex,
      "last_msg_type":conver.lastMessage.msgContent.getMsgType(),
      "last_msg_content":JimUtil.uint8ArrayToString(conver.lastMessage.msgContent.encode()),
      "last_msg_client_id":conver.lastMessage.clientId,
      "last_msg_direction":conver.lastMessage.direction,
      "last_msg_state":conver.lastMessage.state,
      "last_msg_has_read":conver.lastMessage.hasRead,
      "last_msg_sender_id":conver.lastMessage.senderId,
      "is_top":conver.isTop?1:0,
      "top_time":conver.topTime,
      "is_mute":conver.isMute?1:0,
      "unread_tag":conver.unreadTag
    }
    return valuesBucket
  }

  private toConver(resultSet:relationalStore.ResultSet):ConversationInfo{
    let conver:ConversationInfo = new ConversationInfo()
    conver.id = JimDbUtil.toNumber(resultSet, "id")
    let converId = JimDbUtil.toString(resultSet,"conver_id")
    let converType = JimDbUtil.toNumber(resultSet,"conver_type")
    conver.conversation = new Conversation(converId,converType)
    conver.draft = JimDbUtil.toString(resultSet,"draft")
    conver.converTime = JimDbUtil.toNumber(resultSet,"conver_time")

    let msg = new Message()
    msg.messageId = JimDbUtil.toString(resultSet,"last_msg_id")
    msg.sentTime = JimDbUtil.toNumber(resultSet, "last_msg_time")
    msg.msgSeqNo = JimDbUtil.toNumber(resultSet,"last_msg_seq_no")
    conver.lastReadMsgIndex = JimDbUtil.toNumber(resultSet,"last_read_msg_index")
    msg.msgUnreadIndex = JimDbUtil.toNumber(resultSet,"last_msg_index")
    let msgType = JimDbUtil.toString(resultSet,"last_msg_type")
    //content
    let dataStr = JimDbUtil.toString(resultSet,"last_msg_content")
    let data = JimUtil.stringToUint8Array(dataStr)
    msg.msgContent = MsgHandler.constructByMsgType(msgType, data)
    msg.clientId = JimDbUtil.toString(resultSet,"last_msg_client_id")
    msg.direction = JimDbUtil.toNumber(resultSet,"last_msg_direction")
    msg.state = JimDbUtil.toNumber(resultSet,"last_msg_state")
    msg.hasRead = JimDbUtil.toNumber(resultSet,"last_msg_has_read")>0
    msg.senderId = JimDbUtil.toString(resultSet,"last_msg_sender_id")

    conver.isTop = JimDbUtil.toNumber(resultSet,"is_top")>0
    conver.topTime = JimDbUtil.toNumber(resultSet,"top_time")
    conver.isMute = JimDbUtil.toNumber(resultSet,"is_mute")>0
    conver.unreadTag = JimDbUtil.toNumber(resultSet,"unread_tag")
    conver.unreadCount = Math.max(msg.msgUnreadIndex - conver.lastReadMsgIndex, 0)
    conver.tags = ConverTagDao.instance.queryByConversation(conver.conversation)

    conver.lastMessage = msg
    return conver
  }
}
