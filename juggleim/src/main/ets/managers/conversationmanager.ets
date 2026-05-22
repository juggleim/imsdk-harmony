import {JuggleIm} from '../juggleim'
import { Conversation, ConversationInfo, ConversationTag } from "../entries/conversation"
import {immessage} from  '../improto/immessage'
import { ImClient } from '../imclients/imclient'
import {CommonCallback} from '../interfaces/commoncallback'
import { JimDbManager } from '../dbs/dbmanager'
import { MsgHandler } from '../entries/msghandler'
import { MsgSyncManager } from './msgsyncmanager'
import { IConversationManager } from '../interfaces/iconversationmanager'
import { JimErrorCode } from '../entries/errcode'
import { MsgFlagTool } from '../improto/msgflag'
import { JimUtil } from '../commons/jimutil'
import {
  ConversationAddListener,
  ConversationCallback,
  ConversationDeleteListener,
  ConversationInsertCallback,
  ConversationTagsCallback,
  ConversationsCallback,
  ConversationUpdateListener,
  GetConversationOptions,
  TopConverSortType,
  TotalUnreadCountCallback,
  TotalUnreadCountUpdateListener
} from '../interfaces/conversationtypes'

const TOP_TRACE_TAG:string = 'TOPTRACE'

export {
  ConversationAddListener,
  ConversationCallback,
  ConversationDeleteListener,
  ConversationInsertCallback,
  ConversationTagsCallback,
  ConversationsCallback,
  ConversationUpdateListener,
  GetConversationOptions,
  TopConverSortType,
  TotalUnreadCountCallback,
  TotalUnreadCountUpdateListener
} from '../interfaces/conversationtypes'

export class ConversationManager implements IConversationManager{
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

  queryConversations(options:GetConversationOptions,callback:ConversationsCallback): void
  queryConversations(count:number,startTime:number,isPositive:boolean,callback:ConversationsCallback): void
  queryConversations(
    arg1:GetConversationOptions|number,
    arg2:ConversationsCallback|number,
    arg3?:boolean,
    arg4?:ConversationsCallback
  ): void {
    if(typeof arg1 === 'number'){
      if(typeof arg2 !== 'number' || arg3 == undefined || arg4 == undefined){
        return
      }
      let startTime = arg2
      if(!arg3 && startTime <= 0){
        startTime = new Date().getTime()
      }
      let convers = JimDbManager.instance.getConversationDao().queryConversations(startTime,arg1,arg3)
      arg4(0,convers)
      return
    }
    if(typeof arg2 !== 'function'){
      return
    }
    let normalizedOptions = this.normalizeConversationOptions(arg1)
    let convers = JimDbManager.instance.getConversationDao().queryConversationsWithOptions(normalizedOptions)
    arg2(0,convers)
  }

