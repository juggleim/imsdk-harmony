import {
  BroadcastMessageCallback,
  ClearMsgOptions,
  CommonCallback,
  Conversation,
  ConversationAddListener,
  ConversationCallback,
  ConversationDeleteListener,
  ConversationInfo,
  ConversationInsertCallback,
  ConversationListener,
  ConversationSyncListener,
  ConversationTag,
  ConversationTagInfo,
  ConversationTagInfosCallback,
  ConversationTagListener,
  ConversationTagsCallback,
  ConversationUpdateListener,
  ConversationsCallback,
  FavoriteMessage,
  FavoriteMessagesCallback,
  FileMessage,
  FriendInfo,
  FriendInfoCallback,
  GetConversationDirection,
  GetConversationOptions,
  GetFavoriteMessageOption,
  GetMessageDirection,
  GetMessageOptions,
  GetMomentCommentOption,
  GetMomentOption,
  GroupInfo,
  GroupInfoCallback,
  GroupMember,
  GroupMemberCallback,
  GroupMembersCallback,
  GroupMessageReadInfo,
  GroupMessageReadInfoDetailCallback,
  IGetLocalAndRemoteMessagesCallback,
  IGetMessagesCallback,
  ImageMessage,
  IChatroomManager,
  IConnectionManager,
  IConversationManager,
  IMessageManager,
  IMomentManager,
  IUserInfoManager,
  IGroupInfoManager,
  JimMsgType,
  JuggleIm,
  MediaUploadCredential,
  Message,
  MessageContent,
  MediaMessageContent,
  MessageMentionInfo,
  MessageOptions,
  MessageQueryOptions,
  MessageReaction,
  MessageReactionResult,
  MessageReactionsCallback,
  MessageSentState,
  MessageCallback,
  Moment,
  MomentCallback,
  MomentComment,
  MomentCommentCallback,
  MomentCommentsCallback,
  MomentMedia,
  MomentReaction,
  MomentReactionsCallback,
  MomentsCallback,
  PushData,
  PushChannel,
  QueryMsgOptions,
  RecallInfoMessage,
  SearchParams,
  TextMessage,
  TimePeriod,
  TopConverSortType,
  TopMessageCallback,
  UserInfo,
  UserInfoCallback,
  VoiceMessage,
  VideoMessage,
  MergeMessage,
  ChatroomAttributesCallback,
  ChatroomAttributesListener,
  ChatroomAttributesUpdateCallback,
  ChatroomListener,
  ConnStatus,
  ConnectionStatusListener,
  ConnectionStatusListenerValue,
  ConnectionStatusObserver,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgDestroyTimeUpdateListener,
  MsgGroupReadReceiptListener,
  MsgModifiedListener,
  MsgReadReceiptListener,
  MsgReceivedListener,
  MsgRecalledListener,
  MsgTopChangedListener,
  MuteStatusCallback,
  QryMessagesCallback,
  SearchConversationsResult,
  JimUtil
} from '@juggleim/imlib'
import { HashMap } from '@kit.ArkTS'
import { ApiActionConfig, ApiDemoCommonDefaults, ApiDemoInvokeContext, ApiFieldConfig, ApiFieldViewState, ApiListenerConfig, ApiLogItem } from '../models/apiDemoTypes'

type ApiLogSink = (title: string, content: string) => void
type ApiValue = Object | string | number | boolean | undefined
type ApiMethod = (...args: ApiValue[]) => ApiValue

class DemoCustomMessage extends MessageContent {
  static registeredType: string = 'jg:demo_custom'
  content: string = ''

  constructor() {
    super()
    this.setMsgType(DemoCustomMessage.registeredType)
  }

  encode(): Uint8Array {
    return JimUtil.stringToUint8Array(JSON.stringify({ content: this.content }))
  }

  decode(data: Uint8Array): void {
    const text: string = JimUtil.uint8ArrayToString(data)
    const obj: Object = JSON.parse(text) as Object
    const content: ApiValue = Reflect.get(obj, 'content') as ApiValue
    this.content = content == undefined ? '' : `${content}`
  }
}

class LocalAndRemoteMessagesCallbackImpl implements IGetLocalAndRemoteMessagesCallback {
  private logSink: ApiLogSink
  private actionId: string

  constructor(actionId: string, logSink: ApiLogSink) {
    this.actionId = actionId
    this.logSink = logSink
  }

  onGetLocalList(messages: Message[], hasRemote: boolean): void {
    this.logSink(this.actionId, `local: hasRemote=${hasRemote}, messages=${JSON.stringify(messages)}`)
  }

  onGetRemoteList(messages: Message[]): void {
    this.logSink(this.actionId, `remote: ${JSON.stringify(messages)}`)
  }

  onGetRemoteListError(errorCode: number): void {
    this.logSink(this.actionId, `remote error=${errorCode}`)
  }
}

class BroadcastMessageCallbackImpl implements BroadcastMessageCallback {
  private logSink: ApiLogSink
  private actionId: string

  constructor(actionId: string, logSink: ApiLogSink) {
    this.actionId = actionId
    this.logSink = logSink
  }

  onProgress(message: Message | null, code: number, processCount: number, totalCount: number): void {
    this.logSink(this.actionId, `progress code=${code}, ${processCount}/${totalCount}, message=${message == null ? 'null' : message.messageId}`)
  }

  onComplete(): void {
    this.logSink(this.actionId, 'broadcast complete')
  }
}

class ConnectionStatusObserverImpl implements ConnectionStatusObserver {
  private logSink: ApiLogSink
  private listenerId: string

  constructor(listenerId: string, logSink: ApiLogSink) {
    this.listenerId = listenerId
    this.logSink = logSink
  }

  onStatusChange(status: number, reasonCode: number, userId: string): void {
    this.logSink(this.listenerId, `status=${status}, reason=${reasonCode}, userId=${userId}`)
  }

  onDbOpen(): void {
    this.logSink(this.listenerId, 'db open')
  }

  onDbClose(): void {
    this.logSink(this.listenerId, 'db close')
  }
}

class ConversationListenerImpl implements ConversationListener {
  private logSink: ApiLogSink
  private listenerId: string

  constructor(listenerId: string, logSink: ApiLogSink) {
    this.listenerId = listenerId
    this.logSink = logSink
  }

  onConversationInfoAdd(conversationInfoList: ConversationInfo[]): void {
    this.logSink(this.listenerId, `add=${JSON.stringify(conversationInfoList)}`)
  }

  onConversationInfoUpdate(conversationInfoList: ConversationInfo[]): void {
    this.logSink(this.listenerId, `update=${JSON.stringify(conversationInfoList)}`)
  }

