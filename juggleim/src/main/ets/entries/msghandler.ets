import { immessage } from "../improto/immessage"
import { RecallCmdMessage, ReadNtfMessage, ClearUnreadMessage } from "./cmdmsg"
import { MessageContent, TextMessage, MergeMessage, VoiceMessage, ImageMessage, FileMessage, VideoMessage, RecallInfoMessage,
  Message } from "./message"
import { Conversation } from "./conversation"
import { JimUtil } from "../commons/jimutil"

export class MsgHandler{
  private static msgTypeMap:Map<string,Function> = new Map()

  static init() {
    //regist inner msg type
    MsgHandler.registerMessage("jg:text",TextMessage)
    MsgHandler.registerMessage("jg:merge",MergeMessage)
    MsgHandler.registerMessage("jg:voice",VoiceMessage)
    MsgHandler.registerMessage("jg:img",ImageMessage)
    MsgHandler.registerMessage("jg:file",FileMessage)
    MsgHandler.registerMessage("jg:video",VideoMessage)
    MsgHandler.registerMessage("jg:recallinfo",RecallInfoMessage)
    //cmd msg
    MsgHandler.registerMessage("jg:recall",RecallCmdMessage)
    MsgHandler.registerMessage("jg:readntf",ReadNtfMessage)
    MsgHandler.registerMessage("jg:clearunread",ClearUnreadMessage)
  }

  static registerMessage(msgType:string,constructor:Function){
    MsgHandler.msgTypeMap.set(msgType,constructor)
  }

  static constructByMsgType(msgType:string,data:Uint8Array):MessageContent{
    if(MsgHandler.msgTypeMap.has(msgType)){
      let f = MsgHandler.msgTypeMap.get(msgType)
      let obj  = MsgHandler.createObj(f as FunctionConstructor)
      let msgContent = obj as MessageContent
      msgContent.decode(data)
      return msgContent
    }else{
      return new MessageContent()
    }
  }

  private static createObj(constructor:FunctionConstructor):Object{
    return new constructor()
  }

  static downMsg2Message(downMsg:immessage.IDownMsg):Message{
    let message = new Message()
    message.conversation = new Conversation(downMsg.targetId as string,downMsg.channelType as number)
    message.messageId = downMsg.msgId as string
    message.clientId = downMsg.clientUid as string
    message.msgType = downMsg.msgType as string
    message.msgContent = MsgHandler.constructByMsgType(message.msgType,downMsg.msgContent as Uint8Array)

    message.sentTime = JimUtil.toNumber(downMsg.msgTime as number)
    message.msgSeqNo = JimUtil.toNumber(downMsg.msgSeqNo as number)

    message.flags = JimUtil.toNumber(downMsg.flags as number)

    return message
  }
}