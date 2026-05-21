import {immessage} from  '../improto/immessage'
import {
  FileMessage,
  MergeMessage,
  Message,
  MessageContent,
  MessageSentState,
  TextMessage
} from '../entries/message'
import { Conversation, ConversationInfo } from '../entries/conversation'
import { MsgFlagTool } from '../improto/msgflag'
import { ImClient } from '../imclients/imclient'
import { CommonCallback } from '../interfaces/commoncallback'
import { HashMap } from '@kit.ArkTS'
import { JimDbManager } from '../dbs/dbmanager'
import { MsgHandler } from '../entries/msghandler'
import { MsgSyncManager } from './msgsyncmanager'
import { JimUtil } from '../commons/jimutil'
import { JuggleIm } from '../juggleim'
import { IMessageManager } from '../interfaces/imessagemanager'
import { GroupMessageMemberReadDetail, GroupMessageReadInfoDetail } from '../entries/group'
import { MentionType, MessageOptions } from '../entries/messageoptions'
import { MessageOptionUtil } from '../commons/messageoptionutil'
import { UserInfo } from '../entries/user'
import {
  ClearMsgOptions,
  GetMessageDirection,
  GetMessageOptions,
  GroupMessageReadInfoDetailCallback,
  MessageCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgGroupReadReceiptListener,
  MsgModifiedListener,
  MsgReadReceiptListener,
  MsgReceivedListener,
  MsgRecalledListener,
  QryMessagesCallback,
  QueryMsgOptions,
  SearchParams
} from '../interfaces/messagetypes'

export {
  ClearMsgOptions,
  GetMessageDirection,
  GetMessageOptions,
  GroupMessageReadInfoDetailCallback,
  MessageCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgGroupReadReceiptListener,
  MsgModifiedListener,
  MsgReadReceiptListener,
  MsgReceivedListener,
  MsgRecalledListener,
  QryMessagesCallback,
  QueryMsgOptions,
  SearchParams
} from '../interfaces/messagetypes'

export class MessageManager implements IMessageManager{
  private imclient:ImClient
  private msgSyncMgr:MsgSyncManager

  constructor(imclient:ImClient,mgr:MsgSyncManager) {
    this.imclient = imclient
    this.msgSyncMgr = mgr
  }

  addMsgReceivedListener(listener:MsgReceivedListener){
    this.msgSyncMgr.addMsgReceivedListener(listener)
  }

  removeMsgReceivedListener(listener:MsgReceivedListener){
    this.msgSyncMgr.removeMsgReceivedListener(listener)
  }

  addMsgRecalledListener(listener:MsgRecalledListener){
    this.msgSyncMgr.addMsgRecalledListener(listener)
  }

  removeMsgRecalledListener(listener:MsgRecalledListener){
    this.msgSyncMgr.removeMsgRecalledListener(listener)
  }

  addMsgModifiedListener(listener:MsgModifiedListener){
    this.msgSyncMgr.addMsgModifiedListener(listener)
  }

  removeMsgModifiedListener(listener:MsgModifiedListener){
    this.msgSyncMgr.removeMsgModifiedListener(listener)
  }

  addReadReceiptListener(listener:MsgReadReceiptListener){
    this.msgSyncMgr.addReadReceiptListener(listener)
  }

  removeReadReceiptListener(listener:MsgReadReceiptListener){
    this.msgSyncMgr.removeReadReceiptListener(listener)
  }

  addGroupReadReceiptListener(listener:MsgGroupReadReceiptListener){
    this.msgSyncMgr.addGroupReadReceiptListener(listener)
  }

  removeGroupReadReceiptListener(listener:MsgGroupReadReceiptListener){
    this.msgSyncMgr.removeGroupReadReceiptListener(listener)
  }

  addMsgDeletedListener(listener:MsgDeletedListener){
    this.msgSyncMgr.addMsgDeletedListener(listener)
  }

  removeMsgDeletedListener(listener:MsgDeletedListener){
    this.msgSyncMgr.removeMsgDeletedListener(listener)
  }

