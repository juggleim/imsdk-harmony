import { UserInfo } from "../entries/user"
import { relationalStore } from "@kit.ArkData"
import { JimDbUtil } from "./dbutil"

export class UserDao{
  static instance:UserDao = new UserDao()
  private tableName:string = 'users'
  private constructor() {
  }

  private getValuesBucket(user:UserInfo):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "user_id":user.userId,
      "name":user.nickname,
      "portrait":user.userPortrait,
      "user_type":user.userType
    }
    return valuesBucket
  }

  private toUser(resultSet:relationalStore.ResultSet):UserInfo{
    let user = new UserInfo()
    user.userId = JimDbUtil.toString(resultSet,"user_id")
    user.nickname = JimDbUtil.toString(resultSet,"name")
    user.userPortrait = JimDbUtil.toString(resultSet,"portrait")
    user.userType = JimDbUtil.toNumber(resultSet,"user_type")
    return user
  }
}