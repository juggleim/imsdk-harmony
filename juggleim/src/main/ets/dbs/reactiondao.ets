import { relationalStore } from "@kit.ArkData"
import { MessageReaction } from "../entries/message"
import { JimDbManager } from "./dbmanager"
import { JimDbUtil } from "./dbutil"

export class ReactionDao {
  static instance:ReactionDao = new ReactionDao()
  private tableName:string = 'message_reactions'

  private constructor() {
  }

  setReactions(messageId:string, reactions:MessageReaction[]):number{
    let normalizedMessageId = messageId.trim()
    if(normalizedMessageId == ''){
      return 0
    }
    if(reactions.length == 0){
      return this.removeReactions(normalizedMessageId)
    }
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (message_id, reactions) VALUES (?, ?)`
    let args:Array<relationalStore.ValueType> = [normalizedMessageId, this.encodeReactions(reactions)]
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, args)
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  removeReactions(messageId:string):number{
    let sql = `DELETE FROM ${this.tableName} WHERE message_id=?`
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, [messageId])
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  getReactions(messageId:string):MessageReaction[]{
    let sql = `SELECT reactions FROM ${this.tableName} WHERE message_id=?`
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, [messageId])
      if(resultSet?.goToNextRow()){
        return this.decodeReactions(JimDbUtil.toString(resultSet, 'reactions'))
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return []
  }

  private encodeReactions(reactions:MessageReaction[]):string{
    if(reactions.length == 0){
      return ''
    }
    let normalizedReactions:MessageReaction[] = []
    reactions.forEach((reaction)=>{
      let nextReaction = new MessageReaction()
      nextReaction.reactionId = reaction.reactionId
      nextReaction.userIds = reaction.userIds.slice()
      nextReaction.count = reaction.count
      nextReaction.isSelected = reaction.isSelected
      normalizedReactions.push(nextReaction)
    })
    return JSON.stringify(normalizedReactions)
  }

  private decodeReactions(reactionsStr:string):MessageReaction[]{
    if(reactionsStr == ''){
      return []
    }
    try{
      let rawReactions = JSON.parse(reactionsStr) as MessageReaction[]
      let reactions:MessageReaction[] = []
      rawReactions.forEach((reactionData)=>{
        let reaction = new MessageReaction()
        reaction.reactionId = reactionData.reactionId != undefined ? reactionData.reactionId : ''
        reaction.userIds = reactionData.userIds != undefined ? reactionData.userIds.slice() : []
        reaction.count = reactionData.count != undefined && reactionData.count > 0 ? reactionData.count : reaction.userIds.length
        reaction.isSelected = reactionData.isSelected == true
        if(reaction.reactionId != ''){
          reactions.push(reaction)
        }
      })
      return reactions
    }catch (e) {
      console.error(`jimsdk_reaction_decode_fail. [${this.tableName}] err:${e.message}`)
    }
    return []
  }
}
