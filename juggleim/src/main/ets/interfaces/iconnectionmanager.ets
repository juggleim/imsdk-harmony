import { PushChannel } from '../entries/push'
import { CommonCallback } from './commoncallback'

export type ConnectionStatusListener = (status: number, reasonCode: number, userId: string) => void

export interface IConnectionManager {
  connect(token: string): void
  disconnect(receivePush?: boolean): void
  registerPushToken(channel: PushChannel, token: string, callback?: CommonCallback): void
  setLanguage(language: string): void
  getLanguage(): string
  getConnectionStatus(): number
  setConnectParams(params: Map<string, string>): void
  addConnectStatusListener(l: ConnectionStatusListener): void
  removeConnectStatusListener(l: ConnectionStatusListener): void
}
