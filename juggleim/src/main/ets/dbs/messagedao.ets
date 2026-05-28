import { FileMessage, MergeMessage, Message, MessageContent, MessageReaction, TextMessage } from "../entries/message";
import { JimMsgType } from "../entries/msgtypes";
import { relationalStore } from "@kit.ArkData";
import { JimUtil } from "../commons/jimutil";
import { MsgFlagTool } from "../improto/msgflag";
import { JimDbManager } from "./dbmanager";
import { JimDbUtil } from "./dbutil";
import { Conversation, ConversationInfo } from "../entries/conversation";
import { MsgHandler } from "../entries/msghandler";
import { MessageOptionUtil } from "../commons/messageoptionutil";
import { ReactionDao } from "./reactiondao";
import { MessageQueryOptions } from "../entries/messagequeryoptions";
import { SearchConversationsResult } from "../entries/searchconversationresult";

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

  getMessagesByClientMsgNos(clientMsgNos:number[]):Message[]{
    let requestIds:number[] = []
    clientMsgNos.forEach((clientMsgNo)=>{
      if(clientMsgNo > 0 && requestIds.indexOf(clientMsgNo) < 0){
        requestIds.push(clientMsgNo)
      }
    })
    if(requestIds.length == 0){
      return []
    }
    let placeholders:string[] = []
    let args:Array<relationalStore.ValueType> = []
    requestIds.forEach((clientMsgNo)=>{
      placeholders.push('?')
      args.push(clientMsgNo)
    })
    let sql = `SELECT * FROM ${this.tableName} WHERE client_msg_no in (${placeholders.join(',')})`
    let resultSet:relationalStore.ResultSet|undefined
    let queriedMessages:Message[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        queriedMessages.push(this.toMessage(resultSet))
      }
    }catch (e){
      console.error(`faild to query msgs by client msg nos. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    let orderedMessages:Message[] = []
    requestIds.forEach((requestId)=>{
      for(let i = 0; i < queriedMessages.length; i++){
        let message = queriedMessages[i]
        if(message.clientMsgNo == requestId){
          orderedMessages.push(message)
          break
        }
      }
    })
    return orderedMessages
  }

  getMessageDbIdByClientMsgNo(clientMsgNo:number):number{
    if(clientMsgNo <= 0){
      return 0
    }
    let sql = `SELECT id FROM ${this.tableName} WHERE client_msg_no=? LIMIT 1`
    let args:Array<relationalStore.ValueType> = [clientMsgNo]
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        return JimDbUtil.toNumber(resultSet,'id')
      }
    }catch (e){
      console.error(`faild to query msg db id by client msg no. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return 0
  }

  queryMessages(conver:Conversation,start:number,count:number,isPositive:boolean,contentTypes?:string[]):Message[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE is_deleted=0 AND (destroy_time=0 OR destroy_time>?) AND conver_type=? and conver_id=? and subchannel=?`
    let args:Array<relationalStore.ValueType> = [new Date().getTime()]
    args.push(conver.conversationType)
    args.push(conver.conversationId)
    args.push(Conversation.normalizeSubChannel(conver.subChannel))
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
    let sql = `SELECT * FROM ${this.tableName} WHERE is_deleted=0 AND (destroy_time=0 OR destroy_time>?)`
    let args:Array<relationalStore.ValueType> = [new Date().getTime()]
    if(conver != undefined){
      sql = sql + ` and conver_type=? and conver_id=?`
      args.push(conver.conversationType)
      args.push(conver.conversationId)
      sql = sql + ` and subchannel=?`
      args.push(Conversation.normalizeSubChannel(conver.subChannel))
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

  searchConversationsWithMessageContent(options:MessageQueryOptions, now:number):SearchConversationsResult[]{
    let sql = `SELECT conver_type, conver_id, subchannel, COUNT(*) AS match_count, MAX(sent_time) AS sort_time FROM ${this.tableName} WHERE is_deleted=0 AND (destroy_time=0 OR destroy_time>?)`
    let args:Array<relationalStore.ValueType> = [now]
    if(options != undefined){
      let conversations = options.conversations != undefined ? options.conversations : []
      if(conversations.length > 0){
        let conversationClauses:string[] = []
        conversations.forEach((conver)=>{
          conversationClauses.push(`(conver_type=? AND conver_id=? AND subchannel=?)`)
          args.push(conver.conversationType)
          args.push(conver.conversationId)
          args.push(Conversation.normalizeSubChannel(conver.subChannel))
        })
        sql = sql + ` AND (${conversationClauses.join(' OR ')})`
      }
      if(options.direction >= 0){
        sql = sql + ` AND direction=?`
        args.push(options.direction)
      }
      if(options.contentTypes != undefined && options.contentTypes.length > 0){
        let placeholders:string[] = []
        options.contentTypes.forEach((contentType)=>{
          placeholders.push('?')
          args.push(contentType)
        })
        sql = sql + ` AND msg_type IN (${placeholders.join(',')})`
      }
      if(options.senderUserIds != undefined && options.senderUserIds.length > 0){
        let placeholders:string[] = []
        options.senderUserIds.forEach((senderUserId)=>{
          placeholders.push('?')
          args.push(senderUserId)
        })
        sql = sql + ` AND sender_id IN (${placeholders.join(',')})`
      }
      if(options.states != undefined && options.states.length > 0){
        let placeholders:string[] = []
        options.states.forEach((state)=>{
          placeholders.push('?')
          args.push(state)
        })
        sql = sql + ` AND state IN (${placeholders.join(',')})`
      }
      if(options.conversationTypes != undefined && options.conversationTypes.length > 0){
        let placeholders:string[] = []
        options.conversationTypes.forEach((conversationType)=>{
          placeholders.push('?')
          args.push(conversationType)
        })
        sql = sql + ` AND conver_type IN (${placeholders.join(',')})`
      }
      let searchContent = options.searchContent != undefined ? options.searchContent.trim() : ''
      if(searchContent != ''){
        sql = sql + ` AND search_content LIKE ?`
        args.push(`%${searchContent}%`)
      }
    }
    sql = sql + ` GROUP BY conver_type, conver_id, subchannel ORDER BY sort_time DESC`
    let resultSet:relationalStore.ResultSet|undefined
    let resultList:SearchConversationsResult[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let converType = JimDbUtil.toNumber(resultSet, 'conver_type')
        let converId = JimDbUtil.toString(resultSet, 'conver_id')
        let subChannel = JimDbUtil.toString(resultSet, 'subchannel')
        let conver = new Conversation(converId, converType, subChannel)
        let converInfo = JimDbManager.instance.getConversationDao().getConver(conver)
        if(converInfo == undefined){
          converInfo = new ConversationInfo()
          converInfo.conversation = conver
        }
        let result = new SearchConversationsResult()
        result.conversationInfo = converInfo
        result.matchedCount = JimDbUtil.toNumber(resultSet, 'match_count')
        resultList.push(result)
      }
    }catch (e){
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return resultList
  }

  queryMentionMessages(conver:Conversation, startTime:number, count:number, isPositive:boolean):Message[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE is_deleted=0 AND (destroy_time=0 OR destroy_time>?) AND conver_type=? and conver_id=? and subchannel=? and mention_info!=''`
    let args:Array<relationalStore.ValueType> = [new Date().getTime()]
    args.push(conver.conversationType)
    args.push(conver.conversationId)
    args.push(Conversation.normalizeSubChannel(conver.subChannel))
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

  updateMsgStateByClientMsgNo(clientMsgNo:number, state:number):number{
    if(clientMsgNo <= 0){
      return 0
    }
    let sql = `UPDATE ${this.tableName} SET state=? WHERE client_msg_no=?`
    let args:Array<relationalStore.ValueType> = [state, clientMsgNo]
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateMessagesRead(msgIds:string[], readTime:number = new Date().getTime()):number{
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
    let sql = `UPDATE ${this.tableName} SET has_read=1, read_time=? WHERE msg_id in (${placeholders.join(',')})`
    args.unshift(readTime)
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

  clearConversationMessages(conver:Conversation, cleanTime:number, senderId:string):number{
    let sql = `UPDATE ${this.tableName} SET is_deleted=1 WHERE conver_type=? AND conver_id=? AND subchannel=?`
    let args:Array<relationalStore.ValueType> = [conver.conversationType, conver.conversationId, Conversation.normalizeSubChannel(conver.subChannel)]
    if(cleanTime > 0){
      sql = sql + ` AND sent_time<=?`
      args.push(cleanTime)
    }
    let normalizedSenderId = senderId.trim()
    if(normalizedSenderId != ''){
      sql = sql + ` AND sender_id=?`
      args.push(normalizedSenderId)
    }
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  markMessagesDeleted(msgIds:string[]):number{
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
    let sql = `UPDATE ${this.tableName} SET is_deleted=1 WHERE msg_id IN (${placeholders.join(',')})`
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql, args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  getLastVisibleMessage(conver:Conversation):Message|null{
    let sql = `SELECT * FROM ${this.tableName} WHERE is_deleted=0 AND (destroy_time=0 OR destroy_time>?) AND conver_type=? AND conver_id=? AND subchannel=? ORDER BY sent_time DESC LIMIT 1`
    let args:Array<relationalStore.ValueType> = [
      new Date().getTime(),
      conver.conversationType,
      conver.conversationId,
      Conversation.normalizeSubChannel(conver.subChannel)
    ]
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, args)
      if(resultSet?.goToNextRow()){
        return this.toMessage(resultSet)
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  clearChatroomMessagesExclude(chatroomIds:string[]):number{
    let sql = `DELETE FROM ${this.tableName} WHERE conver_type=3`
    let args:Array<relationalStore.ValueType> = []
    if(chatroomIds.length > 0){
      let placeholders:string[] = []
      chatroomIds.forEach((chatroomId)=>{
        placeholders.push('?')
        args.push(chatroomId)
      })
      sql = sql + ` AND conver_id NOT IN (${placeholders.join(',')})`
    }
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql, args)
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

  updateMsgState(
    dbId:number,
    state:number,
    msgId?:string,
    msgTime?:number,
    msgSeq?:number,
    memberCount?:number,
    destroyTime?:number
  ):number{
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
    if(destroyTime!=undefined){
      sql = sql + ` ,destroy_time=?`
      args.push(destroyTime)
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

  updateDestroyTime(msgId:string, destroyTime:number):number{
    let sql = `UPDATE ${this.tableName} SET destroy_time=? WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = [destroyTime, msgId]
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateMessageReactions(msgId:string, reactions:MessageReaction[]):number{
    let sql = `UPDATE ${this.tableName} SET reactions=? WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = [this.encodeReactions(reactions), msgId]
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      ReactionDao.instance.setReactions(msgId, reactions)
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
      "subchannel":Conversation.normalizeSubChannel(msg.conversation?.subChannel),
      "client_msg_no":msg.clientMsgNo,
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
      "refer_msg_id":msg.referMsgId,
      "reactions":this.encodeReactions(msg.reactions),
      "life_time":msg.lifeTime,
      "life_time_after_read":msg.lifeTimeAfterRead,
      "destroy_time":msg.destroyTime,
      "read_time":msg.readTime
    }
    return valuesBucket
  }

  private toMessage(resultSet:relationalStore.ResultSet):Message{
    let message = new Message()
    let converId = JimDbUtil.toString(resultSet,'conver_id')
    let converType = JimDbUtil.toNumber(resultSet,'conver_type')
    let subChannel = JimDbUtil.toString(resultSet,'subchannel')
    message.conversation = new Conversation(converId,converType, subChannel)
    message.clientMsgNo = JimDbUtil.toNumber(resultSet,'client_msg_no')
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
    message.lifeTime = JimDbUtil.toNumber(resultSet, "life_time")
    message.lifeTimeAfterRead = JimDbUtil.toNumber(resultSet, "life_time_after_read")
    message.destroyTime = JimDbUtil.toNumber(resultSet, "destroy_time")
    message.readTime = JimDbUtil.toNumber(resultSet, "read_time")
    message.reactions = ReactionDao.instance.getReactions(message.messageId)
    if(message.reactions.length == 0){
      message.reactions = this.decodeReactions(JimDbUtil.toString(resultSet, "reactions"))
    }
    if(message.referMsgId != ''){
      let referMessage = this.getMessage(message.referMsgId)
      if(referMessage != null){
        message.referredMessage = referMessage
      }
    }
    MessageOptionUtil.decodeMessageExt(JimDbUtil.toString(resultSet, "ext"), message)
    return message
  }

  private encodeReactions(reactions:MessageReaction[]):string{
    if(reactions.length == 0){
      return ''
    }
    let encodedReactions:MessageReaction[] = []
    reactions.forEach((reaction)=>{
      let encodedReaction = new MessageReaction()
      encodedReaction.reactionId = reaction.reactionId
      encodedReaction.userIds = reaction.userIds
      encodedReaction.count = reaction.count
      encodedReaction.isSelected = reaction.isSelected
      encodedReactions.push(encodedReaction)
    })
    return JSON.stringify(encodedReactions)
  }

  private decodeReactions(reactionsStr:string):MessageReaction[]{
    if(reactionsStr == ''){
      return []
    }
    try{
      let rawReactions = JSON.parse(reactionsStr) as MessageReaction[]
      let reactions:MessageReaction[] = []
      rawReactions.forEach((reactionData)=>{
        let reaction = new MessageReaction()
        reaction.reactionId = reactionData.reactionId != undefined ? reactionData.reactionId : ''
        reaction.userIds = reactionData.userIds != undefined ? reactionData.userIds.slice() : []
        let count = reactionData.count
        reaction.count = count != undefined && count > 0 ? count : reaction.userIds.length
        let isSelected = reactionData.isSelected
        reaction.isSelected = isSelected == true
        if(reaction.reactionId != ''){
          reactions.push(reaction)
        }
      })
      return reactions
    }catch (e) {
      console.error(`jimsdk_reaction_decode_fail. [${this.tableName}] err:${e.message}`)
    }
    return []
  }
}
