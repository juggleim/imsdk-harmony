import {JuggleIm} from '../juggleim'
import { Conversation, ConversationInfo } from "../entries/conversation"
import {immessage} from  '../improto/immessage'
import { ImClient } from '../imclients/imclient'
import {CommonCallback} from './commoncallback'
import { JimDbManager } from '../dbs/dbmanager'
import { MsgHandler } from '../entries/msghandler'
import { MsgSyncManager } from './msgsyncmanager'

export type ConversationCallback = (code:number,conver:ConversationInfo|null)=>void
export type ConversationsCallback = (code:number,convers:ConversationInfo[])=>void
export type ConversationInsertCallback = (code:number,conver:ConversationInfo|null)=>void
export type TotalUnreadCountCallback = (code:number,count:number)=>void

export enum TopConverSortType{
  ByTopTime,
  BySortTime
}

export type ConversationAddListener = (convers:ConversationInfo[])=>void
export type ConversationUpdateListener = (convers:ConversationInfo[])=>void
export type ConversationDeleteListener = (convers:ConversationInfo[])=>void
export type TotalUnreadCountUpdateListener = (count:number)=>void

export class ConversationManager{
  private imclient:ImClient
  private msgSyncMgr:MsgSyncManager

  constructor(imclient:ImClient,mgr:MsgSyncManager) {
    this.imclient = imclient
    this.msgSyncMgr = mgr
  }

  addConversationAddListener(listener:ConversationAddListener){
    this.msgSyncMgr.addConversationAddListener(listener)
  }

  removeConversationAddListener(listener:ConversationAddListener){
    this.msgSyncMgr.removeConversationAddListener(listener)
  }

  addConversationUpdateListener(listener:ConversationUpdateListener){
    this.msgSyncMgr.addConversationUpdateListener(listener)
  }

  removeConversationUpdateListener(listener:ConversationUpdateListener){
    this.msgSyncMgr.removeConversationUpdateListener(listener)
  }

  addConversationDeleteListener(listener:ConversationDeleteListener){
    this.msgSyncMgr.addConversationDeleteListener(listener)
  }

  removeConversationDeleteListener(listener:ConversationDeleteListener){
    this.msgSyncMgr.removeConversationDeleteListener(listener)
  }

  addTotalUnreadCountUpdateListener(listener:TotalUnreadCountUpdateListener){
    this.msgSyncMgr.addTotalUnreadCountUpdateListener(listener)
  }
  removeTotalUnreadCountUpdateListener(listener:TotalUnreadCountUpdateListener){
    this.msgSyncMgr.removeTotalUnreadCountUpdateListener(listener)
  }

  queryConversations(count:number,startTime:number,isPositive:boolean,callback:ConversationsCallback){
    if(!isPositive&&startTime<=0){
      startTime = new Date().getTime()
    }
    let convers = JimDbManager.instance.getConversationDao().queryConversations(startTime,count,isPositive)
    callback(0,convers)
  }

