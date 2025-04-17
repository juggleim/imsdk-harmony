import { immessage } from "../improto/immessage"
import { RecallCmdMessage, ReadNtfMessage, ClearUnreadMessage, ModifyMessage } from "./cmdmsg"
import { MessageContent, TextMessage, MergeMessage, VoiceMessage, ImageMessage, FileMessage, VideoMessage, RecallInfoMessage,
  Message } from "./message"
import { Conversation } from "./conversation"
import { JimUtil } from "../commons/jimutil"
import { UserInfo } from "./user"
import { JuggleIm } from "../../../../Index"
import { GroupInfo } from "./group"
import { JimMsgType } from "./msgtypes"

export class MsgHandler{
  private static msgTypeMap:Map<string,Function> = new Map()

  static init() {
    //regist inner msg type
    MsgHandler.registerMessage(JimMsgType.Text,TextMessage)
    MsgHandler.registerMessage(JimMsgType.Merge,MergeMessage)
    MsgHandler.registerMessage(JimMsgType.Voice,VoiceMessage)
    MsgHandler.registerMessage(JimMsgType.Image,ImageMessage)
    MsgHandler.registerMessage(JimMsgType.File,FileMessage)
    MsgHandler.registerMessage(JimMsgType.Video,VideoMessage)
    MsgHandler.registerMessage(JimMsgType.RecallInfo,RecallInfoMessage)
    //cmd msg
    MsgHandler.registerMessage(JimMsgType.RecallCmd,RecallCmdMessage)
    MsgHandler.registerMessage(JimMsgType.ReadNtf,ReadNtfMessage)
    MsgHandler.registerMessage(JimMsgType.ClearUnread,ClearUnreadMessage)
    MsgHandler.registerMessage(JimMsgType.ModifyMsg,ModifyMessage)

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
    message.msgUnreadIndex = JimUtil.toNumber(downMsg.unreadIndex as number)
    message.senderId = downMsg.senderId as string
    message.memberCount = JimUtil.toNumber(downMsg.memberCount as number)
    message.searchContent = downMsg.SearchText as string
    message.referMsgId = downMsg.referMsg as string

    message.flags = JimUtil.toNumber(downMsg.flags as number)

    //check userinfo
    if(downMsg.channelType===immessage.ChannelType.Private){
      if(downMsg.targetUserInfo!=null&&downMsg.targetUserInfo!=undefined){
        let user = new UserInfo()
        user.userId = downMsg.targetUserInfo.userId as string
        user.nickname = downMsg.targetUserInfo.nickname as string
        user.userPortrait = downMsg.targetUserInfo.userPortrait as string
        user.userType = JimUtil.toNumber(downMsg.targetUserInfo.userType as number)
        user.updTime = JimUtil.toNumber(downMsg.targetUserInfo.updatedTime as number)
        JuggleIm.instance.getUserInfoManager().saveUserInfo(user)
      }
    }else if(downMsg.channelType === immessage.ChannelType.Group){
      if(downMsg.groupInfo!=null&&downMsg.groupInfo!=undefined){
        let grp = new GroupInfo()
        grp.groupId = downMsg.groupInfo.groupId as string
        grp.groupName = downMsg.groupInfo.groupName as string
        grp.groupPortrait = downMsg.groupInfo.groupPortrait as string
        grp.updTime = JimUtil.toNumber(downMsg.groupInfo.updatedTime as number)
        JuggleIm.instance.getGroupInfoManager().saveGroupInfo(grp)
      }
    }

    return message
  }
}