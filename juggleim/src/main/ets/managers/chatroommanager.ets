import { Conversation } from '../entries/conversation'
import { JimErrorCode } from '../entries/errcode'
import { ConnStatus, ImClient } from '../imclients/imclient'
import { chatroom } from '../improto/chatroom.js'
import { immessage } from '../improto/immessage'
import { JuggleIm } from '../juggleim'
import { MsgSyncManager } from './msgsyncmanager'
import { JimDbManager } from '../dbs/dbmanager'
import { JimUtil } from '../commons/jimutil'
import { IChatroomManager } from '../interfaces/ichatroommanager'
import {
  ChatroomAttributesCallback,
  ChatroomAttributesListener,
  ChatroomAttributesUpdateCallback,
  ChatroomListener
} from '../interfaces/chatroomtypes'

const TOP_TRACE_TAG:string = 'TOPTRACE'

class CachedChatroom {
  status:number = 0
  syncTime:number = 0
  attrSyncTime:number = 0
  prevMessageCount:number = -1
  attributes:Map<string, string> = new Map()

  constructor() {
  }
}

class ChatroomStatus {
  static readonly joining:number = 1
  static readonly joined:number = 2
  static readonly failed:number = 3
}

export class ChatroomManager implements IChatroomManager {
  private imclient:ImClient
  private msgSyncMgr:MsgSyncManager
  private chatroomCache:Map<string, CachedChatroom> = new Map()
  private listenerMap:Map<string, ChatroomListener> = new Map()
  private attributesListenerMap:Map<string, ChatroomAttributesListener> = new Map()
  private attrRetryTaskId:number = 0
  private attrRetryDelay:number = 1000
  private pendingAttrRetryChatroomId:string = ''
  private chatroomSyncProcessing:boolean = false
  private pendingChatroomSyncMap:Map<string, number> = new Map()

  constructor(imclient:ImClient, msgSyncMgr:MsgSyncManager) {
    this.imclient = imclient
    this.msgSyncMgr = msgSyncMgr
    this.imclient.addConnectStatusListener(this.onConnectionStatusChanged)
    this.imclient.registePublishListener('c_user_ntf', (_index,data)=>{
      this.onChatroomEventNotify(data)
    })
  }

  joinChatroom(chatroomId:string):void
  joinChatroom(chatroomId:string, prevMessageCount:number):void
  joinChatroom(chatroomId:string, prevMessageCount:number, isAutoCreate:boolean):void
  joinChatroom(chatroomId:string, prevMessageCount?:number, isAutoCreate?:boolean):void {
    let normalizedId = chatroomId.trim()
    if(normalizedId == ''){
      console.error(`${TOP_TRACE_TAG} chatroom_join_invalid: chatroomId is empty`)
      return
    }
    let normalizedCount = prevMessageCount != undefined ? prevMessageCount : -1
    let normalizedAutoCreate = isAutoCreate == true
    let cache = this.ensureChatroom(normalizedId)
    cache.status = ChatroomStatus.joining
    cache.prevMessageCount = normalizedCount
    console.log(`${TOP_TRACE_TAG} chatroom_join_request: chatroomId=${normalizedId}, prevMessageCount=${normalizedCount}, isAutoCreate=${normalizedAutoCreate}`)
    let req = chatroom.ChatroomReq.create({
      chatId: normalizedId,
      isAutoCreate: normalizedAutoCreate
    })
    let data = chatroom.ChatroomReq.encode(req).finish()
    this.imclient.query('c_join', normalizedId, data, (code, qryAck)=>{
      let timestamp = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : 0
      console.log(`${TOP_TRACE_TAG} chatroom_join_ack: chatroomId=${normalizedId}, code=${code}, timestamp=${timestamp}`)
      if(code == 0){
        cache.status = ChatroomStatus.joined
        if(normalizedCount == 0 && cache.syncTime == 0 && timestamp > 0){
          cache.syncTime = timestamp
        }
        this.syncChatroomAttributes(normalizedId)
        this.handleChatroomSyncNotify(normalizedId, cache.syncTime + 1)
        this.listenerMap.forEach((listener)=>{
          listener.onChatroomJoin(normalizedId)
        })
        return
      }
      cache.status = ChatroomStatus.failed
      this.listenerMap.forEach((listener)=>{
        listener.onChatroomJoinFail(normalizedId, code)
      })
    })
  }

