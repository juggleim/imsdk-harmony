/*
 * CreateGroup - 群组创建页面
 * 调用 GroupManager.CreateGroup 创建真正的群组
 */
import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base'
import { ObservedArray } from '../jim/common'
import { JimServer } from '../jim/jimserver/jimserver'

@Observed
class CreateGroupFriendItem {
  userId:string = ''
  nickname:string = ''
  avatar:string = ''
  selected:boolean = false

  constructor(userId:string, nickname:string, avatar:string) {
    this.userId = userId
    this.nickname = nickname
    this.avatar = avatar
  }
}

@Component
export struct CreateGroup {
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo: NavPathStack
  @Consume('activeNavSource') activeNavSource: string
  @State private groupName: string = ''
  @State private searchKeyword: string = ''
  @State private loading: boolean = false
  @State private creating: boolean = false
  @State private friends: ObservedArray<CreateGroupFriendItem> = new ObservedArray<CreateGroupFriendItem>([])
  @State private activePageInfo: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    this.activePageInfo = this.resolveActivePageInfo()
    this.loadFriends()
  }

  private resolveActivePageInfo(): NavPathStack {
    if (this.activeNavSource == 'settings') {
      return this.mySettingPageInfo
    }
    return this.pageInfo
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
  }

  private back():void{
    if(this.activePageInfo.size() > 1){
      this.activePageInfo.pop()
    }
  }

  private loadFriends():void{
    if(this.loading){
      return
    }
    this.loading = true
    JimServer.instance.getFriendManager().QueryFriends(1, 200, '', (users)=>{
      this.loading = false
      let items:CreateGroupFriendItem[] = []
      users.items.forEach((user)=>{
        items.push(new CreateGroupFriendItem(
          user.user_id,
          user.nickname != '' ? user.nickname : user.user_id,
          user.avatar
        ))
      })
      this.friends = new ObservedArray<CreateGroupFriendItem>(items)
    })
  }

  private toggleFriend(item:CreateGroupFriendItem):void{
    let nextItems = this.friends.slice()
    let foundIndex = nextItems.findIndex((current)=>{
      return current.userId == item.userId
    })
    if(foundIndex < 0){
      return
    }
    nextItems[foundIndex].selected = !nextItems[foundIndex].selected
    this.friends = new ObservedArray<CreateGroupFriendItem>(nextItems)
  }

  private clearSelectedFriends():void{
    let nextItems = this.friends.slice()
    let changed = false
    for(let i = 0; i < nextItems.length; i++){
      if(nextItems[i].selected){
        nextItems[i].selected = false
        changed = true
      }
    }
    if(changed){
      this.friends = new ObservedArray<CreateGroupFriendItem>(nextItems)
    }
  }

  private getSelectedCount():number{
    return this.friends.filter((item)=>{
      return item.selected
    }).length
  }

  private getSelectedFriends():CreateGroupFriendItem[]{
    return this.friends.filter((item)=>{
      return item.selected
    })
  }

  private getVisibleFriends():CreateGroupFriendItem[]{
    let keyword = this.searchKeyword.trim().toLowerCase()
    if(keyword == ''){
      return this.friends.slice()
    }
    return this.friends.filter((item)=>{
      return item.nickname.toLowerCase().indexOf(keyword) >= 0 ||
        item.userId.toLowerCase().indexOf(keyword) >= 0
    })
  }

  private buildGroupName():string{
    let name = this.groupName.trim()
    if(name != ''){
      return name
    }
    let selected = this.getSelectedFriends()
    if(selected.length == 0){
      return '未命名群组'
    }
    if(selected.length == 1){
      return `${selected[0].nickname} 的群组`
    }
    return `${selected[0].nickname} 等${selected.length}人群组`
  }

  private createGroup():void{
    if(this.creating){
      return
    }
    let selected = this.getSelectedFriends()
    if(selected.length == 0){
      this.showToast('请至少选择一个联系人')
      return
    }
    let name = this.buildGroupName()
    let memberIds = selected.map((item)=>item.userId)
    this.creating = true
    let groupManager = JimServer.instance.getGroupManager()
    if(!groupManager){
      this.showToast('群组服务不可用')
      this.creating = false
      return
    }
    groupManager.CreateGroup(name, '', memberIds, (success, groupId)=>{
      this.creating = false
      if(success && groupId){
        this.showToast('群组创建成功')
        this.back()
      } else {
        this.showToast('群组创建失败')
      }
    })
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              Text('群组名称')
                .fontSize(14)
                .fontColor('#6B7280')
                .margin({ bottom: 8 })
              TextInput({ text: this.groupName, placeholder: '输入群组名称（可选）' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .onChange((value:string)=>{
                  this.groupName = value
                })
              Row() {
                Text(`已选 ${this.getSelectedCount()} 人`)
                  .fontSize(13)
                  .fontColor('#6B7280')
                Blank()
              }
              .width('100%')
              .margin({ top: 10 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Row() {
                Text('选择联系人')
                  .fontSize(14)
                  .fontColor('#6B7280')
                Blank()
              }
              .width('100%')
              .padding({ bottom: 8 })

              TextInput({ text: this.searchKeyword, placeholder: '搜索联系人或用户ID' })
                .width('100%')
                .height(40)
                .fontSize(14)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .onChange((value:string)=>{
                  this.searchKeyword = value
                })

              Row() {
                Text(`已选 ${this.getSelectedCount()} 人`)
                  .fontSize(12)
                  .fontColor('#6B7280')
                Blank()
                Text('清空选择')
                  .fontSize(12)
                  .fontColor(this.getSelectedCount() > 0 ? '#4C8DFF' : '#C4C9D4')
                  .onClick(()=>{
                    this.clearSelectedFriends()
                  })
              }
              .width('100%')
              .margin({ top: 10, bottom: 8 })

              if(this.getSelectedCount() > 0){
                Scroll() {
                  Row() {
                    ForEach(this.getSelectedFriends(), (item:CreateGroupFriendItem)=>{
                      Row() {
                        Text(item.nickname)
                          .fontSize(12)
                          .fontColor('#111827')
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                        Text('x')
                          .fontSize(12)
                          .fontColor('#4C8DFF')
                          .margin({ left: 6 })
                      }
                      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                      .backgroundColor('#EAF1FF')
                      .borderRadius(999)
                      .margin({ right: 8 })
                      .onClick(()=>{
                        this.toggleFriend(item)
                      })
                    }, (item:CreateGroupFriendItem)=>item.userId)
                  }
                  .alignItems(VerticalAlign.Center)
                }
                .scrollBar(BarState.Off)
                .scrollable(ScrollDirection.Horizontal)
                .height(40)
                .margin({ bottom: 8 })
              }

              if(this.loading){
                Row() {
                  Text('联系人加载中...')
                    .fontSize(13)
                    .fontColor('#6B7280')
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
              }else if(this.friends.length == 0){
                Row() {
                  Text('暂无联系人')
                    .fontSize(13)
                    .fontColor('#6B7280')
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
              }else if(this.getVisibleFriends().length == 0){
                Row() {
                  Text('暂无匹配联系人')
                    .fontSize(13)
                    .fontColor('#6B7280')
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
              }else{
                List() {
                  ForEach(this.getVisibleFriends(), (item:CreateGroupFriendItem)=>{
                    ListItem() {
                      Row() {
                        if(item.avatar != ''){
                          Image(item.avatar)
                            .width(44)
                            .height(44)
                            .borderRadius(22)
                        }else{
                          Stack() {
                            Text(item.nickname.charAt(0))
                              .fontSize(18)
                              .fontColor(Color.White)
                          }
                          .width(44)
                          .height(44)
                          .borderRadius(22)
                          .backgroundColor('#7C8DB5')
                        }

                        Column() {
                          Text(item.nickname)
                            .fontSize(15)
                            .fontColor('#111827')
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                          Text(item.userId)
                            .fontSize(12)
                            .fontColor('#9CA3AF')
                            .margin({ top: 4 })
                        }
                        .layoutWeight(1)
                        .margin({ left: 12 })

                        Stack() {
                          if(item.selected){
                            Text('V')
                              .fontSize(14)
                              .fontColor(Color.White)
                          }
                        }
                        .width(22)
                        .height(22)
                        .borderRadius(11)
                        .backgroundColor(item.selected ? '#4C8DFF' : '#D8DCE3')
                      }
                      .width('100%')
                      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                    }
                    .onClick(()=>{
                      this.toggleFriend(item)
                    })
                  }, (item:CreateGroupFriendItem)=>item.userId)
                }
                .width('100%')
                .height(380)
                .divider({ strokeWidth: 1, color: '#EAEAEA', startMargin: 16, endMargin: 16 })
              }
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Button('创建群组')
              .width('100%')
              .height(44)
              .fontSize(15)
              .fontColor(Color.White)
              .backgroundColor(this.creating ? '#A0C4FF' : '#4C8DFF')
              .borderRadius(6)
              .margin({ top: 16 })
              .onClick(()=>{
                this.createGroup()
              })
              .enabled(!this.creating)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 24 })
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .backgroundColor('#F5F7FA')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .title('创建群组')
  }
}
