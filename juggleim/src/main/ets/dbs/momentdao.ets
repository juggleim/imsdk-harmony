import { relationalStore } from "@kit.ArkData"
import {
  GetMomentDirection,
  GetMomentOption,
  Moment,
  MomentComment,
  MomentMedia,
  MomentMediaType,
  MomentReaction
} from "../entries/moment"
import { UserInfo } from "../entries/user"
import { JimDbManager } from "./dbmanager"
import { JimDbUtil } from "./dbutil"

interface MomentRecord {
  momentId:string
  content:string
  mediaList:MomentMedia[]
  userInfo:UserInfo | null
  reactionList:MomentReaction[]
  commentList:MomentComment[]
  createTime:number
}

export class MomentDao {
  static instance:MomentDao = new MomentDao()
  private tableName:string = 'moments'

  private constructor() {
  }

  upsert(moment:Moment):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (moment_id, content, media_json, user_json, reaction_json, comment_json, create_time) VALUES (?,?,?,?,?,?,?)`
    let record = this.toRecord(moment)
    let args:Array<relationalStore.ValueType> = [
      record.momentId,
      record.content,
      JSON.stringify(record.mediaList),
      record.userInfo != null ? JSON.stringify(record.userInfo) : '',
      JSON.stringify(record.reactionList),
      JSON.stringify(record.commentList),
      record.createTime
    ]
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, args)
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  remove(momentId:string):number{
    let sql = `DELETE FROM ${this.tableName} WHERE moment_id=?`
    try{
      let value = JimDbManager.instance.getDb()?.executeSync(sql, [momentId])
      return value as number
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }
    return 0
  }

  getMoment(momentId:string):Moment | null{
    let sql = `SELECT * FROM ${this.tableName} WHERE moment_id=?`
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, [momentId])
      if(resultSet?.goToNextRow()){
        return this.toMoment(resultSet)
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return null
  }

  queryCachedMomentList(option:GetMomentOption):Moment[]{
    let sql = `SELECT * FROM ${this.tableName} WHERE 1=1`
    let args:Array<relationalStore.ValueType> = []
    if(option.userId.trim() != ''){
      sql = sql + ` AND json_extract(user_json, '$.userId')=?`
      args.push(option.userId.trim())
    }
    let anchorTime = option.startTime > 0 ? option.startTime : new Date().getTime()
    if(option.direction == GetMomentDirection.Forward){
      sql = sql + ` AND create_time>? ORDER BY create_time ASC`
    }else{
      sql = sql + ` AND create_time<? ORDER BY create_time DESC`
    }
    args.push(anchorTime)
    if(option.count > 0){
      sql = sql + ` LIMIT ${option.count}`
    }
    let resultSet:relationalStore.ResultSet|undefined
    let moments:Moment[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql, args)
      while(resultSet?.goToNextRow()){
        moments.push(this.toMoment(resultSet))
      }
      if(option.direction == GetMomentDirection.Backward){
        moments = moments.slice().sort((left, right)=>right.createTime - left.createTime)
      }
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] err:${e.message}`)
    }finally {
      resultSet?.close()
    }
    return moments
  }

  private toRecord(moment:Moment):MomentRecord{
    let record:MomentRecord = {
      momentId: moment.momentId,
      content: moment.content,
      mediaList: moment.mediaList.map((media)=>{
        let nextMedia = new MomentMedia()
        nextMedia.url = media.url
        nextMedia.type = media.type
        nextMedia.snapshotUrl = media.snapshotUrl
        nextMedia.height = media.height
        nextMedia.width = media.width
        nextMedia.duration = media.duration
        return nextMedia
      }),
      userInfo: moment.userInfo != null ? this.cloneUser(moment.userInfo) : null,
      reactionList: moment.reactionList.map((reaction)=>{
        let nextReaction = new MomentReaction()
        nextReaction.key = reaction.key
        nextReaction.userList = reaction.userList.map((user)=>this.cloneUser(user))
        return nextReaction
      }),
      commentList: moment.commentList.map((comment)=>{
        let nextComment = new MomentComment()
        nextComment.commentId = comment.commentId
        nextComment.momentId = comment.momentId
        nextComment.parentCommentId = comment.parentCommentId
        nextComment.content = comment.content
        nextComment.userInfo = comment.userInfo != null ? this.cloneUser(comment.userInfo) : null
        nextComment.parentUserInfo = comment.parentUserInfo != null ? this.cloneUser(comment.parentUserInfo) : null
        nextComment.createTime = comment.createTime
        return nextComment
      }),
      createTime: moment.createTime
    }
    return record
  }

  private toMoment(resultSet:relationalStore.ResultSet):Moment{
    let moment = new Moment()
    moment.momentId = JimDbUtil.toString(resultSet, 'moment_id')
    moment.content = JimDbUtil.toString(resultSet, 'content')
    moment.mediaList = this.decodeMediaList(JimDbUtil.toString(resultSet, 'media_json'))
    moment.userInfo = this.decodeUser(JimDbUtil.toString(resultSet, 'user_json'))
    moment.reactionList = this.decodeReactionList(JimDbUtil.toString(resultSet, 'reaction_json'))
    moment.commentList = this.decodeCommentList(JimDbUtil.toString(resultSet, 'comment_json'))
    moment.createTime = JimDbUtil.toNumber(resultSet, 'create_time')
    return moment
  }

  private cloneUser(user:UserInfo):UserInfo{
    let nextUser = new UserInfo()
    nextUser.userId = user.userId
    nextUser.nickname = user.nickname
    nextUser.userPortrait = user.userPortrait
    nextUser.userType = user.userType
    nextUser.updTime = user.updTime
    return nextUser
  }

  private decodeUser(data:string):UserInfo | null{
    if(data == ''){
      return null
    }
    try{
      let rawUser = JSON.parse(data) as UserInfo
      let user = new UserInfo()
      user.userId = rawUser.userId != undefined ? rawUser.userId : ''
      user.nickname = rawUser.nickname != undefined ? rawUser.nickname : ''
      user.userPortrait = rawUser.userPortrait != undefined ? rawUser.userPortrait : ''
      user.userType = rawUser.userType != undefined ? rawUser.userType : 0
      user.updTime = rawUser.updTime != undefined ? rawUser.updTime : 0
      return user
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] decodeUser err:${e.message}`)
    }
    return null
  }

  private decodeMediaList(data:string):MomentMedia[]{
    if(data == ''){
      return []
    }
    try{
      let rawMediaList = JSON.parse(data) as MomentMedia[]
      return rawMediaList.map((rawMedia)=>{
        let media = new MomentMedia()
        media.url = rawMedia.url != undefined ? rawMedia.url : ''
        media.type = rawMedia.type != undefined ? rawMedia.type : MomentMediaType.IMAGE
        media.snapshotUrl = rawMedia.snapshotUrl != undefined ? rawMedia.snapshotUrl : ''
        media.height = rawMedia.height != undefined ? rawMedia.height : 0
        media.width = rawMedia.width != undefined ? rawMedia.width : 0
        media.duration = rawMedia.duration != undefined ? rawMedia.duration : 0
        return media
      })
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] decodeMediaList err:${e.message}`)
    }
    return []
  }

  private decodeReactionList(data:string):MomentReaction[]{
    if(data == ''){
      return []
    }
    try{
      let rawReactionList = JSON.parse(data) as MomentReaction[]
      return rawReactionList.map((rawReaction)=>{
        let reaction = new MomentReaction()
        reaction.key = rawReaction.key != undefined ? rawReaction.key : ''
        let userList:UserInfo[] = []
        if(rawReaction.userList != undefined){
          rawReaction.userList.forEach((rawUser)=>{
            let user = new UserInfo()
            user.userId = rawUser.userId != undefined ? rawUser.userId : ''
            user.nickname = rawUser.nickname != undefined ? rawUser.nickname : ''
            user.userPortrait = rawUser.userPortrait != undefined ? rawUser.userPortrait : ''
            user.userType = rawUser.userType != undefined ? rawUser.userType : 0
            user.updTime = rawUser.updTime != undefined ? rawUser.updTime : 0
            userList.push(user)
          })
        }
        reaction.userList = userList
        return reaction
      })
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] decodeReactionList err:${e.message}`)
    }
    return []
  }

  private decodeCommentList(data:string):MomentComment[]{
    if(data == ''){
      return []
    }
    try{
      let rawCommentList = JSON.parse(data) as MomentComment[]
      return rawCommentList.map((rawComment)=>{
        let comment = new MomentComment()
        comment.commentId = rawComment.commentId != undefined ? rawComment.commentId : ''
        comment.momentId = rawComment.momentId != undefined ? rawComment.momentId : ''
        comment.parentCommentId = rawComment.parentCommentId != undefined ? rawComment.parentCommentId : ''
        comment.content = rawComment.content != undefined ? rawComment.content : ''
        comment.userInfo = rawComment.userInfo != undefined && rawComment.userInfo != null ? this.decodeUser(JSON.stringify(rawComment.userInfo)) : null
        comment.parentUserInfo = rawComment.parentUserInfo != undefined && rawComment.parentUserInfo != null ? this.decodeUser(JSON.stringify(rawComment.parentUserInfo)) : null
        comment.createTime = rawComment.createTime != undefined ? rawComment.createTime : 0
        return comment
      })
    }catch (e) {
      console.error(`jimsdk_db_fail. [${this.tableName}] decodeCommentList err:${e.message}`)
    }
    return []
  }
}
