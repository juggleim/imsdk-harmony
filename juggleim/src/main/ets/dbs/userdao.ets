import { UserInfo } from "../entries/user"
import { relationalStore } from "@kit.ArkData"
import { JimDbUtil } from "./dbutil"
import { JimDbManager } from "./dbmanager"

export class UserDao{
  static instance:UserDao = new UserDao()
  private tableName:string = 'users'
  private constructor() {
  }

  needUpdate(userId:string,updTime:number):boolean{
    let sql = `SELECT id,upd_time FROM ${this.tableName} WHERE user_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(userId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        let id = JimDbUtil.toNumber(resultSet,"id")
        let dbUpdTime = JimDbUtil.toNumber(resultSet,"upd_time")
        if(id>0&&dbUpdTime>=updTime){
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

  getUser(userId:string):UserInfo|null{
    let sql = `SELECT user_id,name,portrait,user_type,upd_time FROM ${this.tableName} WHERE user_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(userId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      console.log("jimsdk_qryu_sql:",sql)
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let user = this.toUser(resultSet)
        console.log("jimsdk_qryu_x",JSON.stringify(user))
        return user
      }
    }catch (e){
      console.error("jimsdk_db_err:",this.tableName,`err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  getUserList(userIdList:string[]):UserInfo[]{
    let requestIds:string[] = []
    userIdList.forEach((userId)=>{
      let normalizedUserId = userId.trim()
      if(normalizedUserId != '' && requestIds.indexOf(normalizedUserId) < 0){
        requestIds.push(normalizedUserId)
      }
    })
    if(requestIds.length == 0){
      return []
    }
    let placeholders:string[] = []
    let args:Array<relationalStore.ValueType> = []
    requestIds.forEach((userId)=>{
      placeholders.push('?')
      args.push(userId)
    })
    let sql = `SELECT user_id,name,portrait,user_type,upd_time FROM ${this.tableName} WHERE user_id IN (${placeholders.join(',')})`
    let resultSet:relationalStore.ResultSet|undefined
    let queriedUsers:UserInfo[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        queriedUsers.push(this.toUser(resultSet))
      }
    }catch (e){
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    let orderedUsers:UserInfo[] = []
    requestIds.forEach((requestId)=>{
      for(let i = 0; i < queriedUsers.length; i++){
        let user = queriedUsers[i]
        if(user.userId == requestId){
          orderedUsers.push(user)
          break
        }
      }
    })
    return orderedUsers
  }

  upsert(user:UserInfo):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (user_id,name,portrait,user_type,upd_time) VALUES (?,?,?,?,?)`
    let args:Array<relationalStore.ValueType> = []
    args.push(user.userId)
    args.push(user.nickname)
    args.push(user.userPortrait)
    args.push(user.userType)
    args.push(user.updTime)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error("jimsdk_upsert_fail. ",this.tableName,`err:${e.message}`,JSON.stringify(e))
    }
    return 0
  }

  private getValuesBucket(user:UserInfo):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "user_id":user.userId,
      "name":user.nickname,
      "portrait":user.userPortrait,
      "user_type":user.userType,
      "upd_time":user.updTime
    }
    return valuesBucket
  }

  private toUser(resultSet:relationalStore.ResultSet):UserInfo{
    let user = new UserInfo()
    user.userId = JimDbUtil.toString(resultSet,"user_id")
    user.nickname = JimDbUtil.toString(resultSet,"name")
    user.userPortrait = JimDbUtil.toString(resultSet,"portrait")
    user.userType = JimDbUtil.toNumber(resultSet,"user_type")
    user.updTime = JimDbUtil.toNumber(resultSet, "upd_time")
    return user
  }
}
