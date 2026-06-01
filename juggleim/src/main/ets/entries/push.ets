/**
 * Defines the Push Channel constants.
 *
 * Example:
 * ```ts
 * const channel = PushChannel.Huawei
 * ```
 */
export enum PushChannel {
  DefaultChannel = 0,
  Apple = 1,
  Huawei = 2,
  Xiaomi = 3,
  Oppo = 4,
  Vivo = 5,
  FCM = 6,
  JPush = 7
}

/**
 * Provides the push Channel To Connect Name helper.
 *
 * Example:
 * ```ts
 * const connectName = pushChannelToConnectName(PushChannel.Huawei)
 * ```
 */
export function pushChannelToConnectName(channel: PushChannel): string {
  switch (channel) {
    case PushChannel.Huawei:
      return 'Huawei'
    case PushChannel.Xiaomi:
      return 'Xiaomi'
    case PushChannel.Oppo:
      return 'Oppo'
    case PushChannel.Vivo:
      return 'Vivo'
    case PushChannel.FCM:
      return 'FCM'
    case PushChannel.JPush:
      return 'Jpush'
    default:
      return ''
  }
}

/**
 * Provides the push Channel To Display Name helper.
 *
 * Example:
 * ```ts
 * const displayName = pushChannelToDisplayName(PushChannel.Huawei)
 * ```
 */
export function pushChannelToDisplayName(channel: PushChannel): string {
  switch (channel) {
    case PushChannel.Apple:
      return 'Apple'
    case PushChannel.Huawei:
      return 'Huawei'
    case PushChannel.Xiaomi:
      return 'Xiaomi'
    case PushChannel.Oppo:
      return 'Oppo'
    case PushChannel.Vivo:
      return 'Vivo'
    case PushChannel.FCM:
      return 'FCM'
    case PushChannel.JPush:
      return 'JPush'
    default:
      return 'Default'
  }
}
