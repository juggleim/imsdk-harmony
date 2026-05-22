import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants'
import { CommonUtil, ObservedArray } from '../../jim/common'
import { buildMessagePreview } from '../../viewmodel/MessageViewModel'
import { FavoriteMessage, GetFavoriteMessageOption, JuggleIm, Message } from 'juggleim'
import { SettingTop } from './SettingTop'

@Observed
class FavoriteMessageViewItem {
  messageId:string = ''
  conversationTitle:string = ''
  senderName:string = ''
  previewText:string = ''
  favoriteTime:string = ''

  constructor() {
  }
}

@Component
export default struct MyFavorite{
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack
  @State private items:ObservedArray<FavoriteMessageViewItem> = new ObservedArray<FavoriteMessageViewItem>([])
  @State private loading:boolean = false
  @State private loadingMore:boolean = false
  @State private nextOffset:string = ''

  aboutToAppear(): void {
    this.loadFavorites(true)
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private loadFavorites(reset:boolean):void{
    if(this.loading || this.loadingMore){
      return
    }
    if(reset){
      this.loading = true
      this.nextOffset = ''
    }else{
      if(this.nextOffset == ''){
        return
      }
      this.loadingMore = true
    }
    let option = new GetFavoriteMessageOption()
    option.count = 20
    option.offset = reset ? '' : this.nextOffset
    JuggleIm.instance.getMessageManager().getFavorite(option, async (code, items, offset)=>{
      this.loading = false
      this.loadingMore = false
      if(code != 0){
        this.showToast(`收藏加载失败: ${code}`)
        return
      }
      let nextItems:FavoriteMessageViewItem[] = reset ? [] : this.items.slice()
      for(let i = 0; i < items.length; i++){
        let item = items[i]
        if(item.message == null){
          continue
        }
        let viewItem = await this.toFavoriteViewItem(item)
        let foundIndex = nextItems.findIndex((current)=>{
          return current.messageId == viewItem.messageId
        })
        if(foundIndex >= 0){
          nextItems[foundIndex] = viewItem
        }else{
          nextItems.push(viewItem)
        }
      }
      this.items = new ObservedArray<FavoriteMessageViewItem>(nextItems)
      this.nextOffset = offset
    })
  }

  private async toFavoriteViewItem(item:FavoriteMessage):Promise<FavoriteMessageViewItem>{
    let message = item.message as Message
    let viewItem = new FavoriteMessageViewItem()
    viewItem.messageId = message.messageId != '' ? message.messageId : message.clientId
    viewItem.previewText = buildMessagePreview(message.msgContent)
    viewItem.favoriteTime = CommonUtil.getTimeToYYYYDDMMHHMMSS(item.createdTime)

    let sender = await JuggleIm.instance.getUserInfoManager().getUserInfo(message.senderId)
    viewItem.senderName = sender.nickname != '' ? sender.nickname : message.senderId
    viewItem.conversationTitle = await this.resolveConversationTitle(message)
    return viewItem
  }

  private async resolveConversationTitle(message:Message):Promise<string>{
    if(message.conversation.conversationType == 1){
      let peerId = this.resolvePrivatePeerId(message)
      if(peerId == ''){
        return ''
      }
      let user = await JuggleIm.instance.getUserInfoManager().getUserInfo(peerId)
      if(user.nickname != ''){
        return user.nickname
      }
      return peerId
    }
    let group = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(message.conversation.conversationId)
    if(group != null && group.groupName != ''){
      return group.groupName
    }
    return message.conversation.conversationId
  }

  private resolvePrivatePeerId(message:Message):string{
    if(message.conversation.conversationId != '' && message.conversation.conversationId != JuggleIm.instance.userId){
      return message.conversation.conversationId
    }
    if(message.senderId != '' && message.senderId != JuggleIm.instance.userId){
      return message.senderId
    }
    return message.conversation.conversationId
  }

  private removeFavorite(item:FavoriteMessageViewItem):void{
    if(item.messageId == ''){
      return
    }
    JuggleIm.instance.getMessageManager().removeFavorite([item.messageId], (code)=>{
      if(code != 0){
        this.showToast(`取消收藏失败: ${code}`)
        return
      }
      let nextItems = this.items.filter((current)=>{
        return current.messageId != item.messageId
      })
      this.items = new ObservedArray<FavoriteMessageViewItem>(nextItems)
      this.showToast('已取消收藏')
    })
  }

  build() {
    NavDestination(){
      Column(){
        Row(){
          SettingTop({ settingTitle: '我的收藏' })
        }.width(BaseConstants.FULL_WIDTH)
        .height(60)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .padding({top:20})

        if(this.loading && this.items.length == 0){
          Column(){
            LoadingProgress()
              .width(28)
              .height(28)
            Text('加载中')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 12 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }else if(this.items.length == 0){
          Column(){
            Text('暂无收藏消息')
              .fontSize(15)
              .fontColor('#999999')
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }else{
          List(){
            ForEach(this.items, (item:FavoriteMessageViewItem)=>{
              ListItem(){
                Column(){
                  Row(){
                    Column(){
                      Text(item.senderName)
                        .fontSize(15)
                        .fontColor('#111111')
                      Text(item.conversationTitle)
                        .fontSize(12)
                        .fontColor('#999999')
                        .margin({ top: 4 })
                    }
                    .alignItems(HorizontalAlign.Start)
                    Blank()
                    Text(item.favoriteTime)
                      .fontSize(12)
                      .fontColor('#999999')
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Top)

                  Text(item.previewText)
                    .fontSize(14)
                    .fontColor('#333333')
                    .width('100%')
                    .margin({ top: 12 })
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Row(){
                    Blank()
                    Text('取消收藏')
                      .fontSize(13)
                      .fontColor('#4C8DFF')
                      .onClick(()=>{
                        this.removeFavorite(item)
                      })
                  }
                  .width('100%')
                  .margin({ top: 14 })
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                .border({
                  width: { bottom: 1 },
                  color: '#F1F3F5'
                })
              }
            }, (item:FavoriteMessageViewItem)=>item.messageId)

            if(this.nextOffset != ''){
              ListItem(){
                Row(){
                  Blank()
                  Text(this.loadingMore ? '加载中...' : '加载更多')
                    .fontSize(14)
                    .fontColor('#4C8DFF')
                    .onClick(()=>{
                      this.loadFavorites(false)
                    })
                  Blank()
                }
                .width('100%')
                .padding({ top: 16, bottom: 24 })
              }
            }
          }
          .layoutWeight(1)
          .width('100%')
          .divider({ strokeWidth: 0 })
        }
      }
      .backgroundColor(Color.White)
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }
    .hideTitleBar(true)
  }
}