  getConversation(conver:Conversation,callback:ConversationCallback){
    let req = immessage.QryConverReq.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType
    })
    let data = immessage.QryConverReq.encode(req).finish()
    this.imclient.query("qry_conver",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code==0){
        let data = qryAck.data as Uint8Array
        let resp = immessage.Conversation.decode(data)
        let converInfo = new ConversationInfo()
        converInfo.lastMessage = MsgHandler.downMsg2Message(resp.msg as immessage.DownMsg)
        converInfo.conversation = converInfo.lastMessage.conversation
        converInfo.converTime = resp.sortTime as number
        converInfo.isTop = (resp.isTop as number)>0
        converInfo.topTime = resp.topUpdatedTime as number
        converInfo.isMute = (resp.undisturbType as number)>0
        callback(code,converInfo)
      }else{
        callback(code,null)
      }
    })
  }

  setDraft(conver:Conversation,draft:string){

  }

  clearDraft(conver:Conversation){}

  insertConversation(conver:Conversation,callback:ConversationInsertCallback){
    let req = immessage.Conversation.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType
    })
    let data = immessage.Conversation.encode(req).finish()
    this.imclient.query("add_conver",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code==0){
        let converInfo = new ConversationInfo()
        converInfo.conversation = conver
        callback(code,converInfo)
      }else{
        callback(code,null)
      }
    })
  }

  setUnread(conver:Conversation,callback:CommonCallback){
    let req = immessage.ConversationsReq.create({
      "conversations":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType
      }]
    })
    let data = immessage.ConversationsReq.encode(req).finish()
    this.imclient.query("mark_unread",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      callback(code)
    })
  }

  delConversation(conver:Conversation,callback:CommonCallback){
    let req = immessage.ConversationsReq.create({
      "conversations":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType
      }]
    })
    let data = immessage.ConversationsReq.encode(req).finish()
    this.imclient.query("del_convers",JuggleIm.instance.userInfo.userId,data,(code)=>{
      callback(code)
    })
  }

  setTop(conver:Conversation,isTop:boolean,callback:CommonCallback){
    let req = immessage.ConversationsReq.create({
      "conversations":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType,
        "isTop":isTop?1:0
      }]
    })
    let data = immessage.ConversationsReq.encode(req).finish()
    this.imclient.query("top_convers",JuggleIm.instance.userInfo.userId,data,(code)=>{
      callback(code)
    })
  }

  getTopConversations(sortType:TopConverSortType,start:number,isPositive:boolean,callback:ConversationsCallback){
    let order:number = 0
    if(isPositive){
      order = 1
    }
    let st = immessage.TopConverSortType.ByTopTime
    if(sortType == TopConverSortType.BySortTime){
      st = immessage.TopConverSortType.BySortTime
    }

    let req = immessage.QryTopConversReq.create({
      "startTime":start,
      "order":order,
      "sortType":st
    })

    let data = immessage.QryConversationsReq.encode(req).finish()
    this.imclient.query("qry_top_convers",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      let convers:ConversationInfo[] = new Array()
      if(code==0){
        let data = qryAck.data as Uint8Array
        let resp = immessage.QryConversationsResp.decode(data)
        resp.conversations.forEach((conver)=>{
          let converInfo = new ConversationInfo()
          converInfo.lastMessage = MsgHandler.downMsg2Message(conver.msg as immessage.IDownMsg)
          converInfo.conversation = converInfo.lastMessage.conversation
          converInfo.converTime = conver.sortTime as number
          converInfo.isTop = (conver.isTop as number)>0
          converInfo.topTime = conver.topUpdatedTime as number
          converInfo.isMute = (conver.undisturbType as number)>0
          convers.push(converInfo)
        })
        callback(code,convers)
      }else{
        console.log("jimsdk_qryconversations_failed:",code)
        callback(code,convers)
      }
    })
  }

  setMute(conver:Conversation,isMute:boolean,callback:CommonCallback){
    let req = immessage.UndisturbConversReq.create({
      "items":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType,
        "undisturbType":1
      }]
    })
    let data = immessage.UndisturbConversReq.encode(req).finish()
    this.imclient.query("undisturb_convers",JuggleIm.instance.userId,data,(code)=>{
      callback(code)
    })
  }

  getTotalUnreadCount(callback:TotalUnreadCountCallback){
    let req = immessage.QryTotalUnreadCountReq.create({
      "time":0
    })
    let data = immessage.QryTotalUnreadCountReq.encode(req).finish()
    this.imclient.query("qry_total_unread_count",JuggleIm.instance.userId,data,(code,qryAck)=>{
      if(code==0){
        let data = qryAck.data as Uint8Array
        let resp = immessage.QryTotalUnreadCountResp.decode(data)
        callback(code,resp.totalCount as number)
      }else{
        callback(code,0)
      }
    })
  }

  clearTotalUnreadCount(callback:CommonCallback){
    let req = immessage.QryTotalUnreadCountReq.create({
      "time":0
    })
    let data = immessage.QryTotalUnreadCountReq.encode(req).finish()
    this.imclient.query("clear_total_unread",JuggleIm.instance.userId,data,(code)=>{
      callback(code)
    })
  }

  clearUnreadCount(conver:Conversation,callback:CommonCallback){
    let req = immessage.ClearUnreadReq.create({
      "conversations":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType,
        "latestReadIndex":conver.msgIndex
      }]
    })
    let data = immessage.ClearUnreadReq.encode(req).finish()
    this.imclient.query("clear_unread",JuggleIm.instance.userId,data,(code)=>{
      callback(code)
    })
  }
}