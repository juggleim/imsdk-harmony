import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base'
import { ConversationRouteParams } from '../../viewmodel/ConversationViewModel'
import { GroupSettingStore } from '../../jim/groupsettingstore'
import { JuggleIm } from 'juggleim'

@Component
export default struct GroupNickname {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private groupId: string = ''
  @State private groupTitle: string = ''
  @State private nickname: string = ''
  @State private updatedText: string = '未保存'

  aboutToAppear(): void {
    let param = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.groupId = param.conversationId
    this.groupTitle = param.title != '' ? param.title : param.conversationId
    let setting = GroupSettingStore.getGroupSetting(this.groupId)
    if (setting != null) {
      this.nickname = setting.myNickname
      this.updatedText = setting.updatedAt > 0 ? `已更新于 ${new Date(setting.updatedAt).toLocaleString()}` : '未保存'
    }
  }

  private showToast(message: string): void {
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
  }

  private saveNickname(): void {
    if (this.groupId == '') {
      this.showToast('群信息不完整')
      return
    }
    let saved = GroupSettingStore.upsertGroupSetting(this.groupId, { myNickname: this.nickname.trim() })
    if (saved == null) {
      this.showToast('保存失败')
      return
    }
    this.updatedText = `已更新于 ${new Date(saved.updatedAt).toLocaleString()}`
    this.showToast('群昵称已保存')
    console.log(`group_nickname_saved: groupId=${this.groupId}, userId=${JuggleIm.instance.userId}, nickname=${this.nickname}`)
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Text(this.groupTitle)
            .fontSize(18)
            .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
            .fontColor('#111827')
          Text(this.groupId)
            .fontSize(12)
            .fontColor('#6B7280')
            .margin({ top: 4 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })
        .backgroundColor(Color.White)

        Scroll() {
          Column() {
            Column() {
              Text('我的群昵称')
                .fontSize(14)
                .fontColor('#6B7280')
                .margin({ bottom: 8 })
              TextInput({ text: this.nickname, placeholder: '请输入群昵称' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .onChange((value: string) => {
                  this.nickname = value
                })
              Text(this.updatedText)
                .fontSize(12)
                .fontColor('#6B7280')
                .margin({ top: 10 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .borderRadius(8)

            Button('保存群昵称')
              .width('100%')
              .height(44)
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor('#10B981')
              .borderRadius(6)
              .margin({ top: 12 })
              .onClick(() => {
                this.saveNickname()
              })
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
    .title('群昵称')
  }
}
