import { Conversation } from './conversation'

/**
 * Represents Message Query Options.
 *
 * Example:
 * ```ts
 * const value = new MessageQueryOptions()
 * ```
 */
export class MessageQueryOptions {
  searchContent: string = ''
  senderUserIds: string[] = []
  contentTypes: string[] = []
  conversations: Conversation[] = []
  states: number[] = []
  direction: number = -1
  conversationTypes: number[] = []
}
