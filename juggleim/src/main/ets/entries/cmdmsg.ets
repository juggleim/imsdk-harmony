import {MessageContent} from './message'
import { MsgFlag } from '../improto/msgflag'
import { JimUtil } from '../commons/jimutil'

interface IRecallCmdMessage{
  msg_id:string
  msg_time:number
  exts:Map<string,string>
}

export class RecallCmdMessage extends MessageContent{
  msgId:string = ''
  msgTime:number = 0
  exts:Map<string,string> = new Map()
  constructor() {
    super()
    this.setMsgType("jg:recall")
    let msgFlag = new MsgFlag()
    msgFlag.isCmd = true
    this.setMsgFlag(msgFlag)
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      msg_id:this.msgId,
      msg_time:this.msgTime,
      exts:JimUtil.map2Obj(this.exts)
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IRecallCmdMessage
    this.msgId = t.msg_id
    this.msgTime = t.msg_time
    this.exts = JimUtil.obj2Map(t.exts)
  }
}

export interface IReadMsg{
  msg_id:string
  msg_index:number
}

export interface  IIndexScope{
  start_index:number
  end_index:number
}

interface IReadNtfMessage{
  msgs:IReadMsg[]
  index_scopes:IIndexScope[]
}

export class ReadNtfMessage extends MessageContent{
  msgs:IReadMsg[] = []
  indexScopes:IIndexScope[] = []
  constructor() {
    super()
    this.setMsgType("jg:readntf")
    let msgFlag = new MsgFlag()
    msgFlag.isCmd = true
    this.setMsgFlag(msgFlag)
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      msgs:this.msgs,
      index_scopes:this.indexScopes
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IReadNtfMessage
    this.msgs = t.msgs
    this.indexScopes = t.index_scopes
  }
}

export interface IClearUnreadConver{
  target_id:string
  channel_type:number
  latest_read_index:number
}

interface IClearUnreadMessage{
  conversations:IClearUnreadConver[]
}

export class ClearUnreadMessage extends  MessageContent{
  conversations:IClearUnreadConver[] = []
  constructor() {
    super()
    this.setMsgType("jg:clearunread")
    let msgFlag = new MsgFlag()
    msgFlag.isCmd = true
    this.setMsgFlag(msgFlag)
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      conversations:this.conversations
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IClearUnreadMessage
    this.conversations = t.conversations
  }
}