import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base'
import { FriendInfo, JuggleIm } from '@juggleim/imlib'
import { FriendRequestRecord, FriendRequestStore } from '../../jim/friendrequeststore'

@Component
export default struct FriendRequestList {
  @State private requestUserId: string = ''
  @State private requestNickname: string = ''
  @State private requestMessage: string = '来自 Harmony demo 的好友申请'
  @State private requests: FriendRequestRecord[] = []
  @State private listHint: string = '暂无申请'

  aboutToAppear(): void {
    this.refreshRequests()
  }

  onPageShow(): void {
    this.refreshRequests()
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

  private getStatusText(status: string): string {
    if (status == 'accepted') {
      return '已通过'
    }
    if (status == 'rejected') {
      return '已拒绝'
    }
    return '待处理'
  }

  private getStatusColor(status: string): string {
    if (status == 'accepted') {
      return '#047857'
    }
    if (status == 'rejected') {
      return '#B91C1C'
    }
    return '#B45309'
  }

  private getStatusBackground(status: string): string {
    if (status == 'accepted') {
      return '#D1FAE5'
    }
    if (status == 'rejected') {
      return '#FEE2E2'
    }
    return '#FEF3C7'
  }

  private refreshRequests(): void {
    this.requests = FriendRequestStore.getRequests()
    this.listHint = this.requests.length > 0 ? `共 ${this.requests.length} 条记录` : '暂无申请'
  }

  private submitRequest(): void {
    let userId = this.requestUserId.trim()
    if (userId == '') {
      this.showToast('请输入 userId')
      return
    }
    let record = FriendRequestStore.submitRequest(userId, this.requestNickname.trim(), '', this.requestMessage.trim())
    if (record == null) {
      this.showToast('发送失败')
      return
    }
    this.requestUserId = ''
    this.requestNickname = ''
    this.requestMessage = '来自 Harmony demo 的好友申请'
    this.refreshRequests()
    this.showToast('已发送申请')
  }

  private markAccepted(record: FriendRequestRecord): void {
    FriendRequestStore.markAccepted(record.requestId)
    let friendInfo = new FriendInfo()
    friendInfo.userId = record.userId
    friendInfo.isFriend = true
    friendInfo.alias = record.nickname != '' ? record.nickname : ''
    friendInfo.updTime = Date.now()
    JuggleIm.instance.getUserInfoManager().saveFriendInfo(friendInfo)
    this.refreshRequests()
  }

  private markRejected(record: FriendRequestRecord): void {
    FriendRequestStore.markRejected(record.requestId)
    this.refreshRequests()
  }

  private resendRequest(record: FriendRequestRecord): void {
    FriendRequestStore.submitRequest(record.userId, record.nickname, record.avatar, record.message)
    this.refreshRequests()
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              Text('发起申请')
                .fontSize(16)
                .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                .fontColor('#111827')
              TextInput({ text: this.requestUserId, placeholder: '输入对方 userId' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .margin({ top: 12 })
                .onChange((value: string) => {
                  this.requestUserId = value
                })
              TextInput({ text: this.requestNickname, placeholder: '备注昵称，可选' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .margin({ top: 12 })
                .onChange((value: string) => {
                  this.requestNickname = value
                })
              TextInput({ text: this.requestMessage, placeholder: '验证消息' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .margin({ top: 12 })
                .onChange((value: string) => {
                  this.requestMessage = value
                })

              Button('发送申请')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#4C8DFF')
                .borderRadius(6)
                .margin({ top: 12 })
                .onClick(() => {
                  this.submitRequest()
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Row() {
                Text('申请记录')
                  .fontSize(16)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor('#111827')
                Blank()
                Text(this.listHint)
                  .fontSize(12)
                  .fontColor('#6B7280')
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              Button('刷新列表')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#10B981')
                .borderRadius(6)
                .margin({ top: 12 })
                .onClick(() => {
                  this.refreshRequests()
                })

              if (this.requests.length == 0) {
                Text('暂无申请记录')
                  .fontSize(13)
                  .fontColor('#6B7280')
                  .margin({ top: 16 })
              } else {
                Column() {
                  ForEach(this.requests, (record: FriendRequestRecord, index: number) => {
                    Column() {
                      Row() {
                        Column() {
                          Text(record.nickname != '' ? record.nickname : record.userId)
                            .fontSize(15)
                            .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                            .fontColor('#111827')
                          Text(record.userId)
                            .fontSize(12)
                            .fontColor('#6B7280')
                            .margin({ top: 4 })
                        }
                        .layoutWeight(1)

                        Text(this.getStatusText(record.status))
                          .fontSize(12)
                          .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                          .fontColor(this.getStatusColor(record.status))
                          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                          .backgroundColor(this.getStatusBackground(record.status))
                          .borderRadius(999)
                      }
                      .width('100%')

                      Text(record.message != '' ? record.message : '无验证消息')
                        .fontSize(13)
                        .fontColor('#374151')
                        .margin({ top: 10 })

                      Row() {
                        Text(this.formatTime(record.createdAt))
                          .fontSize(11)
                          .fontColor('#6B7280')
                        Blank()

                        if (record.status == 'pending') {
                          Button('同意')
                            .height(32)
                            .fontSize(13)
                            .fontColor(Color.White)
                            .backgroundColor('#4C8DFF')
                            .borderRadius(6)
                            .onClick(() => {
                              this.markAccepted(record)
                            })
                          Button('拒绝')
                            .height(32)
                            .fontSize(13)
                            .fontColor('#111827')
                            .backgroundColor('#E5E7EB')
                            .borderRadius(6)
                            .margin({ left: 8 })
                            .onClick(() => {
                              this.markRejected(record)
                            })
                        } else if (record.status == 'rejected') {
                          Button('重新申请')
                            .height(32)
                            .fontSize(13)
                            .fontColor(Color.White)
                            .backgroundColor('#10B981')
                            .borderRadius(6)
                            .onClick(() => {
                              this.resendRequest(record)
                            })
                        } else {
                          Text('已同步到本地好友信息')
                            .fontSize(11)
                            .fontColor('#6B7280')
                        }
                      }
                      .width('100%')
                      .margin({ top: 12 })
                    }
                    .width('100%')
                    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
                    .backgroundColor(Color.White)
                    .borderRadius(8)
                    .margin({ top: index == 0 ? 12 : 12 })
                  }, (record: FriendRequestRecord, index: number) => record.requestId + index)
                }
                .width('100%')
              }
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 24 })
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
    .title('添加好友')
  }
}