  private normalizeConversationOptions(options:GetConversationOptions):GetConversationOptions{
    let normalizedOptions = new GetConversationOptions()
    normalizedOptions.count = options.count > 0 ? options.count : 20
    normalizedOptions.direction = options.direction
    normalizedOptions.time = options.time
    normalizedOptions.conversationTypes = options.conversationTypes.slice()
    normalizedOptions.tagId = options.tagId.trim()
    if(normalizedOptions.time <= 0){
      normalizedOptions.time = new Date().getTime()
    }
    return normalizedOptions
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
        converInfo.conversation = conver
        converInfo.lastMessage.conversation = conver
        converInfo.converTime = resp.sortTime as number
        converInfo.isTop = (resp.isTop as number)>0
        converInfo.topTime = JimUtil.toNumber(resp.topUpdatedTime as number)
        converInfo.isMute = (resp.undisturbType as number)>0
        converInfo.tags = this.toConversationTags(resp.converTags, converInfo.conversation)
        JimDbManager.instance.getConverTagDao().replaceTags(converInfo.conversation, converInfo.tags)
        callback(code,converInfo)
      }else{
        callback(code,null)
      }
    })
  }

  setDraft(conver:Conversation,draft:string){
    let oldConver = JimDbManager.instance.getConversationDao().getConver(conver)
    let converInfo = JimDbManager.instance.getConversationDao().setDraft(conver, draft)
    if(converInfo != undefined){
      if(this.isPlaceholderConversation(converInfo) && draft == ''){
        JimDbManager.instance.getConversationDao().delConver(conver.conversationId, conver.conversationType)
        this.msgSyncMgr.notifyConversationDelete([converInfo])
        return
      }
      if(converInfo.lastMessage.sentTime <= 0 && draft != ''){
        converInfo.converTime = new Date().getTime()
      }
      if(oldConver == undefined){
        this.msgSyncMgr.notifyConversationAdd([converInfo])
      }else{
        this.msgSyncMgr.notifyConversationUpdate([converInfo])
      }
    }
  }

  clearDraft(conver:Conversation){
    this.setDraft(conver, '')
  }

  private isPlaceholderConversation(converInfo:ConversationInfo):boolean{
    return converInfo.lastMessage.messageId == '' &&
      converInfo.lastMessage.clientId == '' &&
      converInfo.lastMessage.sentTime <= 0
  }

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

  addConversationTag(conver:Conversation,tagId:string,callback:CommonCallback){
    let normalizedTagId = tagId.trim()
    if(normalizedTagId == ''){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let converInfo = JimDbManager.instance.getConversationDao().getConver(conver)
    if(converInfo == undefined){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    JimDbManager.instance.getConverTagDao().addTag(conver, normalizedTagId)
    let updatedConver = JimDbManager.instance.getConversationDao().getConver(conver)
    if(updatedConver != undefined){
      this.msgSyncMgr.notifyConversationUpdate([updatedConver])
    }
    callback(0)
  }

  removeConversationTag(conver:Conversation,tagId:string,callback:CommonCallback){
    let normalizedTagId = tagId.trim()
    if(normalizedTagId == ''){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    JimDbManager.instance.getConverTagDao().removeTag(conver, normalizedTagId)
    let updatedConver = JimDbManager.instance.getConversationDao().getConver(conver)
    if(updatedConver != undefined){
      this.msgSyncMgr.notifyConversationUpdate([updatedConver])
    }
    callback(0)
  }

  getConversationTags(conver:Conversation,callback:ConversationTagsCallback){
    callback(0, JimDbManager.instance.getConverTagDao().queryByConversation(conver))
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
    console.log(`${TOP_TRACE_TAG} conversation_set_top_request: converId=${conver.conversationId}, converType=${conver.conversationType}, isTop=${isTop}, userId=${JuggleIm.instance.userInfo.userId}`)
    let req = immessage.ConversationsReq.create({
      "conversations":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType,
        "isTop":isTop?1:0
      }]
    })
    let data = immessage.ConversationsReq.encode(req).finish()
    this.imclient.query("top_convers",JuggleIm.instance.userInfo.userId,data,(code, qryAck)=>{
      let timestamp = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : 0
      console.log(`${TOP_TRACE_TAG} conversation_set_top_ack: converId=${conver.conversationId}, converType=${conver.conversationType}, isTop=${isTop}, code=${code}, timestamp=${timestamp}`)
      if(code == 0){
        let localConver = JimDbManager.instance.getConversationDao().getConver(conver)
        if(localConver != undefined){
          localConver.isTop = isTop
          let topTime = timestamp > 0 ? timestamp : new Date().getTime()
          localConver.topTime = isTop ? topTime : 0
          JimDbManager.instance.getConversationDao().upsert(localConver)
          this.msgSyncMgr.recordLatestSendboxMsgTime(topTime, MsgFlagTool.toFlag({ isCmd:true }))
          console.log(`${TOP_TRACE_TAG} conversation_set_top_local_update: converId=${conver.conversationId}, converType=${conver.conversationType}, localIsTop=${localConver.isTop}, localTopTime=${localConver.topTime}`)
          this.msgSyncMgr.notifyConversationUpdate([localConver])
        }else{
          console.log(`${TOP_TRACE_TAG} conversation_set_top_local_missing: converId=${conver.conversationId}, converType=${conver.conversationType}`)
        }
      }
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
    console.log(`${TOP_TRACE_TAG} conversation_set_mute_request: converId=${conver.conversationId}, converType=${conver.conversationType}, isMute=${isMute}, userId=${JuggleIm.instance.userInfo.userId}`)
    let req = immessage.UndisturbConversReq.create({
      "items":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType,
        "undisturbType":isMute ? 1 : 0
      }]
    })
    let data = immessage.UndisturbConversReq.encode(req).finish()
    this.imclient.query("undisturb_convers",JuggleIm.instance.userInfo.userId,data,(code, qryAck)=>{
      let timestamp = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : 0
      console.log(`${TOP_TRACE_TAG} conversation_set_mute_ack: converId=${conver.conversationId}, converType=${conver.conversationType}, isMute=${isMute}, code=${code}, timestamp=${timestamp}`)
      if(code == 0){
        let localConver = JimDbManager.instance.getConversationDao().getConver(conver)
        if(localConver != undefined){
          localConver.isMute = isMute
          JimDbManager.instance.getConversationDao().upsert(localConver)
          if(timestamp > 0){
            this.msgSyncMgr.recordLatestSendboxMsgTime(timestamp, MsgFlagTool.toFlag({ isCmd:true }))
          }
          console.log(`${TOP_TRACE_TAG} conversation_set_mute_local_update: converId=${conver.conversationId}, converType=${conver.conversationType}, localIsMute=${localConver.isMute}`)
          this.msgSyncMgr.notifyConversationUpdate([localConver])
        }else{
          console.log(`${TOP_TRACE_TAG} conversation_set_mute_local_missing: converId=${conver.conversationId}, converType=${conver.conversationType}`)
        }
      }
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

  getTotalUnreadCountByTag(tagId:string,callback:TotalUnreadCountCallback){
    let normalizedTagId = tagId.trim()
    if(normalizedTagId == ''){
      callback(new JimErrorCode().InvalidParam, 0)
      return
    }
    callback(0, JimDbManager.instance.getConversationDao().queryUnreadCountByTag(normalizedTagId))
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
    let localConver = JimDbManager.instance.getConversationDao().getConver(conver)
    let latestReadIndex = conver.msgIndex
    let latestReadMsgId = ''
    let latestReadMsgTime = 0
    if(localConver != undefined){
      if(latestReadIndex <= 0){
        latestReadIndex = localConver.lastMessage.msgUnreadIndex
      }
      latestReadMsgId = localConver.lastMessage.messageId
      latestReadMsgTime = localConver.lastMessage.sentTime
    }
    let req = immessage.ClearUnreadReq.create({
      "conversations":[{
        "targetId":conver.conversationId,
        "channelType":conver.conversationType,
        "latestReadIndex":latestReadIndex,
        "latestReadMsgId":latestReadMsgId,
        "latestReadMsgTime":latestReadMsgTime
      }]
    })
    let data = immessage.ClearUnreadReq.encode(req).finish()
    this.imclient.query("clear_unread",JuggleIm.instance.userId,data,(code)=>{
      if(code == 0 && localConver != undefined){
        localConver.lastReadMsgIndex = latestReadIndex
        JimDbManager.instance.getConversationDao().upsert(localConver)
        this.msgSyncMgr.notifyConversationUpdate([localConver])
      }
      callback(code)
    })
  }

  private toConversationTags(protoTags:immessage.IConverTag[]|null|undefined, conver:Conversation):ConversationTag[]{
    let tags:ConversationTag[] = []
    if(protoTags == undefined || protoTags == null){
      return tags
    }
    protoTags.forEach((protoTag)=>{
      let tagId = (protoTag.tag as string || '').trim()
      if(tagId == ''){
        return
      }
      let tag = new ConversationTag()
      tag.conversation = conver
      tag.tagId = tagId
      tags.push(tag)
    })
    return tags
  }
}
