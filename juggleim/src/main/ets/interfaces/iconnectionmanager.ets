import { PushChannel } from '../entries/push'
import { CommonCallback } from './commoncallback'

export type ConnectionStatusListener = (status: number, reasonCode: number, userId: string) => void

export interface IConnectionManager {
  connect(token: string): void
  disconnect(): void
  registerPushToken(channel: PushChannel, token: string, callback?: CommonCallback): void
  addConnectStatusListener(l: ConnectionStatusListener): void
  removeConnectStatusListener(l: ConnectionStatusListener): void
}
