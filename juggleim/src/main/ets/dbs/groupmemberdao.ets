import { GroupMember } from "../entries/group"
import { relationalStore } from "@kit.ArkData"
import { JimDbUtil } from "./dbutil"

export class GroupMemberDao{
  static instance:GroupMemberDao = new GroupMemberDao()
  private tableName:string = 'group_members'
  private constructor() {
  }

  private getValuesBucket(member:GroupMember):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "group_id":member.groupId,
      "member_id":member.memberId,
      "display_name":member.displayName
    }
    return valuesBucket
  }

  private toGroupMember(resultSet:relationalStore.ResultSet):GroupMember{
    let grpMember = new GroupMember()
    grpMember.groupId = JimDbUtil.toString(resultSet,"group_id")
    grpMember.memberId = JimDbUtil.toString(resultSet,"member_id")
    grpMember.displayName = JimDbUtil.toString(resultSet,"display_name")
    return grpMember
  }
}