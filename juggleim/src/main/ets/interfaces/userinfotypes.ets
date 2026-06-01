import { FriendInfo, UserInfo } from '../entries/user'

/**
 * Defines the User Info Callback alias.
 *
 * Example:
 * ```ts
 * const callback: UserInfoCallback = (...args: unknown[]) => {}
 * ```
 */
export type UserInfoCallback = (code: number, userInfo: UserInfo) => void
/**
 * Defines the Friend Info Callback alias.
 *
 * Example:
 * ```ts
 * const callback: FriendInfoCallback = (...args: unknown[]) => {}
 * ```
 */
export type FriendInfoCallback = (code: number, friendInfo: FriendInfo) => void
