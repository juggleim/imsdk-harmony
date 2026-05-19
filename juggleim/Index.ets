export { JuggleIm, JimConfig } from './src/main/ets/juggleim'

export { ConnectionStatusListener, IConnectionManager } from './src/main/ets/interfaces/iconnectionmanager'
export { IConversationManager } from './src/main/ets/interfaces/iconversationmanager'
export { IMessageManager } from './src/main/ets/interfaces/imessagemanager'
export { IUserInfoManager } from './src/main/ets/interfaces/iuserinfomanager'
export { IGroupInfoManager } from './src/main/ets/interfaces/igroupinfomanager'
export { CommonCallback } from './src/main/ets/interfaces/commoncallback'
export {
  ConversationAddListener,
  ConversationCallback,
  ConversationDeleteListener,
  ConversationInsertCallback,
  ConversationsCallback,
  ConversationUpdateListener,
  TopConverSortType,
  TotalUnreadCountCallback,
  TotalUnreadCountUpdateListener
} from './src/main/ets/interfaces/conversationtypes'
export {
  ClearMsgOptions,
  MessageCallback,
  MsgCleanedListener,
  MsgDeletedListener,
  MsgModifiedListener,
  MsgReceivedListener,
  MsgRecalledListener,
  QryMessagesCallback,
  QueryMsgOptions,
  SearchParams
} from './src/main/ets/interfaces/messagetypes'
export { UserInfoCallback } from './src/main/ets/interfaces/userinfotypes'

export { ConnStatus } from './src/main/ets/imclients/imclient'
export { Conversation, ConversationInfo, ConversationTag } from './src/main/ets/entries/conversation'
export {
  Message,
  MessageContent,
  MessageSentState,
  TextMessage,
  MergeMessage,
  PreviewUnit,
  VoiceMessage,
  ImageMessage,
  FileMessage,
  VideoMessage,
  RecallInfoMessage
} from './src/main/ets/entries/message'
export { JimMsgType } from './src/main/ets/entries/msgtypes'
export { UserInfo } from './src/main/ets/entries/user'
export { GroupInfo, GroupMember } from './src/main/ets/entries/group'
