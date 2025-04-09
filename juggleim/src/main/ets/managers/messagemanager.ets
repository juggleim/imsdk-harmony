import {immessage} from  '../improto/immessage'
import {
  Message, MessageContent,MessageSentState
} from '../entries/message'
import { Conversation } from '../entries/conversation'
import { MsgFlagTool } from '../improto/msgflag'
import { ImClient } from '../imclients/imclient'
import { CommonCallback } from './commoncallback'
import { HashMap } from '@kit.ArkTS'
import { JimDbManager } from '../dbs/dbmanager'
import { MsgHandler } from '../entries/msghandler'
import { MsgSyncManager } from './msgsyncmanager'

export type MessageCallback = (code:number,msg:Message|null)=>void
export type QryMessagesCallback = (code:number,msgs:Message[],hasMore:boolean)=>void

export type MsgReceivedListener = (msg:Message)=>void
export type MsgRecalledListener = (msg:Message)=>void
export type MsgModifiedListener = (msg:Message)=>void
export type MsgDeletedListener = (conver:Conversation,msgIds:string[])=>void
export type MsgCleanedListener = (conver:Conversation,cleanTime:number,senderId:string)=>void

export class QueryMsgOptions{
  count:number = 20
  startTime:number = 0
  isPositive:boolean = false
  constructor() {
  }
}

export class ClearMsgOptions{
  cleanTime:number = 0
  cleanScope:number = 0
  senderId:string = ''
  cleanTimeOffset:number = 0
}

export class SearchParams{
  conver?:Conversation
  keywords:string = ""
  msgTypes:string[] = []
  startTime:number = 0
  endTime:number = 0
}

export class MessageManager{
  private imclient:ImClient
  private msgSyncMgr:MsgSyncManager

  constructor(imclient:ImClient,mgr:MsgSyncManager) {
    this.imclient = imclient
    this.msgSyncMgr = mgr
  }

  private msgReceivedListeners:MsgReceivedListener[] = new Array()
  private msgRecalledListeners:MsgRecalledListener[] = new Array()
  private msgModifiedListeners:MsgModifiedListener[] = new Array()
  private msgDeletedListeners:MsgDeletedListener[] = new Array()
  private msgCleanedListeners:MsgCleanedListener[] = new Array()

  addMsgReceivedListener(listener:MsgReceivedListener){
    this.msgReceivedListeners.push(listener)
  }

  removeMsgReceivedListener(listener:MsgReceivedListener){
    for(let i=0;i<this.msgReceivedListeners.length;i++){
      if(this.msgReceivedListeners[i]===listener){
        this.msgReceivedListeners.splice(i,1)
        break
      }
    }
  }

  private msgReceive(msg:Message){
    this.msgReceivedListeners.forEach((listener)=>{
      listener(msg)
    })
  }

  addMsgRecalledListener(listener:MsgRecalledListener){
    this.msgRecalledListeners.push(listener)
  }

  removeMsgRecalledListener(listener:MsgRecalledListener){
    for(let i=0;i<this.msgRecalledListeners.length;i++){
      if(this.msgRecalledListeners[i]===listener){
        this.msgRecalledListeners.splice(i,1)
        break
      }
    }
  }

  addMsgModifiedListener(listener:MsgModifiedListener){
    this.msgModifiedListeners.push(listener)
  }

  removeMsgModifiedListener(listener:MsgModifiedListener){
    for(let i=0;i<this.msgModifiedListeners.length;i++){
      if(this.msgModifiedListeners[i]===listener){
        this.msgModifiedListeners.splice(i,1)
        break
      }
    }
  }

  addMsgDeletedListener(listener:MsgDeletedListener){
    this.msgDeletedListeners.push(listener)
  }

  removeMsgDeletedListener(listener:MsgDeletedListener){
    for(let i=0;i<this.msgDeletedListeners.length;i++){
      if(this.msgDeletedListeners[i]===listener){
        this.msgDeletedListeners.splice(i,1)
        break
      }
    }
  }

  addMsgCleanedListener(listener:MsgCleanedListener){
    this.msgCleanedListeners.push(listener)
  }

  removeMsgCleanedListener(listener:MsgCleanedListener){
    for(let i=0;i<this.msgCleanedListeners.length;i++){
      if(this.msgCleanedListeners[i]===listener){
        this.msgCleanedListeners.splice(i,1)
        break
      }
    }
  }

  public registerMessage(msgType:string, constructor:Function){
    MsgHandler.registerMessage(msgType, constructor)
  }

  sendMessage(msg:MessageContent,conver:Conversation,callback:MessageCallback){
    let targetId = conver.conversationId
    let method:string = ""
    if(conver.conversationType == 1){
      method = 'p_msg'
    }else if (conver.conversationType==2){
      method = 'g_msg'
    }
    let flags = MsgFlagTool.toFlag(msg.getFlag())
    let upMsg = immessage.UpMsg.create({
      "msgType":msg.getMsgType(),
      "msgContent":msg.encode(),
      "flags": flags
    })
    let message = new Message()
    message.conversation = conver
    message.msgContent = msg
    message.msgType = msg.getMsgType()

    message.state = MessageSentState.sending
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
        message.state = MessageSentState.success
        callback(code,message)
      }else{
        message.state = MessageSentState.failed
        callback(code,message)
      }
    })
  }

  sendMediaMessage(msg:MessageContent,conver:Conversation){}

  queryMessages(conver:Conversation,options:QueryMsgOptions,callback:QryMessagesCallback){

  }

  queryLocalMessages(conver:Conversation,options:QueryMsgOptions,callback:QryMessagesCallback){
    let dao = JimDbManager.instance.getMessageDao()
    let msgs = dao.queryMessages(conver.conversationId,conver.conversationType,options.startTime,options.count)
    callback(0,msgs,false)
  }

  queryRemoteMessages(conver:Conversation,options:QueryMsgOptions,callback:QryMessagesCallback){
    let order:number = 0
    if(options.isPositive){
      order = 1
    }
    let req = immessage.QryHisMsgsReq.create({
      "targetId":conver.conversationId,
      'channelType':conver.conversationType,
      'startTime':options.startTime,
      'count':options.count,
      'order':order
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

  searchMessages(params:SearchParams,callback:QryMessagesCallback){}

  setLocalAttribue(msgId:string,attribute:string){}

}
