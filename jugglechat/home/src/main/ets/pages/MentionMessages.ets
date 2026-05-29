import { promptAction } from '@kit.ArkUI'
import { CommonUtil, ObservedArray } from '../jim/common'
import { Conversation, GetMessageDirection, JuggleIm, Message } from 'juggleim'
import { isDisplayableMessage, MessageViewItem, toMessageViewItem } from '../viewmodel/MessageViewModel'
import { MentionMessagesParams } from '../viewmodel/ConversationViewModel'

@Component
export struct MentionMessages {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private conversationId:string = ''
  @State private conversationType:number = 2
  @State private conversationSubChannel:string = ''
  @State private title:string = ''
  @State private messages:ObservedArray<MessageViewItem> = new ObservedArray<MessageViewItem>([])
  @State private refreshing:boolean = false
  @State private hasMore:boolean = true
  private minMsgTime:number = Number.MAX_SAFE_INTEGER
  private scroller:Scroller = new Scroller()

  aboutToAppear(): void {
    let params = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as MentionMessagesParams
    this.conversationId = params.conversationId
    this.conversationType = params.converType
    this.conversationSubChannel = params.subChannel ?? ''
    this.title = params.title
    this.loadMentionMessages(true)
  }

  @Builder
  refreshContent() {
    Text('Loading...')
      .width('100%')
      .textAlign(TextAlign.Center)
  }

  private getConversation():Conversation{
    return new Conversation(this.conversationId, this.conversationType, this.conversationSubChannel)
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private getItemKey(item:MessageViewItem):string{
    if(item.messageId != ''){
      return item.messageId
    }
    return item.clientId
  }

  private recordMsgTime(time:number):void{
    if(time < this.minMsgTime){
      this.minMsgTime = time
    }
  }

  private resetMessages():void{
    this.messages = new ObservedArray<MessageViewItem>([])
    this.hasMore = true
    this.minMsgTime = Number.MAX_SAFE_INTEGER
  }

  private async upsertMessage(message:Message):Promise<void>{
    if(!isDisplayableMessage(message)){
      return
    }
    let viewItem = await toMessageViewItem(message)
    let currentKey = this.getItemKey(viewItem)
    let foundIndex = this.messages.findIndex((item)=>{
      return this.getItemKey(item) == currentKey ||
        (viewItem.messageId != '' && item.messageId == viewItem.messageId) ||
        (viewItem.clientId != '' && item.clientId == viewItem.clientId)
    })
    if(foundIndex >= 0){
      this.messages[foundIndex] = viewItem
    }else{
      this.messages.push(viewItem)
    }
    this.recordMsgTime(message.sentTime)
  }

  private async loadMentionMessages(reset:boolean):Promise<void>{
    if(reset){
      this.resetMessages()
    }
    let anchorTime = reset || this.minMsgTime == Number.MAX_SAFE_INTEGER ? 0 : this.minMsgTime
    JuggleIm.instance.getMessageManager().queryMentionMessages(
      this.getConversation(),
      20,
      anchorTime,
      false,
      async (code, msgs, hasMore)=>{
        if(code != 0){
          this.showToast(`提及消息加载失败: ${code}`)
          return
        }
        for(let i = 0; i < msgs.length; i++){
          await this.upsertMessage(msgs[i])
        }
        this.messages = new ObservedArray<MessageViewItem>(this.messages.slice().sort((a,b)=>a.msgTime-b.msgTime))
        this.hasMore = hasMore
      }
    )
  }

  @Builder
  private mentionRow(item:MessageViewItem) {
    Column() {
      Row() {
        Text(item.isReceived ? item.senderName : item.selfName)
          .fontSize(14)
          .fontColor('#111111')
          .fontWeight(500)
        Blank()
        Text(CommonUtil.getTimeToYYYYDDMMHHMMSS(item.msgTime))
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')

      Text(item.previewText)
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .margin({ top: 10 })

      if(item.referenceText != ''){
        Text(`引用: ${item.referenceText}`)
          .fontSize(12)
          .fontColor('#999999')
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 8 })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text(this.title != '' ? this.title : '当前会话')
            .fontSize(12)
            .fontColor('#666666')
          Blank()
          Text(`结果 ${this.messages.length}`)
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ left: 16, right: 16, top: 14, bottom: 14 })

        Refresh({ refreshing: $$this.refreshing, builder: this.refreshContent }) {
          List({ scroller: this.scroller }) {
            if(this.messages.length == 0){
              ListItem() {
                Column() {
                  Text('暂无提及我的消息')
                    .fontSize(14)
                    .fontColor('#999999')
                }
                .width('100%')
                .padding({ top: 48, bottom: 48 })
              }
            } else {
              ForEach(this.messages, (item:MessageViewItem) => {
                ListItem() {
                  this.mentionRow(item)
                }
              }, (item:MessageViewItem) => this.getItemKey(item))
            }

            if(this.messages.length > 0 && !this.hasMore){
              ListItem() {
                Text('没有更多了')
                  .fontSize(12)
                  .fontColor('#999999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .padding({ top: 16, bottom: 16 })
              }
            }
          }
          .divider({
            strokeWidth: 1,
            color: '#F3F4F6',
            startMargin: 16,
            endMargin: 16
          })
        }
        .onRefreshing(() => {
          setTimeout(async () => {
            if(this.hasMore){
              await this.loadMentionMessages(false)
            }
            this.refreshing = false
          }, 200)
        })
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_color_grey'))
    }
    .title('提及我的消息')
  }
}
