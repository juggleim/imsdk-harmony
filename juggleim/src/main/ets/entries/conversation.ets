import { Message } from "./message"
import { faceDetector } from "@kit.CoreVisionKit"

export class Conversation{
  conversationId:string
  conversationType:number

  conversationTitle:string = ''
  conversationPortrait:string = ''
  constructor(converId:string,converType:number) {
    this.conversationId = converId
    this.conversationType = converType
  }
}

export class ConversationInfo{
  conversation:Conversation = new Conversation("",0)
  lastMessage:Message = new Message(new Conversation("",0))
  unreadCount:number = 0
  sortTime:number = 0
  isTop:boolean = false
  topTime:number = 0
  mute:boolean = false
  draft:string = ''
  constructor() {
  }
}