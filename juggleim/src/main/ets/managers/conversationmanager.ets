import {JuggleIm} from '../juggleim'
import { Conversation, ConversationInfo } from "../entries/conversation";
import {immessage} from  '../improto/immessage'
import { ImClient } from '../imclients/imclient';
import {MessageUtil} from  '../commons/msgutil'
import {CommonCallback} from './commoncallback'

export type ConversationCallback = (code:number,conver:ConversationInfo|null)=>void
export type ConversationsCallback = (code:number,convers:ConversationInfo[])=>void

export enum TopConverSortType{
  ByTopTime,
  BySortTime
}

export class ConversationManager{
  private imclient:ImClient
  constructor(imclient:ImClient) {
    this.imclient = imclient
  }

  queryConversations(count:number,startTime:number,isPositive:boolean,callback:ConversationsCallback){
    let order:number = 0
    if(isPositive){
      order = 1
    }
    let req = immessage.QryConversationsReq.create({
      "startTime":startTime,
      "count":count,
      "order":order
    })
    let data = immessage.QryConversationsReq.encode(req).finish()
    this.imclient.query("qry_convers",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      let convers:ConversationInfo[] = new Array()
      if(code==0){
        let data = qryAck.data as Uint8Array
        let resp = immessage.QryConversationsResp.decode(data)
        resp.conversations.forEach((conver)=>{
          let converInfo = new ConversationInfo()
          converInfo.lastMessage = MessageUtil.downMsg2Message(conver.msg as immessage.IDownMsg)
          converInfo.conversation = converInfo.lastMessage.conversation
          converInfo.sortTime = conver.sortTime as number
          converInfo.isTop = (conver.isTop as number)>0
          converInfo.topTime = conver.topUpdatedTime as number
          converInfo.mute = (conver.undisturbType as number)>0
          convers.push(converInfo)
        })
        callback(code,convers)
      }else{
        console.log("jimsdk_qryconversations_failed:",code)
        callback(code,convers)
      }
    })
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
        converInfo.lastMessage = MessageUtil.downMsg2Message(resp.msg as immessage.DownMsg)
        converInfo.conversation = converInfo.lastMessage.conversation
        converInfo.sortTime = resp.sortTime as number
        converInfo.isTop = (resp.isTop as number)>0
        converInfo.topTime = resp.topUpdatedTime as number
        converInfo.mute = (resp.undisturbType as number)>0
        callback(code,converInfo)
      }else{
        callback(code,null)
      }
    })
  }

  insertConversation(conver:Conversation,callback:CommonCallback){
    let req = immessage.Conversation.create({
      "targetId":conver.conversationId,
      "channelType":conver.conversationType
    })
    let data = immessage.Conversation.encode(req).finish()
    this.imclient.query("add_conver",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      callback(code)
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
          converInfo.lastMessage = MessageUtil.downMsg2Message(conver.msg as immessage.IDownMsg)
          converInfo.conversation = converInfo.lastMessage.conversation
          converInfo.sortTime = conver.sortTime as number
          converInfo.isTop = (conver.isTop as number)>0
          converInfo.topTime = conver.topUpdatedTime as number
          converInfo.mute = (conver.undisturbType as number)>0
          convers.push(converInfo)
        })
        callback(code,convers)
      }else{
        console.log("jimsdk_qryconversations_failed:",code)
        callback(code,convers)
      }
    })
  }
}