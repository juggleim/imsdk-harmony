import {immessage} from  '../improto/immessage'
import request from '@ohos.request'
import { fileIo } from '@kit.CoreFileKit'
import { BusinessError } from '@kit.BasicServicesKit'
import {
  ImageMessage,
  FileMessage,
  FavoriteMessage,
  MergeMessage,
  MediaMessageContent,
  MediaMessageUploadState,
  Message,
  MessageContent,
  MessageReaction,
  MessageReactionResult,
  MessageSentState,
  TextMessage,
  VideoMessage,
  VoiceMessage
} from '../entries/message'
import { Conversation, ConversationInfo } from '../entries/conversation'
import { MsgFlagTool } from '../improto/msgflag'
import { ImClient } from '../imclients/imclient'
import { CommonCallback } from '../interfaces/commoncallback'
import {
  IMessageUploadProvider,
  MediaUploadCredential,
  MediaUploadCredentialCallback,
  MediaUploadErrorCallback,
  MediaUploadResult,
  MediaUploadSuccessCallback
} from '../interfaces/imessageuploadprovider'
import { HashMap } from '@kit.ArkTS'
import { JimDbManager } from '../dbs/dbmanager'
import { MsgHandler } from '../entries/msghandler'
import { MsgSyncManager } from './msgsyncmanager'
import { JimUtil } from '../commons/jimutil'
import { JuggleIm } from '../juggleim'
import { IMessageManager } from '../interfaces/imessagemanager'
import { GroupMessageMemberReadDetail, GroupMessageReadInfoDetail } from '../entries/group'
import { JimErrorCode } from '../entries/errcode'
import { MentionType, MessageOptions } from '../entries/messageoptions'
import { MessageOptionUtil } from '../commons/messageoptionutil'
import { UserInfo } from '../entries/user'
import {
  BroadcastMessageCallback,
  ClearMsgOptions,
  DownloadMediaMessageCancelCallback,
  DownloadMediaMessageErrorCallback,
  DownloadMediaMessageProgressCallback,
  DownloadMediaMessageSuccessCallback,
  FavoriteMessagesCallback,
  GetFavoriteMessageOption,
  GetMessageDirection,
  GetMessageOptions,
  GroupMessageReadInfoDetailCallback,
  MessageCallback,
  MessageReactionsCallback,
  MuteStatusCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgDestroyTimeUpdateListener,
  MsgGroupReadReceiptListener,
  MsgModifiedListener,
  MsgReadReceiptListener,
  MsgReceivedListener,
  MsgRecalledListener,
  MsgTopChangedListener,
  QryMessagesCallback,
  QueryMsgOptions,
  SearchParams,
  TimePeriod,
  TopMessageCallback
} from '../interfaces/messagetypes'

export {
  BroadcastMessageCallback,
  ClearMsgOptions,
  DownloadMediaMessageCancelCallback,
  DownloadMediaMessageErrorCallback,
  DownloadMediaMessageProgressCallback,
  DownloadMediaMessageSuccessCallback,
  FavoriteMessagesCallback,
  GetFavoriteMessageOption,
  GetMessageDirection,
  GetMessageOptions,
  GroupMessageReadInfoDetailCallback,
  MessageCallback,
  MessageReactionsCallback,
  MuteStatusCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgDestroyTimeUpdateListener,
  MsgGroupReadReceiptListener,
  MsgModifiedListener,
  MsgReadReceiptListener,
  MsgReceivedListener,
  MsgRecalledListener,
  MsgTopChangedListener,
  QryMessagesCallback,
  QueryMsgOptions,
  SearchParams,
  TimePeriod,
  TopMessageCallback
} from '../interfaces/messagetypes'

const TOP_TRACE_TAG:string = 'TOPTRACE'

class MessageSendContext {
  callback:MessageCallback = (_code:number, _message:Message|null)=>{}
  options?:MessageOptions
  constructor() {
  }
}

export class MessageManager implements IMessageManager{
  private imclient:ImClient
  private msgSyncMgr:MsgSyncManager
  private messageUploadProvider:IMessageUploadProvider | null = null
  private mediaDownloadTasks:Map<string, request.DownloadTask> = new Map()

  constructor(imclient:ImClient,mgr:MsgSyncManager) {
    this.imclient = imclient
    this.msgSyncMgr = mgr
  }

  addMsgReceivedListener(listener:MsgReceivedListener){
    this.msgSyncMgr.addMsgReceivedListener(listener)
  }

  removeMsgReceivedListener(listener:MsgReceivedListener){
    this.msgSyncMgr.removeMsgReceivedListener(listener)
  }

  addMsgRecalledListener(listener:MsgRecalledListener){
    this.msgSyncMgr.addMsgRecalledListener(listener)
  }

  removeMsgRecalledListener(listener:MsgRecalledListener){
    this.msgSyncMgr.removeMsgRecalledListener(listener)
  }

  addMsgModifiedListener(listener:MsgModifiedListener){
    this.msgSyncMgr.addMsgModifiedListener(listener)
  }

  removeMsgModifiedListener(listener:MsgModifiedListener){
    this.msgSyncMgr.removeMsgModifiedListener(listener)
  }

  addReadReceiptListener(listener:MsgReadReceiptListener){
    this.msgSyncMgr.addReadReceiptListener(listener)
  }

  removeReadReceiptListener(listener:MsgReadReceiptListener){
    this.msgSyncMgr.removeReadReceiptListener(listener)
  }

  addGroupReadReceiptListener(listener:MsgGroupReadReceiptListener){
    this.msgSyncMgr.addGroupReadReceiptListener(listener)
  }

  removeGroupReadReceiptListener(listener:MsgGroupReadReceiptListener){
    this.msgSyncMgr.removeGroupReadReceiptListener(listener)
  }

  addMsgDeletedListener(listener:MsgDeletedListener){
    this.msgSyncMgr.addMsgDeletedListener(listener)
  }

  removeMsgDeletedListener(listener:MsgDeletedListener){
    this.msgSyncMgr.removeMsgDeletedListener(listener)
  }

  addMsgCleanedListener(listener:MsgCleanedListener){
    this.msgSyncMgr.addMsgCleanedListener(listener)
  }

  removeMsgCleanedListener(listener:MsgCleanedListener){
    this.msgSyncMgr.removeMsgCleanedListener(listener)
  }

  addMsgTopChangedListener(listener:MsgTopChangedListener){
    this.msgSyncMgr.addMsgTopChangedListener(listener)
  }

  removeMsgTopChangedListener(listener:MsgTopChangedListener){
    this.msgSyncMgr.removeMsgTopChangedListener(listener)
  }

  addMsgDestroyTimeUpdateListener(listener:MsgDestroyTimeUpdateListener){
    this.msgSyncMgr.addMsgDestroyTimeUpdateListener(listener)
  }

  removeMsgDestroyTimeUpdateListener(listener:MsgDestroyTimeUpdateListener){
    this.msgSyncMgr.removeMsgDestroyTimeUpdateListener(listener)
  }

  public registerMessage(msgType:string, constructor:Function){
    MsgHandler.registerMessage(msgType, constructor)
  }

  setMessageUploadProvider(provider:IMessageUploadProvider | null):void{
    this.messageUploadProvider = provider
  }

  getMessageUploadProvider():IMessageUploadProvider | null{
    return this.messageUploadProvider
  }

  uploadImage(path:string, onSuccess:MediaUploadSuccessCallback, onError?:MediaUploadErrorCallback):void{
    let normalizedPath = path.trim()
    if(normalizedPath == ''){
      onError?.(-1, 'image path is empty')
      return
    }
    if(this.messageUploadProvider == null){
      onError?.(-1, 'message upload provider is not set')
      return
    }
    let image = new ImageMessage()
    image.localPath = normalizedPath
    this.messageUploadProvider.uploadMediaMessage(
      image,
      ()=>{
      },
      (result)=>{
        onSuccess(result)
      },
      (code, message)=>{
        onError?.(code, message)
      },
      ()=>{
        onError?.(-2, 'upload canceled')
      }
    )
  }

  addMessageReaction(messageId:string, reactionId:string, callback:CommonCallback):void{
    this.updateMessageReaction(messageId, reactionId, true, callback)
  }

  removeMessageReaction(messageId:string, reactionId:string, callback:CommonCallback):void{
    this.updateMessageReaction(messageId, reactionId, false, callback)
  }