  onConversationInfoDelete(conversationInfoList: ConversationInfo[]): void {
    this.logSink(this.listenerId, `delete=${JSON.stringify(conversationInfoList)}`)
  }

  onTotalUnreadMessageCountUpdate(count: number): void {
    this.logSink(this.listenerId, `totalUnread=${count}`)
  }
}

class ConversationSyncListenerImpl implements ConversationSyncListener {
  private logSink: ApiLogSink
  private listenerId: string

  constructor(listenerId: string, logSink: ApiLogSink) {
    this.listenerId = listenerId
    this.logSink = logSink
  }

  onConversationSyncComplete(): void {
    this.logSink(this.listenerId, 'sync complete')
  }
}

class ConversationTagListenerImpl implements ConversationTagListener {
  private logSink: ApiLogSink
  private listenerId: string

  constructor(listenerId: string, logSink: ApiLogSink) {
    this.listenerId = listenerId
    this.logSink = logSink
  }

  onTagCreate(tagInfo: ConversationTagInfo): void {
    this.logSink(this.listenerId, `tag create=${tagInfo.tagId}/${tagInfo.tagName}`)
  }

  onTagDestroy(tagId: string): void {
    this.logSink(this.listenerId, `tag destroy=${tagId}`)
  }

  onTagNameUpdate(tagId: string, tagName: string): void {
    this.logSink(this.listenerId, `tag update=${tagId}/${tagName}`)
  }

  onConversationsAddToTag(tagId: string, conversations: Conversation[]): void {
    this.logSink(this.listenerId, `tag add=${tagId}, conversations=${JSON.stringify(conversations)}`)
  }

  onConversationsRemoveFromTag(tagId: string, conversations: Conversation[]): void {
    this.logSink(this.listenerId, `tag remove=${tagId}, conversations=${JSON.stringify(conversations)}`)
  }
}

class ChatroomListenerImpl implements ChatroomListener {
  private logSink: ApiLogSink
  private listenerId: string

  constructor(listenerId: string, logSink: ApiLogSink) {
    this.listenerId = listenerId
    this.logSink = logSink
  }

  onChatroomJoin(chatroomId: string): void {
    this.logSink(this.listenerId, `join=${chatroomId}`)
  }

  onChatroomQuit(chatroomId: string): void {
    this.logSink(this.listenerId, `quit=${chatroomId}`)
  }

  onChatroomJoinFail(chatroomId: string, errorCode: number): void {
    this.logSink(this.listenerId, `join fail=${chatroomId}, code=${errorCode}`)
  }

  onChatroomQuitFail(chatroomId: string, errorCode: number): void {
    this.logSink(this.listenerId, `quit fail=${chatroomId}, code=${errorCode}`)
  }

  onChatroomKick(chatroomId: string): void {
    this.logSink(this.listenerId, `kick=${chatroomId}`)
  }

  onChatroomDestroy(chatroomId: string): void {
    this.logSink(this.listenerId, `destroy=${chatroomId}`)
  }
}

class ChatroomAttributesListenerImpl implements ChatroomAttributesListener {
  private logSink: ApiLogSink
  private listenerId: string

  constructor(listenerId: string, logSink: ApiLogSink) {
    this.listenerId = listenerId
    this.logSink = logSink
  }

  onAttributesUpdate(chatroomId: string, attributes: Map<string, string>): void {
    this.logSink(this.listenerId, `attributes update=${chatroomId}, ${JSON.stringify(attributes)}`)
  }

  onAttributesDelete(chatroomId: string, attributes: Map<string, string>): void {
    this.logSink(this.listenerId, `attributes delete=${chatroomId}, ${JSON.stringify(attributes)}`)
  }
}

export class ApiDemoRuntime {
  private logSink: ApiLogSink
  private listenerMap: Map<string, ApiValue> = new Map()

  constructor(logSink: ApiLogSink) {
    this.logSink = logSink
  }

  hasMessageUploadProvider(): boolean {
    return JuggleIm.instance.getMessageManager().getMessageUploadProvider() != null
  }

  initSdk(context: ApiDemoInvokeContext, listeners: ApiListenerConfig[] = [], logTitle: string = 'init'): void {
    const address: string = context.address.trim()
    const appkey: string = context.appkey.trim()
    if (address == '' || appkey == '') {
      this.logSink('init', 'address/appkey cannot be empty')
      return
    }
    Promise.resolve(JuggleIm.instance.init(address, appkey))
      .then(() => {
        JuggleIm.instance.setPackageName(context.packageName.trim())
        JuggleIm.instance.getConnectionManager().setLanguage(context.language.trim())
        if (listeners.length > 0) {
          this.registerListeners(listeners, context)
        }
        this.logSink(
          logTitle,
          `sdk initialized: address=${address}, appkey=${appkey}, uploadProvider=${JuggleIm.instance.getMessageManager().getMessageUploadProvider() == null ? 'null' : 'set'}`
        )
      })
      .catch((err: Object) => {
        this.logSink(logTitle, `sdk init error: ${this.describeError(err)}`)
      })
  }

  registerListeners(listeners: ApiListenerConfig[], context: ApiDemoInvokeContext): void {
    listeners.forEach((listener) => {
      this.registerListener(listener, context)
    })
  }

  unregisterListeners(listeners: ApiListenerConfig[]): void {
    listeners.forEach((listener) => {
      this.unregisterListener(listener)
    })
  }

  invoke(action: ApiActionConfig, fields: ApiFieldViewState[], context: ApiDemoInvokeContext): Promise<void> {
    const target: object = this.resolveTarget(action.target)
    const rawMethod: ApiValue = Reflect.get(target, action.method) as ApiValue
    if (typeof rawMethod !== 'function') {
      this.logSink(action.id, `method not found: ${action.method}`)
      return Promise.resolve()
    }
    const method: ApiMethod = (rawMethod as Function).bind(target) as ApiMethod
    const fieldMap: Map<string, string> = this.buildFieldMap(fields)
    const args: ApiValue[] = []
    action.args.forEach((field) => {
      args.push(this.buildValue(field, fieldMap, context))
    })
    const callbackKinds: string[] = Array.isArray(action.callbackKinds) && action.callbackKinds.length > 0
      ? action.callbackKinds
      : (action.callbackKind == 'none' ? [] : [action.callbackKind])
    callbackKinds.forEach((kind) => {
      const callback: ApiValue | null = this.buildCallback(kind, action, context)
      if (callback != null) {
        args.push(callback)
      }
    })
    try {
      if (action.target == 'message' && action.method == 'sendMediaMessage') {
        const mediaMsg: MediaMessageContent | null = args.length > 0 && args[0] instanceof MediaMessageContent ? args[0] as MediaMessageContent : null
        if (mediaMsg != null && mediaMsg.url.trim() == '' && JuggleIm.instance.getMessageManager().getMessageUploadProvider() == null) {
          this.logSink(action.id, 'sendMediaMessage requires message upload provider for local media')
          return Promise.resolve()
        }
      }
      const result: ApiValue = method(...args)
      return Promise.resolve(result)
        .then((value: ApiValue) => {
          if (value != undefined) {
            this.logSink(action.id, `result: ${this.describeValue(value)}`)
          } else if (action.callbackKind == 'none') {
            this.logSink(action.id, 'invoked')
          }
        })
        .catch((err: Object) => {
          this.logSink(action.id, `error: ${this.describeError(err)}`)
        })
    } catch (err) {
      this.logSink(action.id, `error: ${this.describeError(err)}`)
      return Promise.resolve()
    }
  }

