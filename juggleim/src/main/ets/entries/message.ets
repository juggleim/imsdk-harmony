import { JimUtil, StringMapItem } from '../commons/jimutil'
import { MsgFlag, MsgFlagTool } from '../improto/msgflag'
import { Conversation } from './conversation'
import { JimMsgType } from './msgtypes'
import { MessageMentionInfo, PushData } from './messageoptions'

/**
 * Represents Message Sent State.
 *
 * Example:
 * ```ts
 * const state = MessageSentState.success
 * ```
 */
export class MessageSentState{
  static none:number = 0
  static sending:number = 1
  static success:number = 2
  static failed:number = 3
  static uploading:number = 4
}

/**
 * Represents Media Message Upload State.
 *
 * Example:
 * ```ts
 * const state = MediaMessageUploadState.success
 * ```
 */
export class MediaMessageUploadState{
  static none:number = 0
  static pending:number = 1
  static uploading:number = 2
  static success:number = 3
  static failed:number = 4
  static canceled:number = 5
}

/**
 * Represents Message Reaction.
 *
 * Example:
 * ```ts
 * const value = new MessageReaction()
 * ```
 */
export class MessageReaction{
  reactionId:string = ''
  userIds:string[] = []
  count:number = 0
  isSelected:boolean = false

  constructor() {
  }
}

/**
 * Represents Message Reaction Result.
 *
 * Example:
 * ```ts
 * const value = new MessageReactionResult()
 * ```
 */
export class MessageReactionResult{
  messageId:string = ''
  clientId:string = ''
  reactions:MessageReaction[] = []

  constructor() {
  }
}

/**
 * Represents Favorite Message.
 *
 * Example:
 * ```ts
 * const value = new FavoriteMessage()
 * ```
 */
export class FavoriteMessage{
  message:Message | null = null
  createdTime:number = 0

  constructor() {
  }
}

/**
 * Represents Message Content.
 *
 * Example:
 * ```ts
 * const value = new MessageContent()
 * ```
 */
export class MessageContent{
  private msgType:string
  private msgFlag:MsgFlag
  constructor() {
    this.msgType = "jg:unknown"
    this.msgFlag = new MsgFlag()
  }

  getMsgType():string{
    return this.msgType
  }

  protected setMsgType(msgType:string){
    this.msgType = msgType
  }

  protected setMsgFlag(msgFlag:MsgFlag){
    this.msgFlag = msgFlag
  }

  getFlag():MsgFlag{
    return this.msgFlag
  }

  getFlagNumber():number{
    return MsgFlagTool.toFlag(this.msgFlag)
  }

  encode():Uint8Array{
    return JimUtil.stringToUint8Array('')
  }

  decode(data:Uint8Array){
  }
}

class MediaMessagePayload{
  local:string = ''
  localPath:string = ''
  url:string = ''
  extra:string = ''
  uploadState:number = MediaMessageUploadState.none
  uploadProgress:number = 0
  type:string = ''
  duration:number = 0
  thumbnail:string = ''
  height:number = 0
  width:number = 0
  size:number = 0
  name:string = ''
  poster:string = ''
  constructor() {
  }
}

/**
 * Represents Media Message Content.
 *
 * Example:
 * ```ts
 * const value = new MediaMessageContent()
 * ```
 */
export class MediaMessageContent extends MessageContent{
  public localPath:string = ''
  public url:string = ''
  public extra:string = ''
  public uploadState:number = MediaMessageUploadState.none
  public uploadProgress:number = 0

  constructor() {
    super()
  }

  setUploadState(uploadState:number, uploadProgress:number = this.uploadProgress):void{
    this.uploadState = uploadState
    this.uploadProgress = uploadProgress
  }

  protected encodeMediaPayload(payload:MediaMessagePayload):Uint8Array{
    payload.local = this.localPath
    payload.localPath = this.localPath
    payload.url = this.url
    payload.extra = this.extra
    payload.uploadState = this.uploadState
    payload.uploadProgress = this.uploadProgress
    let str = JSON.stringify(payload)
    return JimUtil.stringToUint8Array(str)
  }

