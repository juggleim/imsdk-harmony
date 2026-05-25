import http from '@ohos.net.http'
import { JuggleIm } from '../juggleim'
import { JimErrorCode } from '../entries/errcode'
import {
  GetMomentCommentOption,
  GetMomentDirection,
  GetMomentOption,
  Moment,
  MomentComment,
  MomentMedia,
  MomentMediaType,
  MomentReaction
} from '../entries/moment'
import { UserInfo } from '../entries/user'
import { CommonCallback } from '../interfaces/commoncallback'
import { IMomentManager } from '../interfaces/imomentmanager'
import {
  MomentCallback,
  MomentCommentCallback,
  MomentCommentsCallback,
  MomentReactionsCallback,
  MomentsCallback
} from '../interfaces/momenttypes'
import { JimDbManager } from '../dbs/dbmanager'

const MOMENT_TRACE_TAG:string = 'MOMENTTRACE'

interface MomentUserPayload {
  user_id?: string
  nickname?: string
  avatar?: string
  updated_time?: number
}

interface MomentMediaPayload {
  url?: string
  snapshot_url?: string
  type?: string | number
  height?: number
  width?: number
  duration?: number
}

interface MomentContentPayload {
  text?: string
  medias?: MomentMediaPayload[]
}

interface MomentCommentPayload {
  comment_id?: string
  moment_id?: string
  parent_comment_id?: string
  content?: MomentContentPayload
  user_info?: MomentUserPayload
  parent_user_info?: MomentUserPayload
  comment_time?: number
}

interface MomentReactionItemPayload {
  key?: string
  user_info?: MomentUserPayload
}

interface MomentPayload {
  moment_id?: string
  content?: MomentContentPayload
  user_info?: MomentUserPayload
  reactions?: MomentReactionItemPayload[]
  top_comments?: MomentCommentPayload[]
  moment_time?: number
}

interface MomentGatewayResponse<T> {
  code?: number
  msg?: string
  data?: T
}

interface MomentListPayload {
  items?: MomentPayload[]
  is_finished?: boolean
}

interface CommentListPayload {
  items?: MomentCommentPayload[]
  is_finished?: boolean
}

interface ReactionListPayload {
  items?: MomentReactionItemPayload[]
}

interface AddMomentResponsePayload {
  moment_id?: string
  moment_time?: number
  user_info?: MomentUserPayload
}

interface AddCommentResponsePayload {
  comment_id?: string
  comment_time?: number
  user_info?: MomentUserPayload
  parent_user_info?: MomentUserPayload
}

interface AddMomentRequestPayload {
  content: MomentContentPayload
}

interface RemoveMomentRequestPayload {
  moment_ids: string[]
}

interface AddCommentRequestPayload {
  moment_id: string
  parent_comment_id?: string
  content: MomentContentPayload
}

interface RemoveCommentRequestPayload {
  moment_id: string
  comment_ids: string[]
}

interface ReactionPayload {
  key: string
}

interface ReactionRequestPayload {
  moment_id: string
  reaction: ReactionPayload
}

interface MomentRequestHeaders {
  AppKey: string
  Authorization: string
  'Content-Type': string
}

export class MomentManager implements IMomentManager {
  private momentCache: Moment[] = []

  addMoment(content: string, mediaList: MomentMedia[], callback: MomentCallback): void {
    let requestContent: MomentContentPayload = {
      text: content
    }
    if (mediaList.length > 0) {
      requestContent.medias = mediaList.map((item) => {
        return this.toMediaPayload(item)
      })
    }
    let payload: AddMomentRequestPayload = {
      content: requestContent
    }
    this.request<AddMomentResponsePayload>('/momentgateway/moments/add', http.RequestMethod.POST, '', JSON.stringify(payload),
      (code, data) => {
        if (code != 0 || data == null) {
          callback(code, null)
          return
        }
        let moment = new Moment()
        moment.momentId = data.moment_id != undefined ? data.moment_id : ''
        moment.content = content
        moment.mediaList = mediaList.map((item) => {
          return this.cloneMedia(item)
        })
        moment.createTime = data.moment_time != undefined ? data.moment_time : 0
        moment.userInfo = this.parseUserInfo(data.user_info)
        this.replaceMoment(moment)
        callback(0, this.cloneMoment(moment))
      })
  }