  addMsgCleanedListener(listener:MsgCleanedListener){
    this.msgSyncMgr.addMsgCleanedListener(listener)
  }

  removeMsgCleanedListener(listener:MsgCleanedListener){
    this.msgSyncMgr.removeMsgCleanedListener(listener)
  }

  public registerMessage(msgType:string, constructor:Function){
    MsgHandler.registerMessage(msgType, constructor)
  }

  sendMessage(msg:MessageContent,conver:Conversation,callback:MessageCallback): void
  sendMessage(msg:MessageContent,conver:Conversation,options:MessageOptions,callback:MessageCallback): void
  sendMessage(msg:MessageContent,conver:Conversation,arg3:MessageCallback|MessageOptions,arg4?:MessageCallback): void{
    let callback:MessageCallback
    let options:MessageOptions|undefined
    if(typeof arg3 === 'function'){
      callback = arg3
    }else{
      options = arg3
      if(arg4 == undefined){
        return
      }
      callback = arg4
    }
    let targetId = conver.conversationId
    let method:string = ""
    if(conver.conversationType == 1){
      method = 'p_msg'
    }else if (conver.conversationType==2){
      method = 'g_msg'
    }
    let clientUid:string = JimUtil.getUuid()
    let flags = MsgFlagTool.toFlag(msg.getFlag())
    let message = new Message()
    message.conversation = conver
    message.msgContent = msg
    message.clientId = clientUid
    message.senderId = JuggleIm.instance.userId
    message.sentTime = new Date().getTime()
    message.flags = msg.getFlagNumber()
    message.searchContent = this.buildSearchContent(msg)
    message.state = MessageSentState.sending
    if(conver.conversationType == 2){
      let localMembers = JuggleIm.instance.getGroupInfoManager().getLocalGroupMembers(conver.conversationId)
      if(localMembers.length > 0){
        message.memberCount = localMembers.length
      }
    }

    let referMsg = this.applyMessageOptions(message, options)

    let upMsg = immessage.UpMsg.create({
      msgType:msg.getMsgType(),
      msgContent:msg.encode(),
      flags: flags,
      clientUid:clientUid,
      pushData: MessageOptionUtil.toProtoPushData(message.pushData),
      mentionInfo: MessageOptionUtil.toProtoMentionInfo(message.mentionInfo),
      referMsg: referMsg != undefined ? MessageOptionUtil.toProtoDownMsg(referMsg) : undefined
    })

    //save in db
    let msgDao = JimDbManager.instance.getMessageDao()
    let msgDbId = msgDao.insert(message)
    //update conversation
    this.msgSyncMgr.updConver(message)
    console.log("sendmsg_ret:",msgDbId)
    let data = immessage.UpMsg.encode(upMsg).finish()
    this.imclient.publish(method,targetId,data,(code,pubAck)=>{
      if(code==0){
        if(typeof pubAck.msgId == 'string'){
          message.messageId = pubAck.msgId
        }
        if(typeof pubAck.timestamp == 'number'){
          message.sentTime = pubAck.timestamp
          this.msgSyncMgr.recordLatestSendboxMsgTime(message.sentTime,flags)
        }
        if(typeof pubAck.msgSeqNo == 'number'){
          message.msgSeqNo = pubAck.msgSeqNo
        }
        if(conver.conversationType == 2 && typeof pubAck.memberCount == 'number' && pubAck.memberCount >= 0){
          message.memberCount = pubAck.memberCount
          message.readCount = 0
        }
        if(message.lifeTime > 0){
          message.destroyTime = message.sentTime + message.lifeTime
        }
        message.state = MessageSentState.success
        msgDao.updateMsgState(
          msgDbId,
          message.state,
          message.messageId,
          message.sentTime,
          message.msgSeqNo,
          conver.conversationType == 2 ? message.memberCount : undefined
        )
        this.msgSyncMgr.updConver(message)
        callback(code,message)
      }else{
        message.state = MessageSentState.failed
        msgDao.updateMsgState(msgDbId,message.state)
        this.msgSyncMgr.updConver(message)
        callback(code,message)
      }
    })
  }

