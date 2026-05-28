import { FriendInfo, UserInfo } from '../entries/user'

export type UserInfoCallback = (code: number, userInfo: UserInfo) => void
export type FriendInfoCallback = (code: number, friendInfo: FriendInfo) => void
