import { GroupInfo, GroupMember } from '../entries/group'

export type GroupMembersCallback = (code: number, members: GroupMember[]) => void

export interface IGroupInfoManager {
  saveGroupInfo(grpInfo: GroupInfo): void
  getLocalGroupInfo(groupId: string): GroupInfo | null
  getGroupInfo(groupId: string): GroupInfo | null
  getLocalGroupMembers(groupId: string): GroupMember[]
  queryGroupMembers(groupId: string, callback: GroupMembersCallback): void
}
