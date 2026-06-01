/**
 * Represents User Info.
 *
 * Example:
 * ```ts
 * const value = new UserInfo()
 * ```
 */
export class UserInfo{
  userId:string = ''
  nickname:string = ''
  userPortrait:string = ''
  userType:number = 0
  updTime:number = 0
  constructor() {
  }
}

/**
 * Represents Friend Info.
 *
 * Example:
 * ```ts
 * const value = new FriendInfo()
 * ```
 */
export class FriendInfo{
  userId:string = ''
  isFriend:boolean = false
  alias:string = ''
  updTime:number = 0

  constructor() {
  }
}
