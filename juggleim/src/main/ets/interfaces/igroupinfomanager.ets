import { GroupInfo } from '../entries/group'

export interface IGroupInfoManager {
  saveGroupInfo(grpInfo: GroupInfo): void
  getLocalGroupInfo(groupId: string): GroupInfo | null
  getGroupInfo(groupId: string): GroupInfo | null
}
