import { promptAction } from '@kit.ArkUI'
import { PreferenceUtil, StoredChatroom } from '../../jim/preferenceutil'

class ChatroomRoomParams {
  chatroomId:string = ''
  title:string = ''
  isAutoCreate:boolean = false

  constructor(chatroomId:string, title:string, isAutoCreate:boolean = false) {
    this.chatroomId = chatroomId
    this.title = title
    this.isAutoCreate = isAutoCreate
  }
}

@Observed
class ChatroomListItem {
  chatroomId:string = ''
  title:string = ''

  constructor(chatroomId:string, title:string) {
    this.chatroomId = chatroomId
    this.title = title
  }
}

@Component
export default struct ChatroomListPage {
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack
  @Consume('activeNavSource') activeNavSource: string
  @State private items: ChatroomListItem[] = []
  @State private joinChatroomId: string = ''

  private getActivePageInfo(): NavPathStack {
    if (this.activeNavSource == 'settings') {
      return this.mySettingPageInfo
    }
    return this.pageInfo
  }

  private showToast(message:string):void {
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  aboutToAppear(): void {
    this.loadMyChatrooms()
  }

  onPageShow(): void {
    this.loadMyChatrooms()
  }

  private loadMyChatrooms(): void {
    let saved = PreferenceUtil.getJoinedChatrooms()
    if (saved && saved.length > 0) {
      this.items = saved.map((item: StoredChatroom) => {
        return new ChatroomListItem(
          item.chatroomId,
          item.title
        )
      })
    } else {
      this.items = []
    }
  }

  private saveJoinedChatroom(chatroomId: string, title: string): void {
    let existing = this.items.find((item) => item.chatroomId == chatroomId)
    if (existing) {
      existing.title = title
      this.items = this.items.slice()
    } else {
      this.items = [new ChatroomListItem(chatroomId, title), ...this.items]
    }
    let raw = this.items.map((item) => new StoredChatroom(item.chatroomId, item.title))
    PreferenceUtil.saveJoinedChatrooms(raw)
  }

  private joinChatroom(): void {
    let chatroomId = this.joinChatroomId.trim()
    if (chatroomId == '') {
      this.showToast('请输入聊天室 ID')
      return
    }
    let title = chatroomId
    this.saveJoinedChatroom(chatroomId, title)
    this.joinChatroomId = ''
    this.getActivePageInfo().pushPath({
      name: 'ChatroomRoom',
      param: new ChatroomRoomParams(chatroomId, title, false)
    })
  }

  private createChatroom(): void {
    let params: Record<string, string> = {}
    this.getActivePageInfo().pushPath({
      name: 'CreateChatroom',
      param: params as Object
    })
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Row() {
            TextInput({ text: this.joinChatroomId, placeholder: '输入聊天室 ID 加入' })
              .layoutWeight(1)
              .height(44)
              .fontSize(14)
              .padding({ left: 12, right: 12 })
              .backgroundColor(Color.White)
              .borderRadius(6)
              .border({ width: 1, color: '#E0E0E0' })
              .onChange((value: string) => {
                this.joinChatroomId = value
              })
            Button('加入')
              .height(44)
              .margin({ left: 8 })
              .fontSize(14)
              .backgroundColor('#4C8DFF')
              .onClick(() => {
                this.joinChatroom()
              })
          }
          .width('100%')

          Row() {
            Text('或')
              .fontSize(12)
              .fontColor('#9CA3AF')
              .margin({ right: 8 })
            Text('创建聊天室')
              .fontSize(12)
              .fontColor('#4C8DFF')
              .decoration({ type: TextDecorationType.Underline })
              .onClick(() => {
                this.createChatroom()
              })
          }
          .margin({ top: 10 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ left: 12, right: 12, top: 12 })

        if (this.items.length == 0) {
          Column() {
            Text('暂无加入的聊天室')
              .fontSize(14)
              .fontColor('#9CA3AF')
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          List() {
            ForEach(this.items, (item: ChatroomListItem) => {
              ListItem() {
                Row() {
                  Column() {
                    Text(item.title)
                      .fontSize(18)
                      .fontWeight(500)
                      .fontColor('#111827')
                    Text(item.chatroomId)
                      .fontSize(12)
                      .fontColor('#6B7280')
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.Start)

                  Blank()

                  Text('进入')
                    .fontSize(14)
                    .fontColor('#4C8DFF')
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                .backgroundColor(Color.White)
                .borderRadius(6)
              }
              .padding({ left: 12, right: 12, top: 8 })
              .onClick(() => {
                this.getActivePageInfo().pushPath({
                  name: 'ChatroomRoom',
                  param: new ChatroomRoomParams(item.chatroomId, item.title, false)
                })
              })
            }, (item: ChatroomListItem) => {
              return item.chatroomId
            })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .title('聊天室')
  }
}

export {
  ChatroomRoomParams
}
