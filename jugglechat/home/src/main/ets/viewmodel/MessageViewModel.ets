import {
  Conversation,
  FileMessage,
  ImageMessage,
  JuggleIm,
  JimMsgType,
  MediaMessageContent,
  MergeMessage,
  Message,
  MessageContent,
  MessageSentState,
  TextMessage,
  VideoMessage,
  VoiceMessage
} from 'juggleim'

export class MediaDownloadState {
  static readonly none:number = 0
  static readonly downloading:number = 1
  static readonly failed:number = 2
  static readonly canceled:number = 3
}

@Observed
class MessageViewItem{
  conversation:Conversation
  conversationType:number = 0
  messageId:string
  clientId:string
  senderId:string
  senderName:string
  senderIcon?:string
  selfName:string
  selfIcon:string
  msgContent?:MessageContent
  referenceText:string = ''
  previewText:string = ''
  msgType:string = JimMsgType.Unknown
  isEdited:boolean = false
  hasRead:boolean = false
  readCount:number = 0
  memberCount:number = 0
  sentState:number = MessageSentState.none
  downloadState:number = MediaDownloadState.none
  downloadProgress:number = 0

  isReceived:boolean = true
  msgTime:number = 0

  constructor(message:Message,senderName:string,senderIcon:string,selfName:string,selfIcon:string) {
    this.conversation = message.conversation
    this.conversationType = message.conversation.conversationType
    this.messageId = message.messageId
    this.clientId = message.clientId
    this.senderId = message.senderId
    this.senderName = senderName
    this.senderIcon = senderIcon
    this.selfName = selfName
    this.selfIcon = selfIcon
    this.msgContent = message.msgContent
    this.msgTime = message.sentTime
    this.msgType = message.msgContent.getMsgType()
    this.isEdited = message.isEdit
    this.hasRead = message.hasRead
    this.readCount = message.readCount
    this.memberCount = message.memberCount
    this.sentState = message.state
    this.previewText = buildMessagePreview(message.msgContent)
    if(message.referredMessage != null){
      this.referenceText = buildMessagePreview(message.referredMessage.msgContent)
    }
  }
}

export function isDisplayableMessage(message:Message):boolean{
  let msgType = message.msgContent.getMsgType()
  return msgType != JimMsgType.ReadNtf &&
    msgType != JimMsgType.GroupReadNtf &&
    msgType != JimMsgType.ClearUnread &&
    msgType != JimMsgType.ModifyMsg &&
    msgType != JimMsgType.RecallCmd
}

export function buildMessagePreview(msgContent?:MessageContent):string{
  if(msgContent == undefined){
    return 'Unknown'
  }
  let msgType = msgContent.getMsgType()
  if(msgType == JimMsgType.Text){
    return (msgContent as TextMessage).content
  }
  if(msgType == JimMsgType.Image){
    return '[图片]'
  }
  if(msgType == JimMsgType.File){
    let fileMsg = msgContent as FileMessage
    if(fileMsg.name != ''){
      return `[文件] ${fileMsg.name}`
    }
    return '[文件]'
  }
  if(msgType == JimMsgType.Video){
    return '[视频]'
  }
  if(msgType == JimMsgType.Voice){
    return '[语音]'
  }
  if(msgType == JimMsgType.Merge){
    let mergeMsg = msgContent as MergeMessage
    if(mergeMsg.title != ''){
      return `[聊天记录] ${mergeMsg.title}`
    }
    return '[聊天记录]'
  }
  if(msgType == JimMsgType.RecallInfo){
    return '[消息已撤回]'
  }
  if(msgType == JimMsgType.Unknown){
    return '[未知消息]'
  }
  return `[暂不支持: ${msgType}]`
}

export function cloneMessageContent(msgContent?:MessageContent):MessageContent|null{
  if(msgContent == undefined){
    return null
  }
  let msgType = msgContent.getMsgType()
  if(msgType == JimMsgType.Text){
    let source = msgContent as TextMessage
    let target = new TextMessage()
    target.content = source.content
    target.extra = source.extra
    return target
  }
  if(msgType == JimMsgType.Image){
    let source = msgContent as ImageMessage
    let target = new ImageMessage()
    copyMediaMessageFields(target, source)
    target.thumbnail = source.thumbnail
    target.height = source.height
    target.width = source.width
    target.size = source.size
    return target
  }
  if(msgType == JimMsgType.File){
    let source = msgContent as FileMessage
    let target = new FileMessage()
    copyMediaMessageFields(target, source)
    target.name = source.name
    target.size = source.size
    target.type = source.type
    return target
  }
  if(msgType == JimMsgType.Video){
    let source = msgContent as VideoMessage
    let target = new VideoMessage()
    copyMediaMessageFields(target, source)
    target.poster = source.poster
    target.height = source.height
    target.width = source.width
    target.size = source.size
    target.duration = source.duration
    return target
  }
  if(msgType == JimMsgType.Voice){
    let source = msgContent as VoiceMessage
    let target = new VoiceMessage()
    copyMediaMessageFields(target, source)
    target.type = source.type
    target.duration = source.duration
    return target
  }
  return null
}

function copyMediaMessageFields(target:MediaMessageContent, source:MediaMessageContent):void{
  target.localPath = source.localPath
  target.url = source.url
  target.extra = source.extra
  target.uploadState = source.uploadState
  target.uploadProgress = source.uploadProgress
}

export async function toMessageViewItem(message:Message):Promise<MessageViewItem>{
  let sender = await JuggleIm.instance.getUserInfoManager().getUserInfo(message.senderId)
  let selfUser = await JuggleIm.instance.getUserInfoManager().getUserInfo(JuggleIm.instance.userId)
  let viewMsg = new MessageViewItem(
    message,
    sender.nickname,
    sender.userPortrait,
    selfUser.nickname,
    selfUser.userPortrait
  )
  if(JuggleIm.instance.userId == message.senderId){
    viewMsg.isReceived = false
  }
  return viewMsg
}

export { MessageViewItem };