  protected decodeMediaPayload(data:Uint8Array):MediaMessagePayload{
    let str = JimUtil.uint8ArrayToString(data)
    let dataObj = JSON.parse(str) as MediaMessagePayload
    let payload = new MediaMessagePayload()
    payload.local = dataObj.local != undefined ? dataObj.local : ''
    payload.localPath = dataObj.localPath != undefined ? dataObj.localPath : payload.local
    payload.url = dataObj.url != undefined ? dataObj.url : ''
    payload.extra = dataObj.extra != undefined ? dataObj.extra : ''
    payload.uploadState = dataObj.uploadState != undefined ? dataObj.uploadState : MediaMessageUploadState.none
    payload.uploadProgress = dataObj.uploadProgress != undefined ? dataObj.uploadProgress : 0
    payload.type = dataObj.type != undefined ? dataObj.type : ''
    payload.duration = dataObj.duration != undefined ? dataObj.duration : 0
    payload.thumbnail = dataObj.thumbnail != undefined ? dataObj.thumbnail : ''
    payload.height = dataObj.height != undefined ? dataObj.height : 0
    payload.width = dataObj.width != undefined ? dataObj.width : 0
    payload.size = dataObj.size != undefined ? dataObj.size : 0
    payload.name = dataObj.name != undefined ? dataObj.name : ''
    payload.poster = dataObj.poster != undefined ? dataObj.poster : ''
    this.localPath = payload.localPath
    this.url = payload.url
    this.extra = payload.extra
    this.uploadProgress = payload.uploadProgress
    this.uploadState = this.normalizeUploadState(payload.uploadState)
    return payload
  }

  private normalizeUploadState(uploadState:number|undefined):number{
    if(uploadState != undefined){
      return uploadState
    }
    if(this.url != ''){
      return MediaMessageUploadState.success
    }
    if(this.localPath != ''){
      return MediaMessageUploadState.pending
    }
    return MediaMessageUploadState.none
  }
}

/**
 * Represents Message.
 *
 * Example:
 * ```ts
 * const value = new Message()
 * ```
 */
export class Message{
  clientMsgNo:number = 0
  conversation:Conversation = new Conversation('',0,'')
  clientId:string = ''
  messageId:string = ''
  // msgType:string = ''
  msgContent:MessageContent = new MessageContent()
  sentTime:number = 0
  msgSeqNo:number = 0
  msgUnreadIndex:number = 0
  senderId:string = ''
  direction:number = 0
  flags:number = 0
  hasRead:boolean = false
  readCount:number = 0
  memberCount:number = 0
  isDeleted:boolean = false
  isEdit:boolean = false
  searchContent:string = ''
  localAttribute:string = ''
  referMsgId:string = ''
  referredMessage:Message | null = null
  mentionInfo?:MessageMentionInfo
  pushData?:PushData
  reactions:MessageReaction[] = []
  lifeTime:number = 0
  lifeTimeAfterRead:number = 0
  destroyTime:number = 0
  readTime:number = 0

  state:number = MessageSentState.none

  constructor() {
  }
}

interface ITextMessage{
  content:string
  extra:string
}

/**
 * Represents Text Message.
 *
 * Example:
 * ```ts
 * const value = new TextMessage()
 * ```
 */
export class TextMessage extends MessageContent{
  public content:string = ''
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType(JimMsgType.Text)
    this.setMsgFlag(MsgFlagTool.storageCountFlag())
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      content:this.content,
      extra:this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as ITextMessage
    this.content = t.content
    this.extra = t.extra
  }
}

/**
 * Represents Preview Unit.
 *
 * Example:
 * ```ts
 * const value = new PreviewUnit()
 * ```
 */
export class PreviewUnit{
  public content:string
  public senderName:string
  constructor(content:string,senderName:string) {
    this.content = content
    this.senderName = senderName
  }
}

interface IMergeMessage{
  title:string
  containerMsgId?:string
  conversationId?:string
  conversationType?:number
  sub_channel?:string
  messageIdList:string[]
  previewList:PreviewUnit[]
  extra:string
}

/**
 * Represents Merge Message.
 *
 * Example:
 * ```ts
 * const value = new MergeMessage()
 * ```
 */
export class MergeMessage extends  MessageContent{
  public title:string = ''
  public containerMsgId:string = ''
  public conversation:Conversation = new Conversation("",0,'')
  public messageIdList:string[] = []
  public previewList:PreviewUnit[] = []
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType(JimMsgType.Merge)
    this.setMsgFlag(MsgFlagTool.storageCountFlag())
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      title:this.title,
      containerMsgId:this.containerMsgId,
      conversationId:this.conversation.conversationId,
      conversationType:this.conversation.conversationType,
      sub_channel:Conversation.normalizeSubChannel(this.conversation.subChannel),
      messageIdList:this.messageIdList,
      previewList:this.previewList,
      extra:this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IMergeMessage
    this.title = t.title
    this.messageIdList = t.messageIdList != undefined ? t.messageIdList : []
    this.containerMsgId = t.containerMsgId != undefined ? t.containerMsgId : ''
    if(t.conversationId != undefined && t.conversationType != undefined){
      this.conversation = new Conversation(
        t.conversationId,
        t.conversationType,
        Conversation.normalizeSubChannel(t.sub_channel)
      )
    }else{
      this.conversation = new Conversation("",0,'')
    }
    this.previewList = t.previewList != undefined ? t.previewList : []
    this.extra = t.extra != undefined ? t.extra : ''
  }
}

