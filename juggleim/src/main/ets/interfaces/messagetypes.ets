import { Conversation } from '../entries/conversation'
import { FavoriteMessage, Message, MessageContent, MessageReactionResult } from '../entries/message'
import { GroupMessageReadInfo, GroupMessageReadInfoDetail } from '../entries/group'
import { SearchConversationsResult } from '../entries/searchconversationresult'
import { UserInfo } from '../entries/user'

/**
 * Defines the Message Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MessageCallback = (...args: unknown[]) => {}
 * ```
 */
export type MessageCallback = (code: number, msg: Message | null) => void
/**
 * Defines the Qry Messages Callback alias.
 *
 * Example:
 * ```ts
 * const callback: QryMessagesCallback = (...args: unknown[]) => {}
 * ```
 */
export type QryMessagesCallback = (code: number, msgs: Message[], hasMore: boolean) => void
/**
 * Defines the Group Message Read Info Detail Callback alias.
 *
 * Example:
 * ```ts
 * const callback: GroupMessageReadInfoDetailCallback = (...args: unknown[]) => {}
 * ```
 */
export type GroupMessageReadInfoDetailCallback = (code: number, detail: GroupMessageReadInfoDetail | null) => void
/**
 * Defines the Message Reactions Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MessageReactionsCallback = (...args: unknown[]) => {}
 * ```
 */
export type MessageReactionsCallback = (code: number, items: MessageReactionResult[]) => void
/**
 * Defines the Favorite Messages Callback alias.
 *
 * Example:
 * ```ts
 * const callback: FavoriteMessagesCallback = (...args: unknown[]) => {}
 * ```
 */
export type FavoriteMessagesCallback = (code: number, items: FavoriteMessage[], offset: string) => void
/**
 * Defines the Top Message Callback alias.
 *
 * Example:
 * ```ts
 * const callback: TopMessageCallback = (...args: unknown[]) => {}
 * ```
 */
export type TopMessageCallback = (code: number, message: Message | null, operator: UserInfo | null, createdTime: number) => void
/**
 * Defines the I Search Conversation With Message Content Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ISearchConversationWithMessageContentCallback = (...args: unknown[]) => {}
 * ```
 */
export type ISearchConversationWithMessageContentCallback = (resultList: SearchConversationsResult[]) => void
/**
 * Defines the I Get Messages Callback alias.
 *
 * Example:
 * ```ts
 * const callback: IGetMessagesCallback = (...args: unknown[]) => {}
 * ```
 */
export type IGetMessagesCallback = (code: number, messages: Message[]) => void
/**
 * Declares the contract for I Get Local And Remote Messages Callback.
 *
 * Example:
 * ```ts
 * const listener: IGetLocalAndRemoteMessagesCallback = {} as IGetLocalAndRemoteMessagesCallback
 * ```
 */
export interface IGetLocalAndRemoteMessagesCallback {
  onGetLocalList(messages: Message[], hasRemote: boolean): void
  onGetRemoteList(messages: Message[]): void
  onGetRemoteListError(errorCode: number): void
}
/**
 * Defines the Download Media Message Progress Callback alias.
 *
 * Example:
 * ```ts
 * const callback: DownloadMediaMessageProgressCallback = (...args: unknown[]) => {}
 * ```
 */
export type DownloadMediaMessageProgressCallback = (progress: number, msg: Message) => void
/**
 * Defines the Download Media Message Success Callback alias.
 *
 * Example:
 * ```ts
 * const callback: DownloadMediaMessageSuccessCallback = (...args: unknown[]) => {}
 * ```
 */
export type DownloadMediaMessageSuccessCallback = (msg: Message) => void
/**
 * Defines the Download Media Message Error Callback alias.
 *
 * Example:
 * ```ts
 * const callback: DownloadMediaMessageErrorCallback = (...args: unknown[]) => {}
 * ```
 */
export type DownloadMediaMessageErrorCallback = (code: number) => void
/**
 * Defines the Download Media Message Cancel Callback alias.
 *
 * Example:
 * ```ts
 * const callback: DownloadMediaMessageCancelCallback = (...args: unknown[]) => {}
 * ```
 */
