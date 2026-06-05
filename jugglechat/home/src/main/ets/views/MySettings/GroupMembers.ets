import { BaseConstants } from 'base'
import { CommonUtil } from '../../jim/common'
import { ConversationRouteParams } from '../../viewmodel/ConversationViewModel'
import { GroupMember, JuggleIm } from 'juggleim'

@Observed
class GroupMemberItem {
  userId: string = ''
  name: string = ''
  portrait: string = ''
  displayName: string = ''
}

@Component
export default struct GroupMembers {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private groupId: string = ''
  @State private groupTitle: string = ''
  @State private members: GroupMemberItem[] = []
  @State private hintText: string = '正在加载成员'

  aboutToAppear(): void {
    let param = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.groupId = param.conversationId
    this.groupTitle = param.title != '' ? param.title : param.conversationId
    this.loadMembers()
  }

  onPageShow(): void {
    this.loadMembers()
  }

  private loadMembers(): void {
    if (this.groupId == '') {
      this.hintText = '群信息不完整'
      return
    }
    this.hintText = '正在加载成员'
    let localMembers = JuggleIm.instance.getGroupInfoManager().getLocalGroupMembers(this.groupId)
    if (localMembers.length > 0) {
      this.applyMembers(localMembers)
    }
    JuggleIm.instance.getGroupInfoManager().queryGroupMembers(this.groupId, (code, members) => {
      if (code != 0) {
        this.hintText = `加载失败 ${code}`
        return
      }
      this.applyMembers(members)
    })
  }

  private async applyMembers(members: GroupMember[]): Promise<void> {
    let next: GroupMemberItem[] = []
    for (let i = 0; i < members.length; i++) {
      let member = members[i]
      let user = await JuggleIm.instance.getUserInfoManager().getUserInfo(member.memberId)
      let item = new GroupMemberItem()
      item.userId = member.memberId
      item.name = user.nickname != '' ? user.nickname : member.displayName != '' ? member.displayName : member.memberId
      item.portrait = user.userPortrait
      item.displayName = member.displayName
      next.push(item)
    }
    this.members = next
    this.hintText = next.length > 0 ? `共 ${next.length} 位成员` : '暂无成员'
  }

  private getInitial(name: string): string {
    if (name == '') {
      return '?'
    }
    return CommonUtil.getFirstChar(name)
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Row() {
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
            .layoutWeight(1)
            Text(this.hintText)
              .fontSize(12)
              .fontColor('#6B7280')
          }
          .width('100%')

          Button('刷新成员')
            .width('100%')
            .height(40)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#4C8DFF')
            .borderRadius(6)
            .margin({ top: 12 })
            .onClick(() => {
              this.loadMembers()
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })
        .backgroundColor(Color.White)

        Scroll() {
          Column() {
            if (this.members.length == 0) {
              Text('暂无成员')
                .fontSize(13)
                .fontColor('#6B7280')
                .margin({ top: 16 })
            } else {
              Column() {
                ForEach(this.members, (item: GroupMemberItem, index: number) => {
                  Row() {
                    if (item.portrait != '') {
                      Image(item.portrait)
                        .width(44)
                        .height(44)
                        .borderRadius(22)
                    } else {
                      Stack() {
                        Text(this.getInitial(item.name))
                          .fontSize(16)
                          .fontColor(Color.White)
                      }
                      .width(44)
                      .height(44)
                      .backgroundColor(CommonUtil.getBackgroundColor(item.name))
                      .borderRadius(22)
                    }

                    Column() {
                      Text(item.name)
                        .fontSize(15)
                        .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                        .fontColor('#111827')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(item.userId)
                        .fontSize(12)
                        .fontColor('#6B7280')
                        .margin({ top: 4 })
                    }
                    .layoutWeight(1)
                    .margin({ left: 12 })

                    if (item.displayName != '') {
                      Text(item.displayName)
                        .fontSize(11)
                        .fontColor('#4C8DFF')
                    }
                  }
                  .width('100%')
                  .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                  .backgroundColor(Color.White)
                  .borderRadius(8)
                  .margin({ top: index == 0 ? 12 : 12 })
                }, (item: GroupMemberItem, index: number) => item.userId + index)
              }
              .width('100%')
            }
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
    .title('群成员')
  }
}