interface IVoiceMessage{
  type:string
  duration:number
}
/**
 * Represents Voice Message.
 *
 * Example:
 * ```ts
 * const value = new VoiceMessage()
 * ```
 */
export class VoiceMessage extends MediaMessageContent{
  public type:string = ''
  public duration:number = 0
  constructor() {
    super()
    this.setMsgType(JimMsgType.Voice)
    this.setMsgFlag(MsgFlagTool.storageCountFlag())
  }

  encode():Uint8Array{
    let payload = new MediaMessagePayload()
    payload.type = this.type
    payload.duration = this.duration
    return this.encodeMediaPayload(payload)
  }

  decode(data:Uint8Array){
    let t = this.decodeMediaPayload(data) as IVoiceMessage
    this.type = t.type
    this.duration = t.duration
  }
}

interface IImageMessage{
  thumbnail:string
  height:number
  width:number
  size:number
}

/**
 * Represents Image Message.
 *
 * Example:
 * ```ts
 * const value = new ImageMessage()
 * ```
 */
export class ImageMessage extends MediaMessageContent{
  thumbnail:string=''
  height:number=0
  width:number=0
  size:number=0
  constructor() {
    super()
    this.setMsgType(JimMsgType.Image)
    this.setMsgFlag(MsgFlagTool.storageCountFlag())
  }

  encode():Uint8Array{
    let payload = new MediaMessagePayload()
    payload.thumbnail = this.thumbnail
    payload.height = this.height
    payload.width = this.width
    payload.size = this.size
    return this.encodeMediaPayload(payload)
  }

  decode(data:Uint8Array){
    let t = this.decodeMediaPayload(data) as IImageMessage
    this.thumbnail = t.thumbnail
    this.height = t.height
    this.width = t.width
    this.size = t.size
  }
}

interface IFileMessage{
  name:string
  size:number
  type:string
}

/**
 * Represents File Message.
 *
 * Example:
 * ```ts
 * const value = new FileMessage()
 * ```
 */
export class FileMessage extends MediaMessageContent{
  name:string=''
  size:number=0
  type:string=''
  constructor() {
    super()
    this.setMsgType(JimMsgType.File)
    this.setMsgFlag(MsgFlagTool.storageCountFlag())
  }

  encode():Uint8Array{
    let payload = new MediaMessagePayload()
    payload.name = this.name
    payload.size = this.size
    payload.type = this.type
    return this.encodeMediaPayload(payload)
  }

  decode(data:Uint8Array){
    let t = this.decodeMediaPayload(data) as IFileMessage
    this.name = t.name
    this.size = t.size
    this.type = t.type
  }
}

interface IVideoMessage{
  poster:string
  height:number
  width:number
  size:number
  duration:number
}

/**
 * Represents Video Message.
 *
 * Example:
 * ```ts
 * const value = new VideoMessage()
 * ```
 */
export class VideoMessage extends MediaMessageContent{
  poster:string=''
  height:number=0
  width:number=0
  size:number = 0
  duration:number=0
  constructor() {
    super()
    this.setMsgType(JimMsgType.Video)
    this.setMsgFlag(MsgFlagTool.storageCountFlag())
  }

  encode():Uint8Array{
    let payload = new MediaMessagePayload()
    payload.poster = this.poster
    payload.height = this.height
    payload.width = this.width
    payload.size = this.size
    payload.duration = this.duration
    return this.encodeMediaPayload(payload)
  }

  decode(data:Uint8Array){
    let t = this.decodeMediaPayload(data) as IVideoMessage
    this.poster = t.poster
    this.height = t.height
    this.width = t.width
    this.size = t.size
    this.duration = t.duration
  }
}

interface IRecallInfoMessage{
  exts:StringMapItem[]
}

/**
 * Represents Recall Info Message.
 *
 * Example:
 * ```ts
 * const value = new RecallInfoMessage()
 * ```
 */
export class RecallInfoMessage extends MessageContent{
  exts:Map<string,string> = new Map()
  constructor() {
    super()
    this.setMsgType(JimMsgType.RecallInfo)
    this.setMsgFlag(MsgFlagTool.storageCountFlag())
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      "exts":JimUtil.map2Obj(this.exts)
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IRecallInfoMessage
    this.exts = JimUtil.obj2Map(t.exts)
  }
}