  quitChatroom(chatroomId:string):void {
    let normalizedId = chatroomId.trim()
    if(normalizedId == ''){
      console.error(`${TOP_TRACE_TAG} chatroom_quit_invalid: chatroomId is empty`)
      return
    }
    let req = chatroom.ChatroomReq.create({
      chatId: normalizedId
    })
    let data = chatroom.ChatroomReq.encode(req).finish()
    console.log(`${TOP_TRACE_TAG} chatroom_quit_request: chatroomId=${normalizedId}`)
    this.imclient.query('c_quit', normalizedId, data, (code, qryAck)=>{
      let timestamp = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : 0
      console.log(`${TOP_TRACE_TAG} chatroom_quit_ack: chatroomId=${normalizedId}, code=${code}, timestamp=${timestamp}`)
      if(code == 0){
        this.clearChatroom(normalizedId)
        this.listenerMap.forEach((listener)=>{
          listener.onChatroomQuit(normalizedId)
        })
        return
      }
      this.listenerMap.forEach((listener)=>{
        listener.onChatroomQuitFail(normalizedId, code)
      })
    })
  }

  setAttributes(chatroomId:string, attributes:Map<string, string>, callback:ChatroomAttributesUpdateCallback):void {
    let normalizedId = chatroomId.trim()
    if(normalizedId == '' || attributes.size == 0){
      callback(new JimErrorCode().InvalidParam, null)
      return
    }
    let reqs:chatroom.IChatAttReq[] = []
    attributes.forEach((value, key)=>{
      let normalizedKey = key.trim()
      if(normalizedKey == ''){
        return
      }
      reqs.push(chatroom.ChatAttReq.create({
        key: normalizedKey,
        value: value,
        isForce: false
      }))
    })
    if(reqs.length == 0){
      callback(new JimErrorCode().InvalidParam, null)
      return
    }
    let req = chatroom.ChatAttBatchReq.create({
      atts: reqs
    })
    let data = chatroom.ChatAttBatchReq.encode(req).finish()
    console.log(`${TOP_TRACE_TAG} chatroom_set_attrs_request: chatroomId=${normalizedId}, keys=${JSON.stringify(Array.from(attributes.keys()))}`)
    this.imclient.query('c_batch_add_att', normalizedId, data, (code, qryAck)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_set_attrs_ack: chatroomId=${normalizedId}, code=${code}`)
      if(code != 0){
        let failedKeys:Map<string, number> = new Map()
        attributes.forEach((_value, key)=>{
          failedKeys.set(key, code)
        })
        callback(code, failedKeys)
        return
      }
      let resp = chatroom.ChatAttBatchResp.decode(qryAck.data as Uint8Array)
      let failedKeys = this.collectFailedKeys(resp.attResps)
      if(failedKeys.size > 0){
        callback(new JimErrorCode().ChatroomBatchSetAttributeFail, failedKeys)
        return
      }
      this.applyAttributeUpdate(normalizedId, attributes)
      callback(0, null)
    })
  }

  removeAttributes(chatroomId:string, keys:string[], callback:ChatroomAttributesUpdateCallback):void {
    let normalizedId = chatroomId.trim()
    let normalizedKeys = keys.map((key)=>{
      return key.trim()
    }).filter((key)=>{
      return key != ''
    })
    if(normalizedId == '' || normalizedKeys.length == 0){
      callback(new JimErrorCode().InvalidParam, null)
      return
    }
    let req = chatroom.ChatAttBatchReq.create({
      atts: normalizedKeys.map((key)=>{
        return chatroom.ChatAttReq.create({
          key: key,
          isForce: false
        })
      })
    })
    let data = chatroom.ChatAttBatchReq.encode(req).finish()
    console.log(`${TOP_TRACE_TAG} chatroom_remove_attrs_request: chatroomId=${normalizedId}, keys=${JSON.stringify(normalizedKeys)}`)
    this.imclient.query('c_batch_del_att', normalizedId, data, (code, qryAck)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_remove_attrs_ack: chatroomId=${normalizedId}, code=${code}`)
      if(code != 0){
        let failedKeys:Map<string, number> = new Map()
        normalizedKeys.forEach((key)=>{
          failedKeys.set(key, code)
        })
        callback(code, failedKeys)
        return
      }
      let resp = chatroom.ChatAttBatchResp.decode(qryAck.data as Uint8Array)
      let failedKeys = this.collectFailedKeys(resp.attResps)
      if(failedKeys.size > 0){
        callback(new JimErrorCode().ChatroomBatchSetAttributeFail, failedKeys)
        return
      }
      this.applyAttributeRemove(normalizedId, normalizedKeys)
      callback(0, null)
    })
  }

  getAllAttributes(chatroomId:string, callback:ChatroomAttributesCallback):void {
    let cache = this.chatroomCache.get(chatroomId)
    if(cache == undefined){
      callback(new JimErrorCode().NotChatroomMember, null)
      return
    }
    callback(0, this.cloneStringMap(cache.attributes))
  }

  addListener(key:string, listener:ChatroomListener):void {
    this.listenerMap.set(key, listener)
  }

  removeListener(key:string):void {
    this.listenerMap.delete(key)
  }

  addAttributesListener(key:string, listener:ChatroomAttributesListener):void {
    this.attributesListenerMap.set(key, listener)
  }

  removeAttributesListener(key:string):void {
    this.attributesListenerMap.delete(key)
  }

  public isChatroomAvailable(chatroomId:string):boolean {
    return this.chatroomCache.get(chatroomId) != undefined
  }

  public getSyncTimeForChatroom(chatroomId:string):number {
    let cache = this.chatroomCache.get(chatroomId)
    if(cache == undefined){
      return 0
    }
    return cache.syncTime
  }

  public handleChatroomSyncNotify(chatroomId:string, syncTime:number):void {
    let cache = this.chatroomCache.get(chatroomId)
    if(cache == undefined){
      return
    }
    if(this.chatroomSyncProcessing){
      let pendingSyncTime = this.pendingChatroomSyncMap.get(chatroomId)
      if(pendingSyncTime == undefined || syncTime > pendingSyncTime){
        this.pendingChatroomSyncMap.set(chatroomId, syncTime)
      }
      return
    }
    if(syncTime <= cache.syncTime && cache.syncTime > 0){
      return
    }
    this.syncChatroomMessages(chatroomId, syncTime)
  }

  public handleChatroomAttributesNotify(chatroomId:string, _syncTime:number):void {
    if(!this.isChatroomAvailable(chatroomId)){
      return
    }
    this.syncChatroomAttributes(chatroomId)
  }

  public handleChatroomDestroy(chatroomId:string):void {
    if(!this.isChatroomAvailable(chatroomId)){
      return
    }
    console.log(`${TOP_TRACE_TAG} chatroom_destroy_notify: chatroomId=${chatroomId}`)
    this.removeChatroom(chatroomId)
    this.listenerMap.forEach((listener)=>{
      listener.onChatroomDestroy(chatroomId)
    })
  }

  private syncChatroomMessages(chatroomId:string, syncTime:number):void {
    let cache = this.chatroomCache.get(chatroomId)
    if(cache == undefined){
      this.checkChatroomSyncQueue()
      return
    }
    if(syncTime <= cache.syncTime && cache.syncTime > 0){
      this.checkChatroomSyncQueue()
      return
    }
    let request = chatroom.SyncChatroomReq.create({
      chatroomId: chatroomId,
      syncTime: cache.syncTime,
      count: cache.prevMessageCount
    })
    let data = chatroom.SyncChatroomReq.encode(request).finish()
    console.log(`${TOP_TRACE_TAG} chatroom_sync_msgs_request: chatroomId=${chatroomId}, syncTime=${cache.syncTime}, prevMessageCount=${cache.prevMessageCount}`)
    this.chatroomSyncProcessing = true
    this.imclient.query('c_sync_msgs', JuggleIm.instance.userId, data, (code, qryAck)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_sync_msgs_ack: chatroomId=${chatroomId}, code=${code}`)
      if(code != 0){
        this.checkChatroomSyncQueue()
        return
      }
      let resp = chatroom.SyncChatroomMsgResp.decode(qryAck.data as Uint8Array)
      let currentCache = this.chatroomCache.get(chatroomId)
      if(currentCache == undefined){
        this.checkChatroomSyncQueue()
        return
      }
      let maxTime:number = currentCache.syncTime
      resp.msgs.forEach((downMsg:immessage.IDownMsg)=>{
        let sentTime = JimUtil.toNumber(downMsg.msgTime as number)
        if(sentTime > maxTime){
          maxTime = sentTime
        }
        this.msgSyncMgr.handleMsg(downMsg, ()=>{})
      })
      currentCache.syncTime = maxTime
      if(currentCache.prevMessageCount >= 0){
        currentCache.prevMessageCount = -1
      }
      console.log(`${TOP_TRACE_TAG} chatroom_sync_msgs_finish: chatroomId=${chatroomId}, count=${resp.msgs.length}, syncTime=${currentCache.syncTime}`)
      this.checkChatroomSyncQueue()
    })
  }

  private syncChatroomAttributes(chatroomId:string):void {
    let cache = this.chatroomCache.get(chatroomId)
    if(cache == undefined){
      return
    }
    let request = chatroom.SyncChatroomReq.create({
      chatroomId: chatroomId,
      syncTime: cache.attrSyncTime
    })
    let data = chatroom.SyncChatroomReq.encode(request).finish()
    console.log(`${TOP_TRACE_TAG} chatroom_sync_attrs_request: chatroomId=${chatroomId}, syncTime=${cache.attrSyncTime}`)
    this.imclient.query('c_sync_atts', JuggleIm.instance.userId, data, (code, qryAck)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_sync_attrs_ack: chatroomId=${chatroomId}, code=${code}`)
      if(code != 0){
        this.scheduleAttrRetry(chatroomId)
        return
      }
      this.resetAttrRetry()
      let resp = chatroom.SyncChatroomAttResp.decode(qryAck.data as Uint8Array)
      let currentCache = this.chatroomCache.get(chatroomId)
      if(currentCache == undefined){
        return
      }
      let currentAttributes = currentCache.attributes
      let updateMap:Map<string, string> = new Map()
      let deleteMap:Map<string, string> = new Map()
      let maxTime:number = currentCache.attrSyncTime
      resp.atts.forEach((item:chatroom.IChatAttItem)=>{
        let attTime = JimUtil.toNumber(item.attTime as number)
        let itemKey:string = item.key != undefined && item.key != null ? item.key : ''
        let itemValue:string = item.value != undefined && item.value != null ? item.value : ''
        if(attTime > maxTime){
          maxTime = attTime
        }
        if(item.optType == chatroom.ChatAttOptType.ChatAttOpt_Del){
          let oldValue = currentAttributes.get(itemKey)
          if(oldValue != undefined){
            currentAttributes.delete(itemKey)
            deleteMap.set(itemKey, oldValue)
          }
          return
        }
        currentAttributes.set(itemKey, itemValue)
        updateMap.set(itemKey, itemValue)
      })
      currentCache.attrSyncTime = maxTime
      if(updateMap.size > 0){
        this.attributesListenerMap.forEach((listener)=>{
          listener.onAttributesUpdate(chatroomId, this.cloneStringMap(updateMap))
        })
      }
      if(deleteMap.size > 0){
        this.attributesListenerMap.forEach((listener)=>{
          listener.onAttributesDelete(chatroomId, this.cloneStringMap(deleteMap))
        })
      }
    })
  }

  private collectFailedKeys(items:chatroom.IChatAttResp[]):Map<string, number> {
    let failedKeys:Map<string, number> = new Map()
    items.forEach((item)=>{
      let itemCode:number = item.code != undefined && item.code != null ? item.code : 0
      let itemKey:string = item.key != undefined && item.key != null ? item.key : ''
      if(itemCode != 0 && itemKey != ''){
        failedKeys.set(itemKey, itemCode)
      }
    })
    return failedKeys
  }

  private applyAttributeUpdate(chatroomId:string, attributes:Map<string, string>):void {
    let cache = this.ensureChatroom(chatroomId)
    attributes.forEach((value, key)=>{
      cache.attributes.set(key, value)
    })
    this.attributesListenerMap.forEach((listener)=>{
      listener.onAttributesUpdate(chatroomId, this.cloneStringMap(attributes))
    })
  }

  private applyAttributeRemove(chatroomId:string, keys:string[]):void {
    let cache = this.ensureChatroom(chatroomId)
    let deleted:Map<string, string> = new Map()
    keys.forEach((key)=>{
      let oldValue = cache.attributes.get(key)
      if(oldValue == undefined){
        return
      }
      cache.attributes.delete(key)
      deleted.set(key, oldValue)
    })
    if(deleted.size == 0){
      return
    }
    this.attributesListenerMap.forEach((listener)=>{
      listener.onAttributesDelete(chatroomId, this.cloneStringMap(deleted))
    })
  }

  private clearChatroom(chatroomId:string):void {
    this.removeChatroom(chatroomId)
    JimDbManager.instance.getMessageDao().clearConversationMessages(new Conversation(chatroomId, 3), 0, '')
  }

  private removeChatroom(chatroomId:string):void {
    this.chatroomCache.delete(chatroomId)
    this.pendingChatroomSyncMap.delete(chatroomId)
    if(this.pendingAttrRetryChatroomId == chatroomId){
      this.resetAttrRetry()
    }
  }

  private ensureChatroom(chatroomId:string):CachedChatroom {
    let cache = this.chatroomCache.get(chatroomId)
    if(cache != undefined){
      return cache
    }
    let created = new CachedChatroom()
    this.chatroomCache.set(chatroomId, created)
    return created
  }

  private cloneStringMap(source:Map<string, string>):Map<string, string> {
    let result:Map<string, string> = new Map()
    source.forEach((value, key)=>{
      result.set(key, value)
    })
    return result
  }

  private onChatroomEventNotify(data:Uint8Array):void {
    let event = chatroom.ChrmEvent.decode(data)
    let chatroomId = event.chatId
    if(chatroomId == ''){
      return
    }
    console.log(`${TOP_TRACE_TAG} chatroom_event_notify: chatroomId=${chatroomId}, eventType=${event.eventType}, userId=${event.userId}`)
    if(event.eventType == chatroom.ChrmEventType.Quit || event.eventType == chatroom.ChrmEventType.Fallout){
      this.removeChatroom(chatroomId)
      this.listenerMap.forEach((listener)=>{
        listener.onChatroomQuit(chatroomId)
      })
      return
    }
    if(event.eventType == chatroom.ChrmEventType.Kick){
      this.removeChatroom(chatroomId)
      this.listenerMap.forEach((listener)=>{
        listener.onChatroomKick(chatroomId)
      })
    }
  }

  private scheduleAttrRetry(chatroomId:string):void {
    if(this.attrRetryTaskId > 0){
      return
    }
    this.pendingAttrRetryChatroomId = chatroomId
    let delay = this.attrRetryDelay
    this.attrRetryTaskId = setTimeout(()=>{
      this.attrRetryTaskId = 0
      let retryChatroomId = this.pendingAttrRetryChatroomId
      this.pendingAttrRetryChatroomId = ''
      if(retryChatroomId != ''){
        this.syncChatroomAttributes(retryChatroomId)
      }
    }, delay)
    this.attrRetryDelay = Math.min(this.attrRetryDelay * 2, 30000)
  }

  private resetAttrRetry():void {
    if(this.attrRetryTaskId > 0){
      clearTimeout(this.attrRetryTaskId)
      this.attrRetryTaskId = 0
    }
    this.pendingAttrRetryChatroomId = ''
    this.attrRetryDelay = 1000
  }

  private checkChatroomSyncQueue():void {
    if(this.pendingChatroomSyncMap.size == 0){
      this.chatroomSyncProcessing = false
      return
    }
    let iterator = this.pendingChatroomSyncMap.entries().next()
    if(iterator.done){
      this.chatroomSyncProcessing = false
      return
    }
    let chatroomId = iterator.value[0]
    let syncTime = iterator.value[1]
    this.pendingChatroomSyncMap.delete(chatroomId)
    this.syncChatroomMessages(chatroomId, syncTime)
  }

  private onConnectionStatusChanged = (status:number, _reasonCode:number, _userId:string):void => {
    if(status != ConnStatus.connected){
      return
    }
    let chatroomIds = Array.from(this.chatroomCache.keys())
    JimDbManager.instance.getMessageDao().clearChatroomMessagesExclude(chatroomIds)
    chatroomIds.forEach((chatroomId)=>{
      let cache = this.chatroomCache.get(chatroomId)
      if(cache == undefined){
        return
      }
      this.joinChatroom(chatroomId, cache.prevMessageCount, false)
    })
  }

  public userDisconnect():void {
    this.chatroomCache.clear()
    this.pendingChatroomSyncMap.clear()
    this.chatroomSyncProcessing = false
    this.resetAttrRetry()
  }
}
