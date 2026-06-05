import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants'
import { CommonUtil, ObservedArray } from '../../jim/common'
import { buildMessagePreview } from '../../viewmodel/MessageViewModel'
import {
  BroadcastMessageCallback,
  Conversation,
  ConversationInfo,
  GetConversationDirection,
  GetConversationOptions,
  JuggleIm,
  Message,
  TextMessage
} from 'juggleim'

const TOP_TRACE_TAG:string = 'TOPTRACE'

@Observed
class BroadcastConversationItem {
  key:string = ''
  conversation:Conversation = new Conversation('', 0, '')
  title:string = ''
  preview:string = ''
  time:string = ''
  selected:boolean = false

  constructor() {
  }
}

@Observed
class BroadcastProgressItem {
  key:string = ''
  title:string = ''
  status:string = '等待中'

  constructor() {
  }
}

class BroadcastSendCallback implements BroadcastMessageCallback {
  private progressHandler:(message: Message | null, code: number, processCount: number, totalCount: number) => void
  private completeHandler:() => void

  constructor(
    progressHandler:(message: Message | null, code: number, processCount: number, totalCount: number) => void,
    completeHandler:() => void
  ) {
    this.progressHandler = progressHandler
    this.completeHandler = completeHandler
  }

  onProgress(message: Message | null, code: number, processCount: number, totalCount: number): void {
    this.progressHandler(message, code, processCount, totalCount)
  }

  onComplete(): void {
    this.completeHandler()
  }
}

@Component
export default struct BroadcastMessagePage {
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  @State private messageText:string = ''
  @State private loading:boolean = false
  @State private sending:boolean = false
  @State private conversations:ObservedArray<BroadcastConversationItem> = new ObservedArray<BroadcastConversationItem>([])
  @State private progressItems:ObservedArray<BroadcastProgressItem> = new ObservedArray<BroadcastProgressItem>([])

