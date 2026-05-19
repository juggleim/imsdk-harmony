import { Conversation } from '../entries/conversation'
import { CommonCallback } from './commoncallback'
import {
  ConversationAddListener,
  ConversationCallback,
  ConversationDeleteListener,
  ConversationInsertCallback,
  ConversationsCallback,
  ConversationUpdateListener,
  TopConverSortType,
  TotalUnreadCountCallback,
  TotalUnreadCountUpdateListener
} from './conversationtypes'

export interface IConversationManager {
  addConversationAddListener(listener: ConversationAddListener): void
  removeConversationAddListener(listener: ConversationAddListener): void
  addConversationUpdateListener(listener: ConversationUpdateListener): void
  removeConversationUpdateListener(listener: ConversationUpdateListener): void
  addConversationDeleteListener(listener: ConversationDeleteListener): void
  removeConversationDeleteListener(listener: ConversationDeleteListener): void
  addTotalUnreadCountUpdateListener(listener: TotalUnreadCountUpdateListener): void
  removeTotalUnreadCountUpdateListener(listener: TotalUnreadCountUpdateListener): void
  queryConversations(count: number, startTime: number, isPositive: boolean, callback: ConversationsCallback): void
  getConversation(conver: Conversation, callback: ConversationCallback): void
  setDraft(conver: Conversation, draft: string): void
  clearDraft(conver: Conversation): void
  insertConversation(conver: Conversation, callback: ConversationInsertCallback): void
  setUnread(conver: Conversation, callback: CommonCallback): void
  delConversation(conver: Conversation, callback: CommonCallback): void
  setTop(conver: Conversation, isTop: boolean, callback: CommonCallback): void
  getTopConversations(sortType: TopConverSortType, start: number, isPositive: boolean, callback: ConversationsCallback): void
  setMute(conver: Conversation, isMute: boolean, callback: CommonCallback): void
  getTotalUnreadCount(callback: TotalUnreadCountCallback): void
  clearTotalUnreadCount(callback: CommonCallback): void
  clearUnreadCount(conver: Conversation, callback: CommonCallback): void
}
