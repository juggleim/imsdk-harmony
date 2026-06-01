import { Conversation, ConversationInfo, ConversationTag, ConversationTagInfo } from '../entries/conversation'

/**
 * Defines the Conversation Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationCallback = (...args: unknown[]) => {}
 * ```
 */
export type ConversationCallback = (code: number, conver: ConversationInfo | null) => void
/**
 * Defines the Conversations Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationsCallback = (...args: unknown[]) => {}
 * ```
 */
export type ConversationsCallback = (code: number, convers: ConversationInfo[]) => void
/**
 * Defines the Conversation Insert Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationInsertCallback = (...args: unknown[]) => {}
 * ```
 */
export type ConversationInsertCallback = (code: number, conver: ConversationInfo | null) => void
/**
 * Defines the Total Unread Count Callback alias.
 *
 * Example:
 * ```ts
 * const callback: TotalUnreadCountCallback = (...args: unknown[]) => {}
 * ```
 */
export type TotalUnreadCountCallback = (code: number, count: number) => void
/**
 * Defines the Conversation Tags Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationTagsCallback = (...args: unknown[]) => {}
 * ```
 */
export type ConversationTagsCallback = (code: number, tags: ConversationTag[]) => void
/**
 * Defines the Conversation Tag Infos Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationTagInfosCallback = (...args: unknown[]) => {}
 * ```
 */
export type ConversationTagInfosCallback = (code: number, tagInfos: ConversationTagInfo[]) => void

/**
 * Defines the Top Conver Sort Type constants.
 *
 * Example:
 * ```ts
 * const sortType = TopConverSortType.ByTopTime
 * ```
 */
export enum TopConverSortType {
  ByTopTime,
  BySortTime
}

/**
 * Defines the Get Conversation Direction constants.
 *
 * Example:
 * ```ts
 * const direction = GetConversationDirection.Backward
 * ```
 */
export enum GetConversationDirection {
  Backward = 0,
  Forward = 1
}

/**
 * Represents Get Conversation Options.
 *
 * Example:
 * ```ts
 * const value = new GetConversationOptions()
 * ```
 */
export class GetConversationOptions {
  count: number = 20
  time: number = 0
  direction: GetConversationDirection = GetConversationDirection.Backward
  conversationTypes: number[] = []
  tagId: string = ''

  constructor() {
  }
}

/**
 * Defines the Conversation Add Listener alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationAddListener = (...args: unknown[]) => {}
 * ```
 */
export type ConversationAddListener = (convers: ConversationInfo[]) => void
/**
 * Defines the Conversation Update Listener alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationUpdateListener = (...args: unknown[]) => {}
 * ```
 */
export type ConversationUpdateListener = (convers: ConversationInfo[]) => void
/**
 * Defines the Conversation Delete Listener alias.
 *
 * Example:
 * ```ts
 * const callback: ConversationDeleteListener = (...args: unknown[]) => {}
 * ```
 */
export type ConversationDeleteListener = (convers: ConversationInfo[]) => void
/**
 * Defines the Total Unread Count Update Listener alias.
 *
 * Example:
 * ```ts
 * const callback: TotalUnreadCountUpdateListener = (...args: unknown[]) => {}
 * ```
 */
export type TotalUnreadCountUpdateListener = (count: number) => void

/**
 * Declares the contract for Conversation Listener.
 *
 * Example:
 * ```ts
 * const listener: ConversationListener = {} as ConversationListener
 * ```
 */
export interface ConversationListener {
  onConversationInfoAdd(conversationInfoList: ConversationInfo[]): void
  onConversationInfoUpdate(conversationInfoList: ConversationInfo[]): void
  onConversationInfoDelete(conversationInfoList: ConversationInfo[]): void
  onTotalUnreadMessageCountUpdate(count: number): void
}

/**
 * Declares the contract for Conversation Sync Listener.
 *
 * Example:
 * ```ts
 * const listener: ConversationSyncListener = {} as ConversationSyncListener
 * ```
 */
export interface ConversationSyncListener {
  onConversationSyncComplete(): void
}

/**
 * Declares the contract for Conversation Tag Listener.
 *
 * Example:
 * ```ts
 * const listener: ConversationTagListener = {} as ConversationTagListener
 * ```
 */
export interface ConversationTagListener {
  onTagCreate(tagInfo: ConversationTagInfo): void
  onTagDestroy(tagId: string): void
  onTagNameUpdate(tagId: string, tagName: string): void
  onConversationsAddToTag(tagId: string, conversations: Conversation[]): void
  onConversationsRemoveFromTag(tagId: string, conversations: Conversation[]): void
}
