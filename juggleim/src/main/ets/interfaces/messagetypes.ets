import { Conversation } from '../entries/conversation'
import { Message, MessageContent } from '../entries/message'
import { GroupMessageReadInfo, GroupMessageReadInfoDetail } from '../entries/group'

export type MessageCallback = (code: number, msg: Message | null) => void
export type QryMessagesCallback = (code: number, msgs: Message[], hasMore: boolean) => void
export type GroupMessageReadInfoDetailCallback = (code: number, detail: GroupMessageReadInfoDetail | null) => void
export type DownloadMediaMessageProgressCallback = (progress: number, msg: Message) => void
export type DownloadMediaMessageSuccessCallback = (msg: Message) => void
export type DownloadMediaMessageErrorCallback = (code: number) => void
export type DownloadMediaMessageCancelCallback = (msg: Message) => void

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
