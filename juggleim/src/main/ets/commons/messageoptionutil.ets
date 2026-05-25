import { immessage } from '../improto/immessage'
import { Message } from '../entries/message'
import { MentionType, MessageMentionInfo, PushData } from '../entries/messageoptions'
import { Conversation } from '../entries/conversation'
import { UserInfo } from '../entries/user'
import { JimUtil } from './jimutil'

interface MentionTargetUserPayload {
  userId: string
  nickname: string
  userPortrait: string
}

interface MentionInfoPayload {
  mentionType: number
  targetUsers: MentionTargetUserPayload[]
}

interface MessageExtPayload {
  pushData?: PushData
  lifeTime: number
  lifeTimeAfterRead: number
}

export class MessageOptionUtil {
  static toProtoMentionType(mentionType: MentionType): immessage.MentionType {
    switch (mentionType) {
      case MentionType.All:
        return immessage.MentionType.All
      case MentionType.Someone:
        return immessage.MentionType.Someone
      case MentionType.AllAndSomeone:
        return immessage.MentionType.AllAndSomeone
      default:
        return immessage.MentionType.MentionDefault
    }
  }

  static fromProtoMentionType(mentionType?: immessage.MentionType | null): MentionType {
    switch (mentionType) {
      case immessage.MentionType.All:
        return MentionType.All
      case immessage.MentionType.Someone:
        return MentionType.Someone
      case immessage.MentionType.AllAndSomeone:
        return MentionType.AllAndSomeone
      default:
        return MentionType.Default
    }
  }

  static toProtoPushData(pushData?: PushData): immessage.IPushData | undefined {
    if (pushData == undefined) {
      return undefined
    }
    let result = immessage.PushData.create({})
    result.title = pushData.title
    result.pushText = pushData.content
    result.pushExtraData = pushData.extra
    return result
  }

  static fromProtoPushData(pushData?: immessage.IPushData | null): PushData | undefined {
    if (pushData == undefined || pushData == null) {
      return undefined
    }
    let result = new PushData()
    result.title = pushData.title as string
    result.content = pushData.pushText as string
    result.extra = pushData.pushExtraData as string
    return result
  }

  static toProtoMentionInfo(mentionInfo?: MessageMentionInfo): immessage.IMentionInfo | undefined {
    if (mentionInfo == undefined) {
      return undefined
    }
    let targetUsers: immessage.IUserInfo[] = []
    mentionInfo.targetUsers.forEach((user) => {
      let targetUser = immessage.UserInfo.create({})
      targetUser.userId = user.userId
      targetUser.nickname = user.nickname
      targetUser.userPortrait = user.userPortrait
      targetUser.userType = user.userType
      targetUser.updatedTime = user.updTime
      targetUsers.push(targetUser)
    })
    let result = immessage.MentionInfo.create({})
    result.mentionType = MessageOptionUtil.toProtoMentionType(mentionInfo.mentionType)
    result.targetUsers = targetUsers
    return result
  }

  static fromProtoMentionInfo(mentionInfo?: immessage.IMentionInfo | null): MessageMentionInfo | undefined {
    if (mentionInfo == undefined || mentionInfo == null) {
      return undefined
    }
    let result = new MessageMentionInfo()
    result.mentionType = MessageOptionUtil.fromProtoMentionType(mentionInfo.mentionType)
    let users: UserInfo[] = []
    if (mentionInfo.targetUsers != undefined) {
      mentionInfo.targetUsers.forEach((targetUser) => {
        let user = new UserInfo()
        user.userId = targetUser.userId as string
        user.nickname = targetUser.nickname as string
        user.userPortrait = targetUser.userPortrait as string
        user.userType = JimUtil.toNumber(targetUser.userType as number)
        user.updTime = JimUtil.toNumber(targetUser.updatedTime as number)
        users.push(user)
      })
    }
    result.targetUsers = users
    return result
  }

  static encodeMentionInfo(mentionInfo?: MessageMentionInfo): string {
    if (mentionInfo == undefined) {
      return ''
    }
    let payload: MentionInfoPayload = {
      mentionType: mentionInfo.mentionType,
      targetUsers: []
    }
    mentionInfo.targetUsers.forEach((user) => {
      payload.targetUsers.push({
        userId: user.userId,
        nickname: user.nickname,
        userPortrait: user.userPortrait
      })
    })
    return JSON.stringify(payload)
  }

