import { Conversation, ConversationInfo, ConversationTag, ConversationTagInfo } from '../entries/conversation'

export type ConversationCallback = (code: number, conver: ConversationInfo | null) => void
export type ConversationsCallback = (code: number, convers: ConversationInfo[]) => void
export type ConversationInsertCallback = (code: number, conver: ConversationInfo | null) => void
export type TotalUnreadCountCallback = (code: number, count: number) => void
export type ConversationTagsCallback = (code: number, tags: ConversationTag[]) => void
export type ConversationTagInfosCallback = (code: number, tagInfos: ConversationTagInfo[]) => void

export enum TopConverSortType {
  ByTopTime,
  BySortTime
}

export enum GetConversationDirection {
  Backward = 0,
  Forward = 1
}

export class GetConversationOptions {
  count: number = 20
  time: number = 0
  direction: GetConversationDirection = GetConversationDirection.Backward
  conversationTypes: number[] = []
  tagId: string = ''

  constructor() {
  }
}

export type ConversationAddListener = (convers: ConversationInfo[]) => void
export type ConversationUpdateListener = (convers: ConversationInfo[]) => void
export type ConversationDeleteListener = (convers: ConversationInfo[]) => void
export type TotalUnreadCountUpdateListener = (count: number) => void

export interface ConversationListener {
  onConversationInfoAdd(conversationInfoList: ConversationInfo[]): void
  onConversationInfoUpdate(conversationInfoList: ConversationInfo[]): void
  onConversationInfoDelete(conversationInfoList: ConversationInfo[]): void
  onTotalUnreadMessageCountUpdate(count: number): void
}

export interface ConversationSyncListener {
  onConversationSyncComplete(): void
}

export interface ConversationTagListener {
  onTagCreate(tagInfo: ConversationTagInfo): void
  onTagDestroy(tagId: string): void
  onTagNameUpdate(tagId: string, tagName: string): void
  onConversationsAddToTag(tagId: string, conversations: Conversation[]): void
  onConversationsRemoveFromTag(tagId: string, conversations: Conversation[]): void
}
