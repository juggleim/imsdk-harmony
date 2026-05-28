import { ConversationInfo } from './conversation'

export class SearchConversationsResult {
  conversationInfo: ConversationInfo = new ConversationInfo()
  matchedCount: number = 0
}