  removeMoment(momentId: string, callback: CommonCallback): void {
    let payload: RemoveMomentRequestPayload = {
      moment_ids: [momentId]
    }
    this.request<Object>('/momentgateway/moments/del', http.RequestMethod.POST, '', JSON.stringify(payload), (code, _data) => {
      if (code == 0) {
        this.removeMomentFromCache(momentId)
      }
      callback(code)
    })
  }

  getCachedMomentList(option: GetMomentOption): Moment[] {
    let cachedMoments = JimDbManager.instance.getMomentDao().queryCachedMomentList(option)
    this.syncMomentCache(cachedMoments)
    return cachedMoments.map((item) => {
      return this.cloneMoment(item)
    })
  }

  getMomentList(option: GetMomentOption, callback: MomentsCallback): void {
    let query = this.buildMomentListQuery(option)
    this.request<MomentListPayload>('/momentgateway/moments/list', http.RequestMethod.GET, query, '', (code, data) => {
      if (code != 0 || data == null) {
        callback(code, [], true)
        return
      }
      let moments: Moment[] = []
      if (data.items != undefined) {
        data.items.forEach((item) => {
          let moment = this.parseMoment(item)
          if (moment != null) {
            moments.push(moment)
          }
        })
      }
      this.mergeMomentList(moments)
      callback(0, moments.map((item) => {
        return this.cloneMoment(item)
      }), data.is_finished != undefined ? data.is_finished : true)
    })
  }

  getMoment(momentId: string, callback: MomentCallback): void {
    let query = this.buildMomentInfoQuery(momentId)
    this.request<MomentPayload>('/momentgateway/moments/info', http.RequestMethod.GET, query, '', (code, data) => {
      if (code != 0 || data == null) {
        callback(code, null)
        return
      }
      let moment = this.parseMoment(data)
      if (moment != null) {
        this.replaceMoment(moment)
      }
      callback(0, moment != null ? this.cloneMoment(moment) : null)
    })
  }

  addComment(momentId: string, parentCommentId: string, content: string, callback: MomentCommentCallback): void {
    let requestContent: MomentContentPayload = {
      text: content
    }
    let payload: AddCommentRequestPayload = {
      moment_id: momentId,
      content: requestContent
    }
    if (parentCommentId != '') {
      payload.parent_comment_id = parentCommentId
    }
    this.request<AddCommentResponsePayload>('/momentgateway/moments/comments/add', http.RequestMethod.POST, '',
      JSON.stringify(payload), (code, data) => {
        if (code != 0 || data == null) {
          callback(code, null)
          return
        }
        let comment = new MomentComment()
        comment.commentId = data.comment_id != undefined ? data.comment_id : ''
        comment.momentId = momentId
        comment.parentCommentId = parentCommentId
        comment.content = content
        comment.userInfo = this.parseUserInfo(data.user_info)
        comment.parentUserInfo = this.parseUserInfo(data.parent_user_info)
        comment.createTime = data.comment_time != undefined ? data.comment_time : 0
        this.refreshMomentAfterMutation(momentId)
        callback(0, this.cloneComment(comment))
      })
  }

  removeComment(momentId: string, commentId: string, callback: CommonCallback): void {
    let payload: RemoveCommentRequestPayload = {
      moment_id: momentId,
      comment_ids: [commentId]
    }
    this.request<Object>('/momentgateway/moments/comments/del', http.RequestMethod.POST, '', JSON.stringify(payload),
      (code, _data) => {
        if (code == 0) {
          this.refreshMomentAfterMutation(momentId)
        }
        callback(code)
      })
  }

