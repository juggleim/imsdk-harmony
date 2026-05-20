import { Conversation } from '../entries/conversation'
import { MessageContent } from '../entries/message'
import { MessageOptions } from '../entries/messageoptions'
import { CommonCallback } from './commoncallback'
import {
  ClearMsgOptions,
  GetMessageOptions,
  MessageCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgModifiedListener,
  MsgReceivedListener,
  MsgRecalledListener,
  QryMessagesCallback,
  QueryMsgOptions,
  SearchParams
} from './messagetypes'
import { HashMap } from '@kit.ArkTS'

export interface IMessageManager {
  addMsgReceivedListener(listener: MsgReceivedListener): void
  removeMsgReceivedListener(listener: MsgReceivedListener): void
  addMsgRecalledListener(listener: MsgRecalledListener): void
  removeMsgRecalledListener(listener: MsgRecalledListener): void
  addMsgModifiedListener(listener: MsgModifiedListener): void
  removeMsgModifiedListener(listener: MsgModifiedListener): void
  addMsgDeletedListener(listener: MsgDeletedListener): void
  removeMsgDeletedListener(listener: MsgDeletedListener): void
  addMsgCleanedListener(listener: MsgCleanedListener): void
  removeMsgCleanedListener(listener: MsgCleanedListener): void
  registerMessage(msgType: string, constructor: Function): void
  sendMessage(msg: MessageContent, conver: Conversation, callback: MessageCallback): void
  sendMessage(msg: MessageContent, conver: Conversation, options: MessageOptions, callback: MessageCallback): void
  sendMediaMessage(msg: MessageContent, conver: Conversation): void
  queryMessages(conver: Conversation, options: GetMessageOptions, callback: QryMessagesCallback): void
  queryLocalMessages(conver: Conversation, options: GetMessageOptions, callback: QryMessagesCallback): void
  queryRemoteMessages(conver: Conversation, options: GetMessageOptions, callback: QryMessagesCallback): void
  queryMentionMessages(conver: Conversation, count: number, startTime: number, isPositive: boolean, callback: QryMessagesCallback): void
  clearMessages(conver: Conversation, options: ClearMsgOptions, callback: CommonCallback): void
  delMessages(conver: Conversation, msgIds: string[], delScope: number, callback: CommonCallback): void
  getMessagesByMessageIds(conver: Conversation | null, msgIds: string[], callback: QryMessagesCallback): void
  getMessagesByIds(conver: Conversation | null, msgIds: string[], callback: QryMessagesCallback): void
  modifyMessage(conver: Conversation, msgId: string, msg: MessageContent, callback: MessageCallback): void
  sendReadReceipt(conver: Conversation, msgIds: string[], callback: CommonCallback): void
  recallMessage(conver: Conversation, msgId: string, extras: HashMap<string, string>, callback: MessageCallback): void
  searchMessages(params: SearchParams, callback: QryMessagesCallback): void
  setLocalAttribute(msgId: string, attribute: string): void
  getLocalAttribute(msgId: string): string
  setLocalAttribue(msgId: string, attribute: string): void
}