export type DownloadMediaMessageCancelCallback = (msg: Message) => void
/**
 * Defines the Mute Status Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MuteStatusCallback = (...args: unknown[]) => {}
 * ```
 */
export type MuteStatusCallback = (code: number, isMute: boolean, timezone: string, periods: TimePeriod[]) => void

/**
 * Declares the contract for Broadcast Message Callback.
 *
 * Example:
 * ```ts
 * const listener: BroadcastMessageCallback = {} as BroadcastMessageCallback
 * ```
 */
export interface BroadcastMessageCallback {
  onProgress(message: Message | null, code: number, processCount: number, totalCount: number): void
  onComplete(): void
}

/**
 * Represents Time Period.
 *
 * Example:
 * ```ts
 * const value = new TimePeriod()
 * ```
 */
export class TimePeriod {
  startTime: string = ''
  endTime: string = ''
}

/**
 * Defines the Get Message Direction constants.
 *
 * Example:
 * ```ts
 * const direction = GetMessageDirection.Backward
 * ```
 */
export enum GetMessageDirection {
  Backward = 0,
  Forward = 1
}

/**
 * Represents Get Message Options.
 *
 * Example:
 * ```ts
 * const value = new GetMessageOptions()
 * ```
 */
export class GetMessageOptions {
  count: number = 20
  time: number = 0
  direction: GetMessageDirection = GetMessageDirection.Backward
  contentTypes: string[] = []
  constructor() {
  }
}

/**
 * Represents Query Msg Options.
 *
 * Example:
 * ```ts
 * const value = new QueryMsgOptions()
 * ```
 */
export class QueryMsgOptions extends GetMessageOptions {
  count: number = 20
  startTime: number = 0
  isPositive: boolean = false
  contentTypes: string[] = []
  constructor() {
    super()
  }
}

/**
 * Represents Clear Msg Options.
 *
 * Example:
 * ```ts
 * const value = new ClearMsgOptions()
 * ```
 */
export class ClearMsgOptions {
  cleanTime: number = 0
  cleanScope: number = 0
  senderId: string = ''
  cleanTimeOffset: number = 0
}

/**
 * Represents Get Favorite Message Option.
 *
 * Example:
 * ```ts
 * const value = new GetFavoriteMessageOption()
 * ```
 */
export class GetFavoriteMessageOption {
  offset: string = ''
  count: number = 20
}

/**
 * Represents Search Params.
 *
 * Example:
 * ```ts
 * const value = new SearchParams()
 * ```
 */
export class SearchParams {
  conver?: Conversation
  keywords: string = ''
  msgTypes: string[] = []
  startTime: number = 0
  endTime: number = 0
  count: number = 50
  direction: GetMessageDirection = GetMessageDirection.Backward
}

/**
 * Defines the Msg Received Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgReceivedListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgReceivedListener = (msg: Message) => void
/**
 * Defines the Msg Recalled Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgRecalledListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgRecalledListener = (msg: Message) => void
/**
 * Defines the Msg Modified Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgModifiedListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgModifiedListener = (msg: Message) => void
/**
 * Defines the Msg Read Receipt Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgReadReceiptListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgReadReceiptListener = (conver: Conversation, msgIds: string[]) => void
/**
 * Defines the Msg Group Read Receipt Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgGroupReadReceiptListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgGroupReadReceiptListener = (conver: Conversation, messages: Map<string, GroupMessageReadInfo>) => void
/**
 * Defines the Msg Deleted Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgDeletedListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgDeletedListener = (conver: Conversation, msgIds: string[]) => void
/**
 * Defines the Msg Cleaned Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgCleanedListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgCleanedListener = (conver: Conversation, cleanTime: number, senderId: string) => void
/**
 * Defines the Msg Top Changed Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgTopChangedListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgTopChangedListener = (conver: Conversation, message: Message | null, operator: UserInfo | null, isTop: boolean, createdTime: number) => void
/**
 * Defines the Msg Destroy Time Update Listener alias.
 *
 * Example:
 * ```ts
 * const callback: MsgDestroyTimeUpdateListener = (...args: unknown[]) => {}
 * ```
 */
export type MsgDestroyTimeUpdateListener = (messageId: string, conver: Conversation, destroyTime: number) => void
