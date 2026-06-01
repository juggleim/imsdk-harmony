import {
  ChatroomAttributesCallback,
  ChatroomAttributesListener,
  ChatroomAttributesUpdateCallback,
  ChatroomListener
} from './chatroomtypes'

/**
 * Declares the contract for I Chatroom Manager.
 *
 * Example:
 * ```ts
 * const manager = JuggleIm.instance.getChatroomManager()
 * ```
 */
export interface IChatroomManager {
  joinChatroom(chatroomId: string): void
  joinChatroom(chatroomId: string, prevMessageCount: number): void
  joinChatroom(chatroomId: string, prevMessageCount: number, isAutoCreate: boolean): void
  quitChatroom(chatroomId: string): void
  setAttributes(chatroomId: string, attributes: Map<string, string>, callback: ChatroomAttributesUpdateCallback): void
  removeAttributes(chatroomId: string, keys: string[], callback: ChatroomAttributesUpdateCallback): void
  getAllAttributes(chatroomId: string, callback: ChatroomAttributesCallback): void
  addListener(key: string, listener: ChatroomListener): void
  removeListener(key: string): void
  addAttributesListener(key: string, listener: ChatroomAttributesListener): void
  removeAttributesListener(key: string): void
}
