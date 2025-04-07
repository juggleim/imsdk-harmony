import {JuggleIm} from '../juggleim'
import {immessage} from  '../improto/immessage'
import {
  FileMessage,
  ImageMessage,
  MergeMessage, Message, MessageContent,MessageSentState,
  RecallInfoMessage,TextMessage,
  VideoMessage,
  VoiceMessage} from '../entries/message'
import { Conversation, ConversationInfo } from '../entries/conversation'
import { MsgFlag, MsgFlagTool } from '../improto/msgflag'
import { ConnStatus, ImClient } from '../imclients/imclient'
import { CommonCallback } from './commoncallback'
import { HashMap } from '@kit.ArkTS'
import { ClearUnreadMessage, ReadNtfMessage, RecallCmdMessage } from '../entries/cmdmsg'
import { UserInfo } from '../entries/user';
import { JimDbManager } from '../dbs/dbmanager'
import Long from 'long'
import { JimUtil } from '../commons/jimutil'

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

function promiseSyncConvers(mgr:MessageManager):Promise<boolean>{
  return new Promise((resolve)=>{
    mgr.syncConvers((isFinish)=>{
      resolve(isFinish)
    })
  })
}

function  promiseSyncMsgs(mgr:MessageManager):Promise<boolean>{
  return new Promise((resolve)=>{
    mgr.syncMsgs(0,(isFinish)=>{
      resolve(isFinish)
    })
  })
}

export class MessageManager{
  public Index:number = 0
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

