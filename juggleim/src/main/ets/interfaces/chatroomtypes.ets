export type ChatroomAttributesUpdateCallback = (errorCode: number, failedKeys: Map<string, number> | null) => void
export type ChatroomAttributesCallback = (errorCode: number, attributes: Map<string, string> | null) => void

export interface ChatroomListener {
  onChatroomJoin(chatroomId: string): void
  onChatroomQuit(chatroomId: string): void
  onChatroomJoinFail(chatroomId: string, errorCode: number): void
  onChatroomQuitFail(chatroomId: string, errorCode: number): void
  onChatroomKick(chatroomId: string): void
  onChatroomDestroy(chatroomId: string): void
}

export interface ChatroomAttributesListener {
  onAttributesUpdate(chatroomId: string, attributes: Map<string, string>): void
  onAttributesDelete(chatroomId: string, attributes: Map<string, string>): void
}
