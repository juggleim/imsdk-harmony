import { JimUtil } from '../commons/jimutil'
import { MsgFlag, MsgFlagTool } from '../improto/msgflag'
import { Conversation } from './conversation'
import { JimMsgType } from './msgtypes'

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
    this.msgFlag = {}
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

interface ITextMessage{
  content:string
  extra:string
}

export class TextMessage extends MessageContent{
  public content:string = ''
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType(JimMsgType.Text)
    this.setMsgFlag({isStorage:true,isCount:true})
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
  conversation:Conversation
  messageIdList:string[]
  previewList:PreviewUnit[]
  extra:string
}

export class MergeMessage extends  MessageContent{
  public title:string = ''
  public conversation:Conversation = new Conversation("",0)
  public messageIdList:string[] = []
  public previewList:PreviewUnit[] = []
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType(JimMsgType.Merge)
    this.setMsgFlag({isStorage:true,isCount:true})
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      title:this.title,
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
    this.messageIdList = t.messageIdList
    this.conversation = t.conversation
    this.previewList = t.previewList
    this.extra = t.extra
  }
}

interface IVoiceMessage{
  url:string
  type:string
  duration:number
  extra:string
}
export class VoiceMessage extends MessageContent{
  public url:string = ''
  public type:string = ''
  public duration:number = 0
  public extra:string = ''
  constructor() {
    super()
    this.setMsgType(JimMsgType.Voice)
    this.setMsgFlag({isStorage:true,isCount:true})
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      url:this.url,
      type:this.type,
      duration:this.duration,
      extra:this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IVoiceMessage
    this.url = t.url
    this.type = t.type
    this.duration = t.duration
    this.extra = t.extra
  }
}

interface IImageMessage{
  url:string
  thumbnail:string
  height:number
  width:number
  size:number
  extra:string
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
    this.setMsgType(JimMsgType.Image)
    this.setMsgFlag({isStorage:true,isCount:true})
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      url:this.url,
      thumbnail:this.thumbnail,
      height:this.height,
      width:this.width,
      size:this.size,
      extra:this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IImageMessage
    this.url = t.url
    this.thumbnail = t.thumbnail
    this.height = t.height
    this.width = t.width
    this.size = t.size
    this.extra = t.extra
  }
}

interface IFileMessage{
  name:string
  url:string
  size:number
  type:string
  extra:string
}

export class FileMessage extends MessageContent{
  name:string=''
  url:string=''
  size:number=0
  type:string=''
  extra:string=''
  constructor() {
    super()
    this.setMsgType(JimMsgType.File)
    this.setMsgFlag({isStorage:true,isCount:true})
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      name:this.name,
      url:this.url,
      size:this.size,
      type:this.type,
      extra:this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IFileMessage
    this.name = t.name
    this.url = t.url
    this.size = t.size
    this.type = t.type
    this.extra = t.extra
  }
}

interface IVideoMessage{
  url:string
  poster:string
  height:number
  width:number
  size:number
  duration:number
  extra:string
}

export class VideoMessage extends MessageContent{
  url:string=''
  poster:string=''
  height:number=0
  width:number=0
  size:number = 0
  duration:number=0
  extra:string=''
  constructor() {
    super()
    this.setMsgType(JimMsgType.Video)
    this.setMsgFlag({isStorage:true,isCount:true})
  }

  encode():Uint8Array{
    let str = JSON.stringify({
      url:this.url,
      poster:this.poster,
      height:this.height,
      width:this.width,
      size:this.size,
      duration:this.duration,
      extra:this.extra
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array){
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IVideoMessage
    this.url = t.url
    this.poster = t.poster
    this.height = t.height
    this.width = t.width
    this.size = t.size
    this.duration = t.duration
    this.extra = t.extra
  }
}

interface IRecallInfoMessage{
  exts:Map<string,string>
}

export class RecallInfoMessage extends MessageContent{
  exts:Map<string,string> = new Map()
  constructor() {
    super()
    this.setMsgType(JimMsgType.RecallInfo)
    this.setMsgFlag({isStorage:true,isCount:true})
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