  private registerListener(listener: ApiListenerConfig, context: ApiDemoInvokeContext): void {
    if (this.listenerMap.has(listener.id)) {
      return
    }
    const target: object = this.resolveTarget(listener.target)
    const rawMethod: ApiValue = Reflect.get(target, listener.method) as ApiValue
    if (typeof rawMethod !== 'function') {
      this.logSink(listener.id, `listener method not found: ${listener.method}`)
      return
    }
    const method: ApiMethod = (rawMethod as Function).bind(target) as ApiMethod
    const callback: ApiValue = this.buildListener(listener, context)
    const normalizedKey: string = listener.key == undefined ? '' : listener.key.trim()
    try {
      if (normalizedKey != '') {
        method(normalizedKey, callback)
      } else {
        method(callback)
      }
      this.listenerMap.set(listener.id, callback)
      this.logSink(listener.id, 'listener registered')
    } catch (err) {
      this.logSink(listener.id, `listener register error: ${this.describeError(err)}`)
    }
  }

  private unregisterListener(listener: ApiListenerConfig): void {
    const callback: ApiValue | undefined = this.listenerMap.get(listener.id)
    if (callback == undefined) {
      return
    }
    const target: object = this.resolveTarget(listener.target)
    const methodName: string = listener.method.replace('add', 'remove')
    const rawMethod: ApiValue = Reflect.get(target, methodName) as ApiValue
    const normalizedKey: string = listener.key == undefined ? '' : listener.key.trim()
    if (typeof rawMethod === 'function') {
      const method: ApiMethod = (rawMethod as Function).bind(target) as ApiMethod
      try {
        if (normalizedKey != '') {
          method(normalizedKey)
        } else {
          method(callback)
        }
        this.logSink(listener.id, 'listener removed')
      } catch (err) {
        this.logSink(listener.id, `listener remove error: ${this.describeError(err)}`)
      }
    }
    this.listenerMap.delete(listener.id)
  }

  private resolveTarget(target: string): object {
    switch (target) {
      case 'sdk':
        return JuggleIm.instance
      case 'connection':
        return JuggleIm.instance.getConnectionManager()
      case 'conversation':
        return JuggleIm.instance.getConversationManager()
      case 'message':
        return JuggleIm.instance.getMessageManager()
      case 'chatroom':
        return JuggleIm.instance.getChatroomManager()
      case 'user':
        return JuggleIm.instance.getUserInfoManager()
      case 'group':
        return JuggleIm.instance.getGroupInfoManager()
      case 'moment':
        return JuggleIm.instance.getMomentManager()
      default:
        return JuggleIm.instance
    }
  }

  private buildFieldMap(fields: ApiFieldViewState[]): Map<string, string> {
    const fieldMap: Map<string, string> = new Map()
    fields.forEach((field) => {
      fieldMap.set(field.key, field.value)
    })
    return fieldMap
  }

  private buildValue(field: ApiFieldConfig, fieldMap: Map<string, string>, context: ApiDemoInvokeContext): ApiValue {
    const raw: string = this.resolveRawValue(field, fieldMap, context)
    switch (field.kind) {
      case 'number':
        return this.toNumber(raw)
      case 'boolean':
        return this.toBoolean(raw)
      case 'json':
        return this.parseJson(raw)
      case 'stringArray':
        return this.parseStringArray(raw)
      case 'numberArray':
        return this.parseNumberArray(raw)
      case 'map':
        return this.parseMapString(raw)
      case 'hashMap':
        return this.parseHashMapString(raw)
      case 'conversation':
        return this.parseConversation(raw, context)
      case 'conversationArray':
        return this.parseConversationArray(raw, context)
      case 'messageContent':
      case 'mediaMessage':
        return this.parseMessageContent(raw, context)
      case 'messageOptions':
        return this.parseMessageOptions(raw, context)
      case 'getConversationOptions':
        return this.parseGetConversationOptions(raw, context)
      case 'getMessageOptions':
        return this.parseGetMessageOptions(raw, context)
      case 'messageQueryOptions':
        return this.parseMessageQueryOptions(raw, context)
      case 'searchParams':
        return this.parseSearchParams(raw, context)
      case 'clearMsgOptions':
        return this.parseClearMsgOptions(raw, context)
      case 'getFavoriteOption':
        return this.parseGetFavoriteOption(raw, context)
      case 'timePeriods':
        return this.parseTimePeriods(raw)
      case 'momentOption':
        return this.parseGetMomentOption(raw, context)
      case 'momentCommentOption':
        return this.parseGetMomentCommentOption(raw, context)
      case 'momentMediaArray':
        return this.parseMomentMediaArray(raw)
      case 'pushData':
        return this.parsePushData(raw)
      case 'messageMentionInfo':
        return this.parseMessageMentionInfo(raw)
      case 'userInfo':
        return this.parseUserInfo(raw)
      case 'groupInfo':
        return this.parseGroupInfo(raw)
      case 'groupMember':
        return this.parseGroupMember(raw)
      case 'friendInfo':
        return this.parseFriendInfo(raw)
      case 'messageFromClientMsgNo':
        return this.buildMessageFromClientMsgNo(raw, context)
      case 'customMessageConstructor':
        DemoCustomMessage.registeredType = this.resolveCustomMessageType(raw, context)
        return () => new DemoCustomMessage()
      case 'password':
      case 'text':
      default:
        return raw
    }
  }

  private resolveRawValue(field: ApiFieldConfig, fieldMap: Map<string, string>, context: ApiDemoInvokeContext): string {
    if (fieldMap.has(field.key)) {
      const value: string | undefined = fieldMap.get(field.key)
      return value == undefined ? '' : value
    }
    if (field.sourceKey != '') {
      return this.getCommonValue(context, field.sourceKey)
    }
    return field.defaultValue
  }

