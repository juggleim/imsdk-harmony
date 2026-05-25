import { Conversation, ConversationTag } from "../entries/conversation"
import { relationalStore } from "@kit.ArkData"
import { JimDbManager } from "./dbmanager"
import { JimDbUtil } from "./dbutil"

export class ConverTagDao{
  static instance:ConverTagDao = new ConverTagDao()
  private tableName:string = 'conversation_tags'
  private constructor() {
  }

  upsert(converTag:ConversationTag):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (tag_id,conver_type,conver_id,subchannel) VALUES (?,?,?,?)`
    let args:Array<relationalStore.ValueType> = [
      converTag.tagId,
      converTag.conversation.conversationType,
      converTag.conversation.conversationId,
      Conversation.normalizeSubChannel(converTag.conversation.subChannel)
    ]
    try{
      let row = JimDbManager.instance.getDb()?.executeSync(sql,args)
      return row as number
    }catch (e) {
    }
    return 0
  }

  addTag(conver:Conversation,tagId:string):number{
    let converTag = new ConversationTag()
    converTag.conversation = conver
    converTag.tagId = tagId
    return this.upsert(converTag)
  }

  removeTag(conver:Conversation,tagId:string):number{
    let pred = new relationalStore.RdbPredicates(this.tableName)
    pred.equalTo('conver_id',conver.conversationId)
    pred.equalTo('conver_type',conver.conversationType)
    pred.equalTo('subchannel', Conversation.normalizeSubChannel(conver.subChannel))
    pred.equalTo('tag_id',tagId)
    try{
      let row = JimDbManager.instance.getDb()?.deleteSync(pred)
      if(row != undefined){
        return row
      }
    }catch (e) {
    }
    return 0
  }

  clearTags(conver:Conversation):number{
    let pred = new relationalStore.RdbPredicates(this.tableName)
    pred.equalTo('conver_id',conver.conversationId)
    pred.equalTo('conver_type',conver.conversationType)
    pred.equalTo('subchannel', Conversation.normalizeSubChannel(conver.subChannel))
    try{
      let row = JimDbManager.instance.getDb()?.deleteSync(pred)
      if(row != undefined){
        return row
      }
    }catch (e) {
    }
    return 0
  }

  replaceTags(conver:Conversation,tags:ConversationTag[]):void{
    this.clearTags(conver)
    tags.forEach((tag)=>{
      if(tag.tagId != ''){
        tag.conversation = conver
        this.upsert(tag)
      }
    })
  }

  queryByConversation(conver:Conversation):ConversationTag[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE conver_type=? AND conver_id=? AND subchannel=? ORDER BY id ASC`
    let args:Array<relationalStore.ValueType> = [conver.conversationType, conver.conversationId, Conversation.normalizeSubChannel(conver.subChannel)]
    let resultSet:relationalStore.ResultSet|undefined
    let tags:ConversationTag[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while(resultSet?.goToNextRow()){
        tags.push(this.toConverTag(resultSet))
      }
    }catch (e) {
    }finally {
      resultSet?.close()
    }
    return tags
  }

  private toConverTag(resultSet:relationalStore.ResultSet):ConversationTag{
    let converTag = new ConversationTag()
    let converId = JimDbUtil.toString(resultSet,"conver_id")
    let converType = JimDbUtil.toNumber(resultSet,"conver_type")
    let subChannel = JimDbUtil.toString(resultSet,"subchannel")
    converTag.conversation = new Conversation(converId,converType, subChannel)
    converTag.tagId = JimDbUtil.toString(resultSet,"tag_id")
    return converTag
  }
}
