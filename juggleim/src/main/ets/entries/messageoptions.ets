import { UserInfo } from './user'

/**
 * Defines the Mention Type constants.
 *
 * Example:
 * ```ts
 * const mentionType = MentionType.All
 * ```
 */
export enum MentionType {
  Default = 0,
  All = 1,
  Someone = 2,
  AllAndSomeone = 3
}

/**
 * Represents Message Mention Info.
 *
 * Example:
 * ```ts
 * const value = new MessageMentionInfo()
 * ```
 */
export class MessageMentionInfo {
  mentionType: MentionType = MentionType.Default
  targetUsers: UserInfo[] = []
}

/**
 * Represents Push Data.
 *
 * Example:
 * ```ts
 * const value = new PushData()
 * ```
 */
export class PushData {
  title: string = ''
  content: string = ''
  extra: string = ''
}

/**
 * Represents Message Options.
 *
 * Example:
 * ```ts
 * const value = new MessageOptions()
 * ```
 */
export class MessageOptions {
  referredMessageId: string = ''
  mentionInfo?: MessageMentionInfo
  pushData?: PushData
  lifeTime: number = 0
  lifeTimeAfterRead: number = 0
}