  private getCommonValue(context: ApiDemoInvokeContext, key: string): string {
    switch (key) {
      case 'address':
        return context.address
      case 'appkey':
        return context.appkey
      case 'token':
        return context.token
      case 'userId':
        return context.userId
      case 'packageName':
        return context.packageName
      case 'language':
        return context.language
      default:
        break
    }
    const advanced: Object = this.parseJson(context.advancedJson)
    const value: ApiValue = this.readJsonValue(advanced, key)
    if (value == undefined || value == null) {
      return ''
    }
    if (typeof value == 'string') {
      return value as string
    }
    return `${value}`
  }

  private buildCallback(kind: string, action: ApiActionConfig, context: ApiDemoInvokeContext): ApiValue | null {
    switch (kind) {
      case 'common':
        return (code: number) => this.logSink(action.id, `code=${code}`)
      case 'count':
        return (code: number, count: number) => this.logSink(action.id, `code=${code}, count=${count}`)
      case 'message':
        return (code: number, msg: Message | null) => this.logSink(action.id, `code=${code}, msg=${this.describeMessage(msg)}`)
      case 'messages':
        return (code: number, msgs: Message[]) => this.logSink(action.id, `code=${code}, msgs=${this.describeValue(msgs)}`)
      case 'qryMessages':
        return (code: number, msgs: Message[], hasMore: boolean) => this.logSink(action.id, `code=${code}, hasMore=${hasMore}, msgs=${this.describeValue(msgs)}`)
      case 'conversation':
        return (code: number, conver: ConversationInfo | null) => this.logSink(action.id, `code=${code}, conver=${this.describeValue(conver)}`)
      case 'conversations':
        return (code: number, convers: ConversationInfo[]) => this.logSink(action.id, `code=${code}, convers=${this.describeValue(convers)}`)
      case 'conversationTagInfos':
        return (code: number, tagInfos: ConversationTagInfo[]) => this.logSink(action.id, `code=${code}, tagInfos=${this.describeValue(tagInfos)}`)
      case 'conversationTags':
        return (code: number, tags: ConversationTag[]) => this.logSink(action.id, `code=${code}, tags=${this.describeValue(tags)}`)
      case 'groupInfo':
        return (code: number, group: GroupInfo | null) => this.logSink(action.id, `code=${code}, group=${this.describeValue(group)}`)
      case 'groupMember':
        return (code: number, member: GroupMember | null) => this.logSink(action.id, `code=${code}, member=${this.describeValue(member)}`)
      case 'groupMembers':
        return (code: number, members: GroupMember[]) => this.logSink(action.id, `code=${code}, members=${this.describeValue(members)}`)
      case 'userInfo':
        return (code: number, userInfo: UserInfo) => this.logSink(action.id, `code=${code}, userInfo=${this.describeValue(userInfo)}`)
      case 'friendInfo':
        return (code: number, friendInfo: FriendInfo) => this.logSink(action.id, `code=${code}, friendInfo=${this.describeValue(friendInfo)}`)
      case 'messageReactions':
        return (code: number, items: MessageReactionResult[]) => this.logSink(action.id, `code=${code}, items=${this.describeValue(items)}`)
      case 'favoriteMessages':
        return (code: number, items: FavoriteMessage[], offset: string) => this.logSink(action.id, `code=${code}, offset=${offset}, items=${this.describeValue(items)}`)
      case 'topMessage':
        return (code: number, message: Message | null, operator: UserInfo | null, createdTime: number) => this.logSink(action.id, `code=${code}, message=${this.describeMessage(message)}, operator=${this.describeValue(operator)}, createdTime=${createdTime}`)
      case 'localAndRemote':
        return new LocalAndRemoteMessagesCallbackImpl(action.id, this.logSink)
      case 'broadcast':
        return new BroadcastMessageCallbackImpl(action.id, this.logSink)
      case 'mute':
        return (code: number, isMute: boolean, timezone: string, periods: TimePeriod[]) => this.logSink(action.id, `code=${code}, isMute=${isMute}, timezone=${timezone}, periods=${this.describeValue(periods)}`)
      case 'searchConversationsWithMessageContent':
        return (resultList: SearchConversationsResult[]) => this.logSink(action.id, this.describeValue(resultList))
      case 'queryUploadFileCredential':
        return (code: number, credential: MediaUploadCredential | null) => this.logSink(action.id, `code=${code}, credential=${this.describeValue(credential)}`)
      case 'mediaUploadProgress':
        return (progress: number) => this.logSink(action.id, `progress=${progress}`)
      case 'mediaUploadCancel':
        return () => this.logSink(action.id, 'cancel')
      case 'downloadMediaProgress':
        return (progress: number, msg: Message) => this.logSink(action.id, `progress=${progress}, msg=${this.describeMessage(msg)}`)
      case 'downloadMediaSuccess':
        return (msg: Message) => this.logSink(action.id, `msg=${this.describeMessage(msg)}`)
      case 'downloadMediaError':
        return (code: number) => this.logSink(action.id, `code=${code}`)
      case 'downloadMediaCancel':
        return (msg: Message) => this.logSink(action.id, `cancel=${this.describeMessage(msg)}`)
      case 'groupMessageReadInfoDetail':
        return (code: number, detail: ApiValue) => this.logSink(action.id, `code=${code}, detail=${this.describeValue(detail)}`)
      case 'moment':
        return (code: number, moment: Moment | null) => this.logSink(action.id, `code=${code}, moment=${this.describeValue(moment)}`)
      case 'moments':
        return (code: number, moments: Moment[], isFinished: boolean) => this.logSink(action.id, `code=${code}, finished=${isFinished}, moments=${this.describeValue(moments)}`)
      case 'momentComment':
        return (code: number, comment: MomentComment | null) => this.logSink(action.id, `code=${code}, comment=${this.describeValue(comment)}`)
      case 'momentComments':
        return (code: number, comments: MomentComment[], isFinished: boolean) => this.logSink(action.id, `code=${code}, finished=${isFinished}, comments=${this.describeValue(comments)}`)
      case 'momentReactions':
        return (code: number, reactions: MomentReaction[], isFinished: boolean) => this.logSink(action.id, `code=${code}, finished=${isFinished}, reactions=${this.describeValue(reactions)}`)
      case 'chatroomAttributes':
        return (errorCode: number, attributes: Map<string, string> | null) => this.logSink(action.id, `errorCode=${errorCode}, attributes=${this.describeMap(attributes)}`)
      case 'chatroomAttributesUpdate':
        return (errorCode: number, failedKeys: Map<string, number> | null) => this.logSink(action.id, `errorCode=${errorCode}, failedKeys=${this.describeMap(failedKeys)}`)
      default:
        void context
        return null
    }
  }

