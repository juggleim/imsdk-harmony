/**
 * Defines the Chatroom Attributes Update Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ChatroomAttributesUpdateCallback = (...args: unknown[]) => {}
 * ```
 */
export type ChatroomAttributesUpdateCallback = (errorCode: number, failedKeys: Map<string, number> | null) => void
/**
 * Defines the Chatroom Attributes Callback alias.
 *
 * Example:
 * ```ts
 * const callback: ChatroomAttributesCallback = (...args: unknown[]) => {}
 * ```
 */
export type ChatroomAttributesCallback = (errorCode: number, attributes: Map<string, string> | null) => void

/**
 * Declares the contract for Chatroom Listener.
 *
 * Example:
 * ```ts
 * const listener: ChatroomListener = {} as ChatroomListener
 * ```
 */
export interface ChatroomListener {
  onChatroomJoin(chatroomId: string): void
  onChatroomQuit(chatroomId: string): void
  onChatroomJoinFail(chatroomId: string, errorCode: number): void
  onChatroomQuitFail(chatroomId: string, errorCode: number): void
  onChatroomKick(chatroomId: string): void
  onChatroomDestroy(chatroomId: string): void
}

/**
 * Declares the contract for Chatroom Attributes Listener.
 *
 * Example:
 * ```ts
 * const listener: ChatroomAttributesListener = {} as ChatroomAttributesListener
 * ```
 */
export interface ChatroomAttributesListener {
  onAttributesUpdate(chatroomId: string, attributes: Map<string, string>): void
  onAttributesDelete(chatroomId: string, attributes: Map<string, string>): void
}