  private applyMessageOptions(message:Message,options?:MessageOptions):Message|undefined{
    if(options == undefined){
      return undefined
    }
    if(options.mentionInfo != undefined){
      message.mentionInfo = options.mentionInfo
    }
    if(options.pushData != undefined){
      message.pushData = options.pushData
    }
    message.lifeTime = options.lifeTime
    message.lifeTimeAfterRead = options.lifeTimeAfterRead
    if(message.lifeTime > 0){
      message.destroyTime = message.sentTime + message.lifeTime
    }
    if(options.referredMessageId == ''){
      return undefined
    }
    message.referMsgId = options.referredMessageId
    let referMsg = JimDbManager.instance.getMessageDao().getMessage(options.referredMessageId)
    if(referMsg != null){
      message.referredMessage = referMsg
      message.referMsgId = referMsg.messageId
      return referMsg
    }
    return undefined
  }

  private buildSearchContent(msg:MessageContent):string{
    let msgType = msg.getMsgType()
    if(msgType == 'jg:text'){
      return (msg as TextMessage).content
    }
    if(msgType == 'jg:file'){
      return (msg as FileMessage).name
    }
    if(msgType == 'jg:merge'){
      return (msg as MergeMessage).title
    }
    return ''
  }

  sendMediaMessage(msg:MessageContent,conver:Conversation){}

  queryMessages(conver:Conversation,options:GetMessageOptions,callback:QryMessagesCallback){
    let normalizedOptions = this.normalizeMessageOptions(options)
    this.queryLocalMessages(conver,normalizedOptions,(code,msgs)=>{
      //check lack msgs
      let isLack:boolean = false
      let lastSeq:number = 0
      msgs.forEach((msg)=>{
        if(lastSeq==0){
          lastSeq = msg.msgSeqNo
        }else{
          if(lastSeq!=msg.msgSeqNo-1){
            isLack = true
            return
          }else{
            lastSeq = msg.msgSeqNo
          }
        }
      })
      if(isLack||msgs.length<normalizedOptions.count){
        //query from remote
        this.queryRemoteMessages(conver,normalizedOptions,(code,remoteMsgs,hasMore)=>{
          this.mergeLocalMessageState(msgs, remoteMsgs)
          remoteMsgs.forEach((msg)=>{
            //check exist
            let msgDao = JimDbManager.instance.getMessageDao()
            if(!msgDao.existByMsgId(msg.messageId,msg.clientId)){
              //save msg
              msgDao.insert(msg)
            }
          })
          callback(code,remoteMsgs,hasMore)
        })
      }else{
        callback(code,msgs,msgs.length>=normalizedOptions.count)
      }
    })
  }

  private mergeLocalMessageState(localMsgs:Message[], remoteMsgs:Message[]):void{
    localMsgs.forEach((localMsg)=>{
      remoteMsgs.forEach((remoteMsg)=>{
        let isSameMessage = false
        if(localMsg.messageId != '' && remoteMsg.messageId != '' && localMsg.messageId == remoteMsg.messageId){
          isSameMessage = true
        } else if(localMsg.clientId != '' && remoteMsg.clientId != '' && localMsg.clientId == remoteMsg.clientId){
          isSameMessage = true
        }
        if(!isSameMessage){
          return
        }
        remoteMsg.state = localMsg.state
        remoteMsg.direction = localMsg.direction
        remoteMsg.hasRead = localMsg.hasRead
        remoteMsg.readCount = localMsg.readCount
        remoteMsg.memberCount = localMsg.memberCount
        remoteMsg.isEdit = localMsg.isEdit
        remoteMsg.referMsgId = localMsg.referMsgId
        remoteMsg.referredMessage = localMsg.referredMessage
        remoteMsg.mentionInfo = localMsg.mentionInfo
        remoteMsg.localAttribute = localMsg.localAttribute
        return
      })
    })
  }

