import { relationalStore } from "@kit.ArkData"
import { FriendInfo } from "../entries/user"
import { JimDbManager } from "./dbmanager"
import { JimDbUtil } from "./dbutil"

export class FriendDao {
  static instance:FriendDao = new FriendDao()
  private tableName:string = 'friends'

  private constructor() {
  }

  needUpdate(userId:string, updTime:number):boolean{
    let sql = `SELECT updated_time FROM ${this.tableName} WHERE user_id=?`
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, [userId])
      if(resultSet?.goToNextRow()){
        let currentUpdatedTime = JimDbUtil.toNumber(resultSet, 'updated_time')
        if(currentUpdatedTime >= updTime){
          return false
        }
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return true
  }

  getFriend(userId:string):FriendInfo | null{
    let sql = `SELECT * FROM ${this.tableName} WHERE user_id=?`
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, [userId])
      if(resultSet?.goToNextRow()){
        return this.toFriendInfo(resultSet)
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  upsert(friendInfo:FriendInfo):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (user_id, is_friend, alias, updated_time) VALUES (?,?,?,?)`
    let args:Array<relationalStore.ValueType> = [
      friendInfo.userId,
      friendInfo.isFriend ? 1 : 0,
      friendInfo.alias,
      friendInfo.updTime
    ]
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, args)
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  private toFriendInfo(resultSet:relationalStore.ResultSet):FriendInfo{
    let friendInfo = new FriendInfo()
    friendInfo.userId = JimDbUtil.toString(resultSet, 'user_id')
    friendInfo.isFriend = JimDbUtil.toNumber(resultSet, 'is_friend') > 0
    friendInfo.alias = JimDbUtil.toString(resultSet, 'alias')
    friendInfo.updTime = JimDbUtil.toNumber(resultSet, 'updated_time')
    return friendInfo
  }
}
