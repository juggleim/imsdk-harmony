import { Message } from "../entries/message";
import { relationalStore } from "@kit.ArkData";
import { JimUtil } from "../commons/jimutil";
import { MsgFlagTool } from "../improto/msgflag";
import { JimDbManager } from "./dbmanager";
import { JimDbUtil } from "./dbutil";
import { Conversation } from "../entries/conversation";

export class MessageDao{
  static instance:MessageDao = new MessageDao()
  private tableName:string = 'messages'
  private constructor() {
  }

  queryMessages(converId:string,converType:number,start:number,count:number):Message[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE conver_type=? and conver_id=? limit ${count}`
    let args:Array<relationalStore.ValueType> = []
    args.push(converType)
    args.push(converId)
    let resultSet:relationalStore.ResultSet|undefined
    let msgList:Message[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let msg = this.toMessage(resultSet)
        msgList.push(msg)
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
    let valueBucket = this.getValuesBucket(msg)
    try{
      let row = JimDbManager.instance.getDb()?.insertSync(this.tableName,valueBucket)
      if(row!==undefined){
        return row
      }
      return 0
    }catch (e) {
      console.log("jimsdk_dbinsert_err",JSON.stringify(e))
      console.error(`insert failed [${this.tableName}] err:${e.message}`)
      return 0
    }
  }

  private getValuesBucket(msg:Message):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "conver_id":msg.conversation?.conversationId as string,
      "conver_type":msg.conversation?.conversationType as number,
      "client_id":msg.clientId,
      "sender_id":msg.senderId,
      "direction":msg.direction,
      "msg_id":msg.messageId,
      "msg_seq_no":msg.msgSeqNo,
      "msg_index":msg.msgUnreadIndex,
      "msg_type":msg.msgType,
      "sent_time":msg.sentTime,
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