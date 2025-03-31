import { Conversation } from 'jimsdk/src/main/ets/entries/conversation'
import { Message } from 'jimsdk/src/main/ets/entries/message'

@Observed
export class ConversationItem{
  conversation:Conversation
  lastMsg:Message
  name:ResourceStr
  msg:ResourceStr
  time:ResourceStr
  icon:ResourceStr
  constructor(conver:Conversation,lastMsg:Message,name:ResourceStr,msg:ResourceStr,time:ResourceStr,icon:ResourceStr) {
    this.conversation = conver
    this.lastMsg = lastMsg
    this.name = name
    this.msg = msg
    this.time = time
    this.icon = icon
  }
}