  getCommentList(option: GetMomentCommentOption, callback: MomentCommentsCallback): void {
    let query = this.buildCommentListQuery(option)
    this.request<CommentListPayload>('/momentgateway/moments/comments/list', http.RequestMethod.GET, query, '',
      (code, data) => {
        if (code != 0 || data == null) {
          callback(code, [], true)
          return
        }
        let comments: MomentComment[] = []
        if (data.items != undefined) {
          data.items.forEach((item) => {
            let comment = this.parseComment(item)
            if (comment != null) {
              comments.push(comment)
            }
          })
        }
        this.updateMomentComments(option.momentId, comments)
        callback(0, comments.map((item) => {
          return this.cloneComment(item)
        }), data.is_finished != undefined ? data.is_finished : true)
      })
  }

  addReaction(momentId: string, key: string, callback: CommonCallback): void {
    let payload: ReactionRequestPayload = {
      moment_id: momentId,
      reaction: {
        key: key
      }
    }
    this.request<Object>('/momentgateway/moments/reactions/add', http.RequestMethod.POST, '', JSON.stringify(payload),
      (code, _data) => {
        if (code == 0) {
          this.refreshMomentAfterMutation(momentId)
        }
        callback(code)
      })
  }

  removeReaction(momentId: string, key: string, callback: CommonCallback): void {
    let payload: ReactionRequestPayload = {
      moment_id: momentId,
      reaction: {
        key: key
      }
    }
    this.request<Object>('/momentgateway/moments/reactions/del', http.RequestMethod.POST, '', JSON.stringify(payload),
      (code, _data) => {
        if (code == 0) {
          this.refreshMomentAfterMutation(momentId)
        }
        callback(code)
      })
  }

  getReactionList(momentId: string, callback: MomentReactionsCallback): void {
    let query = this.buildMomentInfoQuery(momentId)
    this.request<ReactionListPayload>('/momentgateway/moments/reactions/list', http.RequestMethod.GET, query, '',
      (code, data) => {
        if (code != 0 || data == null) {
          callback(code, [], true)
          return
        }
        let reactions = this.parseReactionList(data.items)
        this.updateMomentReactions(momentId, reactions)
        callback(0, reactions.map((item) => {
          return this.cloneReaction(item)
        }), true)
      })
  }

  private buildMomentListQuery(option: GetMomentOption): string {
    let parts: string[] = []
    parts.push(`start=${this.encodeQueryValue(option.startTime)}`)
    parts.push(`limit=${this.encodeQueryValue(option.count)}`)
    parts.push(`order=${this.encodeQueryValue(option.direction == GetMomentDirection.Backward ? 0 : 1)}`)
    if (option.userId != '') {
      parts.push(`user_id=${this.encodeQueryValue(option.userId)}`)
    }
    return parts.join('&')
  }

  private buildCommentListQuery(option: GetMomentCommentOption): string {
    let parts: string[] = []
    parts.push(`moment_id=${this.encodeQueryValue(option.momentId)}`)
    parts.push(`start=${this.encodeQueryValue(option.startTime)}`)
    parts.push(`limit=${this.encodeQueryValue(option.count)}`)
    parts.push(`order=${this.encodeQueryValue(option.direction == GetMomentDirection.Backward ? 0 : 1)}`)
    return parts.join('&')
  }

  private buildMomentInfoQuery(momentId: string): string {
    return `moment_id=${this.encodeQueryValue(momentId)}`
  }

  private encodeQueryValue(value: number | string): string {
    return encodeURIComponent(value.toString())
  }

