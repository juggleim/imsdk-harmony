import { FriendInfo, UserInfo } from '../entries/user'
import { FriendInfoCallback, UserInfoCallback } from './userinfotypes'

export interface IUserInfoManager {
  saveUserInfo(userInfo: UserInfo): void
  getLocalUserInfo(userid: string): UserInfo | null
  getUserInfo(userid: string): Promise<UserInfo>
  getRemoteUserInfo(userid: string, callback: UserInfoCallback): void
  saveFriendInfo(friendInfo: FriendInfo): void
  getLocalFriendInfo(userid: string): FriendInfo | null
  getFriendInfo(userid: string): FriendInfo | null
  fetchFriendInfo(userid: string): Promise<FriendInfo>
  checkFriend(userid: string, callback: FriendInfoCallback): void
}
