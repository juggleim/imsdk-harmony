import { immessage } from "../improto/immessage"
import { RecallCmdMessage, ReadNtfMessage, GroupReadNtfMessage, ClearUnreadMessage, ModifyMessage, MsgExSetMessage, TopMsgMessage } from "./cmdmsg"
import { MessageContent, TextMessage, MergeMessage, VoiceMessage, ImageMessage, FileMessage, VideoMessage, RecallInfoMessage,
  Message, MessageSentState } from "./message"
import { Conversation } from "./conversation"
import { JimUtil } from "../commons/jimutil"
import { UserInfo } from "./user"
import { JuggleIm } from "../../../../Index"
import { GroupInfo } from "./group"
import { JimMsgType } from "./msgtypes"
import { MessageOptionUtil } from "../commons/messageoptionutil"
import { MsgFlagTool } from "../improto/msgflag"

/**
 * Represents Msg Handler.
 *
 * Example:
 * ```ts
 * const value = new MsgHandler()
 * ```
 */
export class MsgHandler{
  private static msgTypeMap:Map<string, () => MessageContent> = new Map()

  static init() {
    //regist inner msg type
    MsgHandler.registerMessage(JimMsgType.Text, ()=> new TextMessage())
    MsgHandler.registerMessage(JimMsgType.Merge, ()=> new MergeMessage())
    MsgHandler.registerMessage(JimMsgType.Voice, ()=> new VoiceMessage())
    MsgHandler.registerMessage(JimMsgType.Image, ()=> new ImageMessage())
    MsgHandler.registerMessage(JimMsgType.File, ()=> new FileMessage())
    MsgHandler.registerMessage(JimMsgType.Video, ()=> new VideoMessage())
    MsgHandler.registerMessage(JimMsgType.RecallInfo, ()=> new RecallInfoMessage())
    //cmd msg
    MsgHandler.registerMessage(JimMsgType.RecallCmd, ()=> new RecallCmdMessage())
    MsgHandler.registerMessage(JimMsgType.ReadNtf, ()=> new ReadNtfMessage())
    MsgHandler.registerMessage(JimMsgType.GroupReadNtf, ()=> new GroupReadNtfMessage())
    MsgHandler.registerMessage(JimMsgType.ClearUnread, ()=> new ClearUnreadMessage())
    MsgHandler.registerMessage(JimMsgType.ModifyMsg, ()=> new ModifyMessage())
    MsgHandler.registerMessage(JimMsgType.MsgExSet, ()=> new MsgExSetMessage())
    MsgHandler.registerMessage(JimMsgType.TopMsg, ()=> new TopMsgMessage())

  }

  static registerMessage(msgType:string, factory:() => MessageContent){
    MsgHandler.msgTypeMap.set(msgType,factory)
  }

  static constructByMsgType(msgType:string,data:Uint8Array):MessageContent{
    if(MsgHandler.msgTypeMap.has(msgType)){
      let f = MsgHandler.msgTypeMap.get(msgType)
      if (f == undefined) {
        console.warn(`jimsdk_unknown_msg_type: ${msgType}`)
        return new MessageContent()
      }
      let msgContent = f()
      msgContent.decode(data)
      return msgContent
    }else{
      console.warn(`jimsdk_unknown_msg_type: ${msgType}`)
      return new MessageContent()
    }
  }

  static downMsg2Message(downMsg:immessage.IDownMsg):Message{
    let message = new Message()
    message.conversation = new Conversation(
      downMsg.targetId as string,
      downMsg.channelType as number,
      downMsg.subChannel != undefined ? downMsg.subChannel as string : ''
    )
    message.messageId = downMsg.msgId as string
    message.clientId = downMsg.clientUid as string
    let msgType = downMsg.msgType as string
    message.msgContent = MsgHandler.constructByMsgType(msgType,downMsg.msgContent as Uint8Array)

    message.sentTime = JimUtil.toNumber(downMsg.msgTime as number)
    message.msgSeqNo = JimUtil.toNumber(downMsg.msgSeqNo as number)
    message.msgUnreadIndex = JimUtil.toNumber(downMsg.unreadIndex as number)
    message.senderId = downMsg.senderId as string
    message.direction = downMsg.senderId == JuggleIm.instance.userId ? 0 : 1
    message.state = MessageSentState.success
    message.hasRead = downMsg.isRead as boolean
    message.readCount = JimUtil.toNumber(downMsg.readCount as number)
    message.memberCount = JimUtil.toNumber(downMsg.memberCount as number)
    message.searchContent = downMsg.SearchText as string
    message.flags = JimUtil.toNumber(downMsg.flags as number)
    message.isEdit = MsgFlagTool.parseFlag(message.flags).isModified == true
    let referMessage:Message|undefined
    if(downMsg.referMsg != undefined && downMsg.referMsg != null){
      referMessage = MsgHandler.downMsg2ReferenceMessage(downMsg.referMsg)
    }
    MessageOptionUtil.applyProtoOptions(message, downMsg, referMessage)

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

  private static downMsg2ReferenceMessage(downMsg:immessage.IDownMsg):Message{
    let message = new Message()
    message.conversation = new Conversation(
      downMsg.targetId as string,
      downMsg.channelType as number,
      downMsg.subChannel != undefined ? downMsg.subChannel as string : ''
    )
    message.messageId = downMsg.msgId as string
    message.clientId = downMsg.clientUid as string
    message.senderId = downMsg.senderId as string
    message.msgContent = MsgHandler.constructByMsgType(downMsg.msgType as string,downMsg.msgContent as Uint8Array)
    message.sentTime = JimUtil.toNumber(downMsg.msgTime as number)
    message.msgSeqNo = JimUtil.toNumber(downMsg.msgSeqNo as number)
    message.msgUnreadIndex = JimUtil.toNumber(downMsg.unreadIndex as number)
    message.direction = downMsg.senderId == JuggleIm.instance.userId ? 0 : 1
    message.state = MessageSentState.success
    message.hasRead = downMsg.isRead as boolean
    message.readCount = JimUtil.toNumber(downMsg.readCount as number)
    message.memberCount = JimUtil.toNumber(downMsg.memberCount as number)
    message.searchContent = downMsg.SearchText as string
    message.flags = JimUtil.toNumber(downMsg.flags as number)
    message.isEdit = MsgFlagTool.parseFlag(message.flags).isModified == true
    MessageOptionUtil.applyProtoOptions(message, downMsg)
    return message
  }
}
