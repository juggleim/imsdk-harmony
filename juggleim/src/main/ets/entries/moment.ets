import { UserInfo } from './user'

/**
 * Defines the Get Moment Direction constants.
 *
 * Example:
 * ```ts
 * const direction = GetMomentDirection.Backward
 * ```
 */
export enum GetMomentDirection {
  Backward = 0,
  Forward = 1
}

/**
 * Defines the Moment Media Type constants.
 *
 * Example:
 * ```ts
 * const mediaType = MomentMediaType.IMAGE
 * ```
 */
export enum MomentMediaType {
  IMAGE = 0,
  VIDEO = 1
}

/**
 * Represents Get Moment Option.
 *
 * Example:
 * ```ts
 * const value = new GetMomentOption()
 * ```
 */
export class GetMomentOption {
  startTime:number = 0
  count:number = 20
  direction:GetMomentDirection = GetMomentDirection.Backward
  userId:string = ''
}

/**
 * Represents Get Moment Comment Option.
 *
 * Example:
 * ```ts
 * const value = new GetMomentCommentOption()
 * ```
 */
export class GetMomentCommentOption {
  momentId:string = ''
  startTime:number = 0
  count:number = 20
  direction:GetMomentDirection = GetMomentDirection.Backward
}

/**
 * Represents Moment Media.
 *
 * Example:
 * ```ts
 * const value = new MomentMedia()
 * ```
 */
export class MomentMedia {
  url:string = ''
  type:MomentMediaType = MomentMediaType.IMAGE
  snapshotUrl:string = ''
  height:number = 0
  width:number = 0
  duration:number = 0
}

/**
 * Represents Moment Reaction.
 *
 * Example:
 * ```ts
 * const value = new MomentReaction()
 * ```
 */
export class MomentReaction {
  key:string = ''
  userList:UserInfo[] = []
}

/**
 * Represents Moment Comment.
 *
 * Example:
 * ```ts
 * const value = new MomentComment()
 * ```
 */
export class MomentComment {
  commentId:string = ''
  momentId:string = ''
  parentCommentId:string = ''
  content:string = ''
  userInfo:UserInfo | null = null
  parentUserInfo:UserInfo | null = null
  createTime:number = 0
}

/**
 * Represents Moment.
 *
 * Example:
 * ```ts
 * const value = new Moment()
 * ```
 */
export class Moment {
  momentId:string = ''
  content:string = ''
  mediaList:MomentMedia[] = []
  userInfo:UserInfo | null = null
  reactionList:MomentReaction[] = []
  commentList:MomentComment[] = []
  createTime:number = 0
}