  private request<T>(subUrl: string, method: http.RequestMethod, query: string, body: string,
    callback: (code: number, data: T | null) => void): void {
    let baseUrl = this.getBaseUrl()
    let token = JuggleIm.instance.config.authToken
    if (baseUrl == '' || token == '' || JuggleIm.instance.config.appkey == '') {
      console.log(`${MOMENT_TRACE_TAG} request_skip: url=${subUrl}, baseUrl=${baseUrl}, tokenLength=${token.length}, appkey=${JuggleIm.instance.config.appkey}`)
      callback(new JimErrorCode().MomentRequestError, null)
      return
    }
    let url = `${baseUrl}${subUrl}`
    if (query != '') {
      url = `${url}?${query}`
    }
    let requestHeaders: MomentRequestHeaders = {
      AppKey: JuggleIm.instance.config.appkey,
      Authorization: token,
      'Content-Type': 'application/json; charset=UTF-8'
    }
    let httpRequest = http.createHttp()
    console.log(`${MOMENT_TRACE_TAG} request_start: method=${method}, url=${url}, body=${body}`)
    httpRequest.request(url, {
      method: method,
      extraData: body,
      header: requestHeaders,
      expectDataType: http.HttpDataType.OBJECT,
      readTimeout: 30000,
      connectTimeout: 30000
    }, (err, response) => {
      if (err) {
        console.log(`${MOMENT_TRACE_TAG} request_error: url=${url}, err=${JSON.stringify(err)}`)
        callback(new JimErrorCode().MomentRequestError, null)
        httpRequest.destroy()
        return
      }
      if (response.responseCode != 200) {
        console.log(`${MOMENT_TRACE_TAG} request_http_error: url=${url}, httpCode=${response.responseCode}`)
        callback(new JimErrorCode().MomentRequestError, null)
        httpRequest.destroy()
        return
      }
      let result = response.result as MomentGatewayResponse<T>
      let code = result.code != undefined ? result.code : new JimErrorCode().MomentRequestError
      console.log(`${MOMENT_TRACE_TAG} request_finish: url=${url}, code=${code}, msg=${result.msg != undefined ? result.msg : ''}`)
      if (code != 0) {
        callback(new JimErrorCode().MomentRequestError, null)
      } else {
        callback(0, result.data != undefined ? result.data : null)
      }
      httpRequest.destroy()
    })
  }

