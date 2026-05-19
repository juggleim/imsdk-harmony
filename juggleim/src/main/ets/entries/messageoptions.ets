import { UserInfo } from './user'

export enum MentionType {
  Default = 0,
  All = 1,
  Someone = 2,
  AllAndSomeone = 3
}

export class MessageMentionInfo {
  mentionType: MentionType = MentionType.Default
  targetUsers: UserInfo[] = []
}

export class PushData {
  title: string = ''
  content: string = ''
  extra: string = ''
}

export class MessageOptions {
  referredMessageId: string = ''
  mentionInfo?: MessageMentionInfo
  pushData?: PushData
  lifeTime: number = 0
  lifeTimeAfterRead: number = 0
}