  queryLocalMessages(conver:Conversation,options:GetMessageOptions,callback:QryMessagesCallback){
    let normalizedOptions = this.normalizeMessageOptions(options)
    let dao = JimDbManager.instance.getMessageDao()
    if(normalizedOptions.direction == GetMessageDirection.Backward && normalizedOptions.time<=0){
      normalizedOptions.time = new Date().getTime()
    }
    let msgs = dao.queryMessages(
      conver.conversationId,
      conver.conversationType,
      normalizedOptions.time,
      normalizedOptions.count,
      normalizedOptions.direction == GetMessageDirection.Forward,
      normalizedOptions.contentTypes
    )
    callback(0,msgs,msgs.length>=normalizedOptions.count)
  }

  queryRemoteMessages(conver:Conversation,options:GetMessageOptions,callback:QryMessagesCallback){
    let normalizedOptions = this.normalizeMessageOptions(options)
    let order:number = 0
    if(normalizedOptions.direction == GetMessageDirection.Forward){
      order = 1
    }
    let req = immessage.QryHisMsgsReq.create({
      "targetId":conver.conversationId,
      'channelType':conver.conversationType,
      'startTime':normalizedOptions.time,
      'count':normalizedOptions.count,
      'order':order,
      'msgTypes':normalizedOptions.contentTypes
    })
    let data = immessage.QryHisMsgsReq.encode(req).finish()
    this.imclient.query("qry_hismsgs",conver.conversationId,data,(code,qryAck)=>{
      let msgs:Message[] = new Array()
      if(code==0){
        let data = qryAck.data as Uint8Array
        let resp = immessage.DownMsgSet.decode(data)
        resp.msgs.forEach((msg)=>{
          msgs.push(MsgHandler.downMsg2Message(msg))
        })
        callback(code,msgs,!resp.isFinished)
      }else{
        callback(code,msgs,false)
      }
    })
  }

  private normalizeMessageOptions(options:GetMessageOptions):GetMessageOptions{
    let normalized = new GetMessageOptions()
    normalized.count = options.count > 0 ? options.count : 20
    normalized.time = options.time
    normalized.direction = options.direction
    normalized.contentTypes = options.contentTypes != undefined ? options.contentTypes.slice() : []

    if(options instanceof QueryMsgOptions){
      let legacyOptions = options as QueryMsgOptions
      if(legacyOptions.startTime > 0){
        normalized.time = legacyOptions.startTime
      }
      if(legacyOptions.isPositive){
        normalized.direction = GetMessageDirection.Forward
      }else if(legacyOptions.startTime > 0 || legacyOptions.time == 0){
        normalized.direction = GetMessageDirection.Backward
      }
      if(legacyOptions.contentTypes.length > 0){
        normalized.contentTypes = legacyOptions.contentTypes.slice()
      }
    }

    if(normalized.time <= 0 && normalized.direction == GetMessageDirection.Backward){
      normalized.time = new Date().getTime()
    }
    return normalized
  }

  private isMentionForCurrentUser(message:Message):boolean{
    if(message.senderId == JuggleIm.instance.userId){
      return false
    }
    let mentionInfo = message.mentionInfo
    if(mentionInfo == undefined){
      return false
    }
    if(mentionInfo.mentionType == MentionType.All ||
      mentionInfo.mentionType == MentionType.AllAndSomeone){
      return true
    }
    if(mentionInfo.mentionType != MentionType.Someone){
      return false
    }
    for(let i = 0; i < mentionInfo.targetUsers.length; i++){
      if(mentionInfo.targetUsers[i].userId == JuggleIm.instance.userId){
        return true
      }
    }
    return false
  }

