/**
 * Represents Group Info.
 *
 * Example:
 * ```ts
 * const value = new GroupInfo()
 * ```
 */
export class GroupInfo{
  groupId:string = ''
  groupName:string = ''
  groupPortrait:string = ''
  updTime:number = 0
  constructor() {
  }
}

/**
 * Represents Group Member.
 *
 * Example:
 * ```ts
 * const value = new GroupMember()
 * ```
 */
export class GroupMember{
  groupId:string=''
  memberId:string=''
  displayName:string=''
  constructor() {
  }
}

/**
 * Represents Group Message Read Info.
 *
 * Example:
 * ```ts
 * const value = new GroupMessageReadInfo()
 * ```
 */
export class GroupMessageReadInfo{
  readCount:number = 0
  memberCount:number = 0
  constructor() {
  }
}

/**
 * Represents Group Message Member Read Detail.
 *
 * Example:
 * ```ts
 * const value = new GroupMessageMemberReadDetail()
 * ```
 */
export class GroupMessageMemberReadDetail{
  userId:string = ''
  nickname:string = ''
  portrait:string = ''
  readTime:number = 0
  constructor() {
  }
}

/**
 * Represents Group Message Read Info Detail.
 *
 * Example:
 * ```ts
 * const value = new GroupMessageReadInfoDetail()
 * ```
 */
export class GroupMessageReadInfoDetail{
  readCount:number = 0
  memberCount:number = 0
  readMembers:GroupMessageMemberReadDetail[] = []
  unreadMembers:GroupMessageMemberReadDetail[] = []
  constructor() {
  }
}