  private buildListener(listener: ApiListenerConfig, context: ApiDemoInvokeContext): ApiValue {
    switch (listener.listenerKind) {
      case 'connection':
        return (status: number, reasonCode: number, userId: string) => this.logSink(listener.id, `status=${status}, reason=${reasonCode}, userId=${userId}`)
      case 'connectionObserver':
        return new ConnectionStatusObserverImpl(listener.id, this.logSink)
      case 'conversation':
        return new ConversationListenerImpl(listener.id, this.logSink)
      case 'conversationSync':
        return new ConversationSyncListenerImpl(listener.id, this.logSink)
      case 'conversationTag':
        return new ConversationTagListenerImpl(listener.id, this.logSink)
      case 'messageReceived':
        return (msg: Message) => this.logSink(listener.id, `received=${this.describeMessage(msg)}`)
      case 'messageRecalled':
        return (msg: Message) => this.logSink(listener.id, `recalled=${this.describeMessage(msg)}`)
      case 'messageModified':
        return (msg: Message) => this.logSink(listener.id, `modified=${this.describeMessage(msg)}`)
      case 'messageReadReceipt':
        return (conver: Conversation, msgIds: string[]) => this.logSink(listener.id, `readReceipt conver=${this.describeConversation(conver)}, msgIds=${this.describeValue(msgIds)}`)
      case 'groupReadReceipt':
        return (conver: Conversation, messages: Map<string, GroupMessageReadInfo>) => this.logSink(listener.id, `groupReadReceipt conver=${this.describeConversation(conver)}, messages=${this.describeMap(messages)}`)
      case 'messageDeleted':
        return (conver: Conversation, msgIds: string[]) => this.logSink(listener.id, `deleted conver=${this.describeConversation(conver)}, msgIds=${this.describeValue(msgIds)}`)
      case 'messageCleaned':
        return (conver: Conversation, cleanTime: number, senderId: string) => this.logSink(listener.id, `cleaned conver=${this.describeConversation(conver)}, cleanTime=${cleanTime}, sender=${senderId}`)
      case 'messageTop':
        return (conver: Conversation, message: Message | null, operator: UserInfo | null, isTop: boolean, createdTime: number) => this.logSink(listener.id, `top conver=${this.describeConversation(conver)}, isTop=${isTop}, message=${this.describeMessage(message)}, operator=${this.describeValue(operator)}, createdTime=${createdTime}`)
      case 'messageDestroyTime':
        return (messageId: string, conver: Conversation, destroyTime: number) => this.logSink(listener.id, `destroyTime messageId=${messageId}, conver=${this.describeConversation(conver)}, destroyTime=${destroyTime}`)
      case 'chatroom':
        return new ChatroomListenerImpl(listener.id, this.logSink)
      case 'chatroomAttributes':
        return new ChatroomAttributesListenerImpl(listener.id, this.logSink)
      default:
        void context
        return (status: number, reasonCode: number, userId: string) => this.logSink(listener.id, `listener=${listener.listenerKind}, status=${status}, reason=${reasonCode}, userId=${userId}`)
    }
  }

  private describeMap(mapValue: Map<string, string> | Map<string, number> | Map<string, GroupMessageReadInfo> | null): string {
    if (mapValue == null) {
      return 'null'
    }
    const items: string[] = []
    mapValue.forEach((value: string | number | GroupMessageReadInfo, key: string) => {
      items.push(`${key}:${this.describeValue(value)}`)
    })
    return `{${items.join(', ')}}`
  }

  private describeConversation(conver: Conversation | null): string {
    if (conver == null) {
      return 'null'
    }
    return `${conver.conversationType}/${conver.conversationId}/${conver.subChannel}`
  }

  private describeMessage(msg: Message | null): string {
    if (msg == null) {
      return 'null'
    }
    return `${msg.messageId}/${msg.msgContent.getMsgType()}/${msg.senderId}/${msg.sentTime}`
  }

  private describeValue(value: ApiValue | null | undefined): string {
    if (value == null) {
      return 'null'
    }
    if (value instanceof Conversation) {
      return this.describeConversation(value)
    }
    if (value instanceof Message) {
      return this.describeMessage(value)
    }
    if (value instanceof GroupInfo) {
      return `${value.groupId}/${value.groupName}`
    }
    if (value instanceof GroupMember) {
      return `${value.groupId}/${value.memberId}/${value.displayName}`
    }
    if (value instanceof UserInfo) {
      return `${value.userId}/${value.nickname}`
    }
    if (value instanceof FriendInfo) {
      return `${value.userId}/${value.isFriend}/${value.alias}`
    }
    if (value instanceof MessageReactionResult) {
      return `${value.messageId}/${value.clientId}/${value.reactions.length}`
    }
    if (value instanceof FavoriteMessage) {
      return `${this.describeMessage(value.message)}/${value.createdTime}`
    }
    if (value instanceof Moment) {
      return `${value.momentId}/${value.content}`
    }
    if (value instanceof MomentComment) {
      return `${value.commentId}/${value.momentId}/${value.content}`
    }
    if (value instanceof MomentReaction) {
      return `${value.key}/${value.userList.length}`
    }
    if (value instanceof MomentMedia) {
      return `${value.type}/${value.url}`
    }
    if (value instanceof TimePeriod) {
      return `${value.startTime}-${value.endTime}`
    }
    if (value instanceof Map) {
      return this.describeMap(value as Map<string, string> | Map<string, number> | Map<string, GroupMessageReadInfo>)
    }
    try {
      return JSON.stringify(value)
    } catch {
      return `${value}`
    }
  }

  private describeError(err: Object | string | number | boolean | null | undefined): string {
    if (err == null) {
      return 'null'
    }
    if (typeof err == 'string') {
      return err
    }
    try {
      return JSON.stringify(err)
    } catch {
      return `${err}`
    }
  }

  private parseJson(raw: string): Object {
    return this.parseJsonObject(raw)
  }

  private parseJsonObject(raw: string): Object {
    const text: string = raw.trim()
    if (text == '') {
      return new Object()
    }
    try {
      return JSON.parse(text) as Object
    } catch {
      this.logSink('parse', 'json parse error')
      return new Object()
    }
  }

  private toNumber(raw: string): number {
    const num: number = Number(raw)
    return isNaN(num) ? 0 : num
  }

  private toBoolean(raw: string): boolean {
    return raw.trim() == 'true' || raw.trim() == '1'
  }