  getMessagesReaction(conver:Conversation | null, msgIds:string[], callback:MessageReactionsCallback):void{
    let normalizedIds = this.normalizeReactionMessageIds(msgIds)
    if(normalizedIds.length == 0){
      callback(0, [])
      return
    }
    let cachedResults = this.buildCachedReactionResults(normalizedIds)
    let targetConversation = this.resolveReactionConversation(conver, normalizedIds)
    if(targetConversation == null || targetConversation.conversationId == ''){
      callback(0, cachedResults)
      return
    }
    let req = immessage.QryMsgExtReq.create({})
    req.targetId = targetConversation.conversationId
    req.channelType = targetConversation.conversationType
    req.msgIds = normalizedIds
    req.subChannel = Conversation.normalizeSubChannel(targetConversation.subChannel)
    let data = immessage.QryMsgExtReq.encode(req).finish()
    this.imclient.query('qry_msg_exset', targetConversation.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, cachedResults)
        return
      }
      let ackData = qryAck.data as Uint8Array
      let resp = immessage.MsgExtItemsList.decode(ackData)
      let results = this.buildReactionResultsFromProto(normalizedIds, resp.items)
      this.applyReactionResults(results)
      callback(0, results)
    })
  }

  addFavorite(msgIds:string[], callback:CommonCallback):void{
    this.updateFavorite(msgIds, true, callback)
  }

  removeFavorite(msgIds:string[], callback:CommonCallback):void{
    this.updateFavorite(msgIds, false, callback)
  }

  getFavorite(option:GetFavoriteMessageOption, callback:FavoriteMessagesCallback):void{
    let normalizedCount = option.count > 0 ? option.count : 0
    if(normalizedCount <= 0){
      callback(new JimErrorCode().InvalidParam, [], '')
      return
    }
    let req = immessage.QryFavoriteMsgsReq.create({})
    req.limit = normalizedCount
    req.offset = option.offset != undefined ? option.offset : ''
    let data = immessage.QryFavoriteMsgsReq.encode(req).finish()
    this.imclient.query('qry_favorite_msgs', JuggleIm.instance.userId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, [], '')
        return
      }
      let resp = immessage.FavoriteMsgs.decode(qryAck.data as Uint8Array)
      let remoteMessages:Message[] = []
      let favoriteMessages:FavoriteMessage[] = []
      resp.items.forEach((item)=>{
        if(item.msg == undefined || item.msg == null){
          return
        }
        let remoteMessage = MsgHandler.downMsg2Message(item.msg)
        remoteMessages.push(remoteMessage)
        let favoriteMessage = new FavoriteMessage()
        favoriteMessage.message = remoteMessage
        favoriteMessage.createdTime = JimUtil.toNumber(item.createdTime as number)
        favoriteMessages.push(favoriteMessage)
      })
      let persistedMessages = this.persistRemoteMessages(remoteMessages)
      favoriteMessages.forEach((favoriteMessage)=>{
        if(favoriteMessage.message == null){
          return
        }
        let persistedMessage = this.findMessageByRequestId(
          persistedMessages,
          favoriteMessage.message.messageId != '' ? favoriteMessage.message.messageId : favoriteMessage.message.clientId
        )
        if(persistedMessage != null){
          favoriteMessage.message = persistedMessage
        }
      })
      callback(0, favoriteMessages, resp.offset != undefined ? resp.offset as string : '')
    })
  }

  broadcastMessage(msg:MessageContent, convers:Conversation[], callback:BroadcastMessageCallback):void{
    let targetConvers = this.normalizeBroadcastConversations(convers)
    if(targetConvers.length == 0){
      callback.onComplete()
      return
    }
    console.log(`${TOP_TRACE_TAG} broadcast_message_start: count=${targetConvers.length}, msgType=${msg.getMsgType()}, targets=${JSON.stringify(targetConvers.map((conver)=>conver.getKey()))}`)
    this.loopBroadcastMessage(msg, targetConvers, 0, targetConvers.length, callback)
  }

  setMute(isMute:boolean, periods:TimePeriod[], callback:CommonCallback):void{
    let normalizedPeriods = this.normalizeTimePeriods(periods)
    let timezone = this.resolveLocalTimezone()
    console.log(`${TOP_TRACE_TAG} global_mute_set_request: isMute=${isMute}, timezone=${timezone}, periods=${JSON.stringify(normalizedPeriods)}, userId=${JuggleIm.instance.userId}`)
    let rules:immessage.UserUndisturbItem[] = []
    normalizedPeriods.forEach((period)=>{
      let item = immessage.UserUndisturbItem.create({})
      item.start = period.startTime
      item.end = period.endTime
      rules.push(item)
    })
    let req = immessage.UserUndisturb.create({})
    req.switch = isMute
    req.timezone = timezone
    req.rules = rules
    let data = immessage.UserUndisturb.encode(req).finish()
    this.imclient.query('set_user_undisturb', JuggleIm.instance.userId, data, (code, qryAck)=>{
      let timestamp = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : 0
      console.log(`${TOP_TRACE_TAG} global_mute_set_ack: isMute=${isMute}, timezone=${timezone}, periods=${JSON.stringify(normalizedPeriods)}, code=${code}, timestamp=${timestamp}`)
      if(code == 0 && timestamp > 0){
        this.msgSyncMgr.recordLatestSendboxMsgTime(timestamp, MsgFlagTool.toFlag(MsgFlagTool.commandFlag()))
      }
      callback(code)
    })
  }

  getMuteStatus(callback:MuteStatusCallback):void{
    console.log(`${TOP_TRACE_TAG} global_mute_get_request: userId=${JuggleIm.instance.userId}`)
    let req = immessage.Nil.create({})
    let data = immessage.Nil.encode(req).finish()
    this.imclient.query('get_user_undisturb', JuggleIm.instance.userId, data, (code, qryAck)=>{
      if(code != 0){
        console.log(`${TOP_TRACE_TAG} global_mute_get_ack: code=${code}, hasData=false`)
        callback(code, false, '', [])
        return
      }
      try{
        let resp = immessage.UserUndisturb.decode(qryAck.data as Uint8Array)
        let periods = this.buildTimePeriodsFromProto(resp.rules)
        let timezone = resp.timezone != undefined ? resp.timezone as string : ''
        let isMute = resp.switch != undefined ? resp.switch as boolean : false
        console.log(`${TOP_TRACE_TAG} global_mute_get_ack: code=${code}, isMute=${isMute}, timezone=${timezone}, periods=${JSON.stringify(periods)}`)
        callback(0, isMute, timezone, periods)
      }catch (error) {
        let err = error as Error
        console.error(`${TOP_TRACE_TAG} global_mute_get_decode_fail: ${err.message}`)
        callback(-1, false, '', [])
      }
    })
  }

  setTop(messageId:string, conver:Conversation, isTop:boolean, callback:CommonCallback):void{
    let normalizedMessageId = messageId.trim()
    if(normalizedMessageId == '' || conver.conversationId == ''){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let req = immessage.TopMsgReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.msgId = normalizedMessageId
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.TopMsgReq.encode(req).finish()
    let topic = isTop ? 'set_top_msg' : 'del_top_msg'
    this.imclient.query(topic, conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code)
        return
      }
      let createdTime = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : new Date().getTime()
      this.msgSyncMgr.recordLatestSendboxMsgTime(createdTime, MsgFlagTool.toFlag(MsgFlagTool.commandFlag()))
      this.resolveTopMessageById(conver, normalizedMessageId, (message)=>{
        this.msgSyncMgr.notifyTopMessageChanged(conver, message, this.getCurrentOperator(), isTop, createdTime)
      })
      callback(0)
    })
  }

  getTopMessage(conver:Conversation, callback:TopMessageCallback):void{
    if(conver.conversationId == ''){
      callback(new JimErrorCode().InvalidParam, null, null, 0)
      return
    }
    let req = immessage.GetTopMsgReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.GetTopMsgReq.encode(req).finish()
    this.imclient.query('get_top_msg', conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, null, null, 0)
        return
      }
      let resp = immessage.TopMsg.decode(qryAck.data as Uint8Array)
      if(resp.msg == undefined || resp.msg == null){
        callback(new JimErrorCode().MessageNotExist, null, this.buildUserInfoFromProto(resp.operator), JimUtil.toNumber(resp.createdTime as number))
        return
      }
      let message = MsgHandler.downMsg2Message(resp.msg)
      let persistedMessages = this.persistRemoteMessages([message])
      let persistedMessage = persistedMessages.length > 0 ? persistedMessages[0] : message
      let operator = this.buildUserInfoFromProto(resp.operator)
      callback(0, persistedMessage, operator, JimUtil.toNumber(resp.createdTime as number))
    })
  }

  private loopBroadcastMessage(
    msg:MessageContent,
    convers:Conversation[],
    processCount:number,
    totalCount:number,
    callback:BroadcastMessageCallback
  ):void{
    if(convers.length == 0){
      callback.onComplete()
      return
    }
    let conver = convers[0]
    let messageContent = this.cloneMessageContent(msg)
    this.sendMessageInternal(messageContent, conver, undefined, true, (code, message)=>{
      console.log(`${TOP_TRACE_TAG} broadcast_message_progress: processCount=${processCount}, totalCount=${totalCount}, converId=${conver.conversationId}, converType=${conver.conversationType}, code=${code}, messageId=${message != null ? message.messageId : ''}, clientId=${message != null ? message.clientId : ''}`)
      callback.onProgress(message, code, processCount, totalCount)
      if(convers.length <= 1){
        callback.onComplete()
        return
      }
      let nextConvers = convers.slice(1)
      setTimeout(()=>{
        this.loopBroadcastMessage(msg, nextConvers, processCount + 1, totalCount, callback)
      }, 50)
    })
  }

  private normalizeTimePeriods(periods:TimePeriod[]):TimePeriod[]{
    let normalizedPeriods:TimePeriod[] = []
    periods.forEach((period)=>{
      let startTime = period.startTime.trim()
      let endTime = period.endTime.trim()
      if(startTime == '' || endTime == ''){
        return
      }
      let nextPeriod = new TimePeriod()
      nextPeriod.startTime = startTime
      nextPeriod.endTime = endTime
      normalizedPeriods.push(nextPeriod)
    })
    return normalizedPeriods
  }

  private buildTimePeriodsFromProto(items:immessage.IUserUndisturbItem[] | null | undefined):TimePeriod[]{
    let periods:TimePeriod[] = []
    if(items == undefined || items == null){
      return periods
    }
    items.forEach((item)=>{
      let startTime = item.start != undefined ? (item.start as string).trim() : ''
      let endTime = item.end != undefined ? (item.end as string).trim() : ''
      if(startTime == '' || endTime == ''){
        return
      }
      let period = new TimePeriod()
      period.startTime = startTime
      period.endTime = endTime
      periods.push(period)
    })
    return periods
  }

  private resolveLocalTimezone():string{
    try{
      let timezone = Intl.DateTimeFormat().resolvedOptions().timeZone
      if(timezone != undefined && timezone != null){
        return timezone
      }
    }catch (error) {
    }
    return ''
  }

  private normalizeBroadcastConversations(convers:Conversation[]):Conversation[]{
    let normalizedConvers:Conversation[] = []
    let seenKeys:Map<string, boolean> = new Map()
    convers.forEach((conver)=>{
      if(conver.conversationId == ''){
        return
      }
      let key = conver.getKey()
      if(seenKeys.has(key)){
        return
      }
      seenKeys.set(key, true)
      normalizedConvers.push(conver.clone())
    })
    return normalizedConvers
  }

  sendMessage(msg:MessageContent,conver:Conversation,callback:MessageCallback): void
  sendMessage(msg:MessageContent,conver:Conversation,options:MessageOptions,callback:MessageCallback): void
  sendMessage(msg:MessageContent,conver:Conversation,arg3:MessageCallback|MessageOptions,arg4?:MessageCallback): void{
    let context = this.resolveSendContext(arg3, arg4)
    if(context == null){
      return
    }
    this.sendMessageInternal(msg, conver, context.options, false, context.callback)
  }

  resendMessage(message:Message, callback:MessageCallback):Message{
    let resendMessage = this.resolveResendMessage(message)
    if(!this.canResendMessage(resendMessage)){
      callback(new JimErrorCode().InvalidParam, resendMessage)
      return resendMessage
    }
    if(resendMessage.state == MessageSentState.success){
      callback(0, resendMessage)
      return resendMessage
    }
    let msgDbId = JimDbManager.instance.getMessageDao().getMessageDbIdByClientMsgNo(resendMessage.clientMsgNo)
    if(msgDbId <= 0){
      callback(new JimErrorCode().MessageNotExist, resendMessage)
      return resendMessage
    }
    resendMessage.state = MessageSentState.sending
    this.setMessageState(resendMessage.clientMsgNo, resendMessage.state)
    let referMsg = this.resolveReferencedMessage(resendMessage)
    this.publishOutgoingMessage(resendMessage, msgDbId, referMsg, callback)
    return resendMessage
  }

  resendMediaMessage(message:Message, callback:MessageCallback):Message{
    let resendMessage = this.resolveResendMessage(message)
    if(!this.canResendMediaMessage(resendMessage)){
      callback(new JimErrorCode().InvalidParam, resendMessage)
      return resendMessage
    }
    if(resendMessage.state == MessageSentState.success){
      callback(0, resendMessage)
      return resendMessage
    }
    let msgDbId = JimDbManager.instance.getMessageDao().getMessageDbIdByClientMsgNo(resendMessage.clientMsgNo)
    if(msgDbId <= 0){
      callback(new JimErrorCode().MessageNotExist, resendMessage)
      return resendMessage
    }
    let mediaMsg = resendMessage.msgContent as MediaMessageContent
    if(mediaMsg.url != ''){
      resendMessage.state = MessageSentState.sending
      this.setMessageState(resendMessage.clientMsgNo, resendMessage.state)
      this.publishOutgoingMessage(resendMessage, msgDbId, this.resolveReferencedMessage(resendMessage), callback)
      return resendMessage
    }
    if(this.messageUploadProvider == null){
      mediaMsg.setUploadState(MediaMessageUploadState.failed)
      resendMessage.state = MessageSentState.failed
      this.updateLocalMediaMessage(msgDbId, resendMessage)
      callback(-1, resendMessage)
      return resendMessage
    }
    mediaMsg.setUploadState(MediaMessageUploadState.uploading, 0)
    resendMessage.state = MessageSentState.uploading
    this.updateLocalMediaMessage(msgDbId, resendMessage)
    this.messageUploadProvider.uploadMediaMessage(
      mediaMsg,
      (progress)=>{
        mediaMsg.setUploadState(MediaMessageUploadState.uploading, progress)
        resendMessage.state = MessageSentState.uploading
        this.updateLocalMediaMessage(msgDbId, resendMessage)
      },
      (result)=>{
        this.applyMediaUploadResult(mediaMsg, result)
        mediaMsg.setUploadState(MediaMessageUploadState.success, 100)
        resendMessage.state = MessageSentState.sending
        this.updateLocalMediaMessage(msgDbId, resendMessage)
        this.publishOutgoingMessage(resendMessage, msgDbId, this.resolveReferencedMessage(resendMessage), callback)
      },
      (code, uploadMessage)=>{
        console.error(`jimsdk_media_resend_upload_fail. code:${code}, message:${uploadMessage}`)
        mediaMsg.setUploadState(MediaMessageUploadState.failed)
        resendMessage.state = MessageSentState.failed
        this.updateLocalMediaMessage(msgDbId, resendMessage)
        callback(code == 0 ? -1 : code, resendMessage)
      },
      ()=>{
        mediaMsg.setUploadState(MediaMessageUploadState.canceled)
        resendMessage.state = MessageSentState.failed
        this.updateLocalMediaMessage(msgDbId, resendMessage)
        callback(-2, resendMessage)
      }
    )
    return resendMessage
  }

  private resolveSendContext(arg3:MessageCallback|MessageOptions,arg4?:MessageCallback):MessageSendContext|null{
    let context = new MessageSendContext()
    if(typeof arg3 === 'function'){
      context.callback = arg3
      return context
    }
    context.options = arg3
    if(arg4 == undefined){
      return null
    }
    context.callback = arg4
    return context
  }

  private resolveResendMessage(message:Message):Message{
    if(message.clientMsgNo <= 0){
      return message
    }
    let messages = JimDbManager.instance.getMessageDao().getMessagesByClientMsgNos([message.clientMsgNo])
    if(messages.length > 0){
      return messages[0]
    }
    return message
  }

  private canResendMessage(message:Message):boolean{
    return message.clientMsgNo > 0 &&
      message.messageId == '' &&
      message.msgContent != undefined &&
      message.conversation != undefined &&
      message.conversation.conversationId != ''
  }

  private canResendMediaMessage(message:Message):boolean{
    return this.canResendMessage(message) && message.msgContent instanceof MediaMessageContent
  }

  private resolveReferencedMessage(message:Message):Message|undefined{
    if(message.referredMessage != null){
      return message.referredMessage
    }
    if(message.referMsgId == ''){
      return undefined
    }
    let referMsg = JimDbManager.instance.getMessageDao().getMessage(message.referMsgId)
    if(referMsg == null){
      return undefined
    }
    return referMsg
  }

  private updateMessageReaction(messageId:string, reactionId:string, isAdd:boolean, callback:CommonCallback):void{
    let normalizedMessageId = messageId.trim()
    let normalizedReactionId = reactionId.trim()
    if(normalizedMessageId == '' || normalizedReactionId == ''){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let msgDao = JimDbManager.instance.getMessageDao()
    let message = msgDao.getMessage(normalizedMessageId)
    if(message == null){
      callback(new JimErrorCode().MessageNotExist)
      return
    }
    let targetMessage:Message = message
    let extItem = immessage.MsgExtItem.create({})
    extItem.key = normalizedReactionId
    extItem.value = JuggleIm.instance.userId
    let req = immessage.MsgExt.create({})
    req.targetId = targetMessage.conversation.conversationId
    req.channelType = targetMessage.conversation.conversationType
    req.msgId = targetMessage.messageId
    req.ext = extItem
    req.subChannel = Conversation.normalizeSubChannel(targetMessage.conversation.subChannel)
    let data = immessage.MsgExt.encode(req).finish()
    let topic = isAdd ? 'msg_exset' : 'del_msg_exset'
    this.imclient.query(topic, normalizedMessageId, data, (code, _qryAck)=>{
      if(code != 0){
        callback(code)
        return
      }
      let nextReactions = this.mergeMessageReactions(targetMessage.reactions, normalizedReactionId, isAdd)
      targetMessage.reactions = nextReactions
      msgDao.updateMessageReactions(normalizedMessageId, nextReactions)
      this.msgSyncMgr.notifyMessageModified(targetMessage)
      callback(0)
    })
  }

  private updateFavorite(msgIds:string[], isAdd:boolean, callback:CommonCallback):void{
    let requestIds = this.normalizeDistinctMessageIds(msgIds)
    if(requestIds.length == 0){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let messages = JimDbManager.instance.getMessageDao().getMessagesByMessageIds(requestIds)
    if(messages.length == 0){
      callback(new JimErrorCode().MessageNotExist)
      return
    }
    let items = this.buildFavoriteMsgIdItems(messages)
    if(items.length == 0){
      callback(new JimErrorCode().MessageNotExist)
      return
    }
    let req = immessage.FavoriteMsgIds.create({})
    req.items = items
    let data = immessage.FavoriteMsgIds.encode(req).finish()
    let topic = isAdd ? 'add_favorite_msgs' : 'del_favorite_msgs'
    this.imclient.query(topic, JuggleIm.instance.userId, data, (code, _qryAck)=>{
      callback(code)
    })
  }

  private buildFavoriteMsgIdItems(messages:Message[]):immessage.FavoriteMsgIdItem[]{
    let currentUserId = JuggleIm.instance.userId
    let items:immessage.FavoriteMsgIdItem[] = []
    messages.forEach((message)=>{
      if(message.messageId == ''){
        return
      }
      let receiverId = message.conversation.conversationId
      if(message.conversation.conversationType == immessage.ChannelType.Private && message.direction == 1){
        receiverId = currentUserId
      }
      let item = immessage.FavoriteMsgIdItem.create({})
      item.senderId = message.senderId
      item.receiverId = receiverId
      item.channelType = message.conversation.conversationType
      item.msgId = message.messageId
      item.subChannel = Conversation.normalizeSubChannel(message.conversation.subChannel)
      items.push(item)
    })
    return items
  }

  private resolveTopMessageById(conver:Conversation, messageId:string, callback:(message:Message | null)=>void):void{
    this.getMessagesByMessageIds(conver, [messageId], (code, messages)=>{
      if(code != 0 || messages.length == 0){
        callback(null)
        return
      }
      callback(messages[0])
    })
  }

  private getCurrentOperator():UserInfo | null{
    let currentUserId = JuggleIm.instance.userId
    if(currentUserId == ''){
      return null
    }
    let user = JuggleIm.instance.getUserInfoManager().getLocalUserInfo(currentUserId)
    if(user != null){
      return user
    }
    let result = new UserInfo()
    result.userId = currentUserId
    return result
  }

  private buildUserInfoFromProto(proto:immessage.IUserInfo | null | undefined):UserInfo | null{
    if(proto == undefined || proto == null){
      return null
    }
    let user = new UserInfo()
    user.userId = proto.userId != undefined ? proto.userId as string : ''
    user.nickname = proto.nickname != undefined ? proto.nickname as string : ''
    user.userPortrait = proto.userPortrait != undefined ? proto.userPortrait as string : ''
    user.userType = proto.userType != undefined ? JimUtil.toNumber(proto.userType as number) : 0
    user.updTime = proto.updatedTime != undefined ? JimUtil.toNumber(proto.updatedTime as number) : 0
    if(user.userId != ''){
      JuggleIm.instance.getUserInfoManager().saveUserInfo(user)
    }
    return user
  }

  private normalizeReactionMessageIds(msgIds:string[]):string[]{
    let normalizedIds:string[] = []
    msgIds.forEach((msgId)=>{
      let normalizedId = msgId.trim()
      if(normalizedId != '' && normalizedIds.indexOf(normalizedId) < 0){
        normalizedIds.push(normalizedId)
      }
    })
    return normalizedIds
  }

  private normalizeDistinctMessageIds(msgIds:string[]):string[]{
    let normalizedIds:string[] = []
    msgIds.forEach((msgId)=>{
      let normalizedId = msgId.trim()
      if(normalizedId != '' && normalizedIds.indexOf(normalizedId) < 0){
        normalizedIds.push(normalizedId)
      }
    })
    return normalizedIds
  }

  private resolveReactionConversation(conver:Conversation | null, msgIds:string[]):Conversation | null{
    if(conver != null && conver.conversationId != ''){
      return conver
    }
    let messages = JimDbManager.instance.getMessageDao().getMessagesByMessageIds(msgIds)
    if(messages.length == 0){
      return null
    }
    return messages[0].conversation
  }

  private buildCachedReactionResults(msgIds:string[]):MessageReactionResult[]{
    let messages = JimDbManager.instance.getMessageDao().getMessagesByMessageIds(msgIds)
    let results:MessageReactionResult[] = []
    messages.forEach((message)=>{
      let result = new MessageReactionResult()
      result.messageId = message.messageId
      result.clientId = message.clientId
      result.reactions = this.cloneMessageReactions(message.reactions)
      results.push(result)
    })
    return results
  }

  private buildReactionResultsFromProto(
    requestedIds:string[],
    items:immessage.IMsgExtItems[]
  ):MessageReactionResult[]{
    let resultMap:Map<string, MessageReactionResult> = new Map()
    items.forEach((item)=>{
      let messageId = item.msgId != undefined ? item.msgId : ''
      if(messageId == ''){
        return
      }
      let result = new MessageReactionResult()
      result.messageId = messageId
      result.clientId = this.resolveReactionClientId(messageId)
      result.reactions = this.buildMessageReactionsFromProtoItems(item.exts)
      resultMap.set(messageId, result)
    })
    let results:MessageReactionResult[] = []
    requestedIds.forEach((messageId)=>{
      if(resultMap.has(messageId)){
        let cachedResult = resultMap.get(messageId)
        if(cachedResult != undefined){
          results.push(cachedResult)
        }
        return
      }
      let result = new MessageReactionResult()
      result.messageId = messageId
      result.clientId = this.resolveReactionClientId(messageId)
      results.push(result)
    })
    return results
  }

  private resolveReactionClientId(messageId:string):string{
    let localMessage = JimDbManager.instance.getMessageDao().getMessage(messageId)
    if(localMessage == null){
      return ''
    }
    return localMessage.clientId
  }

  private buildMessageReactionsFromProtoItems(items:immessage.IMsgExtItem[] | null | undefined):MessageReaction[]{
    let reactions:MessageReaction[] = []
    if(items == undefined || items == null){
      return reactions
    }
    let currentUserId = JuggleIm.instance.userId
    items.forEach((item)=>{
      let reactionId = item.key != undefined ? item.key.trim() : ''
      let userId = item.userInfo != undefined ? (item.userInfo.userId as string).trim() : ''
      if(reactionId == '' || userId == ''){
        return
      }
      let targetReaction:MessageReaction | undefined = undefined
      for(let i = 0; i < reactions.length; i++){
        if(reactions[i].reactionId == reactionId){
          targetReaction = reactions[i]
          break
        }
      }
      if(targetReaction == undefined){
        targetReaction = new MessageReaction()
        targetReaction.reactionId = reactionId
        reactions.push(targetReaction)
      }
      if(targetReaction.userIds.indexOf(userId) < 0){
        targetReaction.userIds.push(userId)
      }
    })
    reactions.forEach((reaction)=>{
      reaction.count = reaction.userIds.length
      reaction.isSelected = reaction.userIds.indexOf(currentUserId) >= 0
    })
    return reactions
  }

  private applyReactionResults(results:MessageReactionResult[]):void{
    let msgDao = JimDbManager.instance.getMessageDao()
    results.forEach((result)=>{
      if(result.messageId == ''){
        return
      }
      msgDao.updateMessageReactions(result.messageId, result.reactions)
      let localMessage = msgDao.getMessage(result.messageId)
      if(localMessage == null){
        return
      }
      localMessage.reactions = this.cloneMessageReactions(result.reactions)
      this.msgSyncMgr.notifyMessageModified(localMessage)
    })
  }

  private mergeMessageReactions(
    reactions:MessageReaction[],
    reactionId:string,
    isAdd:boolean
  ):MessageReaction[]{
    let currentUserId = JuggleIm.instance.userId
    let nextReactions = this.cloneMessageReactions(reactions)
    let foundIndex = nextReactions.findIndex((reaction)=>{
      return reaction.reactionId == reactionId
    })
    if(foundIndex < 0){
      if(!isAdd){
        return nextReactions
      }
      let reaction = new MessageReaction()
      reaction.reactionId = reactionId
      reaction.userIds = [currentUserId]
      reaction.count = 1
      reaction.isSelected = true
      nextReactions.push(reaction)
      return nextReactions
    }
    let target = nextReactions[foundIndex]
    let userIds:string[] = []
    target.userIds.forEach((userId)=>{
      if(userId != '' && userIds.indexOf(userId) < 0){
        userIds.push(userId)
      }
    })
    let selectedIndex = userIds.indexOf(currentUserId)
    if(isAdd){
      if(selectedIndex < 0){
        userIds.push(currentUserId)
      }
    }else if(selectedIndex >= 0){
      userIds.splice(selectedIndex, 1)
    }
    if(userIds.length == 0){
      nextReactions.splice(foundIndex, 1)
      return nextReactions
    }
    target.userIds = userIds
    target.count = userIds.length
    target.isSelected = userIds.indexOf(currentUserId) >= 0
    nextReactions[foundIndex] = target
    return nextReactions
  }

  private cloneMessageReactions(reactions:MessageReaction[]):MessageReaction[]{
    let nextReactions:MessageReaction[] = []
    reactions.forEach((reaction)=>{
      let nextReaction = new MessageReaction()
      nextReaction.reactionId = reaction.reactionId
      nextReaction.userIds = reaction.userIds.slice()
      nextReaction.count = reaction.count
      nextReaction.isSelected = reaction.isSelected
      nextReactions.push(nextReaction)
    })
    return nextReactions
  }

  private sendMessageInternal(
    msg:MessageContent,
    conver:Conversation,
    options:MessageOptions | undefined,
    isBroadcast:boolean,
    callback:MessageCallback
  ):void{
    let message = this.buildOutgoingMessage(msg, conver, isBroadcast)
    let referMsg = this.applyMessageOptions(message, options)
    let msgDao = JimDbManager.instance.getMessageDao()
    let msgDbId = msgDao.insert(message)
    this.msgSyncMgr.updConver(message)
    this.publishOutgoingMessage(message, msgDbId, referMsg, callback)
  }

  private buildOutgoingMessage(msg:MessageContent, conver:Conversation, isBroadcast:boolean = false):Message{
    let message = new Message()
    message.clientMsgNo = JimUtil.getClientMsgNo()
    message.conversation = conver
    message.msgContent = msg
    message.clientId = JimUtil.getUuid()
    message.senderId = JuggleIm.instance.userId
    message.direction = 0
    message.sentTime = new Date().getTime()
    message.flags = msg.getFlagNumber()
    if(isBroadcast){
      message.flags |= MsgFlagTool.toFlag(MsgFlagTool.broadcastFlag())
    }
    message.searchContent = this.buildSearchContent(msg)
    message.state = MessageSentState.sending
    if(conver.conversationType == 2){
      let localMembers = JuggleIm.instance.getGroupInfoManager().getLocalGroupMembers(conver.conversationId)
      if(localMembers.length > 0){
        message.memberCount = localMembers.length
      }
    }
    return message
  }

  saveMessage(msg:MessageContent,conver:Conversation):Message
  saveMessage(msg:MessageContent,conver:Conversation,options:MessageOptions):Message
  saveMessage(msg:MessageContent,conver:Conversation,options?:MessageOptions):Message{
    let message = this.buildOutgoingMessage(msg, conver)
    message.state = MessageSentState.none
    this.applyMessageOptions(message, options)
    JimDbManager.instance.getMessageDao().insert(message)
    this.msgSyncMgr.updConver(message)
    this.msgSyncMgr.notifyMessageModified(message)
    return message
  }

  getMessagesByClientMsgNos(clientMsgNos:number[]):Message[]{
    return JimDbManager.instance.getMessageDao().getMessagesByClientMsgNos(clientMsgNos)
  }

  setMessageState(clientMsgNo:number, state:number):void{
    if(clientMsgNo <= 0){
      return
    }
    let msgDao = JimDbManager.instance.getMessageDao()
    msgDao.updateMsgStateByClientMsgNo(clientMsgNo, state)
    let messages = msgDao.getMessagesByClientMsgNos([clientMsgNo])
    if(messages.length == 0){
      return
    }
    let message = messages[0]
    if(message.conversation.conversationType == immessage.ChannelType.Chatroom){
      return
    }
    message.state = state
    this.msgSyncMgr.notifyMessageModified(message)
  }

  private buildUpMsg(message:Message, referMsg?:Message):immessage.UpMsg{
    let upMsg = immessage.UpMsg.create({})
    upMsg.msgType = message.msgContent.getMsgType()
    upMsg.msgContent = message.msgContent.encode()
    upMsg.flags = message.flags > 0 ? message.flags : MsgFlagTool.toFlag(message.msgContent.getFlag())
    upMsg.clientUid = message.clientId
    upMsg.pushData = MessageOptionUtil.toProtoPushData(message.pushData)
    upMsg.mentionInfo = MessageOptionUtil.toProtoMentionInfo(message.mentionInfo)
    if(referMsg != undefined){
      upMsg.referMsg = MessageOptionUtil.toProtoDownMsg(referMsg)
    }
    upMsg.lifeTime = message.lifeTime
    upMsg.lifeTimeAfterRead = message.lifeTimeAfterRead
    upMsg.subChannel = Conversation.normalizeSubChannel(message.conversation.subChannel)
    return upMsg
  }

  private resolvePublishMethod(conver:Conversation):string{
    if(conver.conversationType == 1){
      return 'p_msg'
    }
    if(conver.conversationType == 2){
      return 'g_msg'
    }
    if(conver.conversationType == 3){
      return 'c_msg'
    }
    return ''
  }

  private publishOutgoingMessage(message:Message,msgDbId:number,referMsg:Message|undefined,callback:MessageCallback):void{
    let method = this.resolvePublishMethod(message.conversation)
    if(method == ''){
      message.state = MessageSentState.failed
      JimDbManager.instance.getMessageDao().updateMsgState(msgDbId,message.state)
      this.msgSyncMgr.notifyMessageModified(message)
      callback(-1,message)
      return
    }
    let upMsg = this.buildUpMsg(message, referMsg)
    let data = immessage.UpMsg.encode(upMsg).finish()
    let flags = message.flags > 0 ? message.flags : MsgFlagTool.toFlag(message.msgContent.getFlag())
    this.imclient.publish(method,message.conversation.conversationId,data,(code,pubAck)=>{
      let msgDao = JimDbManager.instance.getMessageDao()
      if(code==0){
        if(typeof pubAck.msgId == 'string'){
          message.messageId = pubAck.msgId
        }
        if(typeof pubAck.timestamp == 'number'){
          message.sentTime = pubAck.timestamp
          this.msgSyncMgr.recordLatestSendboxMsgTime(message.sentTime,flags)
        }
        if(typeof pubAck.msgSeqNo == 'number'){
          message.msgSeqNo = pubAck.msgSeqNo
        }
        if(message.conversation.conversationType == 2 && typeof pubAck.memberCount == 'number' && pubAck.memberCount >= 0){
          message.memberCount = pubAck.memberCount
          message.readCount = 0
        }
        if(message.lifeTime > 0){
          message.destroyTime = message.sentTime + message.lifeTime
        }
        message.state = MessageSentState.success
        msgDao.updateMsgState(
          msgDbId,
          message.state,
          message.messageId,
          message.sentTime,
          message.msgSeqNo,
          message.conversation.conversationType == 2 ? message.memberCount : undefined,
          message.destroyTime > 0 ? message.destroyTime : undefined
        )
        this.msgSyncMgr.notifyMessageModified(message)
        callback(code,message)
      }else{
        message.state = MessageSentState.failed
        msgDao.updateMsgState(msgDbId,message.state)
        this.msgSyncMgr.notifyMessageModified(message)
        callback(code,message)
      }
    })
  }

  private cloneMessageContent(msg:MessageContent):MessageContent{
    return MsgHandler.constructByMsgType(msg.getMsgType(), msg.encode())
  }

  private applyMessageOptions(message:Message,options?:MessageOptions):Message|undefined{
    if(options == undefined){
      return undefined
    }
    if(options.mentionInfo != undefined){
      message.mentionInfo = options.mentionInfo
    }
    if(options.pushData != undefined){
      message.pushData = options.pushData
    }
    message.lifeTime = options.lifeTime
    message.lifeTimeAfterRead = options.lifeTimeAfterRead
    if(message.lifeTime > 0){
      message.destroyTime = message.sentTime + message.lifeTime
    }
    if(options.referredMessageId == ''){
      return undefined
    }
    message.referMsgId = options.referredMessageId
    let referMsg = JimDbManager.instance.getMessageDao().getMessage(options.referredMessageId)
    if(referMsg != null){
      message.referredMessage = referMsg
      message.referMsgId = referMsg.messageId
      return referMsg
    }
    return undefined
  }

  private buildSearchContent(msg:MessageContent):string{
    let msgType = msg.getMsgType()
    if(msgType == 'jg:text'){
      return (msg as TextMessage).content
    }
    if(msgType == 'jg:file'){
      return (msg as FileMessage).name
    }
    if(msgType == 'jg:merge'){
      return (msg as MergeMessage).title
    }
    return ''
  }

  queryUploadFileCredential(fileType:number, ext:string, callback:MediaUploadCredentialCallback):void{
    let req = immessage.QryFileCredReq.create({
      fileType: fileType,
      ext: ext
    })
    let data = immessage.QryFileCredReq.encode(req).finish()
    this.imclient.query('file_cred', JuggleIm.instance.userId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, null)
        return
      }
      try{
        let resp = immessage.QryFileCredResp.decode(qryAck.data as Uint8Array)
        let credential = new MediaUploadCredential()
        credential.ossType = resp.ossType as number
        if(resp.qiniuCred != undefined && resp.qiniuCred != null){
          credential.domain = resp.qiniuCred.domain ?? ''
          credential.token = resp.qiniuCred.token ?? ''
        }
        if(resp.preSignResp != undefined && resp.preSignResp != null){
          credential.uploadUrl = resp.preSignResp.url ?? ''
          credential.objKey = resp.preSignResp.objKey ?? ''
          credential.downloadUrl = resp.preSignResp.downloadUrl ?? ''
          if(credential.downloadUrl == ''){
            credential.downloadUrl = this.removeQueryString(resp.preSignResp.url ?? '')
          }
        }
        callback(0, credential)
      }catch (e) {
        let err = e as Error
        console.error(`jimsdk_qry_file_cred_decode_fail:${err.message}`)
        callback(-1, null)
      }
    })
  }

  private removeQueryString(url:string):string{
    let index = url.indexOf('?')
    if(index < 0){
      return url
    }
    return url.substring(0, index)
  }

  downloadMediaMessage(
    messageId:string,
    onProgress:DownloadMediaMessageProgressCallback,
    onSuccess:DownloadMediaMessageSuccessCallback,
    onError:DownloadMediaMessageErrorCallback,
    onCancel:DownloadMediaMessageCancelCallback
  ):void{
    let msgDao = JimDbManager.instance.getMessageDao()
    let message = msgDao.getMessage(messageId)
    if(message == null){
      onError(-1)
      return
    }
    let targetMessage:Message = message
    if(!(targetMessage.msgContent instanceof MediaMessageContent)){
      onError(-2)
      return
    }
    let mediaContent = targetMessage.msgContent as MediaMessageContent
    if(mediaContent.url == ''){
      onError(-3)
      return
    }
    if(this.isLocalMediaAvailable(mediaContent.localPath)){
      onSuccess(targetMessage)
      return
    }
    if(this.mediaDownloadTasks.get(messageId) != undefined){
      onError(-6)
      return
    }
    let savePath = this.buildMediaDownloadPath(targetMessage, mediaContent)
    if(savePath == ''){
      onError(-4)
      return
    }
    request.downloadFile(getContext(), {
      url: mediaContent.url,
      filePath: savePath,
      background: false,
      title: this.getFileNameFromUrl(mediaContent.url),
      description: 'juggleim media download'
    }, (err, task)=>{
      if(err){
        let bizError = err as BusinessError
        console.error(`jimsdk_media_download_start_fail:${messageId}:${bizError.code}:${bizError.message}`)
        onError(bizError.code)
        return
      }
      this.bindMediaDownloadTask(messageId, targetMessage, mediaContent, savePath, task, onProgress, onSuccess, onError, onCancel)
    })
  }

  cancelDownloadMediaMessage(messageId:string):void{
    let task = this.mediaDownloadTasks.get(messageId)
    if(task == undefined){
      return
    }
    task.remove().catch((error:BusinessError)=>{
      console.error(`jimsdk_media_download_cancel_fail:${messageId}:${error.code}:${error.message}`)
    })
  }

  private bindMediaDownloadTask(
    persistedMessageId:string,
    message:Message,
    mediaContent:MediaMessageContent,
    savePath:string,
    task:request.DownloadTask,
    onProgress:DownloadMediaMessageProgressCallback,
    onSuccess:DownloadMediaMessageSuccessCallback,
    onError:DownloadMediaMessageErrorCallback,
    onCancel:DownloadMediaMessageCancelCallback
  ):void{
    this.mediaDownloadTasks.set(persistedMessageId, task)
    let finished = false
    let cleanup = ()=>{
      task.off('progress', progressListener)
      task.off('complete', completeListener)
      task.off('pause', pauseListener)
      task.off('remove', removeListener)
      task.off('fail', failListener)
      this.mediaDownloadTasks.delete(persistedMessageId)
    }
    let progressListener = (receivedSize:number, totalSize:number)=>{
      if(totalSize <= 0){
        onProgress(0, message)
        return
      }
      let progress = Math.floor(receivedSize * 100 / totalSize)
      if(progress < 0){
        progress = 0
      }
      if(progress > 100){
        progress = 100
      }
      onProgress(progress, message)
    }
    let completeListener = ()=>{
      if(finished){
        return
      }
      finished = true
      cleanup()
      mediaContent.localPath = savePath
      JimDbManager.instance.getMessageDao().updateMsgContent(persistedMessageId, mediaContent)
      this.msgSyncMgr.notifyMessageModified(message)
      onSuccess(message)
    }
    let pauseListener = ()=>{
      if(finished){
        return
      }
      finished = true
      cleanup()
      onCancel(message)
    }
    let removeListener = ()=>{
      if(finished){
        return
      }
      finished = true
      cleanup()
      onCancel(message)
    }
    let failListener = (code:number)=>{
      if(finished){
        return
      }
      finished = true
      cleanup()
      this.deleteDownloadFileIfExists(savePath)
      console.error(`jimsdk_media_download_fail:${persistedMessageId}:${code}`)
      onError(code == 0 ? -5 : code)
    }
    task.on('progress', progressListener)
    task.on('complete', completeListener)
    task.on('pause', pauseListener)
    task.on('remove', removeListener)
    task.on('fail', failListener)
  }

  private isLocalMediaAvailable(path:string):boolean{
    if(path == ''){
      return false
    }
    try{
      fileIo.statSync(path)
      return true
    }catch (error) {
      return false
    }
  }

  private buildMediaDownloadPath(message:Message, mediaContent:MediaMessageContent):string{
    let context = getContext()
    let cacheDir = context.cacheDir
    if(cacheDir == undefined || cacheDir == ''){
      return ''
    }
    let dir = `${cacheDir}/media/${JuggleIm.instance.config.appkey}/${JuggleIm.instance.userId}/${this.getMediaDownloadDir(mediaContent)}`
    try{
      fileIo.mkdirSync(dir, true)
    }catch (error) {
    }
    let fileName = this.buildMediaDownloadFileName(message, mediaContent.url)
    return `${dir}/${fileName}`
  }

  private getMediaDownloadDir(mediaContent:MediaMessageContent):string{
    if(mediaContent instanceof ImageMessage){
      return 'image'
    }
    if(mediaContent instanceof VoiceMessage){
      return 'voice'
    }
    if(mediaContent instanceof VideoMessage){
      return 'video'
    }
    return 'file'
  }

  private buildMediaDownloadFileName(message:Message, url:string):string{
    let prefix = message.messageId != '' ? message.messageId : message.clientId
    let sourceName = this.getFileNameFromUrl(url)
    if(sourceName == ''){
      sourceName = 'media.bin'
    }
    return `${prefix}_${this.sanitizeFileName(sourceName)}`
  }

  private getFileNameFromUrl(url:string):string{
    let normalizedUrl = this.removeQueryString(url)
    let index = normalizedUrl.lastIndexOf('/')
    if(index < 0 || index >= normalizedUrl.length - 1){
      return ''
    }
    return normalizedUrl.substring(index + 1)
  }

  private sanitizeFileName(name:string):string{
    return name.replaceAll('\\', '_')
      .replaceAll('/', '_')
      .replaceAll(':', '_')
      .replaceAll('*', '_')
      .replaceAll('?', '_')
      .replaceAll('"', '_')
      .replaceAll('<', '_')
      .replaceAll('>', '_')
      .replaceAll('|', '_')
  }

  private deleteDownloadFileIfExists(path:string):void{
    if(path == ''){
      return
    }
    try{
      fileIo.unlinkSync(path)
    }catch (error) {
    }
  }

  sendMediaMessage(msg:MessageContent,conver:Conversation):void
  sendMediaMessage(msg:MessageContent,conver:Conversation,callback:MessageCallback):void
  sendMediaMessage(msg:MessageContent,conver:Conversation,callback?:MessageCallback):void{
    let completed = callback != undefined ? callback : ()=>{}
    if(!(msg instanceof MediaMessageContent)){
      this.sendMessage(msg, conver, completed)
      return
    }
    let mediaMsg = msg as MediaMessageContent
    if(mediaMsg.url != ''){
      mediaMsg.setUploadState(MediaMessageUploadState.success, 100)
      this.sendMessage(mediaMsg, conver, completed)
      return
    }
    if(this.messageUploadProvider == null){
      mediaMsg.setUploadState(MediaMessageUploadState.failed)
      completed(-1, null)
      return
    }
    mediaMsg.setUploadState(MediaMessageUploadState.uploading, 0)
    let localMessage = this.buildOutgoingMessage(mediaMsg, conver)
    localMessage.state = MessageSentState.uploading
    let msgDao = JimDbManager.instance.getMessageDao()
    let msgDbId = msgDao.insert(localMessage)
    this.msgSyncMgr.updConver(localMessage)
    this.msgSyncMgr.notifyMessageModified(localMessage)
    this.messageUploadProvider.uploadMediaMessage(
      mediaMsg,
      (progress)=>{
        mediaMsg.setUploadState(MediaMessageUploadState.uploading, progress)
        localMessage.state = MessageSentState.uploading
        this.updateLocalMediaMessage(msgDbId, localMessage)
      },
      (result)=>{
        this.applyMediaUploadResult(mediaMsg, result)
        mediaMsg.setUploadState(MediaMessageUploadState.success, 100)
        localMessage.state = MessageSentState.sending
        this.updateLocalMediaMessage(msgDbId, localMessage)
        this.publishOutgoingMessage(localMessage, msgDbId, undefined, completed)
      },
      (code, message)=>{
        console.error(`jimsdk_media_upload_fail. code:${code}, message:${message}`)
        mediaMsg.setUploadState(MediaMessageUploadState.failed)
        localMessage.state = MessageSentState.failed
        msgDao.updateMsgState(msgDbId, localMessage.state)
        this.updateLocalMediaMessage(msgDbId, localMessage)
        completed(code == 0 ? -1 : code, null)
      },
      ()=>{
        mediaMsg.setUploadState(MediaMessageUploadState.canceled)
        localMessage.state = MessageSentState.failed
        msgDao.updateMsgState(msgDbId, localMessage.state)
        this.updateLocalMediaMessage(msgDbId, localMessage)
        completed(-2, null)
      }
    )
  }

  private updateLocalMediaMessage(msgDbId:number, message:Message):void{
    let msgDao = JimDbManager.instance.getMessageDao()
    msgDao.updateMsgContentByDbId(msgDbId, message.msgContent)
    msgDao.updateMsgState(msgDbId, message.state)
    this.msgSyncMgr.notifyMessageModified(message)
  }

  private applyMediaUploadResult(msg:MediaMessageContent, result:MediaUploadResult):void{
    if(result.url != ''){
      msg.url = result.url
    }
    if(result.type != ''){
      if(msg instanceof VoiceMessage){
        msg.type = result.type
      }
      if(msg instanceof FileMessage){
        msg.type = result.type
      }
    }
    if(result.size > 0){
      if(msg instanceof ImageMessage){
        msg.size = result.size
      }
      if(msg instanceof FileMessage){
        msg.size = result.size
      }
      if(msg instanceof VideoMessage){
        msg.size = result.size
      }
    }
    if(result.duration > 0){
      if(msg instanceof VoiceMessage){
        msg.duration = result.duration
      }
      if(msg instanceof VideoMessage){
        msg.duration = result.duration
      }
    }
    if(result.width > 0){
      if(msg instanceof ImageMessage){
        msg.width = result.width
      }
      if(msg instanceof VideoMessage){
        msg.width = result.width
      }
    }
    if(result.height > 0){
      if(msg instanceof ImageMessage){
        msg.height = result.height
      }
      if(msg instanceof VideoMessage){
        msg.height = result.height
      }
    }
    if(result.thumbnail != '' && msg instanceof ImageMessage){
      msg.thumbnail = result.thumbnail
    }
    if(result.poster != '' && msg instanceof VideoMessage){
      msg.poster = result.poster
    }
    if(result.name != '' && msg instanceof FileMessage){
      msg.name = result.name
    }
  }

  queryMessages(conver:Conversation,options:GetMessageOptions,callback:QryMessagesCallback){
    let normalizedOptions = this.normalizeMessageOptions(options)
    this.queryLocalMessages(conver,normalizedOptions,(code,msgs)=>{
      if(conver.conversationType == immessage.ChannelType.Chatroom){
        callback(code, msgs, msgs.length >= normalizedOptions.count)
        return
      }
      //check lack msgs
      let isLack:boolean = false
      let lastSeq:number = 0
      msgs.forEach((msg)=>{
        if(lastSeq==0){
          lastSeq = msg.msgSeqNo
        }else{
          if(lastSeq!=msg.msgSeqNo-1){
            isLack = true
            return
          }else{
            lastSeq = msg.msgSeqNo
          }
        }
      })
      if(isLack||msgs.length<normalizedOptions.count){
        //query from remote
        this.queryRemoteMessages(conver,normalizedOptions,(code,remoteMsgs,hasMore)=>{
          this.mergeLocalMessageState(msgs, remoteMsgs)
          remoteMsgs.forEach((msg)=>{
            //check exist
            let msgDao = JimDbManager.instance.getMessageDao()
            if(!msgDao.existByMsgId(msg.messageId,msg.clientId)){
              //save msg
              msgDao.insert(msg)
            }
          })
          callback(code,remoteMsgs,hasMore)
        })
      }else{
        callback(code,msgs,msgs.length>=normalizedOptions.count)
      }
    })
  }

  private mergeLocalMessageState(localMsgs:Message[], remoteMsgs:Message[]):void{
    localMsgs.forEach((localMsg)=>{
      remoteMsgs.forEach((remoteMsg)=>{
        let isSameMessage = false
        if(localMsg.messageId != '' && remoteMsg.messageId != '' && localMsg.messageId == remoteMsg.messageId){
          isSameMessage = true
        } else if(localMsg.clientId != '' && remoteMsg.clientId != '' && localMsg.clientId == remoteMsg.clientId){
          isSameMessage = true
        }
        if(!isSameMessage){
          return
        }
        remoteMsg.state = localMsg.state
        remoteMsg.direction = localMsg.direction
        remoteMsg.hasRead = localMsg.hasRead
        remoteMsg.readCount = localMsg.readCount
        remoteMsg.memberCount = localMsg.memberCount
        remoteMsg.isEdit = localMsg.isEdit
        remoteMsg.referMsgId = localMsg.referMsgId
        remoteMsg.referredMessage = localMsg.referredMessage
        remoteMsg.mentionInfo = localMsg.mentionInfo
        remoteMsg.localAttribute = localMsg.localAttribute
        return
      })
    })
  }

  queryLocalMessages(conver:Conversation,options:GetMessageOptions,callback:QryMessagesCallback){
    let normalizedOptions = this.normalizeMessageOptions(options)
    let dao = JimDbManager.instance.getMessageDao()
    if(normalizedOptions.direction == GetMessageDirection.Backward && normalizedOptions.time<=0){
      normalizedOptions.time = new Date().getTime()
    }
    let msgs = dao.queryMessages(
      conver,
      normalizedOptions.time,
      normalizedOptions.count,
      normalizedOptions.direction == GetMessageDirection.Forward,
      normalizedOptions.contentTypes
    )
    callback(0,msgs,msgs.length>=normalizedOptions.count)
  }

  queryRemoteMessages(conver:Conversation,options:GetMessageOptions,callback:QryMessagesCallback){
    let normalizedOptions = this.normalizeMessageOptions(options)
    if(conver.conversationType == immessage.ChannelType.Chatroom){
      callback(0, [], false)
      return
    }
    let order:number = 0
    if(normalizedOptions.direction == GetMessageDirection.Forward){
      order = 1
    }
    let req = immessage.QryHisMsgsReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.startTime = normalizedOptions.time
    req.count = normalizedOptions.count
    req.order = order
    req.msgTypes = normalizedOptions.contentTypes
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.QryHisMsgsReq.encode(req).finish()
    this.imclient.query("qry_hismsgs",conver.conversationId,data,(code,qryAck)=>{
      let msgs:Message[] = new Array()
      if(code==0){
        let data = qryAck.data as Uint8Array
        let resp = immessage.DownMsgSet.decode(data)
        resp.msgs.forEach((msg)=>{
          msgs.push(MsgHandler.downMsg2Message(msg))
        })
        callback(code,msgs,!resp.isFinished)
      }else{
        callback(code,msgs,false)
      }
    })
  }

  private normalizeMessageOptions(options:GetMessageOptions):GetMessageOptions{
    let normalized = new GetMessageOptions()
    normalized.count = options.count > 0 ? options.count : 20
    normalized.time = options.time
    normalized.direction = options.direction
    normalized.contentTypes = options.contentTypes != undefined ? options.contentTypes.slice() : []

    if(options instanceof QueryMsgOptions){
      let legacyOptions = options as QueryMsgOptions
      if(legacyOptions.startTime > 0){
        normalized.time = legacyOptions.startTime
      }
      if(legacyOptions.isPositive){
        normalized.direction = GetMessageDirection.Forward
      }else if(legacyOptions.startTime > 0 || legacyOptions.time == 0){
        normalized.direction = GetMessageDirection.Backward
      }
      if(legacyOptions.contentTypes.length > 0){
        normalized.contentTypes = legacyOptions.contentTypes.slice()
      }
    }

    if(normalized.time <= 0 && normalized.direction == GetMessageDirection.Backward){
      normalized.time = new Date().getTime()
    }
    return normalized
  }

  private isMentionForCurrentUser(message:Message):boolean{
    if(message.senderId == JuggleIm.instance.userId){
      return false
    }
    let mentionInfo = message.mentionInfo
    if(mentionInfo == undefined){
      return false
    }
    if(mentionInfo.mentionType == MentionType.All ||
      mentionInfo.mentionType == MentionType.AllAndSomeone){
      return true
    }
    if(mentionInfo.mentionType != MentionType.Someone){
      return false
    }
    for(let i = 0; i < mentionInfo.targetUsers.length; i++){
      if(mentionInfo.targetUsers[i].userId == JuggleIm.instance.userId){
        return true
      }
    }
    return false
  }

  private queryLocalMentionMessages(conver:Conversation,count:number,startTime:number,isPositive:boolean):Message[]{
    let queryTime = startTime
    if(queryTime <= 0 && !isPositive){
      queryTime = new Date().getTime()
    }
    let candidates = JimDbManager.instance.getMessageDao().queryMentionMessages(conver, queryTime, count > 0 ? count * 5 : 100, isPositive)
    let results:Message[] = []
    for(let i = 0; i < candidates.length; i++){
      if(this.isMentionForCurrentUser(candidates[i])){
        results.push(candidates[i])
      }
      if(count > 0 && results.length >= count){
        break
      }
    }
    return results
  }

  private mergeMentionResults(localMsgs:Message[], remoteMsgs:Message[], count:number, isPositive:boolean):Message[]{
    let results:Message[] = []
    let keys:Map<string, boolean> = new Map()
    let appendMessage = (message:Message):void => {
      let key = message.messageId != '' ? message.messageId : message.clientId
      if(key == '' || keys.has(key)){
        return
      }
      keys.set(key, true)
      results.push(message)
    }
    remoteMsgs.forEach((message)=>{
      appendMessage(message)
    })
    localMsgs.forEach((message)=>{
      appendMessage(message)
    })
    results = results.slice().sort((a,b)=>{
      if(isPositive){
        return a.sentTime - b.sentTime
      }
      return b.sentTime - a.sentTime
    })
    if(count > 0 && results.length > count){
      results = results.slice(0, count)
    }
    return results
  }

  queryMentionMessages(conver:Conversation,count:number,startTime:number,isPositive:boolean,callback:QryMessagesCallback){
    if(conver.conversationId == ''){
      callback(-1, [], false)
      return
    }
    let queryCount = count > 0 ? count : 20
    let queryTime = startTime
    if(queryTime <= 0 && !isPositive){
      queryTime = new Date().getTime()
    }
    let order = isPositive ? 1 : 0
    let latestReadIndex = 0
    let localConver = JimDbManager.instance.getConversationDao().getConver(conver)
    if(localConver != undefined){
      latestReadIndex = localConver.lastReadMsgIndex
    }
    let req = immessage.QryMentionMsgsReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.startTime = queryTime
    req.count = queryCount
    req.order = order
    req.latestReadIndex = latestReadIndex
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.QryMentionMsgsReq.encode(req).finish()
    this.imclient.query("qry_mention_msgs", conver.conversationId, data, (code, qryAck)=>{
      let msgs:Message[] = []
      let localMentionMsgs = this.queryLocalMentionMessages(conver, queryCount, queryTime, isPositive)
      if(code != 0){
        if(localMentionMsgs.length > 0){
          callback(0, localMentionMsgs, false)
          return
        }
        callback(code, msgs, false)
        return
      }
      let ackData = qryAck.data as Uint8Array
      let resp = immessage.QryMentionMsgsResp.decode(ackData)
      resp.mentionMsgs.forEach((msg)=>{
        msgs.push(MsgHandler.downMsg2Message(msg))
      })
      let localMsgs = JimDbManager.instance.getMessageDao().getMessagesByMessageIds(msgs.map((msg)=>msg.messageId))
      this.mergeLocalMessageState(localMsgs, msgs)
      msgs.forEach((msg)=>{
        if(!JimDbManager.instance.getMessageDao().existByMsgId(msg.messageId, msg.clientId)){
          JimDbManager.instance.getMessageDao().insert(msg)
        }
      })
      let mergedMsgs = this.mergeMentionResults(localMentionMsgs, msgs, queryCount, isPositive)
      callback(0, mergedMsgs, !resp.isFinished)
    })
  }

  clearMessages(conver:Conversation,options:ClearMsgOptions,callback:CommonCallback){
    console.log(`TOPTRACE conversation_clear_messages_request: converId=${conver.conversationId}, converType=${conver.conversationType}, cleanTime=${options.cleanTime}, cleanScope=${options.cleanScope}, senderId=${options.senderId}, cleanTimeOffset=${options.cleanTimeOffset}`)
    let req = immessage.CleanHisMsgReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.cleanMsgTime = options.cleanTime
    req.cleanScope = options.cleanScope
    req.senderId = options.senderId
    req.cleanTimeOffset = options.cleanTimeOffset
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.CleanHisMsgReq.encode(req).finish()
    this.imclient.query("clean_hismsg",conver.conversationId,data,(code,qryAck)=>{
      let timestamp = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : 0
      console.log(`TOPTRACE conversation_clear_messages_ack: converId=${conver.conversationId}, converType=${conver.conversationType}, code=${code}, timestamp=${timestamp}`)
      if(code == 0){
        JimDbManager.instance.getMessageDao().clearConversationMessages(conver, options.cleanTime, options.senderId)
        let localConver = this.refreshConversationAfterLocalMessageRemoval(conver)
        if(timestamp > 0){
          this.msgSyncMgr.recordLatestSendboxMsgTime(timestamp, MsgFlagTool.toFlag(MsgFlagTool.commandFlag()))
        }
        if(localConver != undefined){
          console.log(`TOPTRACE conversation_clear_messages_local_update: converId=${conver.conversationId}, converType=${conver.conversationType}, converTime=${localConver.converTime}, lastMsgId=${localConver.lastMessage.messageId}`)
          this.msgSyncMgr.notifyConversationUpdate([localConver])
        }else{
          console.log(`TOPTRACE conversation_clear_messages_local_missing: converId=${conver.conversationId}, converType=${conver.conversationType}`)
        }
        this.msgSyncMgr.notifyMessageCleaned(conver, options.cleanTime, options.senderId)
      }
      callback(code)
    })
  }

  delMessages(conver:Conversation,msgIds:string[],delScope:number,callback:CommonCallback){
    let normalizedMsgIds = this.normalizeMessageIds(msgIds)
    if(normalizedMsgIds.length == 0){
      callback(new JimErrorCode().InvalidParam)
      return
    }
    let msgs:immessage.SimpleMsg[] = []
    normalizedMsgIds.forEach((msgId)=>{
      let simpleMsg = immessage.SimpleMsg.create({})
      simpleMsg.msgId = msgId
      msgs.push(simpleMsg)
    })
    let req = immessage.DelHisMsgsReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.msgs = msgs
    req.delScope = delScope
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.DelHisMsgsReq.encode(req).finish()
    this.imclient.query("del_hismsg",conver.conversationId,data,(code)=>{
      if(code == 0){
        JimDbManager.instance.getMessageDao().markMessagesDeleted(normalizedMsgIds)
        let localConver = this.refreshConversationAfterLocalMessageRemoval(conver)
        if(localConver != undefined){
          this.msgSyncMgr.notifyConversationUpdate([localConver])
        }
        this.msgSyncMgr.notifyMessageDeleted(conver, normalizedMsgIds)
      }
      callback(code)
    })
  }

  private normalizeMessageIds(msgIds:string[]):string[]{
    let normalizedIds:string[] = []
    msgIds.forEach((msgId)=>{
      let normalizedId = msgId.trim()
      if(normalizedId != ''){
        normalizedIds.push(normalizedId)
      }
    })
    return normalizedIds
  }

  private findMessageByRequestId(messages:Message[], requestId:string):Message|null{
    for(let i = 0; i < messages.length; i++){
      let message = messages[i]
      if(message.messageId == requestId || message.clientId == requestId){
        return message
      }
    }
    return null
  }

  private combineMessagesByRequestIds(requestIds:string[], localMessages:Message[], remoteMessages:Message[]):Message[]{
    let result:Message[] = []
    requestIds.forEach((requestId)=>{
      let localMessage = this.findMessageByRequestId(localMessages, requestId)
      if(localMessage != null){
        result.push(localMessage)
        return
      }
      let remoteMessage = this.findMessageByRequestId(remoteMessages, requestId)
      if(remoteMessage != null){
        result.push(remoteMessage)
      }
    })
    return result
  }

  private persistRemoteMessages(remoteMessages:Message[]):Message[]{
    if(remoteMessages.length == 0){
      return []
    }
    let msgDao = JimDbManager.instance.getMessageDao()
    let localMessages = msgDao.getMessagesByMessageIds(remoteMessages.map((message)=>message.messageId))
    this.mergeLocalMessageState(localMessages, remoteMessages)
    remoteMessages.forEach((message)=>{
      if(!msgDao.existByMsgId(message.messageId, message.clientId)){
        msgDao.insert(message)
      }
    })
    return this.combineMessagesByRequestIds(
      remoteMessages.map((message)=>message.messageId != '' ? message.messageId : message.clientId),
      localMessages,
      remoteMessages
    )
  }

  private refreshConversationAfterLocalMessageRemoval(conver:Conversation):ConversationInfo | undefined{
    let localConver = JimDbManager.instance.getConversationDao().getConver(conver)
    if(localConver == undefined){
      return undefined
    }
    let lastMessage = JimDbManager.instance.getMessageDao().getLastVisibleMessage(conver)
    if(lastMessage == null){
      return JimDbManager.instance.getConversationDao().clearLastMessage(conver)
    }
    localConver.lastMessage = lastMessage
    localConver.converTime = lastMessage.sentTime
    JimDbManager.instance.getConversationDao().upsert(localConver)
    return JimDbManager.instance.getConversationDao().getConver(conver)
  }

  private queryRemoteMessagesByIds(conver:Conversation,msgIds:string[],callback:QryMessagesCallback):void{
    let req = immessage.QryHisMsgByIdsReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.msgIds = msgIds
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.QryHisMsgByIdsReq.encode(req).finish()
    this.imclient.query("qry_hismsg_by_ids",conver.conversationId,data,(code,qryAck)=>{
      let msgs:Message[] = []
      if(code == 0){
        let ackData = qryAck.data as Uint8Array
        let resp = immessage.DownMsgSet.decode(ackData)
        resp.msgs.forEach((msg)=>{
          msgs.push(MsgHandler.downMsg2Message(msg))
        })
        callback(code,msgs,false)
        return
      }
      callback(code,msgs,false)
    })
  }

  getMessagesByMessageIds(conver:Conversation|null,msgIds:string[],callback:QryMessagesCallback){
    let requestIds = this.normalizeMessageIds(msgIds)
    if(requestIds.length == 0){
      callback(0, [], false)
      return
    }
    let msgDao = JimDbManager.instance.getMessageDao()
    let localMessages = msgDao.getMessagesByMessageIds(requestIds)
    let missingIds:string[] = []
    requestIds.forEach((requestId)=>{
      if(this.findMessageByRequestId(localMessages, requestId) == null){
        missingIds.push(requestId)
      }
    })
    if(missingIds.length == 0 || conver == null){
      callback(0, localMessages, false)
      return
    }
    this.queryRemoteMessagesByIds(conver, missingIds, (code, remoteMessages)=>{
      if(code != 0){
        if(localMessages.length > 0){
          callback(0, localMessages, false)
          return
        }
        callback(code, [], false)
        return
      }
      this.mergeLocalMessageState(localMessages, remoteMessages)
      remoteMessages.forEach((message)=>{
        if(!msgDao.existByMsgId(message.messageId, message.clientId)){
          msgDao.insert(message)
        }
      })
      callback(0, this.combineMessagesByRequestIds(requestIds, localMessages, remoteMessages), false)
    })
  }

  getMessagesByIds(conver:Conversation|null,msgIds:string[],callback:QryMessagesCallback){
    this.getMessagesByMessageIds(conver, msgIds, callback)
  }

  updateMessage(msgId:string,msg:MessageContent,conver:Conversation,callback:MessageCallback){
    if(msgId == '' || conver.conversationId == '' || msg == undefined){
      callback(-1, null)
      return
    }
    let localMessages = JimDbManager.instance.getMessageDao().getMessagesByMessageIds([msgId])
    if(localMessages.length == 0){
      callback(-2, null)
      return
    }
    let localMessage = localMessages[0]
    let req = immessage.ModifyMsgReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.msgId = msgId
    req.msgTime = localMessage.sentTime
    req.msgSeqNo = localMessage.msgSeqNo
    req.msgContent = msg.encode()
    req.msgType = msg.getMsgType()
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.ModifyMsgReq.encode(req).finish()
    this.imclient.query("modify_msg", conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, null)
        return
      }
      if(qryAck.timestamp != undefined && qryAck.timestamp != null){
        this.msgSyncMgr.recordLatestSendboxMsgTime(JimUtil.toNumber(qryAck.timestamp as number), localMessage.flags)
      }
      let flags = localMessage.flags | 16
      localMessage.msgContent = msg
      localMessage.flags = flags
      localMessage.isEdit = true
      localMessage.searchContent = this.buildSearchContent(msg)
      let msgDao = JimDbManager.instance.getMessageDao()
      msgDao.updateMsgContent(localMessage.messageId, localMessage.msgContent)
      msgDao.updateMsgFlags(localMessage.messageId, flags)
      this.msgSyncMgr.notifyMessageModified(localMessage)
      callback(0, localMessage)
    })
  }

  modifyMessage(conver:Conversation,msgId:string,msg:MessageContent,callback:MessageCallback){
    this.updateMessage(msgId, msg, conver, callback)
  }

  sendReadReceipt(conver:Conversation,msgIds:string[],callback:CommonCallback){
    if(conver.conversationId == ''){
      callback(-1)
      return
    }
    let requestIds = this.normalizeMessageIds(msgIds)
    if(requestIds.length == 0){
      callback(0)
      return
    }
    let localMessages = JimDbManager.instance.getMessageDao().getMessagesByMessageIds(requestIds)
    let simpleMsgs:immessage.SimpleMsg[] = []
    requestIds.forEach((requestId)=>{
      let localMessage = this.findMessageByRequestId(localMessages, requestId)
      let messageId = requestId
      let msgTime = 0
      let msgReadIndex = 0
      if(localMessage != null){
        if(localMessage.messageId != ''){
          messageId = localMessage.messageId
        }
        msgTime = localMessage.sentTime
        msgReadIndex = localMessage.msgUnreadIndex
      }
      if(messageId != ''){
        let simpleMsg = immessage.SimpleMsg.create({})
        simpleMsg.msgId = messageId
        simpleMsg.msgTime = msgTime
        simpleMsg.msgReadIndex = msgReadIndex
        simpleMsgs.push(simpleMsg)
      }
    })
    if(simpleMsgs.length == 0){
      callback(0)
      return
    }
    let req = immessage.MarkReadReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.msgs = simpleMsgs
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.MarkReadReq.encode(req).finish()
    this.imclient.query("mark_read", conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code)
        return
      }
      if(qryAck.timestamp != undefined && qryAck.timestamp != null){
        this.msgSyncMgr.recordLatestSendboxMsgTime(JimUtil.toNumber(qryAck.timestamp as number), MsgFlagTool.toFlag(MsgFlagTool.commandFlag()))
      }
      let msgDao = JimDbManager.instance.getMessageDao()
      let actualMessageIds:string[] = []
      simpleMsgs.forEach((simpleMsg)=>{
        if(simpleMsg.msgId != undefined && simpleMsg.msgId != ''){
          actualMessageIds.push(simpleMsg.msgId as string)
        }
      })
      let readTime = qryAck.timestamp != undefined && qryAck.timestamp != null ?
        JimUtil.toNumber(qryAck.timestamp as number) : new Date().getTime()
      msgDao.updateMessagesRead(actualMessageIds, readTime)
      let readMessages = msgDao.getMessagesByMessageIds(actualMessageIds)
      readMessages.forEach((message)=>{
        message.hasRead = true
        message.readTime = readTime
        this.msgSyncMgr.notifyMessageModified(message)
        this.msgSyncMgr.checkAndNotifyDestroyTime(message, readTime)
      })
      callback(0)
    })
  }

  private toGroupMessageMemberReadDetail(item:immessage.IMemberReadDetailItem):GroupMessageMemberReadDetail{
    let detail = new GroupMessageMemberReadDetail()
    if(item.member != undefined && item.member != null){
      let user = new UserInfo()
      user.userId = item.member.userId as string
      user.nickname = item.member.nickname as string
      user.userPortrait = item.member.userPortrait as string
      user.userType = JimUtil.toNumber(item.member.userType as number)
      user.updTime = JimUtil.toNumber(item.member.updatedTime as number)
      JuggleIm.instance.getUserInfoManager().saveUserInfo(user)
      detail.userId = user.userId
      detail.nickname = user.nickname
      detail.portrait = user.userPortrait
    }
    detail.readTime = JimUtil.toNumber(item.time as number)
    return detail
  }

  getGroupMessageReadInfoDetail(conver:Conversation,msgId:string,callback:GroupMessageReadInfoDetailCallback):void{
    if(conver.conversationId == '' || msgId == '' || conver.conversationType != 2){
      callback(-1, null)
      return
    }
    let req = immessage.QryReadDetailReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.msgId = msgId
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.QryReadDetailReq.encode(req).finish()
    this.imclient.query("qry_read_detail", conver.conversationId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, null)
        return
      }
      let ackData = qryAck.data as Uint8Array
      let resp = immessage.QryReadDetailResp.decode(ackData)
      let detail = new GroupMessageReadInfoDetail()
      detail.readCount = resp.readCount as number
      detail.memberCount = resp.memberCount as number
      resp.readMembers.forEach((item)=>{
        detail.readMembers.push(this.toGroupMessageMemberReadDetail(item))
      })
      resp.unreadMembers.forEach((item)=>{
        detail.unreadMembers.push(this.toGroupMessageMemberReadDetail(item))
      })
      let msgDao = JimDbManager.instance.getMessageDao()
      msgDao.updateGroupReadInfo(msgId, detail.readCount, detail.memberCount)
      let localMessage = msgDao.getMessage(msgId)
      if(localMessage != null){
        localMessage.readCount = detail.readCount
        localMessage.memberCount = detail.memberCount
        this.msgSyncMgr.notifyMessageModified(localMessage)
      }
      callback(0, detail)
    })
  }

  recallMessage(conver:Conversation,msgId:string,extras:HashMap<string,string>,callback:MessageCallback){
    let exts:immessage.KvItem[] = []
    extras.forEach((k,v)=>{
      let ext = immessage.KvItem.create({})
      ext.key = k != undefined ? k : ''
      ext.value = v != undefined ? v : ''
      exts.push(ext)
    })
    let req = immessage.RecallMsgReq.create({})
    req.targetId = conver.conversationId
    req.channelType = conver.conversationType
    req.msgId = msgId
    req.exts = exts
    req.subChannel = Conversation.normalizeSubChannel(conver.subChannel)
    let data = immessage.RecallMsgReq.encode(req).finish()
    this.imclient.query("recall_msg",conver.conversationId,data,(code)=>{
      let msg = new Message()
      callback(code,msg)
    })
  }

  searchMessages(params:SearchParams,callback:QryMessagesCallback){
    let dao = JimDbManager.instance.getMessageDao()
    let msgs = dao.searchMessages(
      params.keywords,
      params.startTime,
      params.endTime,
      params.count,
      params.direction == GetMessageDirection.Forward,
      params.msgTypes,
      params.conver
    )
    callback(0, msgs, false)
  }

  setLocalAttribute(msgId:string,attribute:string){
    JimDbManager.instance.getMessageDao().updateLocalAttribute(msgId, attribute)
  }

  getLocalAttribute(msgId:string):string{
    return JimDbManager.instance.getMessageDao().getLocalAttribute(msgId)
  }

  setLocalAttribue(msgId:string,attribute:string){
    this.setLocalAttribute(msgId, attribute)
  }

}
