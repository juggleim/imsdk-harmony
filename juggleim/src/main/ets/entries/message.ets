import { JimUtil } from '../commons/jimutil'
import { MsgFlag, MsgFlagTool } from '../improto/msgflag'
import {UserInfo} from './user'
import { Conversation } from './conversation'
import { GroupInfo } from './group'

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

  decode(data:Uint8Array){
  }
}

export class Message{
  conversation:Conversation = new Conversation('',0)
  clientId:string = ''
  messageId:string = ''
  msgType:string = ''
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
  searchContent:string = ''
  referMsgId:string = ''

  state:number = MessageSentState.none

  constructor() {
  }
}

export class TextMessage extends MessageContent{
  public content:string = ''
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType("jg:text")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage = true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      "content":this.content,
      "extra":this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as TextMessage
    this.content = t.content
    this.extra = t.extra
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
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType("jg:merge")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage = true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      "title":this.title,
      "messageIdList":this.messageIdList,
      "previewList":this.previewList,
      "extra":this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as MergeMessage
    this.title = t.title
    this.messageIdList = t.messageIdList
    this.conversation = t.conversation
    this.previewList = t.previewList
    this.extra = t.extra
  }
}

export class VoiceMessage extends MessageContent{
  public url:string = ''
  public type:string = ''
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
    let str = JSON.stringify({
      "url":this.url,
      "type":this.type,
      "duration":this.duration,
      "extra":this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as VoiceMessage
    this.url = t.url
    this.type = t.type
    this.duration = t.duration
    this.extra = t.extra
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
    let str = JSON.stringify({
      "url":this.url,
      "thumbnail":this.thumbnail,
      "height":this.height,
      "width":this.width,
      "size":this.size,
      "extra":this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as ImageMessage
    this.url = t.url
    this.thumbnail = t.thumbnail
    this.height = t.height
    this.width = t.width
    this.size = t.size
    this.extra = t.extra
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
    let str = JSON.stringify({
      "name":this.name,
      "url":this.url,
      "size":this.size,
      "type":this.type,
      "extra":this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as FileMessage
    this.name = t.name
    this.url = t.url
    this.size = t.size
    this.type = t.type
    this.extra = t.extra
  }
}

export class VideoMessage extends MessageContent{
  url:string=''
  snapshotUrl:string=''
  height:number=0
  width:number=0
  size:number = 0
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
    let str = JSON.stringify({
      "url":this.url,
      "snapshotUrl":this.snapshotUrl,
      "height":this.height,
      "width":this.width,
      "size":this.size,
      "duration":this.duration,
      "extra":this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as VideoMessage
    this.url = t.url
    this.snapshotUrl = t.snapshotUrl
    this.height = t.height
    this.width = t.width
    this.size = t.size
    this.duration = t.duration
    this.extra = t.extra
  }
}

export class RecallInfoMessage extends MessageContent{
  exts:Map<string,string> = new Map()
  constructor() {
    super()
    this.setMsgType("jg:recallinfo")
    let msgFlag = new MsgFlag()
    msgFlag.isStorage=true
    msgFlag.isCount = true
    this.setMsgFlag(msgFlag)
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      "exts":JimUtil.map2Obj(this.exts)
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as RecallInfoMessage
    this.exts = JimUtil.obj2Map(t.exts)
  }
}