  private getBaseUrl(): string {
    let baseUrl = JuggleIm.instance.config.appServerUrl
    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1)
    }
    return baseUrl
  }

  private parseMoment(data?: MomentPayload | null): Moment | null {
    if (data == undefined || data == null) {
      return null
    }
    let moment = new Moment()
    moment.momentId = data.moment_id != undefined ? data.moment_id : ''
    moment.content = data.content != undefined && data.content.text != undefined ? data.content.text : ''
    moment.userInfo = this.parseUserInfo(data.user_info)
    moment.mediaList = this.parseMediaList(data.content != undefined ? data.content.medias : undefined)
    moment.reactionList = this.parseReactionList(data.reactions)
    moment.commentList = this.parseCommentList(data.top_comments)
    moment.createTime = data.moment_time != undefined ? data.moment_time : 0
    return moment
  }

  private parseComment(data?: MomentCommentPayload | null): MomentComment | null {
    if (data == undefined || data == null) {
      return null
    }
    let comment = new MomentComment()
    comment.commentId = data.comment_id != undefined ? data.comment_id : ''
    comment.momentId = data.moment_id != undefined ? data.moment_id : ''
    comment.parentCommentId = data.parent_comment_id != undefined ? data.parent_comment_id : ''
    comment.content = data.content != undefined && data.content.text != undefined ? data.content.text : ''
    comment.userInfo = this.parseUserInfo(data.user_info)
    comment.parentUserInfo = this.parseUserInfo(data.parent_user_info)
    comment.createTime = data.comment_time != undefined ? data.comment_time : 0
    return comment
  }

  private parseCommentList(items?: MomentCommentPayload[]): MomentComment[] {
    let comments: MomentComment[] = []
    if (items == undefined) {
      return comments
    }
    items.forEach((item) => {
      let comment = this.parseComment(item)
      if (comment != null) {
        comments.push(comment)
      }
    })
    return comments
  }

  private parseReactionList(items?: MomentReactionItemPayload[]): MomentReaction[] {
    let reactions: MomentReaction[] = []
    if (items == undefined || items.length == 0) {
      return reactions
    }
    let groupedUsers: Map<string, UserInfo[]> = new Map()
    items.forEach((item) => {
      let key = item.key != undefined ? item.key : ''
      if (key == '') {
        return
      }
      let userList = groupedUsers.get(key)
      if (userList == undefined) {
        userList = []
        groupedUsers.set(key, userList)
      }
      let userInfo = this.parseUserInfo(item.user_info)
      if (userInfo != null) {
        userList.push(userInfo)
      }
    })
    groupedUsers.forEach((userList, key) => {
      let reaction = new MomentReaction()
      reaction.key = key
      reaction.userList = this.cloneUserList(userList)
      reactions.push(reaction)
    })
    return reactions
  }

  private parseMediaList(items?: MomentMediaPayload[]): MomentMedia[] {
    let medias: MomentMedia[] = []
    if (items == undefined) {
      return medias
    }
    items.forEach((item) => {
      let media = this.parseMedia(item)
      if (media != null) {
        medias.push(media)
      }
    })
    return medias
  }

  private parseMedia(data?: MomentMediaPayload | null): MomentMedia | null {
    if (data == undefined || data == null) {
      return null
    }
    let media = new MomentMedia()
    media.url = data.url != undefined ? data.url : ''
    media.snapshotUrl = data.snapshot_url != undefined ? data.snapshot_url : ''
    if (data.type == 'video' || data.type == 1) {
      media.type = MomentMediaType.VIDEO
    } else {
      media.type = MomentMediaType.IMAGE
    }
    media.height = data.height != undefined ? data.height : 0
    media.width = data.width != undefined ? data.width : 0
    media.duration = data.duration != undefined ? data.duration : 0
    return media
  }

  private parseUserInfo(data?: MomentUserPayload | null): UserInfo | null {
    if (data == undefined || data == null) {
      return null
    }
    let userInfo = new UserInfo()
    userInfo.userId = data.user_id != undefined ? data.user_id : ''
    userInfo.nickname = data.nickname != undefined ? data.nickname : ''
    userInfo.userPortrait = data.avatar != undefined ? data.avatar : ''
    userInfo.updTime = data.updated_time != undefined ? data.updated_time : 0
    return userInfo
  }

  private toMediaPayload(media: MomentMedia): MomentMediaPayload {
    return {
      url: media.url,
      snapshot_url: media.snapshotUrl,
      type: media.type == MomentMediaType.VIDEO ? 'video' : 'image',
      height: media.height,
      width: media.width,
      duration: media.duration
    }
  }

  private mergeMomentList(moments: Moment[]): void {
    moments.forEach((item) => {
      this.replaceMoment(item)
    })
  }

  private replaceMoment(moment: Moment): void {
    let target = this.cloneMoment(moment)
    let foundIndex = this.momentCache.findIndex((item) => {
      return item.momentId == target.momentId
    })
    if (foundIndex >= 0) {
      this.momentCache[foundIndex] = target
    } else {
      this.momentCache.push(target)
    }
    JimDbManager.instance.getMomentDao().upsert(target)
  }

  private removeMomentFromCache(momentId: string): void {
    this.momentCache = this.momentCache.filter((item) => {
      return item.momentId != momentId
    })
    JimDbManager.instance.getMomentDao().remove(momentId)
  }

  private updateMomentComments(momentId: string, comments: MomentComment[]): void {
    let moment = this.getCachedMomentById(momentId)
    if (moment == null) {
      return
    }
    let nextMoment = this.cloneMoment(moment)
    nextMoment.commentList = comments.map((item) => {
      return this.cloneComment(item)
    })
    this.replaceMoment(nextMoment)
  }

  private updateMomentReactions(momentId: string, reactions: MomentReaction[]): void {
    let moment = this.getCachedMomentById(momentId)
    if (moment == null) {
      return
    }
    let nextMoment = this.cloneMoment(moment)
    nextMoment.reactionList = reactions.map((item) => {
      return this.cloneReaction(item)
    })
    this.replaceMoment(nextMoment)
  }

  private refreshMomentAfterMutation(momentId: string): void {
    this.getMoment(momentId, (code, _moment) => {
      console.log(`${MOMENT_TRACE_TAG} refresh_after_mutation: momentId=${momentId}, code=${code}`)
    })
  }

  private filterCachedMomentList(option: GetMomentOption): Moment[] {
    let moments = this.momentCache.filter((item) => {
      if (option.userId != '') {
        return item.userInfo != null && item.userInfo.userId == option.userId
      }
      return true
    }).sort((left, right) => {
      return right.createTime - left.createTime
    })
    if (option.startTime > 0) {
      moments = moments.filter((item) => {
        if (option.direction == GetMomentDirection.Forward) {
          return item.createTime > option.startTime
        }
        return item.createTime < option.startTime
      })
    }
    if (option.count > 0 && moments.length > option.count) {
      return moments.slice(0, option.count)
    }
    return moments
  }

  private syncMomentCache(moments: Moment[]): void {
    this.momentCache = moments.map((item) => {
      return this.cloneMoment(item)
    })
  }

  private getCachedMomentById(momentId: string): Moment | null {
    for (let i = 0; i < this.momentCache.length; i++) {
      if (this.momentCache[i].momentId == momentId) {
        return this.cloneMoment(this.momentCache[i])
      }
    }
    let cachedMoment = JimDbManager.instance.getMomentDao().getMoment(momentId)
    if (cachedMoment == null) {
      return null
    }
    this.replaceMoment(cachedMoment)
    return this.cloneMoment(cachedMoment)
  }

  private cloneMoment(moment: Moment): Moment {
    let clone = new Moment()
    clone.momentId = moment.momentId
    clone.content = moment.content
    clone.createTime = moment.createTime
    clone.userInfo = this.cloneUserInfo(moment.userInfo)
    clone.mediaList = moment.mediaList.map((item) => {
      return this.cloneMedia(item)
    })
    clone.reactionList = moment.reactionList.map((item) => {
      return this.cloneReaction(item)
    })
    clone.commentList = moment.commentList.map((item) => {
      return this.cloneComment(item)
    })
    return clone
  }

  private cloneComment(comment: MomentComment): MomentComment {
    let clone = new MomentComment()
    clone.commentId = comment.commentId
    clone.momentId = comment.momentId
    clone.parentCommentId = comment.parentCommentId
    clone.content = comment.content
    clone.createTime = comment.createTime
    clone.userInfo = this.cloneUserInfo(comment.userInfo)
    clone.parentUserInfo = this.cloneUserInfo(comment.parentUserInfo)
    return clone
  }

  private cloneReaction(reaction: MomentReaction): MomentReaction {
    let clone = new MomentReaction()
    clone.key = reaction.key
    clone.userList = this.cloneUserList(reaction.userList)
    return clone
  }

  private cloneMedia(media: MomentMedia): MomentMedia {
    let clone = new MomentMedia()
    clone.url = media.url
    clone.snapshotUrl = media.snapshotUrl
    clone.type = media.type
    clone.height = media.height
    clone.width = media.width
    clone.duration = media.duration
    return clone
  }

  private cloneUserInfo(userInfo?: UserInfo | null): UserInfo | null {
    if (userInfo == undefined || userInfo == null) {
      return null
    }
    let clone = new UserInfo()
    clone.userId = userInfo.userId
    clone.nickname = userInfo.nickname
    clone.userPortrait = userInfo.userPortrait
    clone.userType = userInfo.userType
    clone.updTime = userInfo.updTime
    return clone
  }

  private cloneUserList(userList: UserInfo[]): UserInfo[] {
    let result: UserInfo[] = []
    userList.forEach((item) => {
      let clone = this.cloneUserInfo(item)
      if (clone != null) {
        result.push(clone)
      }
    })
    return result
  }
}
