import { Conversation, ConversationInfo } from "../entries/conversation"
import { relationalStore } from "@kit.ArkData"
import { JimUtil } from "../commons/jimutil"
import { JimDbUtil } from "./dbutil"
import { Message } from "../entries/message";
import { JimDbManager } from "./dbmanager";
import { MessageManager } from "../managers/messagemanager";
import { JuggleIm } from "../juggleim";

export class ConversationDao{
  static instance:ConversationDao = new ConversationDao()
  private tableName:string = "conversations"
  private constructor() {
  }

  queryConversations(start:number,count:number,isPositive:boolean):ConversationInfo[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE `
    if(isPositive){
      sql = sql + ` conver_time >? order by conver_time asc`
    }else{
      sql = sql + ` conver_time < ? order by conver_time desc`
    }
    sql = sql + ` LIMIT ${count}`
    let args:Array<relationalStore.ValueType> = []
    args.push(start)
    let resultSet:relationalStore.ResultSet|undefined
    let converList:ConversationInfo[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let conver = this.toConver(resultSet)
        converList.push(conver)
      }
    }catch (e) {
      console.error("failed to query convers",this.tableName,`err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return converList
  }

  insert(conver:ConversationInfo):number{
    let valueBucket = this.getValuesBucket(conver)
    try{
      let row = JimDbManager.instance.getDb()?.insertSync(this.tableName,valueBucket)
      if(row!==undefined){
        return row
      }
      return 0
    }catch (e) {
      console.error(`jimsdk_insert [${this.tableName}] err:${e.message}`)
      return 0
    }
  }

  getConver(c:Conversation):ConversationInfo|undefined{
    let sql = `SELECT * FROM ${this.tableName} WHERE conver_type=? and conver_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(c.conversationType)
    args.push(c.conversationId)
    let resultSet:relationalStore.ResultSet|undefined
    let converInfo:ConversationInfo|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        converInfo = this.toConver(resultSet)
      }
    }catch (e) {
      console.error("failed to query conver ",this.tableName)
    }finally {
      resultSet?.close()
    }
    return converInfo
  }

  private getValuesBucket(conver:ConversationInfo):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "conver_id":conver.conversation.conversationId,
      "conver_type":conver.conversation.conversationType,
      "draft":conver.draft,
      "sync_time":conver.syncTime,
      "conver_time":conver.converTime,
      "last_msg_id":conver.lastMessage.messageId,
      "last_read_msg_index":conver.lastReadMsgIndex,
      "last_msg_index":conver.lastMessage.msgUnreadIndex,
      "is_top":conver.isTop?1:0,
      "top_time":conver.topTime,
      "is_mute":conver.isMute?1:0,
      "last_msg_type":conver.lastMessage.msgType,
      "last_msg_client_id":conver.lastMessage.clientId,
      "last_msg_direction":conver.lastMessage.direction,
      "last_msg_state":conver.lastMessage.state,
      "last_msg_has_read":conver.lastMessage.hasRead,
      "last_msg_sender_id":conver.lastMessage.senderId,
      "last_msg_content":JimUtil.uint8ArrayToString(conver.lastMessage.msgContent.encode()),
      "last_msg_seq_no":conver.lastMessage.msgSeqNo,
      "unread_tag":conver.unreadTag
    }
    return valuesBucket
  }

  private toConver(resultSet:relationalStore.ResultSet):ConversationInfo{
    let conver:ConversationInfo = new ConversationInfo()
    let converId = JimDbUtil.toString(resultSet,"conver_id")
    let converType = JimDbUtil.toNumber(resultSet,"conver_type")
    conver.conversation = new Conversation(converId,converType)
    conver.draft = JimDbUtil.toString(resultSet,"draft")
    conver.syncTime = JimDbUtil.toNumber(resultSet,"sync_time")
    conver.converTime = JimDbUtil.toNumber(resultSet,"conver_time")
    conver.lastReadMsgIndex = JimDbUtil.toNumber(resultSet,"last_read_msg_index")
    conver.isTop = JimDbUtil.toNumber(resultSet,"is_top")>0
    conver.topTime = JimDbUtil.toNumber(resultSet,"top_time")
    conver.isMute = JimDbUtil.toNumber(resultSet,"is_mute")>0
    conver.unreadTag = JimDbUtil.toNumber(resultSet,"unread_tag")
    let msg = new Message()
    msg.messageId = JimDbUtil.toString(resultSet,"last_msg_id")
    msg.msgUnreadIndex = JimDbUtil.toNumber(resultSet,"last_msg_index")
    msg.msgType = JimDbUtil.toString(resultSet,"last_msg_type")

    //content
    let dataStr = JimDbUtil.toString(resultSet,"last_msg_content")
    let data = JimUtil.stringToUint8Array(dataStr)
    let m = JuggleIm.instance.getMessageManager().constructByMsgType(msg.msgType)
    m.decode(data)
    msg.msgContent = m

    msg.clientId = JimDbUtil.toString(resultSet,"last_msg_client_id")
    msg.direction = JimDbUtil.toNumber(resultSet,"last_msg_direction")
    msg.state = JimDbUtil.toNumber(resultSet,"last_msg_state")
    msg.hasRead = JimDbUtil.toNumber(resultSet,"last_msg_has_read")>0
    msg.senderId = JimDbUtil.toString(resultSet,"last_msg_sender_id")
    msg.msgSeqNo = JimDbUtil.toNumber(resultSet,"last_msg_seq_no")
    conver.lastMessage = msg
    return conver
  }
}