  static decodeMentionInfo(value: string): MessageMentionInfo | undefined {
    if (value == '') {
      return undefined
    }
    let payload = JSON.parse(value) as MentionInfoPayload
    let mentionInfo = new MessageMentionInfo()
    mentionInfo.mentionType = payload.mentionType as MentionType
    let users: UserInfo[] = []
    if (payload.targetUsers != undefined) {
      payload.targetUsers.forEach((item) => {
        let user = new UserInfo()
        user.userId = item.userId
        user.nickname = item.nickname
        user.userPortrait = item.userPortrait
        users.push(user)
      })
    }
    mentionInfo.targetUsers = users
    return mentionInfo
  }

  static encodeMessageExt(message: Message): string {
    if (message.pushData == undefined && message.lifeTime <= 0 && message.lifeTimeAfterRead <= 0) {
      return ''
    }
    let payload: MessageExtPayload = {
      pushData: message.pushData,
      lifeTime: message.lifeTime,
      lifeTimeAfterRead: message.lifeTimeAfterRead
    }
    return JSON.stringify(payload)
  }

  static decodeMessageExt(value: string, message: Message): void {
    if (value == '') {
      return
    }
    let payload = JSON.parse(value) as MessageExtPayload
    if (payload.pushData != undefined) {
      let pushData = new PushData()
      pushData.title = payload.pushData.title
      pushData.content = payload.pushData.content
      pushData.extra = payload.pushData.extra
      message.pushData = pushData
    }
    message.lifeTime = payload.lifeTime
    message.lifeTimeAfterRead = payload.lifeTimeAfterRead
    if (message.lifeTime > 0) {
      message.destroyTime = message.sentTime + message.lifeTime
    }
  }

  static applyProtoOptions(message: Message, downMsg: immessage.IDownMsg, referMessage?: Message): void {
    message.pushData = MessageOptionUtil.fromProtoPushData(downMsg.pushData)
    message.mentionInfo = MessageOptionUtil.fromProtoMentionInfo(downMsg.mentionInfo)
    message.lifeTimeAfterRead = downMsg.lifeTimeAfterRead != undefined ?
      JimUtil.toNumber(downMsg.lifeTimeAfterRead as number) : 0
    message.destroyTime = downMsg.destroyTime != undefined ?
      JimUtil.toNumber(downMsg.destroyTime as number) : 0
    message.readTime = downMsg.readTime != undefined ?
      JimUtil.toNumber(downMsg.readTime as number) : 0
    message.isDeleted = downMsg.isDelete == true
    if (downMsg.referMsg != undefined && downMsg.referMsg != null) {
      message.referMsgId = downMsg.referMsg.msgId as string
      if (referMessage != undefined) {
        message.referredMessage = referMessage
      }
    }
  }

  static toProtoDownMsg(message: Message): immessage.IDownMsg {
    let protoMsg = immessage.DownMsg.create({})
    protoMsg.targetId = message.conversation.conversationId
    protoMsg.channelType = message.conversation.conversationType
    protoMsg.msgType = message.msgContent.getMsgType()
    protoMsg.senderId = message.senderId
    protoMsg.msgId = message.messageId
    protoMsg.msgSeqNo = message.msgSeqNo
    protoMsg.msgContent = message.msgContent.encode()
    protoMsg.msgTime = message.sentTime
    protoMsg.flags = message.flags
    protoMsg.clientUid = message.clientId
    protoMsg.pushData = MessageOptionUtil.toProtoPushData(message.pushData)
    protoMsg.mentionInfo = MessageOptionUtil.toProtoMentionInfo(message.mentionInfo)
    protoMsg.isRead = message.hasRead
    protoMsg.unreadIndex = message.msgUnreadIndex
    protoMsg.memberCount = message.memberCount
    protoMsg.SearchText = message.searchContent
    protoMsg.subChannel = Conversation.normalizeSubChannel(message.conversation.subChannel)
    return protoMsg
  }

}
