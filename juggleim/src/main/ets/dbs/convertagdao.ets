import { Conversation, ConversationTag } from "../entries/conversation"
import { relationalStore } from "@kit.ArkData"
import { JimDbManager } from "./dbmanager"
import { JimDbUtil } from "./dbutil"

export class ConverTagDao{
  static instance:ConverTagDao = new ConverTagDao()
  private tableName:string = 'conversation_tags'
  private constructor() {
  }

  insert(converTag:ConversationTag):number{
    let valueBucket = this.getValuesBucket(converTag)
    try{
      let row = JimDbManager.instance.getDb()?.insertSync(this.tableName,valueBucket)
      if(row!==undefined){
        return row
      }
    }catch (e) {
    }
    return 0
  }

  private getValuesBucket(tag:ConversationTag):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket = {
      "tag_id":tag.tagId,
      "conver_type":tag.conversation.conversationType,
      "conver_id":tag.conversation.conversationId
    }
    return valuesBucket
  }

  private toConverTag(resultSet:relationalStore.ResultSet):ConversationTag{
    let converTag = new ConversationTag()
    let converId = JimDbUtil.toString(resultSet,"conver_id")
    let converType = JimDbUtil.toNumber(resultSet,"conver_type")
    converTag.conversation = new Conversation(converId,converType)
    converTag.tagId = JimDbUtil.toString(resultSet,"tag_id")
    return converTag
  }
}