  private parseStringArray(raw: string): string[] {
    const text: string = raw.trim()
    if (text == '') {
      return []
    }
    try {
      const items: Array<string> = JSON.parse(text) as Array<string>
      return items
    } catch {
      return text.split(',').map((item) => item.trim()).filter((item) => item != '')
    }
  }

  private parseNumberArray(raw: string): number[] {
    const items: string[] = this.parseStringArray(raw)
    const numbers: number[] = []
    items.forEach((item) => {
      const next: number = Number(item)
      if (!isNaN(next)) {
        numbers.push(next)
      }
    })
    return numbers
  }

  private parseMapString(raw: string): Map<string, string> {
    const mapValue: Map<string, string> = new Map()
    const parsed: Object = this.parseJsonObject(raw)
    Object.keys(parsed).forEach((name: string) => {
      const value: ApiValue = this.readJsonValue(parsed, name)
      mapValue.set(name, value == null ? '' : `${value}`)
    })
    return mapValue
  }

  private parseHashMapString(raw: string): HashMap<string, string> {
    const mapValue: HashMap<string, string> = new HashMap()
    const parsed: Object = this.parseJsonObject(raw)
    Object.keys(parsed).forEach((name: string) => {
      const value: ApiValue = this.readJsonValue(parsed, name)
      mapValue.set(name, value == null ? '' : `${value}`)
    })
    return mapValue
  }

  private parseConversation(raw: string, context: ApiDemoInvokeContext): Conversation {
    const parsed: Object = this.parseJson(raw)
    const conversationId: string = this.pickString(parsed, 'conversationId', this.getCommonValue(context, 'conversationId'))
    const conversationType: number = this.pickNumber(parsed, 'conversationType', this.toNumber(this.getCommonValue(context, 'conversationType')))
    const subChannel: string = this.pickString(parsed, 'subChannel', this.getCommonValue(context, 'subChannel'))
    return new Conversation(conversationId, conversationType, subChannel)
  }

  private parseConversationArray(raw: string, context: ApiDemoInvokeContext): Conversation[] {
    const parsed: Object = this.parseJson(raw)
    const list: Object[] = Array.isArray(parsed) ? (parsed as Object[]) : []
    if (list.length == 0) {
      const single: string = this.getCommonValue(context, 'conversationIdsJson')
      const text: string = single.trim()
      if (text != '') {
        try {
          return this.parseConversationArray(text, context)
        } catch {
        }
      }
    }
    const items: Conversation[] = []
    list.forEach((item) => {
      const conversationId: string = this.pickString(item, 'conversationId', '')
      const conversationType: number = this.pickNumber(item, 'conversationType', 0)
      const subChannel: string = this.pickString(item, 'subChannel', '')
      if (conversationId != '') {
        items.push(new Conversation(conversationId, conversationType, subChannel))
      }
    })
    return items
  }

  private parseMessageContent(raw: string, context: ApiDemoInvokeContext): MessageContent {
    const parsed: Object = this.parseJson(raw)
    const kind: string = this.pickString(parsed, 'contentKind', this.getCommonValue(context, 'contentKind')).trim() == ''
      ? 'text'
      : this.pickString(parsed, 'contentKind', this.getCommonValue(context, 'contentKind'))
    switch (kind) {
      case 'merge': {
        const msg: MergeMessage = new MergeMessage()
        msg.title = this.pickString(parsed, 'title', '')
        msg.containerMsgId = this.pickString(parsed, 'containerMsgId', '')
        msg.extra = this.pickString(parsed, 'extra', '')
        msg.messageIdList = this.parseStringArray(this.pickString(parsed, 'messageIdListJson', '[]'))
        return msg
      }
      case 'voice': {
        const msg: VoiceMessage = new VoiceMessage()
        msg.localPath = this.pickString(parsed, 'localPath', this.getCommonValue(context, 'filePath'))
        msg.url = this.pickString(parsed, 'url', '')
        msg.extra = this.pickString(parsed, 'extra', '')
        msg.type = this.pickString(parsed, 'type', '')
        msg.duration = this.pickNumber(parsed, 'duration', 0)
        return msg
      }
      case 'image': {
        const msg: ImageMessage = new ImageMessage()
        msg.localPath = this.pickString(parsed, 'localPath', this.getCommonValue(context, 'filePath'))
        msg.url = this.pickString(parsed, 'url', '')
        msg.extra = this.pickString(parsed, 'extra', '')
        msg.thumbnail = this.pickString(parsed, 'thumbnail', '')
        msg.height = this.pickNumber(parsed, 'height', 0)
        msg.width = this.pickNumber(parsed, 'width', 0)
        msg.size = this.pickNumber(parsed, 'size', 0)
        return msg
      }
      case 'file': {
        const msg: FileMessage = new FileMessage()
        msg.localPath = this.pickString(parsed, 'localPath', this.getCommonValue(context, 'filePath'))
        msg.url = this.pickString(parsed, 'url', '')
        msg.extra = this.pickString(parsed, 'extra', '')
        msg.name = this.pickString(parsed, 'name', '')
        msg.size = this.pickNumber(parsed, 'size', 0)
        msg.type = this.pickString(parsed, 'type', '')
        return msg
      }
      case 'video': {
        const msg: VideoMessage = new VideoMessage()
        msg.localPath = this.pickString(parsed, 'localPath', this.getCommonValue(context, 'filePath'))
        msg.url = this.pickString(parsed, 'url', '')
        msg.extra = this.pickString(parsed, 'extra', '')
        msg.poster = this.pickString(parsed, 'poster', '')
        msg.height = this.pickNumber(parsed, 'height', 0)
        msg.width = this.pickNumber(parsed, 'width', 0)
        msg.size = this.pickNumber(parsed, 'size', 0)
        msg.duration = this.pickNumber(parsed, 'duration', 0)
        return msg
      }
      case 'recall': {
        const msg: RecallInfoMessage = new RecallInfoMessage()
        return msg
      }
      default: {
        const msg: TextMessage = new TextMessage()
        msg.content = this.pickString(parsed, 'content', this.getCommonValue(context, 'searchContent'))
        msg.extra = this.pickString(parsed, 'extra', '')
        return msg
      }
    }
  }

