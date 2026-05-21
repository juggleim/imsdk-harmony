import { GroupMember } from "../entries/group"
import { relationalStore } from "@kit.ArkData"
import { JimDbUtil } from "./dbutil"
import { JimDbManager } from "./dbmanager"

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

  upsert(member:GroupMember):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (group_id,member_id,display_name) VALUES (?,?,?)`
    let args:Array<relationalStore.ValueType> = []
    args.push(member.groupId)
    args.push(member.memberId)
    args.push(member.displayName)
    try{
      let vt = JimDbManager.instance.getDb()?.executeSync(sql, args)
      return vt as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  queryGroupMembers(groupId:string):GroupMember[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE group_id=? ORDER BY member_id ASC`
    let args:Array<relationalStore.ValueType> = []
    args.push(groupId)
    let resultSet:relationalStore.ResultSet|undefined
    let members:GroupMember[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, args)
      while(resultSet?.goToNextRow()){
        members.push(this.toGroupMember(resultSet))
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return members
  }

  getGroupMember(groupId:string, memberId:string):GroupMember|null{
    let sql = `SELECT * FROM ${this.tableName} WHERE group_id=? AND member_id=? LIMIT 1`
    let args:Array<relationalStore.ValueType> = []
    args.push(groupId)
    args.push(memberId)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, args)
      if(resultSet?.goToNextRow()){
        return this.toGroupMember(resultSet)
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }
}
