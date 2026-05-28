import { GroupInfo, GroupMember } from '../entries/group'
import { FriendInfo, UserInfo } from '../entries/user'
import { GroupInfoCallback, GroupMemberCallback, GroupMembersCallback } from './igroupinfomanager'
import { FriendInfoCallback, UserInfoCallback } from './userinfotypes'

export interface IUserInfoManager {
  saveUserInfo(userInfo: UserInfo): void
  getLocalUserInfo(userid: string): UserInfo | null
  getUserInfoList(userIdList: string[]): UserInfo[]
  getGroupInfoList(groupIdList: string[]): GroupInfo[]
  getFriendInfoList(friendIdList: string[]): FriendInfo[]
  getLocalGroupInfo(groupId: string): GroupInfo | null
  getGroupInfo(groupId: string): GroupInfo | null
  queryGroupInfo(groupId: string, callback: GroupInfoCallback): void
  getLocalGroupMember(groupId: string, memberId: string): GroupMember | null
  getGroupMember(groupId: string, memberId: string): GroupMember | null
  queryGroupMember(groupId: string, memberId: string, callback: GroupMemberCallback): void
  getLocalGroupMembers(groupId: string): GroupMember[]
  queryGroupMembers(groupId: string, callback: GroupMembersCallback): void
  getUserInfo(userid: string): Promise<UserInfo>
  getRemoteUserInfo(userid: string, callback: UserInfoCallback): void
  saveFriendInfo(friendInfo: FriendInfo): void
  getLocalFriendInfo(userid: string): FriendInfo | null
  getFriendInfo(userid: string): FriendInfo | null
  fetchFriendInfo(userid: string): Promise<FriendInfo>
  checkFriend(userid: string, callback: FriendInfoCallback): void
}
