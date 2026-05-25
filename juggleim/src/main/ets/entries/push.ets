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
