import { FileMessage, MergeMessage, Message, MessageContent, TextMessage } from "../entries/message";
import { JimMsgType } from "../entries/msgtypes";
import { relationalStore } from "@kit.ArkData";
import { JimUtil } from "../commons/jimutil";
import { MsgFlagTool } from "../improto/msgflag";
import { JimDbManager } from "./dbmanager";
import { JimDbUtil } from "./dbutil";
import { Conversation } from "../entries/conversation";
import { MsgHandler } from "../entries/msghandler";
import { MessageOptionUtil } from "../commons/messageoptionutil";

export class MessageDao{
  static instance:MessageDao = new MessageDao()
  private tableName:string = 'messages'
  private constructor() {
  }

  private ensureReferencedMessage(msg:Message):void{
    if(msg.referredMessage == null){
      return
    }
    let referMessage = msg.referredMessage
    let referMsgId = referMessage.messageId
    let referClientId = referMessage.clientId
    if(referMsgId == '' && referClientId == ''){
      return
    }
    if(this.existByMsgId(referMsgId, referClientId)){
      return
    }
    this.insert(referMessage)
  }

  getMessage(msgId:string):Message|null{
    let sql = `SELECT * FROM ${this.tableName} WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msgId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        let msg = this.toMessage(resultSet)
        return msg
      }
    }catch (e){
      console.error(`faild to query msg. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  getMessagesByMessageIds(msgIds:string[]):Message[]{
    let requestIds:string[] = []
    msgIds.forEach((msgId)=>{
      let normalizedId = msgId.trim()
      if(normalizedId != ''){
        requestIds.push(normalizedId)
      }
    })
    if(requestIds.length == 0){
      return []
    }
    let placeholders:string[] = []
    let args:Array<relationalStore.ValueType> = []
    requestIds.forEach((msgId)=>{
      placeholders.push('?')
      args.push(msgId)
    })
    let sql = `SELECT * FROM ${this.tableName} WHERE msg_id in (${placeholders.join(',')}) or client_id in (${placeholders.join(',')})`
    requestIds.forEach((msgId)=>{
      args.push(msgId)
    })
    let resultSet:relationalStore.ResultSet|undefined
    let queriedMessages:Message[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        queriedMessages.push(this.toMessage(resultSet))
      }
    }catch (e){
      console.error(`faild to query msgs by ids. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    let orderedMessages:Message[] = []
    requestIds.forEach((requestId)=>{
      for(let i = 0; i < queriedMessages.length; i++){
        let message = queriedMessages[i]
        if(message.messageId == requestId || message.clientId == requestId){
          orderedMessages.push(message)
          break
        }
      }
    })
    return orderedMessages
  }

  queryMessages(converId:string,converType:number,start:number,count:number,isPositive:boolean,contentTypes?:string[]):Message[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE conver_type=? and conver_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(converType)
    args.push(converId)
    if(contentTypes != undefined && contentTypes.length > 0){
      let placeholders:string[] = []
      contentTypes.forEach((contentType)=>{
        placeholders.push('?')
        args.push(contentType)
      })
      sql = sql + ` and msg_type in (${placeholders.join(',')})`
    }
    if(isPositive){
      sql = sql + ` and sent_time>? order by sent_time asc`
    }else{
      sql = sql + ` and sent_time<? order by sent_time desc`
    }
    args.push(start)
    sql = sql + ` LIMIT ${count}`
    let resultSet:relationalStore.ResultSet|undefined
    let msgList:Message[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let msg = this.toMessage(resultSet)
        msgList.push(msg)
      }
      if(!isPositive){
        msgList = msgList.slice().sort((a,b)=>a.sentTime-b.sentTime)
      }
      return msgList
    }catch (e) {
      console.error('failed to query ',this.tableName)
      return msgList
    }finally {
      resultSet?.close()
    }
  }

  searchMessages(
    keyword:string,
    startTime:number,
    endTime:number,
    count:number,
    isPositive:boolean,
    contentTypes?:string[],
    conver?:Conversation
  ):Message[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE 1=1`
    let args:Array<relationalStore.ValueType> = []
    if(conver != undefined){
      sql = sql + ` and conver_type=? and conver_id=?`
      args.push(conver.conversationType)
      args.push(conver.conversationId)
    }
    if(contentTypes != undefined && contentTypes.length > 0){
      let placeholders:string[] = []
      contentTypes.forEach((contentType)=>{
        placeholders.push('?')
        args.push(contentType)
      })
      sql = sql + ` and msg_type in (${placeholders.join(',')})`
    }
    let normalizedKeyword = keyword.trim()
    if(normalizedKeyword != ''){
      sql = sql + ` and (search_content like ? or msg_content like ?)`
      let fuzzyKeyword = `%${normalizedKeyword}%`
      args.push(fuzzyKeyword)
      args.push(fuzzyKeyword)
    }
    if(startTime > 0){
      sql = sql + ` and sent_time>=?`
      args.push(startTime)
    }
    if(endTime > 0){
      sql = sql + ` and sent_time<=?`
      args.push(endTime)
    }
    if(isPositive){
      sql = sql + ` order by sent_time asc`
    }else{
      sql = sql + ` order by sent_time desc`
    }
    if(count > 0){
      sql = sql + ` LIMIT ${count}`
    }
    let resultSet:relationalStore.ResultSet|undefined
    let msgList:Message[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, args)
      while (resultSet?.goToNextRow()){
        let msg = this.toMessage(resultSet)
        msgList.push(msg)
      }
      if(!isPositive){
        msgList = msgList.slice().sort((a,b)=>a.sentTime-b.sentTime)
      }
      return msgList
    }catch (e) {
      console.error('failed to search ', this.tableName)
      return msgList
    }finally {
      resultSet?.close()
    }
  }

  queryMentionMessages(conver:Conversation, startTime:number, count:number, isPositive:boolean):Message[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE conver_type=? and conver_id=? and mention_info!=''`
    let args:Array<relationalStore.ValueType> = []
    args.push(conver.conversationType)
    args.push(conver.conversationId)
    if(isPositive){
      sql = sql + ` and sent_time>? order by sent_time asc`
    }else{
      sql = sql + ` and sent_time<? order by sent_time desc`
    }
    args.push(startTime)
    if(count > 0){
      sql = sql + ` LIMIT ${count}`
    }
    let resultSet:relationalStore.ResultSet|undefined
    let msgList:Message[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        msgList.push(this.toMessage(resultSet))
      }
      if(!isPositive){
        msgList = msgList.slice().sort((a,b)=>a.sentTime-b.sentTime)
      }
      return msgList
    }catch (e) {
      console.error('failed to query mention msgs ', this.tableName)
      return msgList
    }finally {
      resultSet?.close()
    }
  }

  insert(msg:Message):number{
    console.log("sendmsg_ret_start:",JSON.stringify(msg))
    this.ensureReferencedMessage(msg)
    let valueBucket = this.getValuesBucket(msg)
    try{
      let row = JimDbManager.instance.getDb()?.insertSync(this.tableName,valueBucket)
      console.log("sendmsg_ret_row:",row)
      if(row!==undefined){
        return row
      }
      return 0
    }catch (e) {
      console.error(`sendmsg_ret [${this.tableName}] err:${e.message}`)
      return 0
    }
  }

  existByMsgId(msgId:string,clientId:string):boolean{
    let sql = `SELECT id FROM ${this.tableName} WHERE msg_id=? or client_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msgId)
    args.push(clientId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        let id = JimDbUtil.toNumber(resultSet,"id")
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

  updateMsgContent(msgId:string,msgContent:MessageContent):number{
    let sql = `UPDATE ${this.tableName} SET msg_type=?, msg_content=?, search_content=? WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msgContent.getMsgType())
    args.push(JimUtil.uint8ArrayToString(msgContent.encode()))
    args.push(this.buildSearchContent(msgContent))
    args.push(msgId)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateMsgContentByDbId(dbId:number,msgContent:MessageContent):number{
    let sql = `UPDATE ${this.tableName} SET msg_type=?, msg_content=?, search_content=? WHERE id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msgContent.getMsgType())
    args.push(JimUtil.uint8ArrayToString(msgContent.encode()))
    args.push(this.buildSearchContent(msgContent))
    args.push(dbId)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateMsgFlags(msgId:string, flags:number):number{
    let sql = `UPDATE ${this.tableName} SET flags=? WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = [flags, msgId]
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateMessagesRead(msgIds:string[]):number{
    let normalizedIds:string[] = []
    msgIds.forEach((msgId)=>{
      let normalizedId = msgId.trim()
      if(normalizedId != ''){
        normalizedIds.push(normalizedId)
      }
    })
    if(normalizedIds.length == 0){
      return 0
    }
    let placeholders:string[] = []
    let args:Array<relationalStore.ValueType> = []
    normalizedIds.forEach((msgId)=>{
      placeholders.push('?')
      args.push(msgId)
    })
    let sql = `UPDATE ${this.tableName} SET has_read=1 WHERE msg_id in (${placeholders.join(',')})`
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateGroupReadInfo(msgId:string, readCount:number, memberCount:number):number{
    let sql = `UPDATE ${this.tableName} SET read_count=?, member_count=? WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = [readCount, memberCount, msgId]
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  private buildSearchContent(msg:MessageContent):string{
    let msgType = msg.getMsgType()
    if(msgType == JimMsgType.Text){
      return (msg as TextMessage).content
    }
    if(msgType == JimMsgType.File){
      return (msg as FileMessage).name
    }
    if(msgType == JimMsgType.Merge){
      return (msg as MergeMessage).title
    }
    return ''
  }

  updateMsgState(dbId:number,state:number,msgId?:string,msgTime?:number,msgSeq?:number,memberCount?:number):number{
    let sql = `UPDATE ${this.tableName} SET state=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(state)
    if(msgId!=undefined){
      sql = sql + ` ,msg_id=?`
      args.push(msgId)
    }
    if(msgTime!=undefined){
      sql = sql + ` ,sent_time=?`
      args.push(msgTime)
    }
    if(msgSeq!=undefined){
      sql = sql + ` ,msg_seq_no=?`
      args.push(msgSeq)
    }
    if(memberCount!=undefined){
      sql = sql + ` ,member_count=?`
      args.push(memberCount)
    }
    sql = sql + ` WHERE id=?`
    args.push(dbId)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateLocalAttribute(msgId:string, attribute:string):number{
    let sql = `UPDATE ${this.tableName} SET local_attribute=? WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = [attribute, msgId]
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  getLocalAttribute(msgId:string):string{
    let sql = `SELECT local_attribute FROM ${this.tableName} WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = [msgId]
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        return JimDbUtil.toString(resultSet,'local_attribute')
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return ''
  }

  private getValuesBucket(msg:Message):relationalStore.ValuesBucket{
    let flags = msg.flags > 0 ? msg.flags : MsgFlagTool.toFlag(msg.msgContent.getFlag())
    let valuesBucket:relationalStore.ValuesBucket = {
      "conver_id":msg.conversation?.conversationId as string,
      "conver_type":msg.conversation?.conversationType as number,
      "client_id":msg.clientId!=''?msg.clientId:null,
      "sender_id":msg.senderId,
      "direction":msg.direction,
      "msg_id":msg.messageId!=''?msg.messageId:null,
      "msg_seq_no": JimUtil.toNumber(msg.msgSeqNo),
      "msg_index":msg.msgUnreadIndex,
      "msg_type":msg.msgContent.getMsgType(),
      "sent_time":JimUtil.toNumber(msg.sentTime),
      "msg_content": JimUtil.uint8ArrayToString(msg.msgContent.encode()),
      "ext": MessageOptionUtil.encodeMessageExt(msg),
      "state":msg.state,
      "flags":flags,
      "has_read":msg.hasRead?1:0,
      "read_count":msg.readCount,
      "member_count":msg.memberCount,
      "search_content":msg.searchContent,
      "local_attribute":msg.localAttribute,
      "mention_info": MessageOptionUtil.encodeMentionInfo(msg.mentionInfo),
      "refer_msg_id":msg.referMsgId
    }
    return valuesBucket
  }

  private toMessage(resultSet:relationalStore.ResultSet):Message{
    let message = new Message()
    let converId = JimDbUtil.toString(resultSet,'conver_id')
    let converType = JimDbUtil.toNumber(resultSet,'conver_type')
    message.conversation = new Conversation(converId,converType)
    message.clientId = JimDbUtil.toString(resultSet,'client_id')
    message.senderId = JimDbUtil.toString(resultSet,'sender_id')
    message.direction = JimDbUtil.toNumber(resultSet,'direction')
    message.messageId = JimDbUtil.toString(resultSet,'msg_id')
    message.msgSeqNo = JimDbUtil.toNumber(resultSet,'msg_seq_no')
    message.msgUnreadIndex = JimDbUtil.toNumber(resultSet,'msg_index')
    let msgType = JimDbUtil.toString(resultSet,'msg_type')
    message.sentTime = JimDbUtil.toNumber(resultSet,'sent_time')
    //content
    let content = JimDbUtil.toString(resultSet,'msg_content')
    message.msgContent = MsgHandler.constructByMsgType(msgType, JimUtil.stringToUint8Array(content))
    message.state = JimDbUtil.toNumber(resultSet,'state')
    message.flags = JimDbUtil.toNumber(resultSet,'flags')
    message.isEdit = MsgFlagTool.parseFlag(message.flags).isModified == true
    message.hasRead = JimDbUtil.toNumber(resultSet,"has_read")>0
    message.readCount = JimDbUtil.toNumber(resultSet,"read_count")
    message.memberCount = JimDbUtil.toNumber(resultSet, "member_count")
    message.isDeleted = JimDbUtil.toNumber(resultSet,"is_deleted")>0
    message.searchContent = JimDbUtil.toString(resultSet,"search_content")
    message.localAttribute = JimDbUtil.toString(resultSet,"local_attribute")
    message.mentionInfo = MessageOptionUtil.decodeMentionInfo(JimDbUtil.toString(resultSet,"mention_info"))
    message.referMsgId = JimDbUtil.toString(resultSet, "refer_msg_id")
    if(message.referMsgId != ''){
      let referMessage = this.getMessage(message.referMsgId)
      if(referMessage != null){
        message.referredMessage = referMessage
      }
    }
    MessageOptionUtil.decodeMessageExt(JimDbUtil.toString(resultSet, "ext"), message)
    return message
  }
}
