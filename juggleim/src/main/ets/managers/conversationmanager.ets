import {JuggleIm} from '../juggleim'
import { Conversation, ConversationInfo, ConversationTag, ConversationTagInfo } from "../entries/conversation"
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
  ConversationListener,
  ConversationTagInfosCallback,
  ConversationTagsCallback,
  ConversationSyncListener,
  ConversationTagListener,
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
  ConversationListener,
  ConversationTagInfosCallback,
  ConversationTagsCallback,
  ConversationSyncListener,
  ConversationTagListener,
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

  addListener(key:string, listener:ConversationListener):void {
    this.msgSyncMgr.addListener(key, listener)
  }

  removeListener(key:string):void {
    this.msgSyncMgr.removeListener(key)
  }

  addSyncListener(key:string, listener:ConversationSyncListener):void {
    this.msgSyncMgr.addSyncListener(key, listener)
  }

  removeSyncListener(key:string):void {
    this.msgSyncMgr.removeSyncListener(key)
  }

  addTagListener(key:string, listener:ConversationTagListener):void {
    this.msgSyncMgr.addTagListener(key, listener)
  }

  removeTagListener(key:string):void {
    this.msgSyncMgr.removeTagListener(key)
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
    let req = this.buildQryConverReq(conver)
    let data = immessage.QryConverReq.encode(req).finish()
    this.imclient.query("qry_conver",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code==0){
        let data = qryAck.data as Uint8Array
        let resp = immessage.Conversation.decode(data)
        let responseConver = new Conversation(
          resp.targetId as string,
          resp.channelType as number,
          resp.subChannel != undefined ? resp.subChannel as string : conver.subChannel
        )
        let converInfo = new ConversationInfo()
        converInfo.lastMessage = MsgHandler.downMsg2Message(resp.msg as immessage.DownMsg)
        converInfo.conversation = responseConver
        converInfo.lastMessage.conversation = responseConver
        converInfo.converTime = JimUtil.toNumber(resp.sortTime as number)
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
        JimDbManager.instance.getConversationDao().delConver(conver.conversationId, conver.conversationType, conver.subChannel)
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
    let req = this.buildProtoConversation(conver)
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

  createConversationTag(tagId:string, tagName:string, callback:CommonCallback):void{
    let normalizedTagId = tagId.trim()
    let normalizedTagName = tagName.trim()
    if(normalizedTagId == '' || normalizedTagName == ''){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let protoTag = immessage.ConverTag.create({})
    protoTag.tag = normalizedTagId
    protoTag.tagName = normalizedTagName
    protoTag.tagType = immessage.ConverTagType.UserConverTag
    let protoTags:immessage.IConverTag[] = [protoTag]
    let req = immessage.UserConverTags.create({})
    req.tags = protoTags
    let data = immessage.UserConverTags.encode(req).finish()
    this.imclient.query("create_user_conver_tags", JuggleIm.instance.userInfo.userId, data, (code, qryAck)=>{
      if(code == 0){
        let tagInfo = new ConversationTagInfo()
        tagInfo.tagId = normalizedTagId
        tagInfo.tagName = normalizedTagName
        tagInfo.tagType = immessage.ConverTagType.UserConverTag
        JimDbManager.instance.getConversationTagInfoDao().upsert(tagInfo)
        this.recordCommandSyncTime(qryAck.timestamp != undefined && qryAck.timestamp != null ?
          JimUtil.toNumber(qryAck.timestamp as number) : 0)
        this.msgSyncMgr.notifyTagCreate(tagInfo)
      }
      callback(code)
    })
  }

  destroyConversationTag(tagId:string, callback:CommonCallback):void{
    let normalizedTagId = tagId.trim()
    if(normalizedTagId == ''){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let protoTag = immessage.ConverTag.create({})
    protoTag.tag = normalizedTagId
    let protoTags:immessage.IConverTag[] = [protoTag]
    let req = immessage.UserConverTags.create({})
    req.tags = protoTags
    let data = immessage.UserConverTags.encode(req).finish()
    this.imclient.query("del_user_conver_tags", JuggleIm.instance.userInfo.userId, data, (code, qryAck)=>{
      if(code == 0){
        JimDbManager.instance.getConversationTagInfoDao().remove(normalizedTagId)
        this.recordCommandSyncTime(qryAck.timestamp != undefined && qryAck.timestamp != null ?
          JimUtil.toNumber(qryAck.timestamp as number) : 0)
        this.msgSyncMgr.notifyTagDestroy(normalizedTagId)
      }
      callback(code)
    })
  }

  updateConversationTagName(tagId:string, tagName:string, callback:CommonCallback):void{
    let normalizedTagId = tagId.trim()
    let normalizedTagName = tagName.trim()
    if(normalizedTagId == '' || normalizedTagName == ''){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let protoTag = immessage.ConverTag.create({})
    protoTag.tag = normalizedTagId
    protoTag.tagName = normalizedTagName
    protoTag.tagType = immessage.ConverTagType.UserConverTag
    let protoTags:immessage.IConverTag[] = [protoTag]
    let req = immessage.UserConverTags.create({})
    req.tags = protoTags
    let data = immessage.UserConverTags.encode(req).finish()
    this.imclient.query("create_user_conver_tags", JuggleIm.instance.userInfo.userId, data, (code, qryAck)=>{
      if(code == 0){
        JimDbManager.instance.getConversationTagInfoDao().updateName(normalizedTagId, normalizedTagName)
        this.recordCommandSyncTime(qryAck.timestamp != undefined && qryAck.timestamp != null ?
          JimUtil.toNumber(qryAck.timestamp as number) : 0)
        this.msgSyncMgr.notifyTagNameUpdate(normalizedTagId, normalizedTagName)
      }
      callback(code)
    })
  }

  getCachedConversationTagList():ConversationTagInfo[]{
    return JimDbManager.instance.getConversationTagInfoDao().queryAll()
  }

  getConversationTagList(callback:ConversationTagInfosCallback):void{
    let req = immessage.Nil.create({})
    let data = immessage.Nil.encode(req).finish()
    this.imclient.query("qry_user_conver_tags", JuggleIm.instance.userInfo.userId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, this.getCachedConversationTagList())
        return
      }
      try{
        let resp = immessage.UserConverTags.decode(qryAck.data as Uint8Array)
        let tagInfos:ConversationTagInfo[] = []
        JimDbManager.instance.getConversationTagInfoDao().clearAll()
        if(resp.tags != undefined && resp.tags != null){
          resp.tags.forEach((protoTag)=>{
            let tagInfo = this.toConversationTagInfo(protoTag)
            if(tagInfo == null){
              return
            }
            JimDbManager.instance.getConversationTagInfoDao().upsert(tagInfo)
            tagInfos.push(tagInfo)
          })
        }
        callback(0, tagInfos)
      }catch (e) {
        let err = e as Error
        console.error(`jimsdk_conversation_tag_decode_fail: ${err.message}`)
        callback(-1, this.getCachedConversationTagList())
      }
    })
  }

  getTagsForConversation(conver:Conversation):ConversationTagInfo[]{
    return JimDbManager.instance.getConversationTagInfoDao().queryByConversation(conver)
  }

  addConversationsToTag(convers:Conversation[], tagId:string, callback:CommonCallback):void{
    this.updateConversationsTag(convers, tagId, true, callback)
  }

  removeConversationsFromTag(convers:Conversation[], tagId:string, callback:CommonCallback):void{
    this.updateConversationsTag(convers, tagId, false, callback)
  }

  addConversationTag(conver:Conversation,tagId:string,callback:CommonCallback){
    this.addConversationsToTag([conver], tagId, callback)
  }

  removeConversationTag(conver:Conversation,tagId:string,callback:CommonCallback){
    this.removeConversationsFromTag([conver], tagId, callback)
  }

  getConversationTags(conver:Conversation,callback:ConversationTagsCallback){
    callback(0, JimDbManager.instance.getConverTagDao().queryByConversation(conver))
  }

  private updateConversationsTag(convers:Conversation[], tagId:string, isAdd:boolean, callback:CommonCallback):void{
    let normalizedTagId = tagId.trim()
    let normalizedConvers = this.normalizeConversations(convers)
    if(normalizedTagId == '' || normalizedConvers.length == 0){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let simpleConvers:immessage.ISimpleConversation[] = []
    normalizedConvers.forEach((conver)=>{
      let simpleConver = immessage.SimpleConversation.create({})
      simpleConver.targetId = conver.conversationId
      simpleConver.channelType = conver.conversationType
      simpleConver.msgTime = 0
      simpleConver.msgSeq = 0
      simpleConver.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
      simpleConvers.push(simpleConver)
    })
    let req = immessage.TagConvers.create({})
    req.tag = normalizedTagId
    req.convers = simpleConvers
    let data = immessage.TagConvers.encode(req).finish()
    let topic = isAdd ? "tag_add_convers" : "tag_del_convers"
    this.imclient.query(topic, JuggleIm.instance.userInfo.userId, data, (code, qryAck)=>{
      if(code == 0){
        normalizedConvers.forEach((conver)=>{
          if(isAdd){
            JimDbManager.instance.getConverTagDao().addTag(conver, normalizedTagId)
          }else{
            JimDbManager.instance.getConverTagDao().removeTag(conver, normalizedTagId)
          }
        })
        this.recordCommandSyncTime(qryAck.timestamp != undefined && qryAck.timestamp != null ?
          JimUtil.toNumber(qryAck.timestamp as number) : 0)
        this.notifyConversationTagUpdate(normalizedConvers)
        if(isAdd){
          this.msgSyncMgr.notifyConversationsAddToTag(normalizedTagId, normalizedConvers)
        }else{
          this.msgSyncMgr.notifyConversationsRemoveFromTag(normalizedTagId, normalizedConvers)
        }
      }
      callback(code)
    })
  }

  setUnread(conver:Conversation,callback:CommonCallback){
    let req = immessage.ConversationsReq.create({})
    req.conversations = [this.buildProtoConversation(conver)]
    let data = immessage.ConversationsReq.encode(req).finish()
    this.imclient.query("mark_unread",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code == 0){
        let localConver = JimDbManager.instance.getConversationDao().setUnread(conver, true)
        if(localConver != undefined){
          this.msgSyncMgr.notifyConversationUpdate([localConver])
        }
        this.msgSyncMgr.notifyTotalUnreadCountChange()
      }
      callback(code)
    })
  }

  delConversation(conver:Conversation,callback:CommonCallback){
    let req = immessage.ConversationsReq.create({})
    req.conversations = [this.buildProtoConversation(conver)]
    let data = immessage.ConversationsReq.encode(req).finish()
    this.imclient.query("del_convers",JuggleIm.instance.userInfo.userId,data,(code)=>{
      if(code == 0){
        let localConver = JimDbManager.instance.getConversationDao().getConver(conver)
        JimDbManager.instance.getConversationDao().delConver(conver.conversationId, conver.conversationType, conver.subChannel)
        if(localConver != undefined){
          this.msgSyncMgr.notifyConversationDelete([localConver])
        }
      }
      callback(code)
    })
  }

  setTop(conver:Conversation,isTop:boolean,callback:CommonCallback){
    console.log(`${TOP_TRACE_TAG} conversation_set_top_request: converId=${conver.conversationId}, converType=${conver.conversationType}, isTop=${isTop}, userId=${JuggleIm.instance.userInfo.userId}`)
    let protoConver = this.buildProtoConversation(conver)
    protoConver.isTop = isTop ? 1 : 0
    let req = immessage.ConversationsReq.create({})
    req.conversations = [protoConver]
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
          this.msgSyncMgr.recordLatestSendboxMsgTime(topTime, MsgFlagTool.toFlag(MsgFlagTool.commandFlag()))
          console.log(`${TOP_TRACE_TAG} conversation_set_top_local_update: converId=${conver.conversationId}, converType=${conver.conversationType}, localIsTop=${localConver.isTop}, localTopTime=${localConver.topTime}`)
          this.msgSyncMgr.notifyConversationUpdate([localConver])
        }else{
          console.log(`${TOP_TRACE_TAG} conversation_set_top_local_missing: converId=${conver.conversationId}, converType=${conver.conversationType}`)
        }
      }
      callback(code)
    })
  }

  setTopConversationsOrderType(sortType:TopConverSortType):void{
    let normalizedSortType = sortType == TopConverSortType.BySortTime ?
      TopConverSortType.BySortTime : TopConverSortType.ByTopTime
    JimDbManager.instance.getConfDao().setTopConverSortType(normalizedSortType)
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

    let req = immessage.QryTopConversReq.create({})
    req.startTime = start
    req.order = order
    req.sortType = st

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
          converInfo.converTime = JimUtil.toNumber(conver.sortTime as number)
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
    let item = immessage.UndisturbConverItem.create({})
    item.targetId = conver.conversationId
    item.channelType = conver.conversationType
    item.undisturbType = isMute ? 1 : 0
    item.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let req = immessage.UndisturbConversReq.create({})
    req.items = [item]
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
            this.msgSyncMgr.recordLatestSendboxMsgTime(timestamp, MsgFlagTool.toFlag(MsgFlagTool.commandFlag()))
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
    let req = immessage.QryTotalUnreadCountReq.create({})
    req.time = 0
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

  getUnreadCountWithTypes(conversationTypes:number[], callback:TotalUnreadCountCallback){
    let normalizedTypes:number[] = []
    conversationTypes.forEach((conversationType)=>{
      if(normalizedTypes.indexOf(conversationType) < 0){
        normalizedTypes.push(conversationType)
      }
    })
    callback(0, JimDbManager.instance.getConversationDao().queryUnreadCountByTypes(normalizedTypes))
  }

  getTotalUnreadCountByTag(tagId:string,callback:TotalUnreadCountCallback){
    let normalizedTagId = tagId.trim()
    if(normalizedTagId == ''){
      callback(new JimErrorCode().InvalidParam, 0)
      return
    }
    callback(0, JimDbManager.instance.getConversationDao().queryUnreadCountByTag(normalizedTagId))
  }

  getUnreadCountWithTag(tagId:string,callback:TotalUnreadCountCallback){
    this.getTotalUnreadCountByTag(tagId, callback)
  }

  clearTotalUnreadCount(callback:CommonCallback){
    let req = immessage.QryTotalUnreadCountReq.create({})
    req.time = 0
    let data = immessage.QryTotalUnreadCountReq.encode(req).finish()
    this.imclient.query("clear_total_unread",JuggleIm.instance.userId,data,(code)=>{
      if(code == 0){
        JimDbManager.instance.getConversationDao().clearTotalUnreadCount()
        JimDbManager.instance.getConversationDao().clearUnreadTag()
        this.msgSyncMgr.notifyTotalUnreadCountChange()
      }
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
    let protoConver = this.buildProtoConversation(conver)
    protoConver.latestReadIndex = latestReadIndex
    protoConver.latestReadMsgId = latestReadMsgId
    protoConver.latestReadMsgTime = latestReadMsgTime
    let req = immessage.ClearUnreadReq.create({})
    req.conversations = [protoConver]
    let data = immessage.ClearUnreadReq.encode(req).finish()
    this.imclient.query("clear_unread",JuggleIm.instance.userId,data,(code)=>{
      if(code == 0 && localConver != undefined){
        localConver.lastReadMsgIndex = latestReadIndex
        JimDbManager.instance.getConversationDao().upsert(localConver)
        this.msgSyncMgr.notifyConversationUpdate([localConver])
        this.msgSyncMgr.notifyTotalUnreadCountChange()
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
      let tagInfo = new ConversationTagInfo()
      tagInfo.tagId = tagId
      tagInfo.tagName = protoTag.tagName != undefined ? protoTag.tagName as string : ''
      tagInfo.tagType = JimUtil.toNumber(protoTag.tagType as number)
      JimDbManager.instance.getConversationTagInfoDao().upsert(tagInfo)
      let tag = new ConversationTag()
      tag.conversation = conver
      tag.tagId = tagId
      tags.push(tag)
    })
    return tags
  }

  private toConversationTagInfo(protoTag:immessage.IConverTag):ConversationTagInfo | null{
    let tagId = (protoTag.tag as string || '').trim()
    if(tagId == ''){
      return null
    }
    let tagInfo = new ConversationTagInfo()
    tagInfo.tagId = tagId
    tagInfo.tagName = protoTag.tagName != undefined ? protoTag.tagName as string : ''
    tagInfo.tagType = JimUtil.toNumber(protoTag.tagType as number)
    return tagInfo
  }

  private normalizeConversations(convers:Conversation[]):Conversation[]{
    let normalizedConvers:Conversation[] = []
    let keys:Map<string, boolean> = new Map()
    convers.forEach((conver)=>{
      if(conver.conversationId == ''){
        return
      }
      let key = conver.getKey()
      if(keys.has(key)){
        return
      }
      keys.set(key, true)
      normalizedConvers.push(conver.clone())
    })
    return normalizedConvers
  }

  private buildProtoConversation(conver:Conversation):immessage.Conversation{
    let protoConver = immessage.Conversation.create({})
    protoConver.targetId = conver.conversationId
    protoConver.channelType = conver.conversationType
    protoConver.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    return protoConver
  }

  private buildQryConverReq(conver:Conversation):immessage.QryConverReq{
    let req = immessage.QryConverReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    return req
  }

  private notifyConversationTagUpdate(convers:Conversation[]):void{
    let updatedConvers:ConversationInfo[] = []
    convers.forEach((conver)=>{
      let converInfo = JimDbManager.instance.getConversationDao().getConver(conver)
      if(converInfo != undefined){
        updatedConvers.push(converInfo)
      }
    })
    if(updatedConvers.length > 0){
      this.msgSyncMgr.notifyConversationUpdate(updatedConvers)
    }
  }

  private recordCommandSyncTime(timestamp:number):void{
    if(timestamp > 0){
      this.msgSyncMgr.recordLatestSendboxMsgTime(timestamp, MsgFlagTool.toFlag(MsgFlagTool.commandFlag()))
    }
  }
}
