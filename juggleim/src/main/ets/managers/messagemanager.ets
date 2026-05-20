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
import { MessageOptions } from '../entries/messageoptions'
import { MessageOptionUtil } from '../commons/messageoptionutil'
import {
  ClearMsgOptions,
  GetMessageDirection,
  GetMessageOptions,
  MessageCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgModifiedListener,
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
  MessageCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgModifiedListener,
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
        if(message.lifeTime > 0){
          message.destroyTime = message.sentTime + message.lifeTime
        }
        message.state = MessageSentState.success
        msgDao.updateMsgState(msgDbId,message.state,message.messageId,message.sentTime,message.msgSeqNo)
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

  queryMentionMessages(conver:Conversation,count:number,startTime:number,isPositive:boolean,callback:QryMessagesCallback){

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

  getMessagesByIds(conver:Conversation|null,msgIds:string[],callback:QryMessagesCallback){}

  modifyMessage(conver:Conversation,msgId:string,msg:MessageContent,callback:MessageCallback){}

  sendReadReceipt(conver:Conversation,msgIds:string[],callback:CommonCallback){}

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
