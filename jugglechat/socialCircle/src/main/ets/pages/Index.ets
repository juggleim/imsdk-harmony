import { promptAction } from '@kit.ArkUI'
import { deviceInfo } from '@kit.BasicServicesKit'
import { BaseConstants, BreakpointConstants } from 'base'
import {
  GetMomentCommentOption,
  GetMomentDirection,
  GetMomentOption,
  JuggleIm,
  Moment,
  MomentComment,
  MomentMedia,
  MomentReaction
} from '@juggleim/imlib'

const MOMENT_REACTION_KEY:string = 'like'

@Entry
@Component
export struct SocialCircle {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM
  @State private moments: Moment[] = []
  @State private composeText: string = ''
  @State private refreshing: boolean = false
  @State private loading: boolean = false
  @State private loadingMore: boolean = false
  @State private publishing: boolean = false
  @State private finished: boolean = false
  @State private expandedMomentIds: string[] = []
  @State private activeCommentMomentId: string = ''
  @State private activeReplyCommentId: string = ''
  @State private activeReplyNickname: string = ''
  @State private commentDraft: string = ''
  @State private currentUserId: string = ''
  private scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.currentUserId = JuggleIm.instance.userId
    this.loadCachedMoments()
    this.reloadMoments()
  }

  @Builder
  refreshContent() {
    Text('刷新中...')
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .textAlign(TextAlign.Center)
      .fontSize(12)
      .fontColor('#667085')
  }

  private reloadMoments(): void {
    if (this.loading) {
      return
    }
    this.loading = true
    let option = new GetMomentOption()
    option.startTime = 0
    option.count = 20
    option.direction = GetMomentDirection.Backward
    JuggleIm.instance.getMomentManager().getMomentList(option, (code, _moments, isFinished) => {
      this.loading = false
      this.refreshing = false
      if (code != 0) {
        this.showToast(`刷新朋友圈失败: ${code}`)
        return
      }
      this.finished = isFinished
      this.loadCachedMoments()
    })
  }

  private loadMoreMoments(): void {
    if (this.loadingMore || this.finished || this.moments.length == 0) {
      return
    }
    this.loadingMore = true
    let option = new GetMomentOption()
    option.startTime = this.moments[this.moments.length - 1].createTime
    option.count = 20
    option.direction = GetMomentDirection.Backward
    JuggleIm.instance.getMomentManager().getMomentList(option, (code, _moments, isFinished) => {
      this.loadingMore = false
      if (code != 0) {
        this.showToast(`加载更多失败: ${code}`)
        return
      }
      this.finished = isFinished
      this.loadCachedMoments()
    })
  }

  private loadCachedMoments(): void {
    let option = new GetMomentOption()
    option.startTime = 0
    option.count = 100
    option.direction = GetMomentDirection.Backward
    let moments = JuggleIm.instance.getMomentManager().getCachedMomentList(option)
    this.moments = moments.sort((left, right) => {
      return right.createTime - left.createTime
    })
  }

  private publishMoment(): void {
    let content = this.composeText.trim()
    if (this.publishing) {
      return
    }
    if (content == '') {
      this.showToast('请输入朋友圈内容')
      return
    }
    this.publishing = true
    JuggleIm.instance.getMomentManager().addMoment(content, [], (code, moment) => {
      this.publishing = false
      if (code != 0 || moment == null) {
        this.showToast(`发布失败: ${code}`)
        return
      }
      this.composeText = ''
      this.upsertMoment(moment)
      this.showToast('已发布')
    })
  }

  private refreshMoment(momentId: string): void {
    JuggleIm.instance.getMomentManager().getMoment(momentId, (code, moment) => {
      if (code != 0 || moment == null) {
        this.showToast(`刷新动态失败: ${code}`)
        return
      }
      this.upsertMoment(moment)
    })
  }

  private toggleMomentLike(moment: Moment): void {
    let hasLiked = this.hasLiked(moment)
    let callback = (code: number) => {
      if (code != 0) {
        this.showToast(`${hasLiked ? '取消点赞' : '点赞'}失败: ${code}`)
        return
      }
      this.refreshMoment(moment.momentId)
    }
    if (hasLiked) {
      JuggleIm.instance.getMomentManager().removeReaction(moment.momentId, MOMENT_REACTION_KEY, callback)
    } else {
      JuggleIm.instance.getMomentManager().addReaction(moment.momentId, MOMENT_REACTION_KEY, callback)
    }
  }

  private deleteMoment(momentId: string): void {
    JuggleIm.instance.getMomentManager().removeMoment(momentId, (code) => {
      if (code != 0) {
        this.showToast(`删除失败: ${code}`)
        return
      }
      this.moments = this.moments.filter((item) => {
        return item.momentId != momentId
      })
      this.expandedMomentIds = this.expandedMomentIds.filter((item) => {
        return item != momentId
      })
      if (this.activeCommentMomentId == momentId) {
        this.resetCommentComposer()
      }
      this.showToast('已删除')
    })
  }

  private toggleComments(moment: Moment): void {
    let nextExpandedIds = this.expandedMomentIds.slice()
    let targetIndex = nextExpandedIds.indexOf(moment.momentId)
    if (targetIndex >= 0) {
      nextExpandedIds.splice(targetIndex, 1)
      if (this.activeCommentMomentId == moment.momentId) {
        this.resetCommentComposer()
      }
      this.expandedMomentIds = nextExpandedIds
      return
    }
    nextExpandedIds.push(moment.momentId)
    this.expandedMomentIds = nextExpandedIds
    this.loadMomentComments(moment.momentId)
  }

  private loadMomentComments(momentId: string): void {
    let option = new GetMomentCommentOption()
    option.momentId = momentId
    option.startTime = 0
    option.count = 50
    option.direction = GetMomentDirection.Backward
    JuggleIm.instance.getMomentManager().getCommentList(option, (code, comments, _isFinished) => {
      if (code != 0) {
        this.showToast(`加载评论失败: ${code}`)
        return
      }
      this.applyMomentComments(momentId, comments)
    })
  }

  private openCommentComposer(momentId: string, comment?: MomentComment): void {
    this.activeCommentMomentId = momentId
    this.activeReplyCommentId = ''
    this.activeReplyNickname = ''
    if (comment != undefined && comment.userInfo != null && comment.commentId != '') {
      this.activeReplyCommentId = comment.commentId
      this.activeReplyNickname = comment.userInfo.nickname
    }
    if (this.expandedMomentIds.indexOf(momentId) < 0) {
      let nextExpandedIds = this.expandedMomentIds.slice()
      nextExpandedIds.push(momentId)
      this.expandedMomentIds = nextExpandedIds
      this.loadMomentComments(momentId)
    }
  }

  private submitComment(moment: Moment): void {
    let content = this.commentDraft.trim()
    if (content == '') {
      this.showToast('请输入评论内容')
      return
    }
    JuggleIm.instance.getMomentManager().addComment(moment.momentId, this.activeReplyCommentId, content, (code, _comment) => {
      if (code != 0) {
        this.showToast(`评论失败: ${code}`)
        return
      }
      this.resetCommentComposer()
      this.loadMomentComments(moment.momentId)
      this.refreshMoment(moment.momentId)
    })
  }

  private deleteComment(moment: Moment, commentId: string): void {
    JuggleIm.instance.getMomentManager().removeComment(moment.momentId, commentId, (code) => {
      if (code != 0) {
        this.showToast(`删除评论失败: ${code}`)
        return
      }
      this.loadMomentComments(moment.momentId)
      this.refreshMoment(moment.momentId)
    })
  }

  private applyMomentComments(momentId: string, comments: MomentComment[]): void {
    let nextMoments = this.moments.slice()
    let targetIndex = nextMoments.findIndex((item) => {
      return item.momentId == momentId
    })
    if (targetIndex < 0) {
      return
    }
    nextMoments[targetIndex].commentList = comments
    this.moments = nextMoments
  }

  private upsertMoment(moment: Moment): void {
    let nextMoments = this.moments.slice()
    let targetIndex = nextMoments.findIndex((item) => {
      return item.momentId == moment.momentId
    })
    if (targetIndex >= 0) {
      nextMoments[targetIndex] = moment
    } else {
      nextMoments.unshift(moment)
    }
    this.moments = nextMoments.sort((left, right) => {
      return right.createTime - left.createTime
    })
  }

  private hasLiked(moment: Moment): boolean {
    if (this.currentUserId == '') {
      this.currentUserId = JuggleIm.instance.userId
    }
    let reaction = this.getLikeReaction(moment)
    if (reaction == null) {
      return false
    }
    return reaction.userList.some((item) => {
      return item.userId == this.currentUserId
    })
  }

  private getLikeReaction(moment: Moment): MomentReaction | null {
    let found = moment.reactionList.find((item) => {
      return item.key == MOMENT_REACTION_KEY
    })
    return found != undefined ? found : null
  }

  private isMomentExpanded(momentId: string): boolean {
    return this.expandedMomentIds.indexOf(momentId) >= 0
  }

  private canDeleteMoment(moment: Moment): boolean {
    return moment.userInfo != null && moment.userInfo.userId != '' && moment.userInfo.userId == this.currentUserId
  }

  private canDeleteComment(comment: MomentComment): boolean {
    return comment.userInfo != null && comment.userInfo.userId != '' && comment.userInfo.userId == this.currentUserId
  }

  private getCommentPlaceholder(): string {
    if (this.activeReplyNickname != '') {
      return `回复 ${this.activeReplyNickname}`
    }
    return '写评论'
  }

  private resetCommentComposer(): void {
    this.activeCommentMomentId = ''
    this.activeReplyCommentId = ''
    this.activeReplyNickname = ''
    this.commentDraft = ''
  }

  private formatMomentTime(time: number): string {
    if (time <= 0) {
      return ''
    }
    let date = new Date(time)
    let year = date.getFullYear()
    let month = this.padNumber(date.getMonth() + 1)
    let day = this.padNumber(date.getDate())
    let hour = this.padNumber(date.getHours())
    let minute = this.padNumber(date.getMinutes())
    return `${year}-${month}-${day} ${hour}:${minute}`
  }

  private padNumber(value: number): string {
    if (value < 10) {
      return `0${value}`
    }
    return `${value}`
  }

  private getAvatarText(name: string): string {
    if (name == '') {
      return '友'
    }
    return name.charAt(0)
  }

  private getAvatarColor(name: string): string {
    let colors: string[] = ['#D97706', '#2563EB', '#7C3AED', '#0F766E', '#DC2626', '#4F46E5']
    if (name == '') {
      return colors[0]
    }
    return colors[name.charCodeAt(0) % colors.length]
  }

  private getMomentOwnerName(moment: Moment): string {
    if (moment.userInfo == null || moment.userInfo.nickname == '') {
      return moment.userInfo != null && moment.userInfo.userId != '' ? moment.userInfo.userId : '未知用户'
    }
    return moment.userInfo.nickname
  }

  private getMomentAvatar(moment: Moment): string {
    return moment.userInfo != null ? moment.userInfo.userPortrait : ''
  }

  private getLikeCount(moment: Moment): number {
    let reaction = this.getLikeReaction(moment)
    if (reaction == null) {
      return 0
    }
    return reaction.userList.length
  }

  private getCommentUserName(comment: MomentComment): string {
    if (comment.userInfo == null) {
      return '用户'
    }
    if (comment.userInfo.nickname != '') {
      return comment.userInfo.nickname
    }
    if (comment.userInfo.userId != '') {
      return comment.userInfo.userId
    }
    return '用户'
  }

  private getCommentReplyText(comment: MomentComment): string {
    if (comment.parentUserInfo == null) {
      return ''
    }
    let parentName = comment.parentUserInfo.nickname != '' ? comment.parentUserInfo.nickname : comment.parentUserInfo.userId
    return ` 回复 ${parentName}`
  }

  private showToast(message: string): void {
    promptAction.showToast({
      message: message,
      duration: 1000,
      bottom: 120
    })
  }

  @Builder
  private composerPanel() {
    Column() {
      Row() {
        TextInput({ text: this.composeText, placeholder: '分享此刻' })
          .layoutWeight(1)
          .height(40)
          .padding({ left: 12, right: 12 })
          .backgroundColor('#F3F4F6')
          .borderRadius(8)
          .fontSize(14)
          .onChange((value: string) => {
            this.composeText = value
          })

        Text(this.publishing ? '发布中' : '发布')
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .padding({ left: 16, right: 16, top: 10, bottom: 10 })
          .backgroundColor(this.composeText.trim() == '' || this.publishing ? '#A5B4FC' : '#4F46E5')
          .borderRadius(8)
          .margin({ left: 12 })
          .onClick(() => {
            this.publishMoment()
          })
      }
      .width('100%')

      Row() {
        Text('下拉刷新，底部继续拉取历史动态')
          .fontSize(12)
          .fontColor('#667085')
          .layoutWeight(1)

        Text('刷新')
          .fontSize(12)
          .fontColor('#4F46E5')
          .onClick(() => {
            this.reloadMoments()
          })
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 12 })
    .backgroundColor(Color.White)
  }

  @Builder
  private avatarView(name: string, avatar: string) {
    if (avatar != '') {
      Image(avatar)
        .width(40)
        .height(40)
        .borderRadius(20)
    } else {
      Stack() {
        Text(this.getAvatarText(name))
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
      }
      .width(40)
      .height(40)
      .borderRadius(20)
      .backgroundColor(this.getAvatarColor(name))
    }
  }

  @Builder
  private momentCard(moment: Moment) {
    Column() {
      Row() {
        this.avatarView(this.getMomentOwnerName(moment), this.getMomentAvatar(moment))

        Column() {
          Row() {
            Text(this.getMomentOwnerName(moment))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111827')
              .layoutWeight(1)

            if (this.canDeleteMoment(moment)) {
              Text('删除')
                .fontSize(12)
                .fontColor('#DC2626')
                .onClick(() => {
                  this.deleteMoment(moment.momentId)
                })
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          Text(this.formatMomentTime(moment.createTime))
            .fontSize(12)
            .fontColor('#98A2B3')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      if (moment.content != '') {
        Text(moment.content)
          .width('100%')
          .fontSize(14)
          .fontColor('#1F2937')
          .lineHeight(22)
          .margin({ top: 12 })
      }

      if (moment.mediaList.length > 0) {
        Column() {
          ForEach(moment.mediaList, (media: MomentMedia, index: number) => {
            if (media.url != '') {
              Image(media.url)
                .width('100%')
                .constraintSize({ minHeight: 120, maxHeight: 260 })
                .objectFit(ImageFit.Cover)
                .borderRadius(8)
                .margin({ top: index == 0 ? 0 : 8 })
            }
          }, (_media: MomentMedia, index: number) => `${moment.momentId}_media_${index}`)
        }
        .width('100%')
        .margin({ top: 12 })
      }

      Row() {
        Row() {
          Text(this.hasLiked(moment) ? '取消点赞' : '点赞')
            .fontSize(13)
            .fontColor(this.hasLiked(moment) ? '#4F46E5' : '#475467')
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F8FAFC')
        .borderRadius(8)
        .onClick(() => {
          this.toggleMomentLike(moment)
        })

        Row() {
          Text(this.isMomentExpanded(moment.momentId) ? '收起评论' : '查看评论')
            .fontSize(13)
            .fontColor('#475467')
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F8FAFC')
        .borderRadius(8)
        .margin({ left: 8 })
        .onClick(() => {
          this.toggleComments(moment)
        })

        Row() {
          Text('评论')
            .fontSize(13)
            .fontColor('#475467')
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F8FAFC')
        .borderRadius(8)
        .margin({ left: 8 })
        .onClick(() => {
          this.openCommentComposer(moment.momentId)
        })
      }
      .width('100%')
      .margin({ top: 12 })

      if (this.getLikeCount(moment) > 0) {
        Text(`点赞 ${this.getLikeCount(moment)}`)
          .fontSize(12)
          .fontColor('#4F46E5')
          .margin({ top: 12 })
      }

      if (this.isMomentExpanded(moment.momentId)) {
        Column() {
          if (moment.commentList.length == 0) {
            Text('暂无评论')
              .fontSize(12)
              .fontColor('#98A2B3')
              .width('100%')
          } else {
            ForEach(moment.commentList, (comment: MomentComment, index: number) => {
              this.commentItem(moment, comment, index)
            }, (comment: MomentComment, index: number) => `${moment.momentId}_${comment.commentId}_${index}`)
          }

          if (this.activeCommentMomentId == moment.momentId) {
            Row() {
              TextInput({ text: this.commentDraft, placeholder: this.getCommentPlaceholder() })
                .layoutWeight(1)
                .height(36)
                .padding({ left: 12, right: 12 })
                .backgroundColor(Color.White)
                .borderRadius(8)
                .fontSize(13)
                .onChange((value: string) => {
                  this.commentDraft = value
                })

              Text('发送')
                .fontSize(13)
                .fontColor(Color.White)
                .padding({ left: 14, right: 14, top: 8, bottom: 8 })
                .backgroundColor(this.commentDraft.trim() == '' ? '#A5B4FC' : '#4F46E5')
                .borderRadius(8)
                .margin({ left: 8 })
                .onClick(() => {
                  this.submitComment(moment)
                })
            }
            .width('100%')
            .margin({ top: 12 })
          }
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 12, bottom: 12 })
        .backgroundColor('#F8FAFC')
        .borderRadius(8)
        .margin({ top: 12 })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  @Builder
  private commentItem(moment: Moment, comment: MomentComment, index: number) {
    Row() {
      Column() {
        Text(`${this.getCommentUserName(comment)}${this.getCommentReplyText(comment)}`)
          .fontSize(12)
          .fontColor('#344054')
          .fontWeight(FontWeight.Medium)

        Text(comment.content)
          .fontSize(13)
          .fontColor('#1F2937')
          .lineHeight(20)
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .onClick(() => {
        this.openCommentComposer(moment.momentId, comment)
      })

      if (this.canDeleteComment(comment)) {
        Text('删除')
          .fontSize(12)
          .fontColor('#DC2626')
          .margin({ left: 8 })
          .onClick(() => {
            this.deleteComment(moment, comment.commentId)
          })
      }
    }
    .width('100%')
    .padding({ top: index == 0 ? 0 : 10 })
  }

  build() {
    Column() {
      this.composerPanel()

      Refresh({ refreshing: $$this.refreshing, builder: this.refreshContent }) {
        List({ scroller: this.scroller }) {
          if (this.moments.length == 0) {
            ListItem() {
              Column() {
                Text(this.loading ? '加载中...' : '暂无动态')
                  .fontSize(14)
                  .fontColor('#98A2B3')
              }
              .width('100%')
              .padding({ top: 72, bottom: 72 })
            }
          } else {
            ForEach(this.moments, (moment: Moment) => {
              ListItem() {
                this.momentCard(moment)
              }
              .padding({ left: 12, right: 12, top: 12 })
            }, (moment: Moment) => moment.momentId)

            ListItem() {
              Column() {
                if (this.finished) {
                  Text('没有更多动态了')
                    .fontSize(12)
                    .fontColor('#98A2B3')
                } else {
                  Text(this.loadingMore ? '加载中...' : '加载更多')
                    .fontSize(12)
                    .fontColor('#4F46E5')
                    .onClick(() => {
                      this.loadMoreMoments()
                    })
                }
              }
              .width('100%')
              .padding({ top: 12, bottom: 24 })
            }
          }
        }
      }
      .onRefreshing(() => {
        setTimeout(() => {
          this.refreshing = true
          this.reloadMoments()
        }, 120)
      })
      .layoutWeight(1)
      .width('100%')
    }
    .backgroundColor('#F2F4F7')
    .height(BaseConstants.FULL_HEIGHT)
    .width(BaseConstants.FULL_WIDTH)
    .padding({
      top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? 0 : $r('app.float.device_padding_top')
    })
  }
}
