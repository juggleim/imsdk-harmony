import { Conversation, ConversationTagInfo } from '../entries/conversation'
import { CommonCallback } from './commoncallback'
import {
  ConversationAddListener,
  ConversationCallback,
  ConversationDeleteListener,
  ConversationInsertCallback,
  ConversationTagInfosCallback,
  ConversationTagsCallback,
  ConversationsCallback,
  ConversationUpdateListener,
  GetConversationOptions,
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
  queryConversations(options: GetConversationOptions, callback: ConversationsCallback): void
  queryConversations(count: number, startTime: number, isPositive: boolean, callback: ConversationsCallback): void
  getConversation(conver: Conversation, callback: ConversationCallback): void
  setDraft(conver: Conversation, draft: string): void
  clearDraft(conver: Conversation): void
  insertConversation(conver: Conversation, callback: ConversationInsertCallback): void
  createConversationTag(tagId: string, tagName: string, callback: CommonCallback): void
  destroyConversationTag(tagId: string, callback: CommonCallback): void
  updateConversationTagName(tagId: string, tagName: string, callback: CommonCallback): void
  getCachedConversationTagList(): ConversationTagInfo[]
  getConversationTagList(callback: ConversationTagInfosCallback): void
  getTagsForConversation(conver: Conversation): ConversationTagInfo[]
  addConversationsToTag(convers: Conversation[], tagId: string, callback: CommonCallback): void
  removeConversationsFromTag(convers: Conversation[], tagId: string, callback: CommonCallback): void
  addConversationTag(conver: Conversation, tagId: string, callback: CommonCallback): void
  removeConversationTag(conver: Conversation, tagId: string, callback: CommonCallback): void
  getConversationTags(conver: Conversation, callback: ConversationTagsCallback): void
  setUnread(conver: Conversation, callback: CommonCallback): void
  delConversation(conver: Conversation, callback: CommonCallback): void
  setTop(conver: Conversation, isTop: boolean, callback: CommonCallback): void
  setTopConversationsOrderType(sortType: TopConverSortType): void
  getTopConversations(sortType: TopConverSortType, start: number, isPositive: boolean, callback: ConversationsCallback): void
  setMute(conver: Conversation, isMute: boolean, callback: CommonCallback): void
  getTotalUnreadCount(callback: TotalUnreadCountCallback): void
  getUnreadCountWithTypes(conversationTypes: number[], callback: TotalUnreadCountCallback): void
  getTotalUnreadCountByTag(tagId: string, callback: TotalUnreadCountCallback): void
  clearTotalUnreadCount(callback: CommonCallback): void
  clearUnreadCount(conver: Conversation, callback: CommonCallback): void
}
