import { relationalStore } from "@kit.ArkData"
import { Conversation, ConversationTagInfo } from "../entries/conversation"
import { JimDbManager } from "./dbmanager"
import { JimDbUtil } from "./dbutil"

export class ConversationTagInfoDao {
  static instance:ConversationTagInfoDao = new ConversationTagInfoDao()
  private tableName:string = 'conversation_tag_infos'

  private constructor() {
  }

  upsert(tagInfo:ConversationTagInfo):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (tag_id, tag_name, tag_type) VALUES (?,?,?)`
    let args:Array<relationalStore.ValueType> = [tagInfo.tagId, tagInfo.tagName, tagInfo.tagType]
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, args)
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  remove(tagId:string):number{
    let sql = `DELETE FROM ${this.tableName} WHERE tag_id=?`
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, [tagId])
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  clearAll():number{
    let sql = `DELETE FROM ${this.tableName}`
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, [])
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  updateName(tagId:string, tagName:string):number{
    let sql = `UPDATE ${this.tableName} SET tag_name=? WHERE tag_id=?`
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, [tagName, tagId])
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  getTagInfo(tagId:string):ConversationTagInfo | null{
    let sql = `SELECT * FROM ${this.tableName} WHERE tag_id=?`
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, [tagId])
      if(resultSet?.goToNextRow()){
        return this.toTagInfo(resultSet)
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  queryAll():ConversationTagInfo[]{
    let sql = `SELECT * FROM ${this.tableName} ORDER BY tag_type ASC, tag_name ASC, tag_id ASC`
    let resultSet:relationalStore.ResultSet|undefined
    let tagInfos:ConversationTagInfo[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, [])
      while(resultSet?.goToNextRow()){
        tagInfos.push(this.toTagInfo(resultSet))
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return tagInfos
  }

  queryByConversation(conver:Conversation):ConversationTagInfo[]{
    let sql = `SELECT DISTINCT info.* FROM ${this.tableName} info
      INNER JOIN conversation_tags tags ON tags.tag_id = info.tag_id
      WHERE tags.conver_type=? AND tags.conver_id=? AND tags.subchannel=?
      ORDER BY info.tag_type ASC, info.tag_name ASC, info.tag_id ASC`
    let args:Array<relationalStore.ValueType> = [
      conver.conversationType,
      conver.conversationId,
      Conversation.normalizeSubChannel(conver.subChannel)
    ]
    let resultSet:relationalStore.ResultSet|undefined
    let tagInfos:ConversationTagInfo[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, args)
      while(resultSet?.goToNextRow()){
        tagInfos.push(this.toTagInfo(resultSet))
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return tagInfos
  }

  private toTagInfo(resultSet:relationalStore.ResultSet):ConversationTagInfo{
    let tagInfo = new ConversationTagInfo()
    tagInfo.tagId = JimDbUtil.toString(resultSet, 'tag_id')
    tagInfo.tagName = JimDbUtil.toString(resultSet, 'tag_name')
    tagInfo.tagType = JimDbUtil.toNumber(resultSet, 'tag_type')
    return tagInfo
  }
}