  public async syncAfterConnect(status:number,reasonCode:number,userId:string){
    if(status === ConnStatus.connected) {
      if (!JimDbManager.instance.hasInit) {
        JuggleIm.instance.initDb(userId)
      }
      let isContinue:boolean = true
      //sync convers
      for(;isContinue;) {
        await promiseSyncConvers(JuggleIm.instance.getMessageManager()).then((isFinish)=>{
          if(isFinish){
            isContinue = false
          }
        })
      }
      isContinue = true
      //sync msgs
      for(;isContinue;){
        await promiseSyncMsgs(JuggleIm.instance.getMessageManager()).then((isFinish)=>{
          if(isFinish){
            isContinue = false
          }
        })
      }
      console.log("jimsdk_syncconvers_finish",isContinue)
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
        this.syncMsgs(notify.syncTime as number,(isFinish)=>{})
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

  public syncMsgs(ntfTime:number,callback:(isFinish:boolean)=>void){
    console.log("jimsdk_syncmsg_exetue")
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
        console.log("jimsdk_syncconvers_msgs",downMsgs.msgs.length,this.getLatestInboxMsgTime())
        if(downMsgs.isFinished){
          callback(true)
        }else{
          callback(false)
        }
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

  public syncConvers(callback:(isFinish:boolean)=>void){
    let req = immessage.SyncConversationsReq.create({
      startTime:this.getLatestConverSyncTime(),
      count:100
    })
    let data = immessage.SyncConversationsReq.encode(req).finish()
    this.imclient.query("sync_convers",JuggleIm.instance.userId,data,(code,qryAck)=>{
      if(code==0){
        let d = qryAck.data as Uint8Array
        let resp = immessage.QryConversationsResp.decode(d)
        let l = resp.conversations.length
        let lastSyncTime = 0
        resp.conversations.forEach((conver)=>{
          if(lastSyncTime<(conver.syncTime as number)){
            lastSyncTime = conver.syncTime as number
          }
          let converInfo = new ConversationInfo()
          converInfo.conversation = new Conversation(conver.targetId as string,conver.channelType as number)
          converInfo.unreadCount = JimUtil.toNumber(conver.unreadCount as Long)
          converInfo.converTime = JimUtil.toNumber(conver.sortTime as number)
          converInfo.syncTime = JimUtil.toNumber(conver.syncTime as number)
          converInfo.isTop = (conver.isTop as number)>0
          converInfo.topTime = JimUtil.toNumber(conver.topUpdatedTime as number)
          converInfo.isMute = (conver.undisturbType as number)>0
          converInfo.draft = ""
          converInfo.lastReadMsgIndex = JimUtil.toNumber(conver.latestReadIndex as number)
          converInfo.unreadTag = JimUtil.toNumber(conver.unreadTag as number)
          if(conver.msg!=undefined && conver.msg!=null){
            converInfo.lastMessage = new Message()
            converInfo.lastMessage.conversation = new Conversation(conver.targetId as string, conver.channelType as number)
            converInfo.lastMessage.clientId = conver.msg.clientUid as string
            converInfo.lastMessage.messageId = conver.msg.msgId as string
            converInfo.lastMessage.msgType = conver.msg.msgType as string
            converInfo.lastMessage.msgContent = this.constructByMsgType(conver.msg.msgType as string)
            converInfo.lastMessage.msgContent.decode(conver.msg.msgContent as Uint8Array)
            converInfo.lastMessage.sentTime = JimUtil.toNumber(conver.msg.msgTime as number)
            converInfo.lastMessage.msgSeqNo = JimUtil.toNumber(conver.msg.msgSeqNo as number)
            converInfo.lastMessage.msgUnreadIndex = JimUtil.toNumber(conver.msg.unreadIndex as number)
            converInfo.lastMessage.senderId = conver.msg.senderId as string
            if(converInfo.conversation.conversationType==1){
              let dbU = JuggleIm.instance.getUserInfoManager().getLocalUserInfo(conver.targetId as string)
              if(dbU===null){
                if(conver.targetUserInfo!=null&&conver.targetUserInfo!=undefined){
                  let user = new UserInfo()
                  user.userId = conver.targetUserInfo.userId as string
                  user.nickname = conver.targetUserInfo.nickname as string
                  user.userPortrait = conver.targetUserInfo.userPortrait as string
                  user.updTime = JimUtil.toNumber(conver.targetUserInfo.updatedTime as number)
                  user.userType = conver.targetUserInfo.userType as number
                  console.log("jimsdk_saveuser:",JuggleIm.instance.userId,conver.targetId,conver.channelType,JSON.stringify(user))
                  JuggleIm.instance.getUserInfoManager().saveUserInfo(user)
                  let du = JuggleIm.instance.getUserInfoManager().getLocalUserInfo(user.userId)
                  console.log("jimsdk_saveuser_qry:",JSON.stringify(du))
                }
              }
            }else if(converInfo.conversation.conversationType==2)
            // converInfo.lastMessage.sender = new UserInfo()
            // if(conver.msg.targetUserInfo!=null){
            //   converInfo.lastMessage.sender.userId = conver.msg.targetUserInfo.userId as string
            //   converInfo.lastMessage.sender.nickname = conver.msg.targetUserInfo.nickname as string
            //   converInfo.lastMessage.sender.userPortrait = conver.msg.targetUserInfo.userPortrait as string
            //   converInfo.lastMessage.sender.userType = conver.msg.targetUserInfo.userType as immessage.UserType
            // }
            if(conver.msg.senderId == JuggleIm.instance.userId){
              converInfo.lastMessage.direction = 0
            }else{
              converInfo.lastMessage.direction = 1
            }
            converInfo.lastMessage.flags = JimUtil.toNumber(conver.msg.flags as number)
            converInfo.lastMessage.hasRead = conver.msg.isRead as boolean
            converInfo.lastMessage.readCount = JimUtil.toNumber(conver.msg.readCount as number)
            converInfo.lastMessage.memberCount = JimUtil.toNumber(conver.msg.memberCount as number)
            converInfo.lastMessage.searchContent = conver.msg.SearchText as string
            converInfo.lastMessage.referMsgId = conver.msg.referMsg?.msgId as string
          }
          JimDbManager.instance.getConversationDao().insert(converInfo)
          this.recordLatestConverSyncTime(JimUtil.toNumber(conver.syncTime as number),conver.msg?.flags as number)
        })
        console.log("jimsdk_syncconvers_len:",l,this.latestConverSyncTime)
        if(resp.isFinished){
          callback(true)
        }else{
          callback(false)
        }
      }else{
        callback(true)
      }
    })
  }

  private recordLatestConverSyncTime(time:number,flags:number){
    let flag = MsgFlagTool.parseFlag(flags)
    if(flag.isStorage){
      if(time>this.latestConverSyncTime){
        this.latestConverSyncTime = time
        JimDbManager.instance.getConfDao().setConverSyncTime(this.latestConverSyncTime)
      }
    }
  }

  private getLatestConverSyncTime():number{
    if(this.latestConverSyncTime>0){
      return this.latestConverSyncTime
    }
    this.latestConverSyncTime = JimDbManager.instance.getConfDao().getConverSyncTime()
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
