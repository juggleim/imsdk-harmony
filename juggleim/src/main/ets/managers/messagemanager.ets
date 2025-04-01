import {JuggleIm} from '../juggleim'
import {immessage} from  '../improto/immessage'
import { Message, MessageContent,MessageSentState,TextMessage} from '../entries/message'
import {imconnect} from '../improto/imconnect'
import { Conversation } from '../entries/conversation'
import { MsgFlagTool } from '../improto/msgflag'
import { ImClient } from '../imclients/imclient'
import {MessageUtil} from '../commons/msgutil'

export type MsgSendCallback = (code:number,msg:Message|null)=>void
export type QryMessagesCallback = (msgs:Message[])=>void

export type MsgReceivedListener = (msg:Message)=>void
export type MsgRecalledListener = (msg:Message)=>void
export type MsgModifiedListener = (msg:Message)=>void
export type MsgDeletedListener = (conver:Conversation,msgIds:string[])=>void
export type MsgCleanedListener = (conver:Conversation,cleanTime:number,senderId:string)=>void

export class MessageManager{

  private imclient:ImClient

  private latestInboxMsgTime:number = 0
  private latestSendboxMsgTime:number = 0
  private isSyncing:boolean = false

  constructor(imclient:ImClient) {
    this.imclient = imclient
    this.imclient.registePublishListener("msg",(index,data)=>{
      this.onDirectMsgReceived(index,data)
    })
    this.imclient.registePublishListener("ntf",(index,data)=>{
      this.onMsgNotify(index,data)
    })
  }

  private msgReceivedListeners:MsgReceivedListener[] = new Array()
  private msgRecalledListeners:MsgRecalledListener[] = new Array()
  private msgModifiedListeners:MsgModifiedListener[] = new Array()
  private msgDeletedListeners:MsgDeletedListener[] = new Array()
  private msgCleanedListeners:MsgCleanedListener[] = new Array()

  sendMessage(msg:MessageContent,conver:Conversation,callback:MsgSendCallback){
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

    message.sentState = MessageSentState.sending
    let data = immessage.UpMsg.encode(upMsg).finish()
    this.imclient.publish(method,targetId,data,(code,pubAck)=>{
      if(code==0){
        if(typeof pubAck.msgId == 'string'){
          message.messageId = pubAck.msgId
        }
        if(typeof pubAck.timestamp == 'number'){
          message.sentTime = pubAck.timestamp
          this.recordLatestSendboxMsgTime(message.sentTime,flags)
        }
        if(typeof pubAck.msgSeqNo == 'number'){
          message.msgSeqNo = pubAck.msgSeqNo
        }
        message.sentState = MessageSentState.success
        callback(code,message)
      }else{
        message.sentState = MessageSentState.failed
        callback(code,message)
      }
    })
  }

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


  onDirectMsgReceived(index:number,data:Uint8Array){
    if(data!=null&&data!=undefined){
      let downMsg = immessage.DownMsg.decode(data)
      //send ack
      this.recordLatestInboxMsgTime(downMsg.msgTime as number,downMsg.flags)
      this.msgAck(index,downMsg.flags)
      let msg = MessageUtil.downMsg2Message(downMsg)
      if(!this.isSyncing||msg.msgContent.getFlag().isState){
        this.msgReceive(msg)
      }
    }
  }

  onMsgNotify(index:number,data:Uint8Array){
    if(data!=null&&data!=undefined){
      let notify = immessage.Notify.decode(data)
      if(notify.type == immessage.NotifyType.Msg) {
        this.syncMsgs(notify.syncTime as number)
      }else if(notify.type == immessage.NotifyType.ChatroomMsg){
        //TODO
      }
    }
  }

  onMsgReceived(pubBody:imconnect.IPublishMsgBody){
    let index = pubBody.index
    if(typeof index == 'number'){
      let topic = pubBody.topic
      if (typeof topic == 'string'){
        if(topic=='msg'){
          let data = pubBody.data
          if(data!=null&&data!=undefined){
            let downMsg = immessage.DownMsg.decode(data)
            //send ack
            this.recordLatestInboxMsgTime(downMsg.msgTime as number,downMsg.flags)
            this.msgAck(index,downMsg.flags)
            let msg = MessageUtil.downMsg2Message(downMsg)
            if(!this.isSyncing||msg.msgContent.getFlag().isState){
              this.msgReceive(msg)
            }
          }
        }else if(topic=='ntf'){
          let data = pubBody.data
          if(data!=null&&data!=undefined){
            let notify = immessage.Notify.decode(data)
            if(notify.type == immessage.NotifyType.Msg) {
              this.syncMsgs(notify.syncTime as number)
            }
          }
        }
      }
    }
  }

  private recordLatestInboxMsgTime(sentTime:number,flags:number){
    let flag = MsgFlagTool.parseFlag(flags)
    if(!flag.isState) {
      if (sentTime > this.latestInboxMsgTime) {
        this.latestInboxMsgTime = sentTime
      }
    }
  }

  private recordLatestSendboxMsgTime(sentTime:number,flags:number){
    let flag = MsgFlagTool.parseFlag(flags)
    if(!flag.isState) {
      if (sentTime > this.latestSendboxMsgTime) {
        this.latestSendboxMsgTime = sentTime
      }
    }
  }

  private msgAck(index:number,flags:number){
    this.imclient.pubAck(index)
  }

  public syncMsgs(ntfTime:number){
    console.log("jimsdk_syncmsg_exetue")
    this.isSyncing = true
    let syncReq = immessage.SyncMsgReq.create({
      "syncTime":this.latestInboxMsgTime,
      "containsSendBox":true,
      "sendBoxSyncTime":this.latestSendboxMsgTime
    })
    let data = immessage.SyncMsgReq.encode(syncReq).finish()
    let msgs = immessage.DownMsgSet.create()
    this.imclient.query("sync_msgs",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code==0){
        let data = qryAck.data as Uint8Array
        let downMsgs = immessage.DownMsgSet.decode(data)
        downMsgs.msgs.forEach((downMsg,index)=>{
          let message = MessageUtil.downMsg2Message(downMsg)
          this.recordLatestInboxMsgTime(downMsg.msgTime as number,downMsg.flags as number)
          this.msgReceive(message)
        })
        this.isSyncing = false
      }else{
       console.log("jimsdk_syncmsg_failed:",code)
      }
    })
  }

  queryHistoryMsgs(conver:Conversation,count:number,startTime:number,isPositive:boolean,callback:QryMessagesCallback){
    let order:number = 0
    if(isPositive){
      order = 1
    }
    let req = immessage.QryHisMsgsReq.create({
      "targetId":conver.conversationId,
      'channelType':conver.conversationType,
      'startTime':startTime,
      'count':count,
      'order':order
    })
    let data = immessage.QryHisMsgsReq.encode(req).finish()
    this.imclient.query("qry_hismsgs",conver.conversationId,data,(code,qryAck)=>{
      if(code==0){
        let msgs:Message[] = new Array()
        let data = qryAck.data as Uint8Array
        let resp = immessage.DownMsgSet.decode(data)
        resp.msgs.forEach((msg)=>{
          msgs.push(MessageUtil.downMsg2Message(msg))
        })
        callback(msgs)
      }
    })
  }
}