import { MessageContent } from "juggleim/src/main/ets/entries/message"

@Observed
class MessageViewItem{
  senderName:string
  senderIcon?:string
  selfName:string
  selfIcon:string
  msgContent?:MessageContent

  isReceived:boolean = true
  msgTime:number = 0

  constructor(senderName:string,senderIcon:string,selfName:string,selfIcon:string,msgContent:MessageContent,msgTime:number) {
    this.senderName = senderName
    this.senderIcon = senderIcon
    this.selfName = selfName
    this.selfIcon = selfIcon
    this.msgContent = msgContent
    this.msgTime = msgTime
  }
}

export { MessageViewItem };