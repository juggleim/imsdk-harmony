import {immessage} from  '../improto/immessage'
import {
  Message, MessageContent,MessageSentState
} from '../entries/message'
import { Conversation, ConversationInfo } from '../entries/conversation'
import { MsgFlagTool } from '../improto/msgflag'
import { ImClient } from '../imclients/imclient'
import { CommonCallback } from './commoncallback'
import { HashMap } from '@kit.ArkTS'
import { JimDbManager } from '../dbs/dbmanager'
import { MsgHandler } from '../entries/msghandler'
import { MsgSyncManager } from './msgsyncmanager'
import { JimUtil } from '../commons/jimutil'
import { JuggleIm } from '../juggleim'

export type MessageCallback = (code:number,msg:Message|null)=>void
export type QryMessagesCallback = (code:number,msgs:Message[],hasMore:boolean)=>void

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

export type MsgReceivedListener = (msg:Message)=>void
export type MsgRecalledListener = (msg:Message)=>void
export type MsgModifiedListener = (msg:Message)=>void
export type MsgDeletedListener = (conver:Conversation,msgIds:string[])=>void
export type MsgCleanedListener = (conver:Conversation,cleanTime:number,senderId:string)=>void

export class MessageManager{
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

  sendMessage(msg:MessageContent,conver:Conversation,callback:MessageCallback){
    let targetId = conver.conversationId
    let method:string = ""
    if(conver.conversationType == 1){
      method = 'p_msg'
    }else if (conver.conversationType==2){
      method = 'g_msg'
    }
    let clientUid:string = JimUtil.getUuid()
    let flags = MsgFlagTool.toFlag(msg.getFlag())
    let upMsg = immessage.UpMsg.create({
      msgType:msg.getMsgType(),
      msgContent:msg.encode(),
      flags: flags,
      clientUid:clientUid
    })

    let message = new Message()
    message.conversation = conver
    message.msgContent = msg
    message.msgType = msg.getMsgType()
    message.clientId = clientUid
    message.senderId = JuggleIm.instance.userId
    message.sentTime = new Date().getTime()
    message.flags = msg.getFlagNumber()
    message.state = MessageSentState.sending

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

  sendMediaMessage(msg:MessageContent,conver:Conversation){}

  queryMessages(conver:Conversation,options:QueryMsgOptions,callback:QryMessagesCallback){
    this.queryLocalMessages(conver,options,(code,msgs)=>{
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
      if(isLack||msgs.length<options.count){
        //query from remote
        this.queryRemoteMessages(conver,options,(code,remoteMsgs,hasMore)=>{
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
        callback(code,msgs,msgs.length>=options.count)
      }
    })
  }

  queryLocalMessages(conver:Conversation,options:QueryMsgOptions,callback:QryMessagesCallback){
    let dao = JimDbManager.instance.getMessageDao()
    if(!options.isPositive&&options.startTime<=0){
      options.startTime = new Date().getTime()
    }
    let msgs = dao.queryMessages(conver.conversationId,conver.conversationType,options.startTime,options.count,options.isPositive)
    callback(0,msgs,msgs.length>=options.count)
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
