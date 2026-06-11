/*
 * ContactPicker - 可复用的联系人选择组件
 * 用途：创建群聊选人、群管理邀请成员
 * 形式：CustomDialog，展示好友列表，支持多选（Checkbox）
 */
import { JimServer } from '../../jim/jimserver/jimserver';
import { User } from '../../jim/jimserver/entries/user';
import { CommonUtil } from '../../jim/common';

@CustomDialog
export struct ContactPicker {
  controller: CustomDialogController;
  title: string = '选择联系人';
  onConfirm?: (selectedUsers: User[]) => void;
  @State friends: User[] = [];
  @State selectedIds: Set<string> = new Set();
  @State loading: boolean = true;

  aboutToAppear(): void {
    JimServer.instance.getFriendManager().QueryFriends(1, 100, '', (users) => {
      this.friends = users.items || [];
      this.loading = false;
    });
  }

  private toggleSelection(userId: string): void {
    if (this.selectedIds.has(userId)) {
      this.selectedIds.delete(userId);
    } else {
      this.selectedIds.add(userId);
    }
    this.selectedIds = new Set(this.selectedIds);
  }

  private getInitial(name: string): string {
    return CommonUtil.getFirstChar(name);
  }

  private getBgColor(name: string): string {
    return CommonUtil.getBackgroundColor(name);
  }

  build() {
    Column() {
      Row() {
        Button('取消')
          .fontSize(15)
          .fontColor('#6B7280')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.controller.close();
          })
        Blank()
        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827')
        Blank()
        Button(`确认(${this.selectedIds.size})`)
          .fontSize(15)
          .fontColor(this.selectedIds.size > 0 ? '#FFFFFF' : '#9CA3AF')
          .backgroundColor(this.selectedIds.size > 0 ? '#4C8DFF' : '#E5E7EB')
          .borderRadius(6)
          .height(36)
          .onClick(() => {
            if (this.onConfirm && this.selectedIds.size > 0) {
              let selected = this.friends.filter((u: User) => this.selectedIds.has(u.user_id));
              this.onConfirm(selected);
            }
            this.controller.close();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Divider().strokeWidth(1).color('#EAEAEA')

      if (this.loading) {
        Column() {
          LoadingProgress().width(36).height(36)
          Text('加载中...').fontSize(14).fontColor('#9CA3AF').margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.friends.length === 0) {
        Column() {
          Text('暂无好友').fontSize(15).fontColor('#9CA3AF')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.friends, (user: User, index: number) => {
            ListItem() {
              Row({ space: 12 }) {
                Checkbox({ name: `picker_${user.user_id}`, group: 'contactPickerGroup' })
                  .select(this.selectedIds.has(user.user_id))
                  .selectedColor('#4C8DFF')
                  .onChange((value: boolean) => {
                    this.toggleSelection(user.user_id);
                  })

                if (user.avatar) {
                  Image(user.avatar)
                    .width(40)
                    .height(40)
                    .borderRadius(20)
                } else {
                  Text(this.getInitial(user.nickname || user.user_id))
                    .width(40)
                    .height(40)
                    .borderRadius(20)
                    .fontSize(16)
                    .fontColor(Color.White)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(this.getBgColor(user.nickname || user.user_id))
                }

                Text(user.nickname || user.user_id)
                  .fontSize(16)
                  .fontColor('#111827')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .layoutWeight(1)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .onClick(() => {
                this.toggleSelection(user.user_id);
              })
            }
          }, (user: User, index: number) => `${user.user_id}_${index}`)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('70%')
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 16, topRight: 16 })
  }
}
