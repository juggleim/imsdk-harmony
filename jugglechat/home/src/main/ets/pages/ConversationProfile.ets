import { StandardIcon } from 'base'
import { JuggleIm } from 'juggleim'
import { ConversationRouteParams } from '../viewmodel/ConversationViewModel'

@Component
export struct ConversationProfile {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private title:string = '会话详情'
  @State private conversationId:string = ''
  @State private conversationType:number = 1
  @State private typeLabel:string = ''

  aboutToAppear(): void {
    let params = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.conversationId = params.conversationId
    this.conversationType = params.converType
    this.title = params.title != '' ? params.title : '会话详情'
    this.typeLabel = this.conversationType == 2 ? '群聊' : '单聊'
    this.loadConversationTitle()
  }

  private loadConversationTitle():void{
    if(this.title != '' && this.title != '会话详情'){
      return
    }
    if(this.conversationType == 1){
      let user = JuggleIm.instance.getUserInfoManager().getLocalUserInfo(this.conversationId)
      if(user != null && user.nickname != ''){
        this.title = user.nickname
      }
      return
    }
    let group = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(this.conversationId)
    if(group != null && group.groupName != ''){
      this.title = group.groupName
    }
  }

  @Builder
  private infoRow(label:string, value:string) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor('#666666')
      Blank()
      Text(value)
        .fontSize(15)
        .fontColor('#111111')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          this.infoRow('会话名称', this.title)
          Divider().strokeWidth(1).color('#EAEAEA')
          this.infoRow('会话类型', this.typeLabel)
          Divider().strokeWidth(1).color('#EAEAEA')
          this.infoRow('会话 ID', this.conversationId)
        }
        .width('100%')
        .backgroundColor(Color.White)

        Column() {
          Row() {
            Text('历史消息')
              .fontSize(16)
              .fontColor('#111111')
            Blank()
            StandardIcon({ icon: $r('app.media.ic_public_more') })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .onClick(()=>{
            this.pageInfo.pushPath({
              name: 'ConversationHistory',
              param: new ConversationRouteParams(this.conversationId, this.conversationType, this.title)
            })
          })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .margin({ top: 12 })

        Blank()
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_color_grey'))
    }
    .title('会话详情')
  }
}
