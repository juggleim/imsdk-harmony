/**
 * Declares the contract for Users.
 *
 * Example:
 * ```ts
 * const users: Users = { items: [] }
 * ```
 */
export interface Users{
  items:User[]
}

/**
 * Declares the contract for User Settings.
 *
 * Example:
 * ```ts
 * const settings: UserSettings = { language: "", friend_verify_type: 0, grp_verify_type: 0, undisturb: "" }
 * ```
 */
export interface UserSettings{
  language:string
  friend_verify_type:number
  grp_verify_type:number,
  undisturb:string
}

/**
 * Declares the contract for User.
 *
 * Example:
 * ```ts
 * const user: User = { user_id: "", nickname: "", avatar: "" }
 * ```
 */
export interface User{
  user_id:string
  nickname:string
  avatar:string
  pinyin?:string
  phone?:string
  status?:number
  settings?:UserSettings
}