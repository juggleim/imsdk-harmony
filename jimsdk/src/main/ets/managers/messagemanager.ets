import {JuggleIm} from '../juggleim'
import {immessage} from  '../improto/immessage'
import { Message, MessageContent,MessageSentState,TextMessage} from '../entries/message'
import {imconnect} from '../improto/imconnect'
import { Conversation } from '../entries/conversation'
import { MsgFlagTool } from '../improto/msgflag'
import { ConnectionManager } from './connectionmanager'

export type MsgSendCallback = (isSucc:boolean,msg:Message,code:number)=>void
export type MsgReceivedListener = (msg:Message)=>void

export class MessageManager{
  static instance:MessageManager = new MessageManager()

  private latestInboxMsgTime:number = 0
  private latestSendboxMsgTime:number = 0
  private isSyncing:boolean = false

  constructor() {
    // ConnectionManager.instance.registePublishListener("msg",(index,data)=>{
    //   this.onDirectMsgReceived(index,data)
    // })
    // ConnectionManager.instance.registePublishListener("ntf",(index,data)=>{
    //   this.onMsgNotify(index,data)
    // })
  }

  private msgReceivedListener:MsgReceivedListener = (msg)=>{}

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
    let message = new Message(conver)
    message.msgContent = msg
    message.msgType = msg.getMsgType()

    message.sentState = MessageSentState.sending
    let data = immessage.UpMsg.encode(upMsg).finish()
    JuggleIm.instance.connectionManager().publish(method,targetId,data,(code,pubAck)=>{
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
        callback(true,message,code)
      }else{
        message.sentState = MessageSentState.failed
        callback(false,message,code)
      }
    })
  }

  setMessageListener(listener:MsgReceivedListener){
    console.log("jimsdk_setmsglistener")
    this.msgReceivedListener = listener
  }

  onDirectMsgReceived(index:number,data:Uint8Array){
    if(data!=null&&data!=undefined){
      let downMsg = immessage.DownMsg.decode(data)
      //send ack
      this.recordLatestInboxMsgTime(downMsg.msgTime as number,downMsg.flags)
      this.msgAck(index,downMsg.flags)
      let msg = this.downMsg2Message(downMsg)
      if(!this.isSyncing||msg.msgContent.getFlag().isState){
        this.msgReceivedListener(msg)
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
            let msg = this.downMsg2Message(downMsg)
            if(!this.isSyncing||msg.msgContent.getFlag().isState){
              this.msgReceivedListener(msg)
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
    ConnectionManager.instance.pubAck(index)
    // JuggleIm.instance.connectionManager().pubAck(index)
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
    JuggleIm.instance.connectionManager().query("sync_msgs",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code==0){
        let data = qryAck.data as Uint8Array
        let downMsgs = immessage.DownMsgSet.decode(data)
        downMsgs.msgs.forEach((downMsg,index)=>{
          let message = this.downMsg2Message(downMsg)
          this.recordLatestInboxMsgTime(downMsg.msgTime as number,downMsg.flags as number)
          this.msgReceivedListener(message)
        })
        this.isSyncing = false
      }else{
       console.log("jimsdk_syncmsg_failed:",code)
      }
    })
  }

  private downMsg2Message(downMsg:immessage.IDownMsg):Message{
    let message = new Message(new Conversation(downMsg.targetId as string,downMsg.channelType as number))
    message.messageId = downMsg.msgId as string
    message.msgType = downMsg.msgType as string
    if(message.msgType=="jg:text"){
      let txtMsg = new TextMessage("","")
      message.msgContent = txtMsg.decode(downMsg.msgContent as Uint8Array)
    }
    message.sentTime = downMsg.msgTime as number
    message.msgSeqNo = downMsg.msgSeqNo as number

    return message
  }
}