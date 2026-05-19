import { Conversation } from '../entries/conversation'
import { Message, MessageContent } from '../entries/message'

export type MessageCallback = (code: number, msg: Message | null) => void
export type QryMessagesCallback = (code: number, msgs: Message[], hasMore: boolean) => void

export class QueryMsgOptions {
  count: number = 20
  startTime: number = 0
  isPositive: boolean = false
  constructor() {
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
}

export type MsgReceivedListener = (msg: Message) => void
export type MsgRecalledListener = (msg: Message) => void
export type MsgModifiedListener = (msg: Message) => void
export type MsgDeletedListener = (conver: Conversation, msgIds: string[]) => void
export type MsgCleanedListener = (conver: Conversation, cleanTime: number, senderId: string) => void
