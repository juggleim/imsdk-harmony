import { UserInfo } from '../entries/user'
import { UserInfoCallback } from './userinfotypes'

export interface IUserInfoManager {
  saveUserInfo(userInfo: UserInfo): void
  getLocalUserInfo(userid: string): UserInfo | null
  getUserInfo(userid: string): Promise<UserInfo>
  getRemoteUserInfo(userid: string, callback: UserInfoCallback): void
}
