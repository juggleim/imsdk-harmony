export type ConnectionStatusListener = (status: number, reasonCode: number, userId: string) => void

export interface IConnectionManager {
  connect(token: string): void
  disconnect(): void
  addConnectStatusListener(l: ConnectionStatusListener): void
  removeConnectStatusListener(l: ConnectionStatusListener): void
}
