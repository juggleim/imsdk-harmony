import { Conversation, ConversationInfo } from '../entries/conversation'

export type ConversationCallback = (code: number, conver: ConversationInfo | null) => void
export type ConversationsCallback = (code: number, convers: ConversationInfo[]) => void
export type ConversationInsertCallback = (code: number, conver: ConversationInfo | null) => void
export type TotalUnreadCountCallback = (code: number, count: number) => void

export enum TopConverSortType {
  ByTopTime,
  BySortTime
}

export type ConversationAddListener = (convers: ConversationInfo[]) => void
export type ConversationUpdateListener = (convers: ConversationInfo[]) => void
export type ConversationDeleteListener = (convers: ConversationInfo[]) => void
export type TotalUnreadCountUpdateListener = (count: number) => void