  private queryLocalMentionMessages(conver:Conversation,count:number,startTime:number,isPositive:boolean):Message[]{
    let queryTime = startTime
    if(queryTime <= 0 && !isPositive){
      queryTime = new Date().getTime()
    }
    let candidates = JimDbManager.instance.getMessageDao().queryMentionMessages(conver, queryTime, count > 0 ? count * 5 : 100, isPositive)
    let results:Message[] = []
    for(let i = 0; i < candidates.length; i++){
      if(this.isMentionForCurrentUser(candidates[i])){
        results.push(candidates[i])
      }
      if(count > 0 && results.length >= count){
        break
      }
    }
    return results
  }

  private mergeMentionResults(localMsgs:Message[], remoteMsgs:Message[], count:number, isPositive:boolean):Message[]{
    let results:Message[] = []
    let keys:Map<string, boolean> = new Map()
    let appendMessage = (message:Message):void => {
      let key = message.messageId != '' ? message.messageId : message.clientId
      if(key == '' || keys.has(key)){
        return
      }
      keys.set(key, true)
      results.push(message)
    }
    remoteMsgs.forEach((message)=>{
      appendMessage(message)
    })
    localMsgs.forEach((message)=>{
      appendMessage(message)
    })
    results = results.slice().sort((a,b)=>{
      if(isPositive){
        return a.sentTime - b.sentTime
      }
      return b.sentTime - a.sentTime
    })
    if(count > 0 && results.length > count){
      results = results.slice(0, count)
    }
    return results
  }

  queryMentionMessages(conver:Conversation,count:number,startTime:number,isPositive:boolean,callback:QryMessagesCallback){
    if(conver.conversationId == ''){
      callback(-1, [], false)
      return
    }
    let queryCount = count > 0 ? count : 20
    let queryTime = startTime
    if(queryTime <= 0 && !isPositive){
      queryTime = new Date().getTime()
    }
    let order = isPositive ? 1 : 0
    let latestReadIndex = 0
    let localConver = JimDbManager.instance.getConversationDao().getConver(conver)
    if(localConver != undefined){
      latestReadIndex = localConver.lastReadMsgIndex
    }
    let req = immessage.QryMentionMsgsReq.create({
      "targetId": conver.conversationId,
      "channelType": conver.conversationType,
      "startTime": queryTime,
      "count": queryCount,
      "order": order,
      "latestReadIndex": latestReadIndex
    })
    let data = immessage.QryMentionMsgsReq.encode(req).finish()
    this.imclient.query("qry_mention_msgs", conver.conversationId, data, (code, qryAck)=>{
      let msgs:Message[] = []
      let localMentionMsgs = this.queryLocalMentionMessages(conver, queryCount, queryTime, isPositive)
      if(code != 0){
        if(localMentionMsgs.length > 0){
          callback(0, localMentionMsgs, false)
          return
        }
        callback(code, msgs, false)
        return
      }
      let ackData = qryAck.data as Uint8Array
      let resp = immessage.QryMentionMsgsResp.decode(ackData)
      resp.mentionMsgs.forEach((msg)=>{
        msgs.push(MsgHandler.downMsg2Message(msg))
      })
      let localMsgs = JimDbManager.instance.getMessageDao().getMessagesByMessageIds(msgs.map((msg)=>msg.messageId))
      this.mergeLocalMessageState(localMsgs, msgs)
      msgs.forEach((msg)=>{
        if(!JimDbManager.instance.getMessageDao().existByMsgId(msg.messageId, msg.clientId)){
          JimDbManager.instance.getMessageDao().insert(msg)
        }
      })
      let mergedMsgs = this.mergeMentionResults(localMentionMsgs, msgs, queryCount, isPositive)
      callback(0, mergedMsgs, !resp.isFinished)
    })
  }

