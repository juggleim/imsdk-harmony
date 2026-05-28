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

  getFriendList(friendIdList:string[]):FriendInfo[]{
    let requestIds:string[] = []
    friendIdList.forEach((friendId)=>{
      let normalizedFriendId = friendId.trim()
      if(normalizedFriendId != '' && requestIds.indexOf(normalizedFriendId) < 0){
        requestIds.push(normalizedFriendId)
      }
    })
    if(requestIds.length == 0){
      return []
    }
    let placeholders:string[] = []
    let args:Array<relationalStore.ValueType> = []
    requestIds.forEach((friendId)=>{
      placeholders.push('?')
      args.push(friendId)
    })
    let sql = `SELECT * FROM ${this.tableName} WHERE user_id IN (${placeholders.join(',')})`
    let resultSet:relationalStore.ResultSet|undefined
    let queriedFriends:FriendInfo[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        queriedFriends.push(this.toFriendInfo(resultSet))
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    let orderedFriends:FriendInfo[] = []
    requestIds.forEach((requestId)=>{
      for(let i = 0; i < queriedFriends.length; i++){
        let friend = queriedFriends[i]
        if(friend.userId == requestId){
          orderedFriends.push(friend)
          break
        }
      }
    })
    return orderedFriends
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
