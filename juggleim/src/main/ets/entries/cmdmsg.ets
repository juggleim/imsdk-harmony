import {MessageContent, MessageReaction} from './message'
import { MsgFlag } from '../improto/msgflag'
import { JimUtil } from '../commons/jimutil'
import { JimMsgType } from './msgtypes'
import { GroupMessageReadInfo } from './group'

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
    this.setMsgType(JimMsgType.RecallCmd)
    this.setMsgFlag({isCmd:true})
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
    this.setMsgType(JimMsgType.ReadNtf)
    this.setMsgFlag({isCmd:true})
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

interface IGroupReadNtfMsg{
  msg_id:string
  read_count:number
  member_count:number
}

interface IGroupReadNtfMessage{
  msgs:IGroupReadNtfMsg[]
}

export class GroupReadNtfMessage extends MessageContent{
  messages:Map<string, GroupMessageReadInfo> = new Map()
  constructor() {
    super()
    this.setMsgType(JimMsgType.GroupReadNtf)
    this.setMsgFlag({isCmd:true})
  }

  encode(): Uint8Array {
    let msgs:IGroupReadNtfMsg[] = []
    this.messages.forEach((info, msgId)=>{
      msgs.push({
        msg_id:msgId,
        read_count:info.readCount,
        member_count:info.memberCount
      })
    })
    let str = JSON.stringify({
      msgs:msgs
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IGroupReadNtfMessage
    let messages:Map<string, GroupMessageReadInfo> = new Map()
    t.msgs.forEach((item)=>{
      if(item.msg_id == ''){
        return
      }
      let info = new GroupMessageReadInfo()
      info.readCount = item.read_count
      info.memberCount = item.member_count
      messages.set(item.msg_id, info)
    })
    this.messages = messages
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
    this.setMsgType(JimMsgType.ClearUnread)
    this.setMsgFlag({isCmd:true})
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

interface IModifyMessage{
  msg_type:string
  msg_id:string
  msg_time:number
  msg_seq:number
  msg_content:Uint8Array
}

export class ModifyMessage extends MessageContent{
  newMsgType:string = ''
  msgId:string = ''
  msgTime:number = 0
  msgSeq:number = 0
  newMsgContent:Uint8Array = JimUtil.stringToUint8Array('')

  constructor() {
    super()
    this.setMsgType(JimMsgType.ModifyMsg)
    this.setMsgFlag({isCmd:true})
  }

  encode(): Uint8Array {
    let str = JSON.stringify({
      msg_type:this.newMsgType,
      msg_id:this.msgId,
      msg_time:this.msgTime,
      msg_seq:this.msgSeq,
      msg_content:this.newMsgContent
    })
    return JimUtil.stringToUint8Array(str)
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let t = JSON.parse(str) as IModifyMessage
    this.newMsgType = t.msg_type
    this.msgId = t.msg_id
    this.msgTime = t.msg_time
    this.msgSeq = t.msg_seq
    this.newMsgContent = t.msg_content
  }
}

interface IMsgExSetUser{
  user_id:string
}

interface IMsgExSetItem{
  is_del:number
  key:string
  user?:IMsgExSetUser
}

interface IMsgExSetPayload{
  msg_id:string
  exts:IMsgExSetItem[]
}

export class MsgExSetMessage extends MessageContent{
  originalMessageId:string = ''
  addReactions:MessageReaction[] = []
  removeReactions:MessageReaction[] = []

  constructor() {
    super()
    this.setMsgType(JimMsgType.MsgExSet)
  }

  encode(): Uint8Array {
    return JimUtil.stringToUint8Array('')
  }

  decode(data: Uint8Array): void {
    let str = JimUtil.uint8ArrayToString(data)
    let payload = JSON.parse(str) as IMsgExSetPayload
    this.originalMessageId = payload.msg_id
    let addReactionMap:Map<string, string[]> = new Map()
    let removeReactionMap:Map<string, string[]> = new Map()
    payload.exts.forEach((item)=>{
      let reactionId = item.key != undefined ? item.key.trim() : ''
      let userId = item.user != undefined ? item.user.user_id.trim() : ''
      if(reactionId == '' || userId == ''){
        return
      }
      let targetMap = item.is_del != 0 ? removeReactionMap : addReactionMap
      let userIds = targetMap.get(reactionId)
      if(userIds == undefined){
        userIds = []
      }
      if(userIds.indexOf(userId) < 0){
        userIds.push(userId)
      }
      targetMap.set(reactionId, userIds)
    })
    this.addReactions = this.buildReactionList(addReactionMap)
    this.removeReactions = this.buildReactionList(removeReactionMap)
  }

  private buildReactionList(reactionMap:Map<string, string[]>):MessageReaction[]{
    let reactions:MessageReaction[] = []
    reactionMap.forEach((userIds, reactionId)=>{
      let reaction = new MessageReaction()
      reaction.reactionId = reactionId
      reaction.userIds = userIds.slice()
      reaction.count = reaction.userIds.length
      reactions.push(reaction)
    })
    return reactions
  }
}
