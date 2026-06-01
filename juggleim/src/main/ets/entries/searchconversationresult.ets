import { ConversationInfo } from './conversation'

/**
 * Represents Search Conversations Result.
 *
 * Example:
 * ```ts
 * const value = new SearchConversationsResult()
 * ```
 */
export class SearchConversationsResult {
  conversationInfo: ConversationInfo = new ConversationInfo()
  matchedCount: number = 0
}
