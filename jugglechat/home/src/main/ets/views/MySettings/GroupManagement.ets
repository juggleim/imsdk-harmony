import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base'
import { GroupInfo, JuggleIm } from '@juggleim/imlib'
import { ConversationRouteParams } from '../../viewmodel/ConversationViewModel'
import { GroupSettingStore } from '../../jim/groupsettingstore'

@Component
export default struct GroupManagement {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private groupId: string = ''
  @State private groupTitle: string = ''
  @State private groupPortrait: string = ''
  @State private memberCount: number = 0
  @State private announcement: string = ''
  @State private myNickname: string = ''
  @State private updatedText: string = '未更新'

  aboutToAppear(): void {
    let param = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.groupId = param.conversationId
    this.groupTitle = param.title != '' ? param.title : param.conversationId
    this.loadGroupMeta()
    this.loadGroupMembers()
    this.loadLocalSetting()
  }

  onPageShow(): void {
    this.loadGroupMeta()
    this.loadGroupMembers()
    this.loadLocalSetting()
  }

  private showToast(message: string): void {
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
  }

  private loadGroupMeta(): void {
    if (this.groupId == '') {
      return
    }
    let localGroup = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(this.groupId)
    if (localGroup != null) {
      this.applyGroupInfo(localGroup)
    }
    JuggleIm.instance.getGroupInfoManager().queryGroupInfo(this.groupId, (code, groupInfo) => {
      if (code != 0 || groupInfo == null) {
        return
      }
      this.applyGroupInfo(groupInfo)
    })
  }

  private applyGroupInfo(groupInfo: GroupInfo): void {
    if (groupInfo.groupName != '') {
      this.groupTitle = groupInfo.groupName
    }
    if (groupInfo.groupPortrait != '') {
      this.groupPortrait = groupInfo.groupPortrait
    }
  }

  private loadGroupMembers(): void {
    if (this.groupId == '') {
      return
    }
    let localMembers = JuggleIm.instance.getGroupInfoManager().getLocalGroupMembers(this.groupId)
    this.memberCount = localMembers.length
    JuggleIm.instance.getGroupInfoManager().queryGroupMembers(this.groupId, (code, members) => {
      if (code != 0) {
        return
      }
      this.memberCount = members.length
    })
  }

  private loadLocalSetting(): void {
    let setting = GroupSettingStore.getGroupSetting(this.groupId)
    if (setting != null) {
      this.announcement = setting.announcement
      this.myNickname = setting.myNickname
      this.updatedText = setting.updatedAt > 0 ? `已更新于 ${new Date(setting.updatedAt).toLocaleString()}` : '未更新'
    } else {
      this.announcement = ''
      this.myNickname = ''
      this.updatedText = '未更新'
    }
  }

  private openPage(name: string): void {
    this.pageInfo.pushPath({
      name,
      param: new ConversationRouteParams(this.groupId, 2, this.groupTitle)
    })
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              Row() {
                Column() {
                  Text(this.groupTitle)
                    .fontSize(20)
                    .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                    .fontColor('#111827')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(this.groupId)
                    .fontSize(12)
                    .fontColor('#6B7280')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                Column() {
                  Text(`${this.memberCount} 人`)
                    .fontSize(13)
                    .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                    .fontColor('#4C8DFF')
                }
                .alignItems(HorizontalAlign.End)
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              Text(this.updatedText)
                .fontSize(12)
                .fontColor('#6B7280')
                .margin({ top: 12 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Row() {
                Text('群公告')
                  .fontSize(16)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor('#111827')
                Blank()
                Text(this.announcement != '' ? '已设置' : '未设置')
                  .fontSize(12)
                  .fontColor(this.announcement != '' ? '#047857' : '#B45309')
              }
              .width('100%')

              Text(this.announcement != '' ? this.announcement : '暂无群公告')
                .fontSize(13)
                .fontColor('#374151')
                .lineHeight(20)
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 12 })

              Button('编辑群公告')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#4C8DFF')
                .borderRadius(6)
                .margin({ top: 12 })
                .onClick(() => {
                  this.openPage('GroupAnnouncement')
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Column() {
              Row() {
                Text('我的群昵称')
                  .fontSize(16)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor('#111827')
                Blank()
                Text(this.myNickname != '' ? this.myNickname : '未设置')
                  .fontSize(12)
                  .fontColor(this.myNickname != '' ? '#047857' : '#B45309')
              }
              .width('100%')

              Button('设置群昵称')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#10B981')
                .borderRadius(6)
                .margin({ top: 12 })
                .onClick(() => {
                  this.openPage('GroupNickname')
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Column() {
              Row() {
                Text('群成员')
                  .fontSize(16)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor('#111827')
                Blank()
                Text('查看完整列表')
                  .fontSize(12)
                  .fontColor('#6B7280')
              }
              .width('100%')

              Button('打开成员列表')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#4C8DFF')
                .borderRadius(6)
                .margin({ top: 12 })
                .onClick(() => {
                  this.openPage('GroupMembers')
                })
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
    .title('群管理')
  }
}