  private parseMessageOptions(raw: string, context: ApiDemoInvokeContext): MessageOptions {
    const parsed: Object = this.parseJson(raw)
    const options: MessageOptions = new MessageOptions()
    options.referredMessageId = this.pickString(parsed, 'referredMessageId', '')
    options.lifeTime = this.pickNumber(parsed, 'lifeTime', 0)
    options.lifeTimeAfterRead = this.pickNumber(parsed, 'lifeTimeAfterRead', 0)
    const pushData: PushData = new PushData()
    pushData.title = this.pickString(parsed, 'pushTitle', '')
    pushData.content = this.pickString(parsed, 'pushContent', '')
    pushData.extra = this.pickString(parsed, 'pushExtra', '')
    if (pushData.title != '' || pushData.content != '' || pushData.extra != '') {
      options.pushData = pushData
    }
    const mentionInfo: MessageMentionInfo = new MessageMentionInfo()
    const mentionType: number = this.pickNumber(parsed, 'mentionType', 0)
    mentionInfo.mentionType = mentionType
    mentionInfo.targetUsers = this.parseUserInfoArray(this.pickString(parsed, 'targetUsersJson', '[]'))
    if (mentionInfo.mentionType != 0 || mentionInfo.targetUsers.length > 0) {
      options.mentionInfo = mentionInfo
    }
    void context
    return options
  }

  private parseGetConversationOptions(raw: string, context: ApiDemoInvokeContext): GetConversationOptions {
    const parsed: Object = this.parseJson(raw)
    const options: GetConversationOptions = new GetConversationOptions()
    options.count = this.pickNumber(parsed, 'count', this.toNumber(this.getCommonValue(context, 'count')))
    options.time = this.pickNumber(parsed, 'time', this.toNumber(this.getCommonValue(context, 'time')))
    options.direction = this.pickNumber(parsed, 'direction', this.toNumber(this.getCommonValue(context, 'direction'))) as GetConversationDirection
    options.conversationTypes = this.parseNumberArray(this.pickString(parsed, 'conversationTypesJson', '[]'))
    options.tagId = this.pickString(parsed, 'tagId', this.getCommonValue(context, 'tagId'))
    return options
  }

  private parseGetMessageOptions(raw: string, context: ApiDemoInvokeContext): GetMessageOptions {
    const parsed: Object = this.parseJson(raw)
    const options: GetMessageOptions = new GetMessageOptions()
    options.count = this.pickNumber(parsed, 'count', this.toNumber(this.getCommonValue(context, 'count')))
    options.time = this.pickNumber(parsed, 'time', this.toNumber(this.getCommonValue(context, 'time')))
    options.direction = this.pickNumber(parsed, 'direction', this.toNumber(this.getCommonValue(context, 'direction'))) as GetMessageDirection
    options.contentTypes = this.parseStringArray(this.pickString(parsed, 'contentTypesJson', this.getCommonValue(context, 'contentTypesJson')))
    return options
  }

  private parseMessageQueryOptions(raw: string, context: ApiDemoInvokeContext): MessageQueryOptions {
    const parsed: Object = this.parseJson(raw)
    const options: MessageQueryOptions = new MessageQueryOptions()
    options.searchContent = this.pickString(parsed, 'searchContent', this.getCommonValue(context, 'searchContent'))
    options.senderUserIds = this.parseStringArray(this.pickString(parsed, 'senderUserIdsJson', this.getCommonValue(context, 'userIdsJson')))
    options.contentTypes = this.parseStringArray(this.pickString(parsed, 'contentTypesJson', this.getCommonValue(context, 'contentTypesJson')))
    options.conversations = this.parseConversationArray(this.pickString(parsed, 'conversationsJson', this.getCommonValue(context, 'conversationIdsJson')), context)
    options.states = this.parseNumberArray(this.pickString(parsed, 'statesJson', '[]'))
    options.direction = this.pickNumber(parsed, 'direction', this.toNumber(this.getCommonValue(context, 'direction')))
    options.conversationTypes = this.parseNumberArray(this.pickString(parsed, 'conversationTypesJson', '[]'))
    return options
  }

  private parseSearchParams(raw: string, context: ApiDemoInvokeContext): SearchParams {
    const parsed: Object = this.parseJson(raw)
    const params: SearchParams = new SearchParams()
    params.keywords = this.pickString(parsed, 'keywords', this.getCommonValue(context, 'searchContent'))
    params.msgTypes = this.parseStringArray(this.pickString(parsed, 'msgTypesJson', this.getCommonValue(context, 'contentTypesJson')))
    params.startTime = this.pickNumber(parsed, 'startTime', this.toNumber(this.getCommonValue(context, 'startTime')))
    params.endTime = this.pickNumber(parsed, 'endTime', 0)
    params.count = this.pickNumber(parsed, 'count', this.toNumber(this.getCommonValue(context, 'count')))
    params.direction = this.pickNumber(parsed, 'direction', this.toNumber(this.getCommonValue(context, 'direction'))) as GetMessageDirection
    params.conver = this.parseConversation(this.pickString(parsed, 'conversationJson', ''), context)
    return params
  }

  private parseClearMsgOptions(raw: string, context: ApiDemoInvokeContext): ClearMsgOptions {
    const parsed: Object = this.parseJson(raw)
    const options: ClearMsgOptions = new ClearMsgOptions()
    options.cleanTime = this.pickNumber(parsed, 'cleanTime', this.toNumber(this.getCommonValue(context, 'cleanTime')))
    options.cleanScope = this.pickNumber(parsed, 'cleanScope', this.toNumber(this.getCommonValue(context, 'cleanScope')))
    options.senderId = this.pickString(parsed, 'senderId', this.getCommonValue(context, 'userId'))
    options.cleanTimeOffset = this.pickNumber(parsed, 'cleanTimeOffset', 0)
    return options
  }

  private parseGetFavoriteOption(raw: string, context: ApiDemoInvokeContext): GetFavoriteMessageOption {
    const parsed: Object = this.parseJson(raw)
    const option: GetFavoriteMessageOption = new GetFavoriteMessageOption()
    option.offset = this.pickString(parsed, 'offset', this.getCommonValue(context, 'offset'))
    option.count = this.pickNumber(parsed, 'count', this.toNumber(this.getCommonValue(context, 'count')))
    return option
  }

  private parseTimePeriods(raw: string): TimePeriod[] {
    const parsed: Object = this.parseJson(raw)
    const list: Object[] = Array.isArray(parsed) ? (parsed as Object[]) : []
    const periods: TimePeriod[] = []
    list.forEach((item) => {
      const period: TimePeriod = new TimePeriod()
      period.startTime = this.pickString(item, 'startTime', '')
      period.endTime = this.pickString(item, 'endTime', '')
      if (period.startTime != '' || period.endTime != '') {
        periods.push(period)
      }
    })
    return periods
  }

