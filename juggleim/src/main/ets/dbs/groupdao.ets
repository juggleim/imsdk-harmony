import { UserInfo } from "../entries/user"
import { relationalStore } from "@kit.ArkData"
import { JimDbUtil } from "./dbutil"
import { GroupInfo } from "../entries/group"
import { JimDbManager } from "./dbmanager"

export class GroupDao{
  static instance:GroupDao = new GroupDao()
  private tableName:string = 'groups'
  private constructor() {
  }

  needUpdate(groupId:string,updTime:number):boolean{
    let sql = `SELECT id,upd_time FROM ${this.tableName} WHERE group_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(groupId)
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

  getGroupInfo(groupId:string):GroupInfo|null{
    let sql = `SELECT group_id,name,portrait,upd_time FROM ${this.tableName} WHERE group_id=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(groupId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while (resultSet?.goToNextRow()){
        let group = this.toGroupInfo(resultSet)
        return group
      }
    }catch (e) {
      console.error("jimsdk_db_err:",this.tableName,`err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  upsert(grp:GroupInfo):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (group_id,name,portrait,upd_time) VALUES (?,?,?,?)`
    let args:Array<relationalStore.ValueType> = []
    args.push(grp.groupId)
    args.push(grp.groupName)
    args.push(grp.groupPortrait)
    args.push(grp.updTime)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return vt as number
    }catch (e) {
      console.error("jimsdk_db_fail. ", this.tableName,`err:${e.message}`)
    }
    return 0
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