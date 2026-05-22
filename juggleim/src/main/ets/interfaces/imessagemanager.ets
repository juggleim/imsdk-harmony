import { Conversation } from '../entries/conversation'
import { MessageContent } from '../entries/message'
import { MessageOptions } from '../entries/messageoptions'
import { CommonCallback } from './commoncallback'
import { IMessageUploadProvider, MediaUploadCredentialCallback } from './imessageuploadprovider'
import {
    BroadcastMessageCallback,
    ClearMsgOptions,
    DownloadMediaMessageCancelCallback,
    DownloadMediaMessageErrorCallback,
    DownloadMediaMessageProgressCallback,
    DownloadMediaMessageSuccessCallback,
    FavoriteMessagesCallback,
    GetFavoriteMessageOption,
  GetMessageOptions,
    GroupMessageReadInfoDetailCallback,
    MessageCallback,
    MessageReactionsCallback,
    MuteStatusCallback,
    MsgCleanedListener,
  MsgDeletedListener,
  MsgGroupReadReceiptListener,
  MsgModifiedListener,
  MsgReadReceiptListener,
  MsgReceivedListener,
  MsgRecalledListener,
  MsgTopChangedListener,
  QryMessagesCallback,
  QueryMsgOptions,
  SearchParams,
  TimePeriod,
  TopMessageCallback
} from './messagetypes'
import { HashMap } from '@kit.ArkTS'

export interface IMessageManager {
  addMsgReceivedListener(listener: MsgReceivedListener): void
  removeMsgReceivedListener(listener: MsgReceivedListener): void
  addMsgRecalledListener(listener: MsgRecalledListener): void
  removeMsgRecalledListener(listener: MsgRecalledListener): void
  addMsgModifiedListener(listener: MsgModifiedListener): void
  removeMsgModifiedListener(listener: MsgModifiedListener): void
  addReadReceiptListener(listener: MsgReadReceiptListener): void
  removeReadReceiptListener(listener: MsgReadReceiptListener): void
  addGroupReadReceiptListener(listener: MsgGroupReadReceiptListener): void
  removeGroupReadReceiptListener(listener: MsgGroupReadReceiptListener): void
  addMsgDeletedListener(listener: MsgDeletedListener): void
  removeMsgDeletedListener(listener: MsgDeletedListener): void
  addMsgCleanedListener(listener: MsgCleanedListener): void
  removeMsgCleanedListener(listener: MsgCleanedListener): void
  addMsgTopChangedListener(listener: MsgTopChangedListener): void
  removeMsgTopChangedListener(listener: MsgTopChangedListener): void
  registerMessage(msgType: string, constructor: Function): void
  setMessageUploadProvider(provider: IMessageUploadProvider | null): void
  getMessageUploadProvider(): IMessageUploadProvider | null
  addMessageReaction(messageId: string, reactionId: string, callback: CommonCallback): void
  removeMessageReaction(messageId: string, reactionId: string, callback: CommonCallback): void
  getMessagesReaction(conver: Conversation | null, msgIds: string[], callback: MessageReactionsCallback): void
  addFavorite(msgIds: string[], callback: CommonCallback): void
  removeFavorite(msgIds: string[], callback: CommonCallback): void
  getFavorite(option: GetFavoriteMessageOption, callback: FavoriteMessagesCallback): void
  broadcastMessage(msg: MessageContent, convers: Conversation[], callback: BroadcastMessageCallback): void
  setMute(isMute: boolean, periods: TimePeriod[], callback: CommonCallback): void
  getMuteStatus(callback: MuteStatusCallback): void
  setTop(messageId: string, conver: Conversation, isTop: boolean, callback: CommonCallback): void
  getTopMessage(conver: Conversation, callback: TopMessageCallback): void
  sendMessage(msg: MessageContent, conver: Conversation, callback: MessageCallback): void
  sendMessage(msg: MessageContent, conver: Conversation, options: MessageOptions, callback: MessageCallback): void
  sendMediaMessage(msg: MessageContent, conver: Conversation): void
  sendMediaMessage(msg: MessageContent, conver: Conversation, callback: MessageCallback): void
  downloadMediaMessage(
    messageId: string,
    onProgress: DownloadMediaMessageProgressCallback,
    onSuccess: DownloadMediaMessageSuccessCallback,
    onError: DownloadMediaMessageErrorCallback,
    onCancel: DownloadMediaMessageCancelCallback
  ): void
  cancelDownloadMediaMessage(messageId: string): void
  queryUploadFileCredential(fileType: number, ext: string, callback: MediaUploadCredentialCallback): void
  queryMessages(conver: Conversation, options: GetMessageOptions, callback: QryMessagesCallback): void
  queryLocalMessages(conver: Conversation, options: GetMessageOptions, callback: QryMessagesCallback): void
  queryRemoteMessages(conver: Conversation, options: GetMessageOptions, callback: QryMessagesCallback): void
  queryMentionMessages(conver: Conversation, count: number, startTime: number, isPositive: boolean, callback: QryMessagesCallback): void
  clearMessages(conver: Conversation, options: ClearMsgOptions, callback: CommonCallback): void
  delMessages(conver: Conversation, msgIds: string[], delScope: number, callback: CommonCallback): void
  getMessagesByMessageIds(conver: Conversation | null, msgIds: string[], callback: QryMessagesCallback): void
  getMessagesByIds(conver: Conversation | null, msgIds: string[], callback: QryMessagesCallback): void
  updateMessage(msgId: string, msg: MessageContent, conver: Conversation, callback: MessageCallback): void
  modifyMessage(conver: Conversation, msgId: string, msg: MessageContent, callback: MessageCallback): void
  sendReadReceipt(conver: Conversation, msgIds: string[], callback: CommonCallback): void
  getGroupMessageReadInfoDetail(conver: Conversation, msgId: string, callback: GroupMessageReadInfoDetailCallback): void
  recallMessage(conver: Conversation, msgId: string, extras: HashMap<string, string>, callback: MessageCallback): void
  searchMessages(params: SearchParams, callback: QryMessagesCallback): void
  setLocalAttribute(msgId: string, attribute: string): void
  getLocalAttribute(msgId: string): string
  setLocalAttribue(msgId: string, attribute: string): void
}
