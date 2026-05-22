import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants'
import { SettingTop } from './SettingTop'

class ChatroomRoomParams {
  chatroomId:string = ''
  title:string = ''

  constructor(chatroomId:string, title:string) {
    this.chatroomId = chatroomId
    this.title = title
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

const CHATROOM_ITEMS:ChatroomListItem[] = [
  new ChatroomListItem('chatroom1001', '植物大战僵尸首秀'),
  new ChatroomListItem('chatroom1002', '敢不敢和我比比谁更甜'),
  new ChatroomListItem('chatroom1003', '今天和我一起拿下这个黑猴'),
  new ChatroomListItem('chatroom1004', '爱滑雪，2024 滑雪季备赛'),
  new ChatroomListItem('chatroom1005', '战斗吧豌豆君，看我一决高下'),
  new ChatroomListItem('chatroom1006', '倔强青铜的逆袭之路'),
  new ChatroomListItem('chatroom1007', '一个教唱歌的教授'),
  new ChatroomListItem('chatroom1008', '咔咔咔卡个哇伊喽')
]

@Component
export default struct ChatroomListPage {
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  build() {
    NavDestination() {
      Column() {
        Row() {
          SettingTop({ settingTitle: '聊天室' })
        }
        .width(BaseConstants.FULL_WIDTH)
        .height(60)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .padding({ top: 20 })

        List() {
          ForEach(CHATROOM_ITEMS, (item:ChatroomListItem)=>{
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
            .onClick(()=>{
              this.mySettingPageInfo.pushPath({
                name: 'ChatroomRoom',
                param: new ChatroomRoomParams(item.chatroomId, item.title)
              })
            })
          }, (item:ChatroomListItem)=>{
            return item.chatroomId
          })
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .hideTitleBar(true)
  }
}

export {
  ChatroomRoomParams
}