  clearMessages(conver:Conversation,options:ClearMsgOptions,callback:CommonCallback){
    let req = immessage.CleanHisMsgReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType,
      "cleanMsgTime":options.cleanTime,
      "cleanScope":options.cleanScope,
      "senderId":options.senderId,
      "cleanTimeOffset":options.cleanTimeOffset
    })
    let data = immessage.CleanHisMsgReq.encode(req).finish()
    this.imclient.query("clean_hismsg",conver.conversationId,data,(code)=>{
      callback(code)
    })
  }

  delMessages(conver:Conversation,msgIds:string[],delScope:number,callback:CommonCallback){
    let msgs:immessage.SimpleMsg[] = []
    msgIds.forEach((msgId)=>{
      msgs.push(immessage.SimpleMsg.create({
        "msgId":msgId
      }))
    })
    let req = immessage.DelHisMsgsReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType,
      "msgs":msgs,
      "delScope":delScope
    })
    let data = immessage.DelHisMsgsReq.encode(req).finish()
    this.imclient.query("del_hismsg",conver.conversationId,data,(code)=>{
      callback(code)
    })
  }

  private normalizeMessageIds(msgIds:string[]):string[]{
    let normalizedIds:string[] = []
    msgIds.forEach((msgId)=>{
      let normalizedId = msgId.trim()
      if(normalizedId != ''){
        normalizedIds.push(normalizedId)
      }
    })
    return normalizedIds
  }

  private findMessageByRequestId(messages:Message[], requestId:string):Message|null{
    for(let i = 0; i < messages.length; i++){
      let message = messages[i]
      if(message.messageId == requestId || message.clientId == requestId){
        return message
      }
    }
    return null
  }

  private combineMessagesByRequestIds(requestIds:string[], localMessages:Message[], remoteMessages:Message[]):Message[]{
    let result:Message[] = []
    requestIds.forEach((requestId)=>{
      let localMessage = this.findMessageByRequestId(localMessages, requestId)
      if(localMessage != null){
        result.push(localMessage)
        return
      }
      let remoteMessage = this.findMessageByRequestId(remoteMessages, requestId)
      if(remoteMessage != null){
        result.push(remoteMessage)
      }
    })
    return result
  }

  private queryRemoteMessagesByIds(conver:Conversation,msgIds:string[],callback:QryMessagesCallback):void{
    let req = immessage.QryHisMsgByIdsReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType,
      "msgIds":msgIds
    })
    let data = immessage.QryHisMsgByIdsReq.encode(req).finish()
    this.imclient.query("qry_hismsg_by_ids",conver.conversationId,data,(code,qryAck)=>{
      let msgs:Message[] = []
      if(code == 0){
        let ackData = qryAck.data as Uint8Array
        let resp = immessage.DownMsgSet.decode(ackData)
        resp.msgs.forEach((msg)=>{
          msgs.push(MsgHandler.downMsg2Message(msg))
        })
        callback(code,msgs,false)
        return
      }
      callback(code,msgs,false)
    })
  }

  getMessagesByMessageIds(conver:Conversation|null,msgIds:string[],callback:QryMessagesCallback){
    let requestIds = this.normalizeMessageIds(msgIds)
    if(requestIds.length == 0){
      callback(0, [], false)
      return
    }
    let msgDao = JimDbManager.instance.getMessageDao()
    let localMessages = msgDao.getMessagesByMessageIds(requestIds)
    let missingIds:string[] = []
    requestIds.forEach((requestId)=>{
      if(this.findMessageByRequestId(localMessages, requestId) == null){
        missingIds.push(requestId)
      }
    })
    if(missingIds.length == 0 || conver == null){
      callback(0, localMessages, false)
      return
    }
    this.queryRemoteMessagesByIds(conver, missingIds, (code, remoteMessages)=>{
      if(code != 0){
        if(localMessages.length > 0){
          callback(0, localMessages, false)
          return
        }
        callback(code, [], false)
        return
      }
      this.mergeLocalMessageState(localMessages, remoteMessages)
      remoteMessages.forEach((message)=>{
        if(!msgDao.existByMsgId(message.messageId, message.clientId)){
          msgDao.insert(message)
        }
      })
      callback(0, this.combineMessagesByRequestIds(requestIds, localMessages, remoteMessages), false)
    })
  }

  getMessagesByIds(conver:Conversation|null,msgIds:string[],callback:QryMessagesCallback){
    this.getMessagesByMessageIds(conver, msgIds, callback)
  }

  updateMessage(msgId:string,msg:MessageContent,conver:Conversation,callback:MessageCallback){
    if(msgId == '' || conver.conversationId == '' || msg == undefined){
      callback(-1, null)
      return
    }
    let localMessages = JimDbManager.instance.getMessageDao().getMessagesByMessageIds([msgId])
    if(localMessages.length == 0){
      callback(-2, null)
      return
    }
    let localMessage = localMessages[0]
    let req = immessage.ModifyMsgReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType,
      "msgId":msgId,
      "msgTime":localMessage.sentTime,
      "msgSeqNo":localMessage.msgSeqNo,
      "msgContent":msg.encode(),
      "msgType":msg.getMsgType()
    })
    let data = immessage.ModifyMsgReq.encode(req).finish()
    this.imclient.query("modify_msg", conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, null)
        return
      }
      if(qryAck.timestamp != undefined && qryAck.timestamp != null){
        this.msgSyncMgr.recordLatestSendboxMsgTime(JimUtil.toNumber(qryAck.timestamp as number), localMessage.flags)
      }
      let flags = localMessage.flags | 16
      localMessage.msgContent = msg
      localMessage.flags = flags
      localMessage.isEdit = true
      localMessage.searchContent = this.buildSearchContent(msg)
      let msgDao = JimDbManager.instance.getMessageDao()
      msgDao.updateMsgContent(localMessage.messageId, localMessage.msgContent)
      msgDao.updateMsgFlags(localMessage.messageId, flags)
      this.msgSyncMgr.notifyMessageModified(localMessage)
      callback(0, localMessage)
    })
  }

  modifyMessage(conver:Conversation,msgId:string,msg:MessageContent,callback:MessageCallback){
    this.updateMessage(msgId, msg, conver, callback)
  }

  sendReadReceipt(conver:Conversation,msgIds:string[],callback:CommonCallback){
    if(conver.conversationId == ''){
      callback(-1)
      return
    }
    let requestIds = this.normalizeMessageIds(msgIds)
    if(requestIds.length == 0){
      callback(0)
      return
    }
    let localMessages = JimDbManager.instance.getMessageDao().getMessagesByMessageIds(requestIds)
    let simpleMsgs:immessage.SimpleMsg[] = []
    requestIds.forEach((requestId)=>{
      let localMessage = this.findMessageByRequestId(localMessages, requestId)
      let messageId = requestId
      let msgTime = 0
      let msgReadIndex = 0
      if(localMessage != null){
        if(localMessage.messageId != ''){
          messageId = localMessage.messageId
        }
        msgTime = localMessage.sentTime
        msgReadIndex = localMessage.msgUnreadIndex
      }
      if(messageId != ''){
        simpleMsgs.push(immessage.SimpleMsg.create({
          "msgId":messageId,
          "msgTime":msgTime,
          "msgReadIndex":msgReadIndex
        }))
      }
    })
    if(simpleMsgs.length == 0){
      callback(0)
      return
    }
    let req = immessage.MarkReadReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType,
      "msgs":simpleMsgs
    })
    let data = immessage.MarkReadReq.encode(req).finish()
    this.imclient.query("mark_read", conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code)
        return
      }
      if(qryAck.timestamp != undefined && qryAck.timestamp != null){
        this.msgSyncMgr.recordLatestSendboxMsgTime(JimUtil.toNumber(qryAck.timestamp as number), MsgFlagTool.toFlag({ isCmd:true }))
      }
      let msgDao = JimDbManager.instance.getMessageDao()
      let actualMessageIds:string[] = []
      simpleMsgs.forEach((simpleMsg)=>{
        if(simpleMsg.msgId != undefined && simpleMsg.msgId != ''){
          actualMessageIds.push(simpleMsg.msgId as string)
        }
      })
      msgDao.updateMessagesRead(actualMessageIds)
      let readMessages = msgDao.getMessagesByMessageIds(actualMessageIds)
      readMessages.forEach((message)=>{
        message.hasRead = true
        this.msgSyncMgr.notifyMessageModified(message)
      })
      callback(0)
    })
  }

  private toGroupMessageMemberReadDetail(item:immessage.IMemberReadDetailItem):GroupMessageMemberReadDetail{
    let detail = new GroupMessageMemberReadDetail()
    if(item.member != undefined && item.member != null){
      let user = new UserInfo()
      user.userId = item.member.userId as string
      user.nickname = item.member.nickname as string
      user.userPortrait = item.member.userPortrait as string
      user.userType = JimUtil.toNumber(item.member.userType as number)
      user.updTime = JimUtil.toNumber(item.member.updatedTime as number)
      JuggleIm.instance.getUserInfoManager().saveUserInfo(user)
      detail.userId = user.userId
      detail.nickname = user.nickname
      detail.portrait = user.userPortrait
    }
    detail.readTime = JimUtil.toNumber(item.time as number)
    return detail
  }

  getGroupMessageReadInfoDetail(conver:Conversation,msgId:string,callback:GroupMessageReadInfoDetailCallback):void{
    if(conver.conversationId == '' || msgId == '' || conver.conversationType != 2){
      callback(-1, null)
      return
    }
    let req = immessage.QryReadDetailReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType,
      "msgId":msgId
    })
    let data = immessage.QryReadDetailReq.encode(req).finish()
    this.imclient.query("qry_read_detail", conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, null)
        return
      }
      let ackData = qryAck.data as Uint8Array
      let resp = immessage.QryReadDetailResp.decode(ackData)
      let detail = new GroupMessageReadInfoDetail()
      detail.readCount = resp.readCount as number
      detail.memberCount = resp.memberCount as number
      resp.readMembers.forEach((item)=>{
        detail.readMembers.push(this.toGroupMessageMemberReadDetail(item))
      })
      resp.unreadMembers.forEach((item)=>{
        detail.unreadMembers.push(this.toGroupMessageMemberReadDetail(item))
      })
      let msgDao = JimDbManager.instance.getMessageDao()
      msgDao.updateGroupReadInfo(msgId, detail.readCount, detail.memberCount)
      let localMessage = msgDao.getMessage(msgId)
      if(localMessage != null){
        localMessage.readCount = detail.readCount
        localMessage.memberCount = detail.memberCount
        this.msgSyncMgr.notifyMessageModified(localMessage)
      }
      callback(0, detail)
    })
  }

  recallMessage(conver:Conversation,msgId:string,extras:HashMap<string,string>,callback:MessageCallback){
    let exts:immessage.KvItem[] = []
    extras.forEach((k,v)=>{
      exts.push(immessage.KvItem.create({
        "key":k,
        "value":v
      }))
    })
    let req = immessage.RecallMsgReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType,
      "msgId":msgId,
      "exts":exts
    })
    let data = immessage.RecallMsgReq.encode(req).finish()
    this.imclient.query("recall_msg",conver.conversationId,data,(code)=>{
      let msg = new Message()
      callback(code,msg)
    })
  }

  searchMessages(params:SearchParams,callback:QryMessagesCallback){
    let dao = JimDbManager.instance.getMessageDao()
    let msgs = dao.searchMessages(
      params.keywords,
      params.startTime,
      params.endTime,
      params.count,
      params.direction == GetMessageDirection.Forward,
      params.msgTypes,
      params.conver
    )
    callback(0, msgs, false)
  }

  setLocalAttribute(msgId:string,attribute:string){
    JimDbManager.instance.getMessageDao().updateLocalAttribute(msgId, attribute)
  }

  getLocalAttribute(msgId:string):string{
    return JimDbManager.instance.getMessageDao().getLocalAttribute(msgId)
  }

  setLocalAttribue(msgId:string,attribute:string){
    this.setLocalAttribute(msgId, attribute)
  }

}
