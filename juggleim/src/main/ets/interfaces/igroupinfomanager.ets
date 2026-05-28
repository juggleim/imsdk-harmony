import { GroupInfo, GroupMember } from '../entries/group'

export type GroupMembersCallback = (code: number, members: GroupMember[]) => void
export type GroupInfoCallback = (code: number, group: GroupInfo | null) => void
export type GroupMemberCallback = (code: number, member: GroupMember | null) => void

export interface IGroupInfoManager {
  saveGroupInfo(grpInfo: GroupInfo): void
  getLocalGroupInfo(groupId: string): GroupInfo | null
  getGroupInfoList(groupIdList: string[]): GroupInfo[]
  getGroupInfo(groupId: string): GroupInfo | null
  queryGroupInfo(groupId: string, callback: GroupInfoCallback): void
  getLocalGroupMember(groupId: string, memberId: string): GroupMember | null
  getGroupMember(groupId: string, memberId: string): GroupMember | null
  queryGroupMember(groupId: string, memberId: string, callback: GroupMemberCallback): void
  getLocalGroupMembers(groupId: string): GroupMember[]
  queryGroupMembers(groupId: string, callback: GroupMembersCallback): void
}
