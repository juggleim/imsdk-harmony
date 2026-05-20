import {
  Conversation,
  FileMessage,
  ImageMessage,
  JuggleIm,
  JimMsgType,
  MergeMessage,
  Message,
  MessageContent,
  TextMessage,
  VideoMessage,
  VoiceMessage
} from 'juggleim'

@Observed
class MessageViewItem{
  conversation:Conversation
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

  isReceived:boolean = true
  msgTime:number = 0

  constructor(message:Message,senderName:string,senderIcon:string,selfName:string,selfIcon:string) {
    this.conversation = message.conversation
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
    this.previewText = buildMessagePreview(message.msgContent)
    if(message.referredMessage != null){
      this.referenceText = buildMessagePreview(message.referredMessage.msgContent)
    }
  }
}

export function isDisplayableMessage(message:Message):boolean{
  let msgType = message.msgContent.getMsgType()
  return msgType != JimMsgType.ReadNtf &&
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
    target.url = source.url
    target.thumbnail = source.thumbnail
    target.height = source.height
    target.width = source.width
    target.size = source.size
    target.extra = source.extra
    return target
  }
  if(msgType == JimMsgType.File){
    let source = msgContent as FileMessage
    let target = new FileMessage()
    target.name = source.name
    target.url = source.url
    target.size = source.size
    target.type = source.type
    target.extra = source.extra
    return target
  }
  if(msgType == JimMsgType.Video){
    let source = msgContent as VideoMessage
    let target = new VideoMessage()
    target.url = source.url
    target.poster = source.poster
    target.height = source.height
    target.width = source.width
    target.size = source.size
    target.duration = source.duration
    target.extra = source.extra
    return target
  }
  if(msgType == JimMsgType.Voice){
    let source = msgContent as VoiceMessage
    let target = new VoiceMessage()
    target.url = source.url
    target.type = source.type
    target.duration = source.duration
    target.extra = source.extra
    return target
  }
  return null
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
