import { Message } from "./message"
import { faceDetector } from "@kit.CoreVisionKit"

export class Conversation{
  conversationId:string
  conversationType:number
  subChannel:string

  msgIndex:number = 0
  constructor(converId:string,converType:number, subChannel:string = '') {
    this.conversationId = converId
    this.conversationType = converType
    this.subChannel = Conversation.normalizeSubChannel(subChannel)
  }

  static normalizeSubChannel(subChannel:string|null|undefined):string{
    if(subChannel == undefined || subChannel == null){
      return ''
    }
    return subChannel.trim()
  }

  clone():Conversation{
    let nextConversation = new Conversation(this.conversationId, this.conversationType, this.subChannel)
    nextConversation.msgIndex = this.msgIndex
    return nextConversation
  }

  getKey():string{
    return `${this.conversationType}_${this.conversationId}_${this.subChannel}`
  }
}

export class ConversationInfo{
  id:number = 0
  conversation:Conversation = new Conversation("",0,'')
  lastMessage:Message = new Message()
  unreadCount:number = 0
  converTime:number = 0
  isTop:boolean = false
  topTime:number = 0
  isMute:boolean = false
  draft:string = ''
  lastReadMsgIndex:number = 0
  unreadTag:number = 0
  tags:ConversationTag[] = []
  constructor() {
  }
}

export class ConversationTag{
  conversation:Conversation = new Conversation("",0,'')
  tagId:string = ''
  constructor() {
  }
}

export class ConversationTagInfo{
  tagId:string = ''
  tagName:string = ''
  tagType:number = 0

  constructor() {
  }
}