  private parseGetMomentOption(raw: string, context: ApiDemoInvokeContext): GetMomentOption {
    const parsed: Object = this.parseJson(raw)
    const option: GetMomentOption = new GetMomentOption()
    option.startTime = this.pickNumber(parsed, 'startTime', this.toNumber(this.getCommonValue(context, 'startTime')))
    option.count = this.pickNumber(parsed, 'count', this.toNumber(this.getCommonValue(context, 'count')))
    option.direction = this.pickNumber(parsed, 'direction', 0) as number
    option.userId = this.pickString(parsed, 'userId', this.getCommonValue(context, 'userId'))
    return option
  }

  private parseGetMomentCommentOption(raw: string, context: ApiDemoInvokeContext): GetMomentCommentOption {
    const parsed: Object = this.parseJson(raw)
    const option: GetMomentCommentOption = new GetMomentCommentOption()
    option.momentId = this.pickString(parsed, 'momentId', this.getCommonValue(context, 'momentId'))
    option.startTime = this.pickNumber(parsed, 'startTime', this.toNumber(this.getCommonValue(context, 'startTime')))
    option.count = this.pickNumber(parsed, 'count', this.toNumber(this.getCommonValue(context, 'count')))
    option.direction = this.pickNumber(parsed, 'direction', 0) as number
    return option
  }

  private parseMomentMediaArray(raw: string): MomentMedia[] {
    const parsed: Object = this.parseJson(raw)
    const list: Object[] = Array.isArray(parsed) ? (parsed as Object[]) : []
    const items: MomentMedia[] = []
    list.forEach((item) => {
      const media: MomentMedia = new MomentMedia()
      media.url = this.pickString(item, 'url', '')
      media.snapshotUrl = this.pickString(item, 'snapshotUrl', '')
      media.type = this.pickNumber(item, 'type', 0) as number
      media.height = this.pickNumber(item, 'height', 0)
      media.width = this.pickNumber(item, 'width', 0)
      media.duration = this.pickNumber(item, 'duration', 0)
      if (media.url != '') {
        items.push(media)
      }
    })
    return items
  }

  private parsePushData(raw: string): PushData {
    const parsed: Object = this.parseJson(raw)
    const pushData: PushData = new PushData()
    pushData.title = this.pickString(parsed, 'title', '')
    pushData.content = this.pickString(parsed, 'content', '')
    pushData.extra = this.pickString(parsed, 'extra', '')
    return pushData
  }

  private parseMessageMentionInfo(raw: string): MessageMentionInfo {
    const parsed: Object = this.parseJson(raw)
    const mentionInfo: MessageMentionInfo = new MessageMentionInfo()
    mentionInfo.mentionType = this.pickNumber(parsed, 'mentionType', 0) as number
    mentionInfo.targetUsers = this.parseUserInfoArray(this.pickString(parsed, 'targetUsersJson', '[]'))
    return mentionInfo
  }

  private parseUserInfo(raw: string): UserInfo {
    const parsed: Object = this.parseJson(raw)
    const userInfo: UserInfo = new UserInfo()
    userInfo.userId = this.pickString(parsed, 'userId', '')
    userInfo.nickname = this.pickString(parsed, 'nickname', '')
    userInfo.userPortrait = this.pickString(parsed, 'userPortrait', '')
    userInfo.userType = this.pickNumber(parsed, 'userType', 0)
    userInfo.updTime = this.pickNumber(parsed, 'updTime', 0)
    return userInfo
  }

  private parseUserInfoArray(raw: string): UserInfo[] {
    const parsed: Object = this.parseJson(raw)
    const list: Object[] = Array.isArray(parsed) ? (parsed as Object[]) : []
    const items: UserInfo[] = []
    list.forEach((item) => {
      items.push(this.parseUserInfo(JSON.stringify(item)))
    })
    return items
  }

  private parseGroupInfo(raw: string): GroupInfo {
    const parsed: Object = this.parseJson(raw)
    const groupInfo: GroupInfo = new GroupInfo()
    groupInfo.groupId = this.pickString(parsed, 'groupId', '')
    groupInfo.groupName = this.pickString(parsed, 'groupName', '')
    groupInfo.groupPortrait = this.pickString(parsed, 'groupPortrait', '')
    groupInfo.updTime = this.pickNumber(parsed, 'updTime', 0)
    return groupInfo
  }

  private parseGroupMember(raw: string): GroupMember {
    const parsed: Object = this.parseJson(raw)
    const member: GroupMember = new GroupMember()
    member.groupId = this.pickString(parsed, 'groupId', '')
    member.memberId = this.pickString(parsed, 'memberId', '')
    member.displayName = this.pickString(parsed, 'displayName', '')
    return member
  }

  private parseFriendInfo(raw: string): FriendInfo {
    const parsed: Object = this.parseJson(raw)
    const friendInfo: FriendInfo = new FriendInfo()
    friendInfo.userId = this.pickString(parsed, 'userId', '')
    friendInfo.isFriend = this.toBoolean(this.pickString(parsed, 'isFriend', 'false'))
    friendInfo.alias = this.pickString(parsed, 'alias', '')
    friendInfo.updTime = this.pickNumber(parsed, 'updTime', 0)
    return friendInfo
  }

  private buildMessageFromClientMsgNo(raw: string, context: ApiDemoInvokeContext): Message | undefined {
    const clientMsgNo: number = this.toNumber(raw)
    if (clientMsgNo <= 0) {
      const fallback: number = this.toNumber(this.getCommonValue(context, 'clientMsgNo'))
      if (fallback <= 0) {
        return undefined
      }
      const list: Message[] = JuggleIm.instance.getMessageManager().getMessagesByClientMsgNos([fallback])
      return list.length > 0 ? list[0] : undefined
    }
    const messages: Message[] = JuggleIm.instance.getMessageManager().getMessagesByClientMsgNos([clientMsgNo])
    return messages.length > 0 ? messages[0] : undefined
  }

  private resolveCustomMessageType(raw: string, context: ApiDemoInvokeContext): string {
    const text: string = raw.trim()
    if (text != '') {
      return text
    }
    const fallback: string = this.getCommonValue(context, 'messageType')
    return fallback.trim() == '' ? 'jg:demo_custom' : fallback
  }

  private pickString(source: Object, key: string, defaultValue: string): string {
    const value: ApiValue = this.readJsonValue(source, key)
    if (value == undefined || value == null) {
      return defaultValue
    }
    return `${value}`
  }

  private pickNumber(source: Object, key: string, defaultValue: number): number {
    const value: ApiValue = this.readJsonValue(source, key)
    if (value == undefined || value == null) {
      return defaultValue
    }
    const num: number = Number(`${value}`)
    return isNaN(num) ? defaultValue : num
  }

  private readJsonValue(source: Object, key: string): ApiValue {
    return Reflect.get(source, key) as ApiValue
  }
}
