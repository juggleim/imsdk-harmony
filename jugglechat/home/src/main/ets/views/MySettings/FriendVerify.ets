import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base'
import { JimServer } from '../../jim/jimserver/jimserver'
import { FriendInfo, JuggleIm } from 'juggleim'

class FriendVerifyItem {
  userId: string = ''
  nickname: string = ''
  avatar: string = ''
  alias: string = ''
  friendStatus: string = '待校验'
  updatedText: string = '未更新'
}

@Component
export default struct FriendVerify {
  @State private userIdInput: string = ''
  @State private selectedUserId: string = ''
  @State private selectedNickname: string = ''
  @State private selectedStatus: string = '未查询'
  @State private selectedAlias: string = '-'
  @State private selectedUpdatedText: string = '-'
  @State private selectedHint: string = '输入 userId 后刷新好友资料'
  @State private selectedLoading: boolean = false
  @State private listLoading: boolean = false
  @State private listHint: string = '正在加载好友列表'
  @State private friendList: FriendVerifyItem[] = []

  aboutToAppear(): void {
    this.refreshFriendList()
  }

  private showToast(message: string): void {
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
  }

  private formatTime(timestamp: number): string {
    if (timestamp <= 0) {
      return '-'
    }
    let date = new Date(timestamp)
    let pad = (value: number): string => value < 10 ? `0${value}` : `${value}`
    return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`
  }

  private buildInitial(name: string, userId: string): string {
    let source = name != '' ? name : userId
    if (source == '') {
      return '?'
    }
    return source.charAt(0).toUpperCase()
  }

  private getStatusColor(status: string): string {
    if (status == '好友') {
      return '#047857'
    }
    if (status == '非好友') {
      return '#B91C1C'
    }
    return '#6B7280'
  }

  private getStatusBackground(status: string): string {
    if (status == '好友') {
      return '#D1FAE5'
    }
    if (status == '非好友') {
      return '#FEE2E2'
    }
    return '#E5E7EB'
  }

  private applySelectedFriend(friendInfo: FriendInfo, hint: string): void {
    this.selectedUserId = friendInfo.userId
    if (this.selectedNickname == '') {
      this.selectedNickname = friendInfo.userId
    }
    this.selectedStatus = friendInfo.isFriend ? '好友' : '非好友'
    this.selectedAlias = friendInfo.alias != '' ? friendInfo.alias : '-'
    this.selectedUpdatedText = this.formatTime(friendInfo.updTime)
    this.selectedHint = hint
  }

  private refreshSelectedFriendInfo(): void {
    let userId = this.userIdInput.trim()
    if (userId == '') {
      this.showToast('请输入 userId')
      return
    }
    this.selectedNickname = ''
    this.selectedLoading = true
    this.selectedHint = '正在查询'
    JuggleIm.instance.getUserInfoManager().queryFriendInfo(userId, (code, friendInfo) => {
      if (code != 0 || friendInfo == null) {
        this.selectedLoading = false
        this.selectedHint = '好友资料加载失败'
        this.showToast('好友资料加载失败')
        return
      }
      this.applySelectedFriend(friendInfo, '资料已刷新')
      this.selectedLoading = false
    })
  }

  private checkSelectedFriend(): void {
    let userId = this.userIdInput.trim()
    if (userId == '') {
      this.showToast('请输入 userId')
      return
    }
    this.selectedNickname = ''
    this.selectedLoading = true
    this.selectedHint = '正在校验'
    JuggleIm.instance.getUserInfoManager().checkFriend(userId, (code, friendInfo) => {
      if (code != 0 || friendInfo == null) {
        this.selectedLoading = false
        this.selectedHint = '好友校验失败'
        this.showToast('好友校验失败')
        return
      }
      this.applySelectedFriend(friendInfo, '好友状态已校验')
      this.selectedLoading = false
    })
  }

  private refreshSelectedFriend(keepNickname: boolean = false): void {
    let userId = this.userIdInput.trim()
    if (userId == '') {
      this.showToast('请输入 userId')
      return
    }
    if (!keepNickname) {
      this.selectedNickname = ''
    }
    this.selectedLoading = true
    this.selectedHint = '正在完整刷新'
    let cachedAlias = ''
    let cachedUpdatedAt = 0
    JuggleIm.instance.getUserInfoManager().queryFriendInfo(userId, (code, friendInfo) => {
      if (code == 0 && friendInfo != null) {
        cachedAlias = friendInfo.alias
        cachedUpdatedAt = friendInfo.updTime
      }
      JuggleIm.instance.getUserInfoManager().checkFriend(userId, (checkCode, checkFriendInfo) => {
        let finalInfo = checkFriendInfo ?? new FriendInfo()
        finalInfo.userId = userId
        if (cachedAlias != '' && finalInfo.alias == '') {
          finalInfo.alias = cachedAlias
        }
        if (cachedUpdatedAt > finalInfo.updTime) {
          finalInfo.updTime = cachedUpdatedAt
        }
        if (checkCode != 0 && code != 0) {
          this.selectedLoading = false
          this.selectedHint = '完整刷新失败'
          this.showToast('完整刷新失败')
          return
        }
        this.applySelectedFriend(finalInfo, '完整刷新完成')
        this.selectedLoading = false
      })
    })
  }

  private fillSelectedUser(userId: string, nickname: string): void {
    this.userIdInput = userId
    this.selectedNickname = nickname != '' ? nickname : userId
    this.refreshSelectedFriend(true)
  }

  private refreshFriendItem(userId: string, index: number): void {
    JuggleIm.instance.getUserInfoManager().queryFriendInfo(userId, (code, friendInfo) => {
      if (index < 0 || index >= this.friendList.length) {
        return
      }
      let current = this.friendList[index]
      if (current.userId != userId) {
        return
      }
      if (code != 0 || friendInfo == null) {
        current.friendStatus = '加载失败'
        current.updatedText = '未更新'
        this.friendList = this.friendList.slice()
        return
      }
      current.alias = friendInfo.alias != '' ? friendInfo.alias : '-'
      current.friendStatus = friendInfo.isFriend ? '好友' : '非好友'
      current.updatedText = this.formatTime(friendInfo.updTime)
      this.friendList = this.friendList.slice()
    })
  }

  private refreshFriendList(): void {
    this.listLoading = true
    this.listHint = '正在加载好友列表'
    this.friendList = []
    JimServer.instance.getFriendManager().QueryFriends(1, 100, '', (users) => {
      let next: FriendVerifyItem[] = []
      if (users.items.length == 0) {
        this.listLoading = false
        this.listHint = '暂无好友数据'
        this.friendList = []
        return
      }
      users.items.forEach((user) => {
        let item = new FriendVerifyItem()
        item.userId = user.user_id
        item.nickname = user.nickname
        item.avatar = user.avatar
        item.friendStatus = '查询中'
        item.updatedText = '未更新'
        next.push(item)
      })
      this.friendList = next
      this.listLoading = false
      this.listHint = `共 ${next.length} 位好友`
      next.forEach((item, index) => {
        this.refreshFriendItem(item.userId, index)
      })
    })
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              Text('校验好友')
                .fontSize(16)
                .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                .fontColor('#111827')
              TextInput({ text: this.userIdInput, placeholder: '输入 userId' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .margin({ top: 12 })
                .onChange((value: string) => {
                  this.userIdInput = value
                })

              Row() {
                Button('查询资料')
                  .layoutWeight(1)
                  .height(40)
                  .fontSize(14)
                  .fontColor(Color.White)
                  .backgroundColor('#4C8DFF')
                  .borderRadius(6)
                  .onClick(() => {
                    this.refreshSelectedFriendInfo()
                  })
                Button('校验好友')
                  .layoutWeight(1)
                  .height(40)
                  .fontSize(14)
                  .fontColor('#111827')
                  .backgroundColor('#E5E7EB')
                  .borderRadius(6)
                  .margin({ left: 12 })
                  .onClick(() => {
                    this.checkSelectedFriend()
                  })
              }
              .width('100%')
              .margin({ top: 12 })

              Button('完整刷新')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#10B981')
                .borderRadius(6)
                .margin({ top: 12 })
                .onClick(() => {
                  this.refreshSelectedFriend()
                })

              Text(this.selectedHint)
                .fontSize(13)
                .fontColor('#6B7280')
                .margin({ top: 12 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Row() {
                Text('当前结果')
                  .fontSize(16)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor('#111827')
                Blank()
                Text(this.selectedStatus)
                  .fontSize(12)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor(this.getStatusColor(this.selectedStatus))
                  .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                  .backgroundColor(this.getStatusBackground(this.selectedStatus))
                  .borderRadius(999)
              }
              .width('100%')

              Row() {
                Text('userId')
                  .fontSize(13)
                  .fontColor('#6B7280')
                Blank()
                Text(this.selectedUserId != '' ? this.selectedUserId : '-')
                  .fontSize(13)
                  .fontColor('#111827')
              }
              .width('100%')
              .margin({ top: 12 })

              Row() {
                Text('昵称')
                  .fontSize(13)
                  .fontColor('#6B7280')
                Blank()
                Text(this.selectedNickname != '' ? this.selectedNickname : '-')
                  .fontSize(13)
                  .fontColor('#111827')
              }
              .width('100%')
              .margin({ top: 12 })

              Row() {
                Text('备注')
                  .fontSize(13)
                  .fontColor('#6B7280')
                Blank()
                Text(this.selectedAlias)
                  .fontSize(13)
                  .fontColor('#111827')
              }
              .width('100%')
              .margin({ top: 12 })

              Row() {
                Text('最后更新')
                  .fontSize(13)
                  .fontColor('#6B7280')
                Blank()
                Text(this.selectedUpdatedText)
                  .fontSize(13)
                  .fontColor('#111827')
              }
              .width('100%')
              .margin({ top: 12 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Column() {
              Row() {
                Text('好友列表')
                  .fontSize(16)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor('#111827')
                Blank()
                Text(this.listHint)
                  .fontSize(12)
                  .fontColor('#6B7280')
              }
              .width('100%')

              Button(this.listLoading ? '加载中' : '刷新好友列表')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#4C8DFF')
                .borderRadius(6)
                .margin({ top: 12 })
                .onClick(() => {
                  this.refreshFriendList()
                })

              if (this.friendList.length == 0 && !this.listLoading) {
                Text('暂无好友数据')
                  .fontSize(13)
                  .fontColor('#6B7280')
                  .margin({ top: 16 })
              } else {
                Column() {
                  ForEach(this.friendList, (item: FriendVerifyItem, index: number) => {
                    Row() {
                      if (item.avatar != '') {
                        Image(item.avatar)
                          .width(40)
                          .height(40)
                          .borderRadius(20)
                      } else {
                        Stack() {
                          Text(this.buildInitial(item.nickname, item.userId))
                            .fontSize(15)
                            .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                            .fontColor(Color.White)
                        }
                        .width(40)
                        .height(40)
                        .backgroundColor('#4C8DFF')
                        .borderRadius(20)
                      }

                      Column() {
                        Text(item.nickname != '' ? item.nickname : item.userId)
                          .fontSize(15)
                          .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                          .fontColor('#111827')
                        Text(item.userId)
                          .fontSize(12)
                          .fontColor('#6B7280')
                          .margin({ top: 4 })
                      }
                      .layoutWeight(1)
                      .margin({ left: 12 })

                      Column() {
                        Text(item.friendStatus)
                          .fontSize(12)
                          .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                          .fontColor(this.getStatusColor(item.friendStatus))
                          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                          .backgroundColor(this.getStatusBackground(item.friendStatus))
                          .borderRadius(999)
                        Text(item.updatedText)
                          .fontSize(11)
                          .fontColor('#6B7280')
                          .margin({ top: 6 })
                      }
                      .alignItems(HorizontalAlign.End)
                    }
                    .width('100%')
                    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                    .onClick(() => {
                      this.fillSelectedUser(item.userId, item.nickname)
                    })

                    if (index != this.friendList.length - 1) {
                      Divider()
                        .width('100%')
                        .color('#E5E7EB')
                    }
                  }, (item: FriendVerifyItem, index: number) => item.userId + index)
                }
                .width('100%')
                .margin({ top: 12 })
              }
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12, bottom: 24 })
            .borderRadius(8)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 24 })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .backgroundColor('#F5F7FA')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .title('好友验证')
  }
}
