import {JuggleIm} from '../juggleim'
import {immessage} from  '../improto/immessage'
import {
  FileMessage,
  ImageMessage,
  MergeMessage, Message, MessageContent,MessageSentState,
  RecallInfoMessage,TextMessage,
  VideoMessage,
  VoiceMessage} from '../entries/message'
import { Conversation } from '../entries/conversation'
import { MsgFlagTool } from '../improto/msgflag'
import { ConnStatus, ImClient } from '../imclients/imclient'
import { CommonCallback } from './commoncallback'
import { HashMap } from '@kit.ArkTS'
import { ClearUnreadMessage, ReadNtfMessage, RecallCmdMessage } from '../entries/cmdmsg'
import { UserInfo } from '../entries/user';
import { ConnStatusListener } from '../imclients/imclient'
import { JimDbManager } from '../dbs/dbmanager'
import { PreferenceUtil } from '../commons/preferenceutil'

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

  private msgTypeMap:Map<string,Function> = new Map()
  private latestInboxMsgTime:number = 0
  private latestSendboxMsgTime:number = 0
  private isSyncing:boolean = false
  private latestConverSyncTime:number = 0

  constructor(imclient:ImClient) {
    this.imclient = imclient
    //regist inner msg type
    this.registerMessage("jg:text",TextMessage)
    this.registerMessage("jg:merge",MergeMessage)
    this.registerMessage("jg:voice",VoiceMessage)
    this.registerMessage("jg:img",ImageMessage)
    this.registerMessage("jg:file",FileMessage)
    this.registerMessage("jg:video",VideoMessage)
    this.registerMessage("jg:recallinfo",RecallInfoMessage)
    //cmd msg
    this.registerMessage("jg:recall",RecallCmdMessage)
    this.registerMessage("jg:readntf",ReadNtfMessage)
    this.registerMessage("jg:clearunread",ClearUnreadMessage)

    this.imclient.registePublishListener("msg",(index,data)=>{
      this.onDirectMsgReceived(index,data)
    })
    this.imclient.registePublishListener("ntf",(index,data)=>{
      this.onMsgNotify(index,data)
    })
    this.imclient.addConnectStatusListener(this.syncAfterConnect)
  }

  registerMessage(msgType:string,constructor:Function){
    this.msgTypeMap.set(msgType,constructor)
  }

  constructByMsgType(msgType:string):MessageContent{
    if(this.msgTypeMap.has(msgType)){
      let f = this.msgTypeMap.get(msgType)
      let obj  = this.createObj(f as FunctionConstructor)
      return obj as MessageContent
    }else{
      return new MessageContent()
    }
  }

  private createObj(constructor:FunctionConstructor):Object{
    return new constructor()
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

  private syncAfterConnect(status:number,reasonCode:number,userId:string){
    if(status === ConnStatus.connected) {
      if (!JimDbManager.instance.hasInit) {
        JuggleIm.instance.initDb(userId)
      }
      //sync conversation
      this.syncConvers()
      //sync offline msg
      this.syncMsgs(0)
    }
  }

  private onDirectMsgReceived(index:number,data:Uint8Array){
    if(data!=null&&data!=undefined){
      let downMsg = immessage.DownMsg.decode(data)
      //send ack
      this.recordLatestInboxMsgTime(downMsg.msgTime as number,downMsg.flags)
      this.msgAck(index,downMsg.flags)
      let msg = this.downMsg2Message(downMsg)
      if(!this.isSyncing||msg.msgContent.getFlag().isState){
        this.msgReceive(msg)
      }
    }
  }

  private onMsgNotify(index:number,data:Uint8Array){
    if(data!=null&&data!=undefined){
      let notify = immessage.Notify.decode(data)
      if(notify.type == immessage.NotifyType.Msg) {
        this.syncMsgs(notify.syncTime as number)
      }else if(notify.type == immessage.NotifyType.ChatroomMsg){
        //TODO
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

  private syncMsgs(ntfTime:number){
    console.log("jimsdk_syncmsg_exetue")
    this.isSyncing = true
    let syncReq = immessage.SyncMsgReq.create({
      "syncTime":this.getLatestInboxMsgTime(),
      "containsSendBox":true,
      "sendBoxSyncTime":this.getLatestSendboxMsgTime()
    })
    let data = immessage.SyncMsgReq.encode(syncReq).finish()
    this.imclient.query("sync_msgs",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code==0){
        let data = qryAck.data as Uint8Array
        let downMsgs = immessage.DownMsgSet.decode(data)
        downMsgs.msgs.forEach((downMsg)=>{
          let message = this.downMsg2Message(downMsg)
          this.recordLatestInboxMsgTime(downMsg.msgTime as number,downMsg.flags as number)
          this.msgReceive(message)
        })
        this.isSyncing = false
      }else{
       console.log("jimsdk_syncmsg_failed:",code)
      }
    })
  }

  private getLatestInboxMsgTime():number{
    return this.latestInboxMsgTime
  }

  private getLatestSendboxMsgTime():number{
    return this.latestSendboxMsgTime
  }

  private syncConvers(){
    let req = immessage.SyncConversationsReq.create({
      startTime:this.getLatestConverSyncTime(),
      count:100
    })
  }

  private recordLatestConverSyncTime(time:number,flags:number){

  }

  private getLatestConverSyncTime():number{
    return this.latestConverSyncTime
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
          this.recordLatestSendboxMsgTime(message.sentTime,flags)
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
          msgs.push(this.downMsg2Message(msg))
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

  downMsg2Message(downMsg:immessage.IDownMsg):Message{
    let message = new Message()
    message.conversation = new Conversation(downMsg.targetId as string,downMsg.channelType as number)
    if(downMsg.channelType === immessage.ChannelType.Private){
      message.conversation.conversationTitle = downMsg.targetUserInfo?.nickname as string
      message.conversation.conversationPortrait = downMsg.targetUserInfo?.userPortrait as string
    }else if(downMsg.channelType === immessage.ChannelType.Group){
      message.conversation.conversationTitle = downMsg.groupInfo?.groupName as string
      message.conversation.conversationPortrait = downMsg.groupInfo?.groupPortrait as string
    }
    console.log("jimsdk_converitem\tname:",message.conversation.conversationTitle,"\tportrait:",message.conversation.conversationPortrait)
    message.messageId = downMsg.msgId as string
    message.msgType = downMsg.msgType as string

    message.msgContent = this.constructByMsgType(message.msgType)
    message.msgContent.decode(downMsg.msgContent as Uint8Array)
    console.log("jimsdk_des:", message.msgContent instanceof TextMessage,message.msgType)

    message.sentTime = downMsg.msgTime as number
    message.msgSeqNo = downMsg.msgSeqNo as number
    message.sender = new UserInfo()
    message.sender.userId = downMsg.senderId as string
    message.sender.nickname = downMsg.targetUserInfo?.nickname as string
    message.sender.userPortrait = downMsg.targetUserInfo?.userPortrait as string

    return message
  }
}