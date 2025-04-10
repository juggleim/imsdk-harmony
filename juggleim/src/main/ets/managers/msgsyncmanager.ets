import { JuggleIm } from "../../../../Index";
import { JimUtil } from "../commons/jimutil";
import { JimDbManager } from "../dbs/dbmanager";
import { Conversation, ConversationInfo } from "../entries/conversation";
import { GroupInfo } from "../entries/group";
import { Message, MessageContent, MessageSentState } from "../entries/message";
import { MsgHandler } from "../entries/msghandler";
import { UserInfo } from "../entries/user";
import { ConnStatus, ImClient } from "../imclients/imclient";
import { immessage } from "../improto/immessage";
import { MsgFlag, MsgFlagTool } from "../improto/msgflag";
import Long from 'long'
import { ConversationAddListener,ConversationUpdateListener,ConversationDeleteListener,TotalUnreadCountUpdateListener } from "./conversationmanager";
import { MsgReceivedListener } from "./messagemanager";

function promiseSyncConvers(mgr:MsgSyncManager):Promise<boolean>{
  return new Promise((resolve)=>{
    mgr.syncConvers((isFinish)=>{
      resolve(isFinish)
    })
  })
}

function  promiseSyncMsgs(mgr:MsgSyncManager):Promise<boolean>{
  return new Promise((resolve)=>{
    mgr.syncMsgs(0,(isFinish)=>{
      resolve(isFinish)
    })
  })
}

function promiseHandleMsg(mgr:MsgSyncManager,downMsg:immessage.IDownMsg):Promise<boolean>{
  return new Promise((resolve)=>{
    mgr.handleMsg(downMsg,(isFinish)=>{
      resolve(isFinish)
    })
  })
}

class MsgNtfTask{
  taskType:number = 0 //0:msg; 1:ntf; 2:chatNtf;
  time:number = 0
  msg?:immessage.IDownMsg
  chatId:string = ''
  constructor(type:number,time:number,msg:immessage.IDownMsg|undefined,chatId:string) {
    this.taskType = type
    this.time = time
    this.msg = msg
    this.chatId = chatId
  }
}

export class MsgSyncManager{
  private imclient:ImClient
  private latestInboxMsgTime:number = 0
  private latestSendboxMsgTime:number = 0
  private latestConverSyncTime:number = 0
  private startSeqRunner:boolean = false
  private afterFirstSync:boolean = false
  private taskQueue:MsgNtfTask[] = []

  //conversation
  private converAddListeners:ConversationAddListener[] = new Array()
  private converUpdateListeners:ConversationUpdateListener[] = new Array()
  private converDeleteListeners:ConversationDeleteListener[] = new Array()
  private totalUnreadCountUpdateListeners:TotalUnreadCountUpdateListener[] = new Array()

  //message
  private msgReceivedListeners:MsgReceivedListener[] = new Array()

  constructor(imclient:ImClient) {
    this.imclient = imclient
    this.imclient.registePublishListener("msg",(index,data)=>{
      this.onDirectMsgReceived(index,data)
    })
    this.imclient.registePublishListener("ntf",(index,data)=>{
      this.onMsgNotify(index,data)
    })
    this.imclient.addConnectStatusListener(this.syncAfterConnect)
  }

  addConversationAddListener(listener:ConversationAddListener){
    this.converAddListeners.push(listener)
  }

  removeConversationAddListener(listener:ConversationAddListener){
    for(let i=0;i<this.converAddListeners.length;i++){
      if(this.converAddListeners[i]===listener){
        this.converAddListeners.splice(i,1)
        break
      }
    }
  }

  private triggerConversationAdd(convers:ConversationInfo[]){
    this.converAddListeners.forEach((listener)=>{
      listener(convers)
    })
  }

  addConversationUpdateListener(listener:ConversationUpdateListener){
    this.converUpdateListeners.push(listener)
  }

  removeConversationUpdateListener(listener:ConversationUpdateListener){
    for(let i=0;i<this.converUpdateListeners.length;i++){
      if(this.converUpdateListeners[i]===listener){
        this.converUpdateListeners.splice(i,1)
        break
      }
    }
  }

  private triggerConversationUpdate(convers:ConversationInfo[]){
    this.converUpdateListeners.forEach((listener)=>{
      listener(convers)
    })
  }

  addConversationDeleteListener(listener:ConversationDeleteListener){
    this.converDeleteListeners.push(listener)
  }

  removeConversationDeleteListener(listener:ConversationDeleteListener){
    for(let i=0;i<this.converDeleteListeners.length;i++){
      if(this.converDeleteListeners[i]===listener){
        this.converDeleteListeners.splice(i,1)
        break
      }
    }
  }

  private triggerConversationDelete(convers:ConversationInfo[]){
    this.converDeleteListeners.forEach((listener)=>{
      listener(convers)
    })
  }

