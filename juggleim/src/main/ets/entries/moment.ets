import { UserInfo } from './user'

export enum GetMomentDirection {
  Backward = 0,
  Forward = 1
}

export enum MomentMediaType {
  IMAGE = 0,
  VIDEO = 1
}

export class GetMomentOption {
  startTime:number = 0
  count:number = 20
  direction:GetMomentDirection = GetMomentDirection.Backward
  userId:string = ''
}

export class GetMomentCommentOption {
  momentId:string = ''
  startTime:number = 0
  count:number = 20
  direction:GetMomentDirection = GetMomentDirection.Backward
}

export class MomentMedia {
  url:string = ''
  type:MomentMediaType = MomentMediaType.IMAGE
  snapshotUrl:string = ''
  height:number = 0
  width:number = 0
  duration:number = 0
}

export class MomentReaction {
  key:string = ''
  userList:UserInfo[] = []
}

export class MomentComment {
  commentId:string = ''
  momentId:string = ''
  parentCommentId:string = ''
  content:string = ''
  userInfo:UserInfo | null = null
  parentUserInfo:UserInfo | null = null
  createTime:number = 0
}

export class Moment {
  momentId:string = ''
  content:string = ''
  mediaList:MomentMedia[] = []
  userInfo:UserInfo | null = null
  reactionList:MomentReaction[] = []
  commentList:MomentComment[] = []
  createTime:number = 0
}
