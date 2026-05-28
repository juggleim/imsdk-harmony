import { Conversation } from './conversation'

export class MessageQueryOptions {
  searchContent: string = ''
  senderUserIds: string[] = []
  contentTypes: string[] = []
  conversations: Conversation[] = []
  states: number[] = []
  direction: number = -1
  conversationTypes: number[] = []
}
