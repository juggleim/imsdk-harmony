import { GroupInfo, GroupMember } from '../entries/group'

/**
 * Defines the Group Members Callback alias.
 *
 * Example:
 * ```ts
 * const callback: GroupMembersCallback = (...args: unknown[]) => {}
 * ```
 */
export type GroupMembersCallback = (code: number, members: GroupMember[]) => void
/**
 * Defines the Group Info Callback alias.
 *
 * Example:
 * ```ts
 * const callback: GroupInfoCallback = (...args: unknown[]) => {}
 * ```
 */
export type GroupInfoCallback = (code: number, group: GroupInfo | null) => void
/**
 * Defines the Group Member Callback alias.
 *
 * Example:
 * ```ts
 * const callback: GroupMemberCallback = (...args: unknown[]) => {}
 * ```
 */
export type GroupMemberCallback = (code: number, member: GroupMember | null) => void

/**
 * Declares the contract for I Group Info Manager.
 *
 * Example:
 * ```ts
 * const manager = JuggleIm.instance.getGroupInfoManager()
 * ```
 */
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
