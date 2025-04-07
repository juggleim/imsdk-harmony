import { UserInfo } from "../entries/user"
import { relationalStore } from "@kit.ArkData"
import { JimDbUtil } from "./dbutil"
import { GroupInfo } from "../entries/group"

export class GroupDao{
  static instance:GroupDao = new GroupDao()
  private tableName:string = 'groups'
  private constructor() {
  }

  private getValuesBucket(grp:GroupInfo):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "group_id":grp.groupId,
      "name":grp.groupName,
      "portrait":grp.groupPortrait,
      "upd_time":grp.updTime
    }
    return valuesBucket
  }

  private toGroupInfo(resultSet:relationalStore.ResultSet):GroupInfo{
    let grp = new GroupInfo()
    grp.groupId = JimDbUtil.toString(resultSet,"group_id")
    grp.groupName = JimDbUtil.toString(resultSet,"name")
    grp.groupPortrait = JimDbUtil.toString(resultSet,"portrait")
    grp.updTime = JimDbUtil.toNumber(resultSet, "upd_time")
    return grp
  }
}