/*
 * GroupList - 群组列表页
 * 对齐 Android: GroupListActivity / GroupListFragment
 */
import { promptAction } from '@kit.ArkUI';
import { BaseConstants } from 'base';
import { JimServer } from '../../jim/jimserver/jimserver';
import { CommonUtil } from '../../jim/common';
import { GroupBean } from '../../jim/jimserver/groupmanager';

@Component
struct GroupItem {
  @Prop item: GroupBean;
  @State private memberCount: number = 0;

  aboutToAppear(): void {
    this.memberCount = this.item.member_count ?? 0;
  }

  build() {
    Row({ space: 12 }) {
      if (this.item.group_portrait) {
        Image(this.item.group_portrait)
          .width(48)
          .height(48)
          .borderRadius(24)
          .objectFit(ImageFit.Cover)
      } else {
        Text(CommonUtil.getFirstChar(this.item.group_name))
          .width(48)
          .height(48)
          .borderRadius(24)
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .backgroundColor(CommonUtil.getBackgroundColor(this.item.group_name))
      }

      Column({ space: 4 }) {
        Text(this.item.group_name)
          .fontSize(16)
          .fontColor('#111827')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.memberCount} 人`)
          .fontSize(12)
          .fontColor('#9CA3AF')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
  }
}

@Component
export struct GroupList {
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State groups: GroupBean[] = [];
  @State loading: boolean = true;
  @State empty: boolean = false;

  aboutToAppear(): void {
    this.loadGroups();
  }

  onPageShow(): void {
    this.loadGroups();
  }

  loadGroups(): void {
    this.loading = true;
    let groupManager = JimServer.instance.getGroupManager();
    if (!groupManager) {
      this.loading = false;
      this.empty = true;
      return;
    }

    groupManager.GetMyGroups((items: GroupBean[]) => {
      this.loading = false;
      if (items && items.length > 0) {
        this.groups = items;
        this.empty = false;
      } else {
        this.groups = [];
        this.empty = true;
      }
    });
  }

  build() {
    NavDestination() {
      Column() {
        if (this.loading) {
          Column() {
            LoadingProgress().width(40).height(40)
            Text('加载中...').fontSize(14).fontColor('#9CA3AF').margin({ top: 12 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F5F7FA')
        } else if (this.empty) {
          Column() {
            Text('暂无群组').fontSize(14).fontColor('#9CA3AF')
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F5F7FA')
        } else {
          List() {
            ForEach(this.groups, (item: GroupBean) => {
              ListItem() {
                GroupItem({ item: item })
              }
            }, (item: GroupBean) => item.group_id)
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .backgroundColor('#F5F7FA')
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .title('群组')
  }
}