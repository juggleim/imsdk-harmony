import { Message } from "./message"
import { faceDetector } from "@kit.CoreVisionKit"

export class Conversation{
  conversationId:string
  conversationType:number

  msgIndex:number = 0
  constructor(converId:string,converType:number) {
    this.conversationId = converId
    this.conversationType = converType
  }
}

export class ConversationInfo{
  conversation:Conversation = new Conversation("",0)
  lastMessage:Message = new Message()
  unreadCount:number = 0
  converTime:number = 0
  syncTime:number = 0
  isTop:boolean = false
  topTime:number = 0
  isMute:boolean = false
  draft:string = ''
  lastReadMsgIndex:number = 0
  unreadTag:number = 0
  constructor() {
  }
}

export class ConversationTag{
  conversation:Conversation = new Conversation("",0)
  tagId:string = ''
  constructor() {
  }
}