  addTotalUnreadCountUpdateListener(listener:TotalUnreadCountUpdateListener){
    this.totalUnreadCountUpdateListeners.push(listener)
  }

  removeTotalUnreadCountUpdateListener(listener:TotalUnreadCountUpdateListener){
    for(let i=0;i<this.totalUnreadCountUpdateListeners.length;i++){
      if(this.totalUnreadCountUpdateListeners[i]===listener){
        this.totalUnreadCountUpdateListeners.splice(i,1)
        break
      }
    }
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

  private triggerMsgReceive(msg:Message){
    this.msgReceivedListeners.forEach((listener)=>{
      listener(msg)
    })
  }

  private onDirectMsgReceived(index:number,data:Uint8Array){
    if(data!=null&&data!=undefined){
      let downMsg = immessage.DownMsg.decode(data)
      //send ack
      this.msgAck(index,downMsg.flags)
      this.handleMsgNtf(new MsgNtfTask(0,JimUtil.toNumber(downMsg.msgTime as number),downMsg,''))
    }
  }

  private onMsgNotify(index:number,data:Uint8Array){
    if(data!=null&&data!=undefined){
      let notify = immessage.Notify.decode(data)
      if(notify.type == immessage.NotifyType.Msg) {
        this.handleMsgNtf(new MsgNtfTask(1,notify.syncTime as number,undefined,''))
      }else if(notify.type == immessage.NotifyType.ChatroomMsg){
        //TODO
      }
    }
  }

  private completeFirstSync(){
    this.afterFirstSync = true
  }

  private handleMsgNtf(task:MsgNtfTask){
    this.taskQueue.push(task)
    if(this.afterFirstSync&&!this.startSeqRunner){
      this.doMsgNtfProcess()
    }
  }

  private doMsgNtfProcess(){
    this.startSeqRunner = true
    while(this.taskQueue.length>0){
      let task = this.taskQueue.shift()
      if(task?.taskType == 0){//msg
        // this.handleMsg(task.msg as immessage.IDownMsg,(isFinish)=>{})
        promiseHandleMsg(this,task.msg as immessage.IDownMsg).then(()=>{})
      }else if(task?.taskType == 1){//ntf
        // promiseSyncMsgs(this).then(()=>{})
        this.syncMsgs(task.time,(isFinish)=>{})
      }
    }
    this.startSeqRunner = false
  }

  private recordLatestInboxMsgTime(sentTime:number,flags:number){
    let flag = MsgFlagTool.parseFlag(flags)
    if(!flag.isState) {
      if (sentTime > this.latestInboxMsgTime) {
        this.latestInboxMsgTime = sentTime
        JimDbManager.instance.getConfDao().setInboxSyncTime(this.latestInboxMsgTime)
      }
    }
  }

  public recordLatestSendboxMsgTime(sentTime:number,flags:number){
    let flag = MsgFlagTool.parseFlag(flags)
    if(!flag.isState) {
      if (sentTime > this.latestSendboxMsgTime) {
        this.latestSendboxMsgTime = sentTime
        JimDbManager.instance.getConfDao().setSendboxSyncTime(this.latestSendboxMsgTime)
      }
    }
  }

  private msgAck(index:number,flags:number){
    this.imclient.pubAck(index)
  }

  public syncMsgs(ntfTime:number,callback:(isFinish:boolean)=>void){
    if(ntfTime>0&&ntfTime<=this.getLatestInboxMsgTime()){
      callback(true)
      return
    }
    console.log("jimsdk_direct_syncmsg:",ntfTime,this.getLatestInboxMsgTime(),this.getLatestSendboxMsgTime())
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
          this.handleMsg(downMsg,(isFinish)=>{})
        })
        if(downMsgs.isFinished){
          callback(true)
        }else{
          callback(false)
        }
      }
    })
  }

  public handleMsg(downMsg:immessage.IDownMsg,callback:(isFinish:boolean)=>void){
    let msg = MsgHandler.downMsg2Message(downMsg)
    let msgFlag = MsgFlagTool.parseFlag(msg.flags)
    let isTrigger:boolean = true
    if(msgFlag.isState){

    }else{
      let isSend:boolean = false
      if(downMsg.senderId ==JuggleIm.instance.userId){
        isSend = true
      }
      if(isSend){
        if((downMsg.msgTime as number) < this.getLatestSendboxMsgTime()){
          return
        }
      }else{
        if((downMsg.msgTime as number) < this.getLatestInboxMsgTime()){
          return
        }
      }
      if(msgFlag.isCmd){
        //handle cmd msg
      }else{
        if(msgFlag.isStorage){
          let msgDao = JimDbManager.instance.getMessageDao()
          // check exist
          if(!msgDao.existByMsgId(msg.messageId)){
            //save msg
            console.log("jimsdk_qryhismsg_sync:",msg.messageId,msg.clientId)
            console.log("jimsdk_qryhismsg_sync:",JSON.stringify(msg))
            let aff = msgDao.insert(msg)
            if(aff>0&&msg.sentTime>this.getLatestConverSyncTime()) {
              //check conver exist
              let dbConver = JimDbManager.instance.getConversationDao().getConver(new Conversation(msg.conversation.conversationId,msg.conversation.conversationType))
              let newConverInfo = this.msg2Conver(msg)
              let isAdd:boolean = true
              if(dbConver===undefined){//add
                dbConver = newConverInfo
              }else{//update
                dbConver.syncTime = newConverInfo.syncTime
                dbConver.converTime = newConverInfo.converTime
                dbConver.lastMessage = newConverInfo.lastMessage
                isAdd = false
              }
              //update conver
              JimDbManager.instance.getConversationDao().upsert(dbConver as ConversationInfo)
              this.recordLatestConverSyncTime(dbConver.converTime)
              let convers:ConversationInfo[] = new Array()
              convers.push(dbConver)
              if(isAdd){
                this.triggerConversationAdd(convers)
              }else{
                this.triggerConversationUpdate(convers)
              }
            }
          }else{
            isTrigger = false
          }
        }
      }
      if(isSend){
        this.recordLatestSendboxMsgTime(msg.sentTime,msg.flags)
      }else {
        this.recordLatestInboxMsgTime(msg.sentTime, msg.flags)
      }
      if(isTrigger){
        this.triggerMsgReceive(msg)
      }
    }
    callback(true)
  }

  private msg2Conver(msg:Message):ConversationInfo{
    let converInfo = new ConversationInfo()
    converInfo.conversation = new Conversation(msg.conversation.conversationId,msg.conversation.conversationType)
    converInfo.lastMessage = msg
    converInfo.converTime = msg.sentTime
    converInfo.syncTime = msg.sentTime
    console.log("jimsdk_syncmsg_conver:",JSON.stringify(converInfo))
    return converInfo
  }

  private getLatestInboxMsgTime():number{
    if(this.latestInboxMsgTime>0){
      return this.latestInboxMsgTime
    }
    this.latestInboxMsgTime = JimDbManager.instance.getConfDao().getInboxSyncTime()
    return this.latestInboxMsgTime
  }

  private getLatestSendboxMsgTime():number{
    if(this.latestSendboxMsgTime>0){
      return this.latestSendboxMsgTime
    }
    this.latestSendboxMsgTime = JimDbManager.instance.getConfDao().getSendboxSyncTime()
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
        let addConvers:ConversationInfo[] = []
        let updateConvers:ConversationInfo[] = []
        let delConvers:ConversationInfo[] = []
        resp.conversations.forEach((conver)=> {
          if (lastSyncTime < (conver.syncTime as number)) {
            lastSyncTime = conver.syncTime as number
          }
          if (conver.isDelete != null && conver.isDelete != undefined) {
            if (conver.isDelete == 1) {
              let converInfo = new ConversationInfo()
              converInfo.conversation = new Conversation(conver.targetId as string, conver.channelType as number)
              delConvers.push(converInfo)
              JimDbManager.instance.getConversationDao().delConver(conver.targetId as string, conver.channelType as number)
            } else {
              let converInfo = this.toConversationInfo(conver)
              let dbConver = JimDbManager.instance.getConversationDao().getConver(new Conversation(conver.targetId as string,conver.channelType as number))
              if(dbConver===undefined){//add
                addConvers.push(converInfo)
              }else{//update
                updateConvers.push(converInfo)
              }
              JimDbManager.instance.getConversationDao().upsert(converInfo)
            }
          }
        })
        if(lastSyncTime>0){
          this.recordLatestConverSyncTime(lastSyncTime)
        }
        //trigger listener
        if(addConvers.length>0){
          this.triggerConversationAdd(addConvers)
        }
        if(updateConvers.length>0){
          this.triggerConversationUpdate(updateConvers)
        }
        if(delConvers.length>0){
          this.triggerConversationDelete(delConvers)
        }
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

  private recordLatestConverSyncTime(time:number){
    if(time>this.latestConverSyncTime){
      this.latestConverSyncTime = time
      JimDbManager.instance.getConfDao().setConverSyncTime(this.latestConverSyncTime)
    }
  }

  private getLatestConverSyncTime():number{
    if(this.latestConverSyncTime>0){
      return this.latestConverSyncTime
    }
    this.latestConverSyncTime = JimDbManager.instance.getConfDao().getConverSyncTime()
    return this.latestConverSyncTime
  }

  public async syncAfterConnect(status:number,reasonCode:number,userId:string){
    if(status === ConnStatus.connected) {
      if (!JimDbManager.instance.hasInit) {
        JuggleIm.instance.initDb(userId)
      }
      let isContinue:boolean = true
      //sync convers
      for(;isContinue;) {
        await promiseSyncConvers(JuggleIm.instance.getMsgSyncManager()).then((isFinish)=>{
          if(isFinish){
            isContinue = false
          }
        })
      }
      isContinue = true
      //sync msgs
      for(;isContinue;){
        await promiseSyncMsgs(JuggleIm.instance.getMsgSyncManager()).then((isFinish)=>{
          if(isFinish){
            isContinue = false
          }
        })
      }
      JuggleIm.instance.getMsgSyncManager().completeFirstSync()
    }
  }

  private toConversationInfo(conver:immessage.IConversation):ConversationInfo{
    let converInfo = new ConversationInfo()
    converInfo.conversation = new Conversation(conver.targetId as string, conver.channelType as number)
    converInfo.unreadCount = JimUtil.toNumber(conver.unreadCount as Long)
    converInfo.converTime = JimUtil.toNumber(conver.sortTime as number)
    converInfo.syncTime = JimUtil.toNumber(conver.syncTime as number)
    converInfo.isTop = (conver.isTop as number) > 0
    converInfo.topTime = JimUtil.toNumber(conver.topUpdatedTime as number)
    converInfo.isMute = (conver.undisturbType as number) > 0
    converInfo.draft = ""
    converInfo.lastReadMsgIndex = JimUtil.toNumber(conver.latestReadIndex as number)
    converInfo.unreadTag = JimUtil.toNumber(conver.unreadTag as number)
    if (conver.msg != undefined && conver.msg != null) {
      converInfo.lastMessage = new Message()
      converInfo.lastMessage.conversation =
        new Conversation(conver.targetId as string, conver.channelType as number)
      converInfo.lastMessage.clientId = conver.msg.clientUid as string
      converInfo.lastMessage.messageId = conver.msg.msgId as string
      converInfo.lastMessage.msgType = conver.msg.msgType as string
      converInfo.lastMessage.msgContent = MsgHandler.constructByMsgType(conver.msg.msgType as string,conver.msg.msgContent as Uint8Array)
      converInfo.lastMessage.sentTime = JimUtil.toNumber(conver.msg.msgTime as number)
      converInfo.lastMessage.msgSeqNo = JimUtil.toNumber(conver.msg.msgSeqNo as number)
      converInfo.lastMessage.msgUnreadIndex = JimUtil.toNumber(conver.msg.unreadIndex as number)
      converInfo.lastMessage.senderId = conver.msg.senderId as string
      if (converInfo.conversation.conversationType == 1) {
        if (conver.targetUserInfo != null && conver.targetUserInfo != undefined) {
          let user = new UserInfo()
          user.userId = conver.targetUserInfo.userId as string
          user.nickname = conver.targetUserInfo.nickname as string
          user.userPortrait = conver.targetUserInfo.userPortrait as string
          user.updTime = JimUtil.toNumber(conver.targetUserInfo.updatedTime as number)
          user.userType = conver.targetUserInfo.userType as number
          JuggleIm.instance.getUserInfoManager().saveUserInfo(user)
        }
      } else if (converInfo.conversation.conversationType == 2) {
        if (conver.groupInfo != null && conver.groupInfo != undefined) {
          let grp = new GroupInfo()
          grp.groupId = conver.groupInfo.groupId as string
          grp.groupName = conver.groupInfo.groupName as string
          grp.groupPortrait = conver.groupInfo.groupPortrait as string
          grp.updTime = JimUtil.toNumber(conver.groupInfo.updatedTime as number)
          JuggleIm.instance.getGroupInfoManager().saveGroupInfo(grp)
          console.log("jimsdk_grp:", JSON.stringify(grp))
        }
      }
      console.log("jimsdk_converinfo:", conver.targetId, conver.channelType, JSON.stringify(conver.groupInfo),
        JSON.stringify(conver.targetUserInfo))
      if (conver.msg.senderId == JuggleIm.instance.userId) {
        converInfo.lastMessage.direction = 0
      } else {
        converInfo.lastMessage.direction = 1
      }
      converInfo.lastMessage.flags = JimUtil.toNumber(conver.msg.flags as number)
      converInfo.lastMessage.hasRead = conver.msg.isRead as boolean
      converInfo.lastMessage.readCount = JimUtil.toNumber(conver.msg.readCount as number)
      converInfo.lastMessage.memberCount = JimUtil.toNumber(conver.msg.memberCount as number)
      converInfo.lastMessage.searchContent = conver.msg.SearchText as string
      converInfo.lastMessage.referMsgId = conver.msg.referMsg?.msgId as string
    }
    return converInfo
  }
}