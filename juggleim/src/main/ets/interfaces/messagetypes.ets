import { Conversation } from '../entries/conversation'
import { FavoriteMessage, Message, MessageContent, MessageReactionResult } from '../entries/message'
import { GroupMessageReadInfo, GroupMessageReadInfoDetail } from '../entries/group'
import { SearchConversationsResult } from '../entries/searchconversationresult'
import { UserInfo } from '../entries/user'

export type MessageCallback = (code: number, msg: Message | null) => void
export type QryMessagesCallback = (code: number, msgs: Message[], hasMore: boolean) => void
export type GroupMessageReadInfoDetailCallback = (code: number, detail: GroupMessageReadInfoDetail | null) => void
export type MessageReactionsCallback = (code: number, items: MessageReactionResult[]) => void
export type FavoriteMessagesCallback = (code: number, items: FavoriteMessage[], offset: string) => void
export type TopMessageCallback = (code: number, message: Message | null, operator: UserInfo | null, createdTime: number) => void
export type ISearchConversationWithMessageContentCallback = (resultList: SearchConversationsResult[]) => void
export type IGetMessagesCallback = (code: number, messages: Message[]) => void
export interface IGetLocalAndRemoteMessagesCallback {
  onGetLocalList(messages: Message[], hasRemote: boolean): void
  onGetRemoteList(messages: Message[]): void
  onGetRemoteListError(errorCode: number): void
}
export type DownloadMediaMessageProgressCallback = (progress: number, msg: Message) => void
export type DownloadMediaMessageSuccessCallback = (msg: Message) => void
export type DownloadMediaMessageErrorCallback = (code: number) => void
export type DownloadMediaMessageCancelCallback = (msg: Message) => void
export type MuteStatusCallback = (code: number, isMute: boolean, timezone: string, periods: TimePeriod[]) => void

export interface BroadcastMessageCallback {
  onProgress(message: Message | null, code: number, processCount: number, totalCount: number): void
  onComplete(): void
}

export class TimePeriod {
  startTime: string = ''
  endTime: string = ''
}

export enum GetMessageDirection {
  Backward = 0,
  Forward = 1
}

export class GetMessageOptions {
  count: number = 20
  time: number = 0
  direction: GetMessageDirection = GetMessageDirection.Backward
  contentTypes: string[] = []
  constructor() {
  }
}

export class QueryMsgOptions extends GetMessageOptions {
  count: number = 20
  startTime: number = 0
  isPositive: boolean = false
  contentTypes: string[] = []
  constructor() {
    super()
  }
}

export class ClearMsgOptions {
  cleanTime: number = 0
  cleanScope: number = 0
  senderId: string = ''
  cleanTimeOffset: number = 0
}

export class GetFavoriteMessageOption {
  offset: string = ''
  count: number = 20
}

export class SearchParams {
  conver?: Conversation
  keywords: string = ''
  msgTypes: string[] = []
  startTime: number = 0
  endTime: number = 0
  count: number = 50
  direction: GetMessageDirection = GetMessageDirection.Backward
}

export type MsgReceivedListener = (msg: Message) => void
export type MsgRecalledListener = (msg: Message) => void
export type MsgModifiedListener = (msg: Message) => void
export type MsgReadReceiptListener = (conver: Conversation, msgIds: string[]) => void
export type MsgGroupReadReceiptListener = (conver: Conversation, messages: Map<string, GroupMessageReadInfo>) => void
export type MsgDeletedListener = (conver: Conversation, msgIds: string[]) => void
export type MsgCleanedListener = (conver: Conversation, cleanTime: number, senderId: string) => void
export type MsgTopChangedListener = (conver: Conversation, message: Message | null, operator: UserInfo | null, isTop: boolean, createdTime: number) => void
export type MsgDestroyTimeUpdateListener = (messageId: string, conver: Conversation, destroyTime: number) => void
