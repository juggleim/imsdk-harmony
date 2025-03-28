import {JuggleIm} from '../juggleim'
import { Conversation, ConversationInfo } from "../entries/conversation";
import {immessage} from  '../improto/immessage'
import { Message,TextMessage } from '../entries/message';

export type ConversationsCallback = (convers:ConversationInfo[])=>void

export class ConversationManager{
  static instance:ConversationManager = new ConversationManager()
  constructor() {
  }

  queryConversations(count:number,startTime:number,isPositive:boolean,callback:ConversationsCallback){
    let order:number = 0
    if(isPositive){
      order = 1
    }
    let req = immessage.QryConversationsReq.create({
      "startTime":startTime,
      "count":count,
      "order":order
    })
    let data = immessage.QryConversationsReq.encode(req).finish()
    JuggleIm.instance.connectionManager().query("qry_convers",JuggleIm.instance.userInfo.userId,data,(code,qryAck)=>{
      if(code==0){
        let convers:ConversationInfo[] = new Array()
        let data = qryAck.data as Uint8Array
        let resp = immessage.QryConversationsResp.decode(data)
        resp.conversations.forEach((conver)=>{
          let converInfo = new ConversationInfo()
          converInfo.lastMessage = this.downMsg2Message(conver.msg as immessage.IDownMsg)
          converInfo.conversation = converInfo.lastMessage.conversation
          converInfo.sortTime = conver.sortTime as number
          converInfo.isTop = (conver.isTop as number)>0
          converInfo.topTime = conver.topUpdatedTime as number
          converInfo.mute = (conver.undisturbType as number)>0
          convers.push(converInfo)
        })
        callback(convers)
      }else{
        console.log("jimsdk_qryconversations_failed:",code)
      }
    })
  }

  private downMsg2Message(downMsg:immessage.IDownMsg):Message{
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

    return message
  }
}