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
  constructor() {
    this.msgType = "jg:unknown"
  }

  getMsgType():string{
    return this.msgType
  }

  protected setMsgType(msgType:string){
    this.msgType = msgType
  }

  getFlag():MsgFlag{
    let msgFlag = new MsgFlag()
    msgFlag.isCount = true
    msgFlag.isStorage = true
    return msgFlag
  }

  encode():Uint8Array{
    return JimUtil.stringToUint8Array('')
  }

  decode(data:Uint8Array):MessageContent{
    return new MessageContent()
  }
}

export class Message{
  conversation:Conversation
  conversationTitle:string=''
  conversationPortrait:string=''
  conversationExts:string = ''

  localMsgId:string = ''
  messageId:string = ''
  msgType:string = ''
  msgContent:MessageContent = new MessageContent()
  sentTime:number = 0
  msgSeqNo:number = 0
  sender?:UserInfo

  sentState:number = MessageSentState.none

  constructor(conver:Conversation) {
    this.conversation = conver
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
    this.content = content
    this.extra = extra
  }

  encode():Uint8Array{
    let str = JSON.stringify(this)
    return JimUtil.stringToUint8Array(str)
  }

  decode(data:Uint8Array):TextMessage{
    let txtMsg = new TextMessage("","")
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as TextMessage
    return t
  }
}