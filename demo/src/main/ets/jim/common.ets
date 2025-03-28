import { Conversation } from 'jimsdk/src/main/ets/entries/conversation';
import { Message } from 'jimsdk/src/main/ets/entries/message';

@Observed
export class ObservedArray<T> extends Array<T>{
  constructor(args: T[]) {
    if (args instanceof Array) {
      super(...args);
    } else {
      super(args)
    }
  }
}

@Observed
export class ConversationViewItem{
  conversation: Conversation
  lastMsg:Message
  name: ResourceStr
  msg: ResourceStr
  time: ResourceStr
  icon: ResourceStr
  constructor(conver:Conversation,lastMsg:Message,name:ResourceStr,msg:ResourceStr,time:ResourceStr,icon:ResourceStr) {
    this.conversation = conver
    this.lastMsg = lastMsg
    this.name = name
    this.msg = msg
    this.time = time
    this.icon = icon
  }
}