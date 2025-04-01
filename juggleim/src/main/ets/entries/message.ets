import { JimUtil } from '../commons/jimutil'
import { MsgFlag, MsgFlagTool } from '../improto/msgflag'
import {UserInfo} from './user'
import { JSON } from '@kit.ArkTS'
import { Conversation } from './conversation'

export class MessageSentState{
  static none:number = 0
  static sending:number = 1
  static success:number = 2
  static failed:number = 3
  static uploading:number = 4
}

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

  decode(data:Uint8Array):MessageContent{
    return new MessageContent()
  }
}

export class Message{
  conversation:Conversation = new Conversation('',0)
  conversationTitle:string=''
  conversationPortrait:string=''
  conversationExts:string = ''

  clientId:string = ''
  messageId:string = ''
  msgType:string = ''
  msgContent:MessageContent = new MessageContent()
  sentTime:number = 0
  msgSeqNo:number = 0
  msgIndex:number = 0
  senderId:string = ''
  sender?:UserInfo
  direction:number = 0
  flags:number = 0

  sentState:number = MessageSentState.none

  constructor() {
  }
}

// export interface ITextMessage{
//   content:string
//   extra:string
// }

export class TextMessage extends MessageContent{
  public content:string
  public extra:string
  constructor(content:string,extra:string) {
    super()
    this.setMsgType("jg:text")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage = true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
    this.content = content
    this.extra = extra
  }

  encode():Uint8Array{
    let str = JSON.stringify(this)
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array):TextMessage{
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as TextMessage
    return t
  }
}

export class PreviewUnit{
  public content:string
  public senderName:string
  constructor(content:string,senderName:string) {
    this.content = content
    this.senderName = senderName
  }
}

export class MergeMessage extends  MessageContent{
  public title:string = ''
  public conversation:Conversation = new Conversation("",0)
  public messageIdList:string[] = []
  public previewList:PreviewUnit[] = []
  constructor() {
    super()
    this.setMsgType("jg:merge")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage = true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode():Uint8Array{
    let str = JSON.stringify(this)
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array):MergeMessage{
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as MergeMessage
    return t
  }
}

export class VoiceMessage extends MessageContent{
  public url:string = ''
  public duration:number = 0
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType("jg:voice")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage = true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode():Uint8Array{
    let str = JSON.stringify(this)
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array):VoiceMessage{
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as VoiceMessage
    return t
  }
}

export class ImageMessage extends MessageContent{
  url:string = ''
  thumbnail:string=''
  height:number=0
  width:number=0
  size:number=0
  extra:string=''
  constructor() {
    super()
    this.setMsgType("jg:img")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage = true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode():Uint8Array{
    let str = JSON.stringify(this)
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array):ImageMessage{
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as ImageMessage
    return t
  }
}

export class FileMessage extends MessageContent{
  name:string=''
  url:string=''
  size:number=0
  type:string=''
  extra:string=''
  constructor() {
    super()
    this.setMsgType("jg:file")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage=true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode():Uint8Array{
    let str = JSON.stringify(this)
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array):FileMessage{
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as FileMessage
    return t
  }
}

export class VideoMessage extends MessageContent{
  url:string=''
  snapshotUrl:string=''
  height:number=0
  width:number=0
  duration:number=0
  extra:string=''
  constructor() {
    super()
    this.setMsgType("jg:video")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage=true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode():Uint8Array{
    let str = JSON.stringify(this)
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array):VideoMessage{
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as VideoMessage
    return t
  }
}