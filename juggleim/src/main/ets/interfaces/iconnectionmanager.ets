import { PushChannel } from '../entries/push'
import { CommonCallback } from './commoncallback'

export type ConnectionStatusListener = (status: number, reasonCode: number, userId: string) => void

export interface ConnectionStatusObserver {
  onStatusChange(status: number, reasonCode: number, userId: string): void
  onDbOpen?(): void
  onDbClose?(): void
}

export type ConnectionStatusListenerValue = ConnectionStatusListener | ConnectionStatusObserver

export interface IConnectionManager {
  connect(token: string): void
  disconnect(receivePush?: boolean): void
  registerPushToken(channel: PushChannel, token: string, callback?: CommonCallback): void
  setLanguage(language: string): void
  getLanguage(): string
  getConnectionStatus(): number
  pushSwitch(isBackground: boolean): void
  setConnectParams(params: Map<string, string>): void
  setConnectParams(signKey: string, headers: Map<string, string>): void
  addConnectStatusListener(l: ConnectionStatusListenerValue): void
  addConnectStatusListener(key: string, l: ConnectionStatusListenerValue): void
  removeConnectStatusListener(l: ConnectionStatusListenerValue): void
  removeConnectStatusListener(key: string): void
}
