import { Message, MessageContent } from "../entries/message";
import { relationalStore } from "@kit.ArkData";
import { JimUtil } from "../commons/jimutil";
import { MsgFlagTool } from "../improto/msgflag";
import { JimDbManager } from "./dbmanager";
import { JimDbUtil } from "./dbutil";
import { Conversation } from "../entries/conversation";
import { MsgHandler } from "../entries/msghandler";

export class MessageDao{
  static instance:MessageDao = new MessageDao()
  private tableName:string = 'messages'
  private constructor() {
  }

  getMessage(msgId:string):Message|null{
    let sql = `SELECT * FROM ${this.tableName} WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msgId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        let msg = this.toMessage(resultSet)
        return msg
      }
    }catch (e){
      console.error(`faild to query msg. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  queryMessages(converId:string,converType:number,start:number,count:number,isPositive:boolean):Message[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE conver_type=? and conver_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(converType)
    args.push(converId)
    if(isPositive){
      sql = sql + ` and sent_time>? order by sent_time asc`
    }else{
      sql = sql + ` and sent_time<? order by sent_time desc`
    }
    args.push(start)
    sql = sql + ` LIMIT ${count}`
    let resultSet:relationalStore.ResultSet|undefined
    let msgList:Message[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let msg = this.toMessage(resultSet)
        msgList.push(msg)
      }
      if(!isPositive){
        msgList = msgList.slice().sort((a,b)=>a.sentTime-b.sentTime)
      }
      return msgList
    }catch (e) {
      console.error('failed to query ',this.tableName)
      return msgList
    }finally {
      resultSet?.close()
    }
  }

  insert(msg:Message):number{
    console.log("sendmsg_ret_start:",JSON.stringify(msg))
    let valueBucket = this.getValuesBucket(msg)
    try{
      let row = JimDbManager.instance.getDb()?.insertSync(this.tableName,valueBucket)
      console.log("sendmsg_ret_row:",row)
      if(row!==undefined){
        return row
      }
      return 0
    }catch (e) {
      console.error(`sendmsg_ret [${this.tableName}] err:${e.message}`)
      return 0
    }
  }

  existByMsgId(msgId:string,clientId:string):boolean{
    let sql = `SELECT id FROM ${this.tableName} WHERE msg_id=? or client_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msgId)
    args.push(clientId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        let id = JimDbUtil.toNumber(resultSet,"id")
        if(id>0){
          return true
        }
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}], err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return false
  }

  updateMsgContent(msgId:string,msgType:string,msgContent:MessageContent):number{
    let sql = `UPDATE ${this.tableName} SET msg_type=?, msg_content=? WHERE msg_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(msgType)
    args.push(JimUtil.uint8ArrayToString(msgContent.encode()))
    args.push(msgId)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateMsgState(dbId:number,state:number,msgId?:string,msgTime?:number,msgSeq?:number):number{
    let sql = `UPDATE ${this.tableName} SET state=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(state)
    if(msgId!=undefined){
      sql = sql + ` ,msg_id=?`
      args.push(msgId)
    }
    if(msgTime!=undefined){
      sql = sql + ` ,msg_time=?`
      args.push(msgTime)
    }
    if(msgSeq!=undefined){
      sql = sql + ` ,msg_seq_no=?`
      args.push(msgSeq)
    }
    sql = sql + ` WHERE id=?`
    args.push(dbId)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  private getValuesBucket(msg:Message):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "conver_id":msg.conversation?.conversationId as string,
      "conver_type":msg.conversation?.conversationType as number,
      "client_id":msg.clientId!=''?msg.clientId:null,
      "sender_id":msg.senderId,
      "direction":msg.direction,
      "msg_id":msg.messageId!=''?msg.messageId:null,
      "msg_seq_no": JimUtil.toNumber(msg.msgSeqNo),
      "msg_index":msg.msgUnreadIndex,
      "msg_type":msg.msgContent.getMsgType(),
      "sent_time":JimUtil.toNumber(msg.sentTime),
      "msg_content": JimUtil.uint8ArrayToString(msg.msgContent.encode()),
      "state":msg.state,
      "flags":MsgFlagTool.toFlag(msg.msgContent.getFlag()),
      "has_read":msg.hasRead?1:0,
      "read_count":msg.readCount,
      "member_count":msg.memberCount,
      "search_content":msg.searchContent,
      "refer_msg_id":msg.referMsgId
    }
    return valuesBucket
  }

  private toMessage(resultSet:relationalStore.ResultSet):Message{
    let message = new Message()
    let converId = JimDbUtil.toString(resultSet,'conver_id')
    let converType = JimDbUtil.toNumber(resultSet,'conver_type')
    message.conversation = new Conversation(converId,converType)
    message.clientId = JimDbUtil.toString(resultSet,'client_id')
    message.senderId = JimDbUtil.toString(resultSet,'sender_id')
    message.direction = JimDbUtil.toNumber(resultSet,'direction')
    message.messageId = JimDbUtil.toString(resultSet,'msg_id')
    message.msgSeqNo = JimDbUtil.toNumber(resultSet,'msg_seq_no')
    message.msgUnreadIndex = JimDbUtil.toNumber(resultSet,'msg_index')
    message.msgType = JimDbUtil.toString(resultSet,'msg_type')
    message.sentTime = JimDbUtil.toNumber(resultSet,'sent_time')
    //content
    let content = JimDbUtil.toString(resultSet,'msg_content')
    message.msgContent = MsgHandler.constructByMsgType(message.msgType, JimUtil.stringToUint8Array(content))
    message.state = JimDbUtil.toNumber(resultSet,'state')
    message.flags = JimDbUtil.toNumber(resultSet,'flags')
    message.hasRead = JimDbUtil.toNumber(resultSet,"has_read")>0
    message.readCount = JimDbUtil.toNumber(resultSet,"read_count")
    message.memberCount = JimDbUtil.toNumber(resultSet, "member_count")
    message.isDeleted = JimDbUtil.toNumber(resultSet,"is_deleted")>0
    message.searchContent = JimDbUtil.toString(resultSet,"search_content")
    message.referMsgId = JimDbUtil.toString(resultSet, "refer_msg_id")
    return message
  }
}