  aboutToAppear(): void {
    this.loadConversations()
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private loadConversations():void{
    if(this.loading){
      return
    }
    this.loading = true
    let options = new GetConversationOptions()
    options.count = 200
    options.time = 0
    options.direction = GetConversationDirection.Backward
    console.log(`${TOP_TRACE_TAG} broadcast_page_load_start`)
    JuggleIm.instance.getConversationManager().queryConversations(options, async (code, convers)=>{
      this.loading = false
      console.log(`${TOP_TRACE_TAG} broadcast_page_load_finish: code=${code}, count=${convers.length}`)
      if(code != 0){
        this.showToast(`会话加载失败: ${code}`)
        return
      }
      let items:BroadcastConversationItem[] = []
      for(let i = 0; i < convers.length; i++){
        items.push(await this.toConversationItem(convers[i]))
      }
      this.conversations = new ObservedArray<BroadcastConversationItem>(items)
    })
  }

  private async toConversationItem(conver:ConversationInfo):Promise<BroadcastConversationItem>{
    let item = new BroadcastConversationItem()
    item.conversation = new Conversation(conver.conversation.conversationId, conver.conversation.conversationType, conver.conversation.subChannel)
    item.key = item.conversation.getKey()
    item.title = await this.resolveConversationTitle(conver)
    item.preview = conver.lastMessage.messageId != '' || conver.lastMessage.clientId != '' ? buildMessagePreview(conver.lastMessage.msgContent) : ''
    item.time = conver.converTime > 0 ? CommonUtil.getTimeToYYYYDDMMHHMMSS(conver.converTime) : ''
    return item
  }

  private async resolveConversationTitle(conver:ConversationInfo):Promise<string>{
    if(conver.conversation.conversationType == 1){
      let user = await JuggleIm.instance.getUserInfoManager().getUserInfo(conver.conversation.conversationId)
      if(user.nickname != ''){
        return user.nickname
      }
    }else if(conver.conversation.conversationType == 2){
      let group = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(conver.conversation.conversationId)
      if(group != null && group.groupName != ''){
        return group.groupName
      }
    }
    return conver.conversation.conversationId
  }

  private toggleConversation(item:BroadcastConversationItem):void{
    if(this.sending){
      return
    }
    let nextItems = this.conversations.slice()
    let foundIndex = nextItems.findIndex((current)=>{
      return current.key == item.key
    })
    if(foundIndex < 0){
      return
    }
    nextItems[foundIndex].selected = !nextItems[foundIndex].selected
    this.conversations = new ObservedArray<BroadcastConversationItem>(nextItems)
  }

  private getSelectedCount():number{
    return this.conversations.filter((item)=>{
      return item.selected
    }).length
  }

  private sendBroadcast():void{
    let content = this.messageText.trim()
    if(this.sending){
      return
    }
    if(content == ''){
      this.showToast('请输入广播消息内容')
      return
    }
    let selectedItems = this.conversations.filter((item)=>{
      return item.selected
    })
    if(selectedItems.length == 0){
      this.showToast('请至少选择一个会话')
      return
    }
    let textMessage = new TextMessage()
    textMessage.content = content
    this.sending = true
    this.progressItems = new ObservedArray<BroadcastProgressItem>(selectedItems.map((item)=>{
      let progressItem = new BroadcastProgressItem()
      progressItem.key = item.key
      progressItem.title = item.title
      return progressItem
    }))
    console.log(`${TOP_TRACE_TAG} broadcast_page_send_start: count=${selectedItems.length}, textLength=${content.length}, targets=${JSON.stringify(selectedItems.map((item)=>item.key))}`)
    let callback = new BroadcastSendCallback(
      (message:Message | null, code:number, processCount:number, totalCount:number)=>{
        let key = message != null ? message.conversation.getKey() : ''
        let nextItems = this.progressItems.slice()
        let foundIndex = nextItems.findIndex((item)=>{
          return item.key == key
        })
        if(foundIndex >= 0){
          nextItems[foundIndex].status = code == 0 ? '发送成功' : `发送失败: ${code}`
          this.progressItems = new ObservedArray<BroadcastProgressItem>(nextItems)
        }
        console.log(`${TOP_TRACE_TAG} broadcast_page_send_progress: processCount=${processCount}, totalCount=${totalCount}, key=${key}, code=${code}`)
      },
      ()=>{
        this.sending = false
        console.log(`${TOP_TRACE_TAG} broadcast_page_send_complete: count=${selectedItems.length}`)
        this.showToast('广播发送完成')
      }
    )
    JuggleIm.instance.getMessageManager().broadcastMessage(textMessage, selectedItems.map((item)=>{
      return new Conversation(item.conversation.conversationId, item.conversation.conversationType, item.conversation.subChannel)
    }), callback)
  }

  @Builder
  private selectedIndicator(selected:boolean) {
    Stack() {
      if(selected){
        Text('✓')
          .fontSize(14)
          .fontColor(Color.White)
      }
    }
    .width(22)
    .height(22)
    .borderRadius(11)
    .backgroundColor(selected ? '#4C8DFF' : '#D8DCE3')
  }

  build() {
    NavDestination(){
      Column(){
        Column() {
          TextInput({ text: this.messageText, placeholder: '输入广播消息内容' })
            .fontSize(15)
            .backgroundColor('#F5F6F8')
            .height(44)
            .padding({ left: 12, right: 12 })
            .onChange((value:string)=>{
              this.messageText = value
            })

          Row() {
            Text(`已选择 ${this.getSelectedCount()} 个会话`)
              .fontSize(13)
              .fontColor('#666666')
            Blank()
            Button(this.sending ? '发送中' : '发送广播')
              .height(36)
              .enabled(!this.sending)
              .onClick(()=>{
                this.sendBroadcast()
              })
          }
          .width('100%')
          .margin({ top: 12 })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })

        if(this.loading){
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
          .margin({ top: 48, bottom: 24 })
        }else if(this.conversations.length == 0){
          Column(){
            Text('暂无可广播会话')
              .fontSize(15)
              .fontColor('#999999')
          }
          .width('100%')
          .margin({ top: 48, bottom: 24 })
        }else{
          List() {
            ForEach(this.conversations, (item:BroadcastConversationItem)=>{
              ListItem() {
                Row() {
                  this.selectedIndicator(item.selected)
                  Column() {
                    Row() {
                      Text(item.title)
                        .fontSize(15)
                        .fontColor('#111111')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Blank()
                      if(item.time != ''){
                        Text(item.time)
                          .fontSize(12)
                          .fontColor('#999999')
                      }
                    }
                    .width('100%')

                    if(item.preview != ''){
                      Text(item.preview)
                        .fontSize(13)
                        .fontColor('#999999')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .width('100%')
                        .margin({ top: 6 })
                    }
                  }
                  .layoutWeight(1)
                  .margin({ left: 12 })
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                .backgroundColor(Color.White)
                .onClick(()=>{
                  this.toggleConversation(item)
                })
              }
            }, (item:BroadcastConversationItem)=>item.key)
          }
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 1, color: '#EAEAEA', startMargin: 16, endMargin: 16 })
        }

        if(this.progressItems.length > 0){
          Column() {
            Text('发送进度')
              .fontSize(15)
              .fontColor('#111111')
              .width('100%')
              .padding({ left: 16, right: 16, top: 16, bottom: 12 })

            ForEach(this.progressItems, (item:BroadcastProgressItem)=>{
              Row() {
                Text(item.title)
                  .fontSize(14)
                  .fontColor('#111111')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .layoutWeight(1)
                Text(item.status)
                  .fontSize(13)
                  .fontColor(item.status == '发送成功' ? '#3D8B37' : '#999999')
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
            }, (item:BroadcastProgressItem)=>item.key)
          }
          .width('100%')
          .backgroundColor(Color.White)
        }
      }
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
      .backgroundColor('#F5F6F8')
    }
    .title('广播消息')
  }
}
