import {MessageContent} from './message'
import { MsgFlag } from '../improto/msgflag'
import { JimUtil } from '../commons/jimutil'

export class RecallCmdMessage extends MessageContent{
  msg_id:string = ''
  msg_time:number = 0
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
      "msg_id":this.msg_id,
      "msg_time":this.msg_time,
      "exts":JimUtil.map2Obj(this.exts)
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as RecallCmdMessage
    this.msg_id = t.msg_id
    this.msg_time = t.msg_time
    this.exts = JimUtil.obj2Map(t.exts)
  }
}

export class ReadMsg{
  msg_id:string=''
  msg_index:number=0
  constructor() {
  }
}

export class IndexScope{
  start_index:number=0
  end_index:number=0
}

export class ReadNtfMessage extends MessageContent{
  msgs:ReadMsg[] = []
  index_scopes:IndexScope[] = []
  constructor() {
    super()
    this.setMsgType("jg:readntf")
    let msgFlag = new MsgFlag()
    msgFlag.isCmd = true
    this.setMsgFlag(msgFlag)
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      "msgs":this.msgs,
      "index_scopes":this.index_scopes
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as ReadNtfMessage
    this.msgs = t.msgs
    this.index_scopes = t.index_scopes
  }
}

export class ClearUnreadConver{
  target_id:string=''
  channel_type:number=0
  latest_read_index:number=0
  constructor() {
  }
}
export class ClearUnreadMessage extends  MessageContent{
  conversations:ClearUnreadConver[] = []
  constructor() {
    super()
    this.setMsgType("jg:clearunread")
    let msgFlag = new MsgFlag()
    msgFlag.isCmd = true
    this.setMsgFlag(msgFlag)
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      "conversations":this.conversations
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as ClearUnreadMessage
    this.conversations = t.conversations
  }
}