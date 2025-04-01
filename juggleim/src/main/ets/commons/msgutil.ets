import {immessage} from  '../improto/immessage'
import { Conversation, ConversationInfo } from "../entries/conversation";
import { Message,TextMessage } from '../entries/message';
import { UserInfo } from '../entries/user';

export class MessageUtil{
  static downMsg2Message(downMsg:immessage.IDownMsg):Message{
    let message = new Message(new Conversation(downMsg.targetId as string,downMsg.channelType as number))
    if(downMsg.channelType === immessage.ChannelType.Private){
      message.conversation.conversationTitle = downMsg.targetUserInfo?.nickname as string
      message.conversation.conversationPortrait = downMsg.targetUserInfo?.userPortrait as string
    }else if(downMsg.channelType === immessage.ChannelType.Group){
      message.conversation.conversationTitle = downMsg.groupInfo?.groupName as string
      message.conversation.conversationPortrait = downMsg.groupInfo?.groupPortrait as string
    }
    console.log("jimsdk_converitem\tname:",message.conversation.conversationTitle,"\tportrait:",message.conversation.conversationPortrait)
    message.messageId = downMsg.msgId as string
    message.msgType = downMsg.msgType as string
    if(message.msgType=="jg:text"){
      let txtMsg = new TextMessage("","")
      message.msgContent = txtMsg.decode(downMsg.msgContent as Uint8Array)
    }
    message.sentTime = downMsg.msgTime as number
    message.msgSeqNo = downMsg.msgSeqNo as number
    message.sender = new UserInfo()
    message.sender.userId = downMsg.senderId as string
    message.sender.nickname = downMsg.targetUserInfo?.nickname as string
    message.sender.userPortrait = downMsg.targetUserInfo?.userPortrait as string

    return message
  }
}