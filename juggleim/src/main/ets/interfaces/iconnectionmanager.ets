import { PushChannel } from '../entries/push'
import { CommonCallback } from './commoncallback'

/**
 * Defines the Connection Status Listener alias.
 *
 * Example:
 * ```ts
 * const callback: ConnectionStatusListener = (...args: unknown[]) => {}
 * ```
 */
export type ConnectionStatusListener = (status: number, reasonCode: number, userId: string) => void

/**
 * Declares the contract for Connection Status Observer.
 *
 * Example:
 * ```ts
 * const listener: ConnectionStatusObserver = {} as ConnectionStatusObserver
 * ```
 */
export interface ConnectionStatusObserver {
  onStatusChange(status: number, reasonCode: number, userId: string): void
  onDbOpen?(): void
  onDbClose?(): void
}

/**
 * Defines the Connection Status Listener Value alias.
 *
 * Example:
 * ```ts
 * const callback: ConnectionStatusListenerValue = (...args: unknown[]) => {}
 * ```
 */
export type ConnectionStatusListenerValue = ConnectionStatusListener | ConnectionStatusObserver

/**
 * Declares the contract for I Connection Manager.
 *
 * Example:
 * ```ts
 * const manager = JuggleIm.instance.getConnectionManager()
 * ```
 */
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
