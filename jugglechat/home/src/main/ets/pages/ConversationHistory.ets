import { promptAction } from '@kit.ArkUI'
import { ObservedArray, CommonUtil } from '../jim/common'
import {
  Conversation,
  GetMessageDirection,
  GetMessageOptions,
  JimMsgType,
  JuggleIm,
  Message,
  SearchParams
} from '@juggleim/imlib'
import { isDisplayableMessage, MessageViewItem, toMessageViewItem } from '../viewmodel/MessageViewModel'
import { ConversationDetailParams, ConversationRouteParams } from '../viewmodel/ConversationViewModel'

@Component
export struct ConversationHistory {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private conversationId:string = ''
  @State private conversationType:number = 1
  @State private conversationSubChannel:string = ''
  @State private conversationTitle:string = ''
  @State private sourceMessages:ObservedArray<MessageViewItem> = new ObservedArray<MessageViewItem>([])
  @State private displayMessages:ObservedArray<MessageViewItem> = new ObservedArray<MessageViewItem>([])
  @State private selectedMessageTypeFilter:string = 'all'
  @State private searchInput:string = ''
  @State private activeSearchKeyword:string = ''
  @State private selectedTimeRangeFilter:string = 'all'
  @State private refreshing:boolean = false
  private minMsgTime:number = Number.MAX_SAFE_INTEGER
  private maxMsgTime:number = 0
  private scroller:Scroller = new Scroller()
  private messageTypeFilters:string[] = ['all', 'text', 'image', 'file', 'video', 'voice']
  private timeRangeFilters:string[] = ['all', '7d', '30d']

  aboutToAppear(): void {
    let params = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.conversationId = params.conversationId
    this.conversationType = params.converType
    this.conversationSubChannel = params.subChannel ?? ''
    this.conversationTitle = params.title
    this.loadInitialHistory()
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

  private openConversation():void{
    this.pageInfo.pushPath({
      name: 'ConversationDetail',
      param: new ConversationDetailParams(
        this.conversationType == 1 ? this.conversationId : '',
        this.conversationId,
        this.conversationType,
        this.conversationTitle,
        this.conversationSubChannel
      )
    })
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private recordMsgTime(time:number):void{
    if(time > this.maxMsgTime){
      this.maxMsgTime = time
    }
    if(time < this.minMsgTime){
      this.minMsgTime = time
    }
  }

  private resetHistory():void{
    this.sourceMessages = new ObservedArray<MessageViewItem>([])
    this.displayMessages = new ObservedArray<MessageViewItem>([])
    this.minMsgTime = Number.MAX_SAFE_INTEGER
    this.maxMsgTime = 0
  }

  private getItemKey(item:MessageViewItem):string{
    if(item.messageId != ''){
      return item.messageId
    }
    return item.clientId
  }

  private getMessageTypeFilterLabel(filterKey:string):string{
    if(filterKey == 'text'){
      return '文本'
    }
    if(filterKey == 'image'){
      return '图片'
    }
    if(filterKey == 'file'){
      return '文件'
    }
    if(filterKey == 'video'){
      return '视频'
    }
    if(filterKey == 'voice'){
      return '语音'
    }
    return '全部'
  }

  private getTimeRangeFilterLabel(filterKey:string):string{
    if(filterKey == '7d'){
      return '近7天'
    }
    if(filterKey == '30d'){
      return '近30天'
    }
    return '全部时间'
  }

  private getMessageTypeLabel(msgType:string):string{
    if(msgType == JimMsgType.Text){
      return '文本'
    }
    if(msgType == JimMsgType.Image){
      return '图片'
    }
    if(msgType == JimMsgType.File){
      return '文件'
    }
    if(msgType == JimMsgType.Video){
      return '视频'
    }
    if(msgType == JimMsgType.Voice){
      return '语音'
    }
    if(msgType == JimMsgType.Merge){
      return '聊天记录'
    }
    return '消息'
  }

  private buildContentTypes():string[]{
    if(this.selectedMessageTypeFilter == 'text'){
      return [JimMsgType.Text]
    }
    if(this.selectedMessageTypeFilter == 'image'){
      return [JimMsgType.Image]
    }
    if(this.selectedMessageTypeFilter == 'file'){
      return [JimMsgType.File]
    }
    if(this.selectedMessageTypeFilter == 'video'){
      return [JimMsgType.Video]
    }
    if(this.selectedMessageTypeFilter == 'voice'){
      return [JimMsgType.Voice]
    }
    return []
  }

  private buildMessageQueryOptions(direction:GetMessageDirection, time:number):GetMessageOptions{
    let options = new GetMessageOptions()
    options.count = 20
    options.time = time
    options.direction = direction
    options.contentTypes = this.buildContentTypes()
    return options
  }

  private getSearchStartTime():number{
    let now = new Date().getTime()
    if(this.selectedTimeRangeFilter == '7d'){
      return now - 7 * 24 * 60 * 60 * 1000
    }
    if(this.selectedTimeRangeFilter == '30d'){
      return now - 30 * 24 * 60 * 60 * 1000
    }
    return 0
  }

  private async upsertMessage(message:Message):Promise<void>{
    if(!isDisplayableMessage(message)){
      return
    }
    let viewItem = await toMessageViewItem(message)
    let currentKey = this.getItemKey(viewItem)
    let foundIndex = this.sourceMessages.findIndex((item)=>{
      return this.getItemKey(item) == currentKey ||
        (viewItem.messageId != '' && item.messageId == viewItem.messageId) ||
        (viewItem.clientId != '' && item.clientId == viewItem.clientId)
    })
    if(foundIndex >= 0){
      this.sourceMessages[foundIndex] = viewItem
    }else{
      this.sourceMessages.push(viewItem)
    }
    this.recordMsgTime(message.sentTime)
  }

  private syncDisplayMessages():void{
    this.displayMessages = new ObservedArray<MessageViewItem>(this.sourceMessages.slice().sort((a,b)=>a.msgTime-b.msgTime))
  }

  private buildSearchParams():SearchParams{
    let params = new SearchParams()
    params.conver = this.getConversation()
    params.keywords = this.activeSearchKeyword
    params.msgTypes = this.buildContentTypes()
    params.startTime = this.getSearchStartTime()
    params.endTime = 0
    params.count = 100
    params.direction = GetMessageDirection.Backward
    return params
  }

  private async performSearch():Promise<void>{
    let keyword = this.searchInput.trim()
    this.activeSearchKeyword = keyword
    if(keyword == ''){
      this.syncDisplayMessages()
      return
    }
    let params = this.buildSearchParams()
    JuggleIm.instance.getMessageManager().searchMessages(params, async (code, msgs)=>{
      if(code != 0){
        this.showToast(`搜索失败: ${code}`)
        return
      }
      let results:MessageViewItem[] = []
      for(let i = 0; i < msgs.length; i++){
        if(!isDisplayableMessage(msgs[i])){
          continue
        }
        results.push(await toMessageViewItem(msgs[i]))
      }
      this.displayMessages = new ObservedArray<MessageViewItem>(results.slice().sort((a,b)=>a.msgTime-b.msgTime))
    })
  }

  private clearSearch():void{
    this.searchInput = ''
    this.activeSearchKeyword = ''
    this.syncDisplayMessages()
  }

  private queryHistory(direction:GetMessageDirection, time:number, reset:boolean):void{
    if(reset){
      this.resetHistory()
    }
    let options = this.buildMessageQueryOptions(direction, time)
    JuggleIm.instance.getMessageManager().queryMessages(this.getConversation(), options, async (code, msgs)=>{
      if(code != 0){
        this.showToast(`历史消息加载失败: ${code}`)
        return
      }
      for(let i = 0; i < msgs.length; i++){
        await this.upsertMessage(msgs[i])
      }
      this.sourceMessages = new ObservedArray<MessageViewItem>(this.sourceMessages.slice().sort((a,b)=>a.msgTime-b.msgTime))
      if(this.activeSearchKeyword != ''){
        await this.performSearch()
      }else{
        this.syncDisplayMessages()
      }
    })
  }

  private loadInitialHistory():void{
    this.queryHistory(GetMessageDirection.Backward, 0, true)
  }

  private loadOlderHistory():void{
    let anchorTime = this.minMsgTime == Number.MAX_SAFE_INTEGER ? 0 : this.minMsgTime
    this.queryHistory(GetMessageDirection.Backward, anchorTime, false)
  }

  private loadNewerHistory():void{
    let anchorTime = this.maxMsgTime
    if(anchorTime <= 0){
      this.loadInitialHistory()
      return
    }
    this.queryHistory(GetMessageDirection.Forward, anchorTime, false)
  }

  private applyMessageTypeFilter(filterKey:string):void{
    if(this.selectedMessageTypeFilter == filterKey){
      return
    }
    this.selectedMessageTypeFilter = filterKey
    if(this.activeSearchKeyword != ''){
      this.performSearch()
      return
    }
    this.loadInitialHistory()
  }

  private applyTimeRangeFilter(filterKey:string):void{
    if(this.selectedTimeRangeFilter == filterKey){
      return
    }
    this.selectedTimeRangeFilter = filterKey
    if(this.activeSearchKeyword != ''){
      this.performSearch()
    }
  }

  @Builder
  private historyRow(item:MessageViewItem) {
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

      Row() {
        Text(this.getMessageTypeLabel(item.msgType))
          .fontSize(11)
          .fontColor('#3B82F6')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .border({
            width: 1,
            color: '#BFDBFE'
          })
          .borderRadius(10)
        Blank()
      }
      .width('100%')
      .margin({ top: 10 })

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
        Column() {
          Row() {
            TextInput({ text: this.searchInput, placeholder: '输入关键字搜索消息内容' })
              .layoutWeight(1)
              .height(40)
              .backgroundColor('#F3F4F6')
              .borderRadius(10)
              .fontSize(14)
              .padding({ left: 14, right: 14 })
              .onChange((value:string)=>{
                this.searchInput = value
              })
            Button('搜索')
              .type(ButtonType.Normal)
              .fontSize(13)
              .height(40)
              .margin({ left: 8 })
              .onClick(async ()=>{
                await this.performSearch()
              })
            Button('清空')
              .type(ButtonType.Normal)
              .fontSize(13)
              .height(40)
              .margin({ left: 8 })
              .onClick(()=>{
                this.clearSearch()
              })
          }
          .width('100%')

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.messageTypeFilters, (filterKey:string) => {
              Text(this.getMessageTypeFilterLabel(filterKey))
                .fontSize(12)
                .fontColor(this.selectedMessageTypeFilter == filterKey ? Color.White : '#666666')
                .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                .backgroundColor(this.selectedMessageTypeFilter == filterKey ? '#3B82F6' : '#F3F4F6')
                .borderRadius(14)
                .margin({ right: 8, top: 12 })
                .onClick(()=>{
                  this.applyMessageTypeFilter(filterKey)
                })
            }, (filterKey:string) => filterKey)
          }
          .width('100%')

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.timeRangeFilters, (filterKey:string) => {
              Text(this.getTimeRangeFilterLabel(filterKey))
                .fontSize(12)
                .fontColor(this.selectedTimeRangeFilter == filterKey ? Color.White : '#666666')
                .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                .backgroundColor(this.selectedTimeRangeFilter == filterKey ? '#2563EB' : '#F3F4F6')
                .borderRadius(14)
                .margin({ right: 8, top: 12 })
                .onClick(()=>{
                  this.applyTimeRangeFilter(filterKey)
                })
            }, (filterKey:string) => filterKey)
          }
          .width('100%')

          Row() {
            Button('加载较新')
              .type(ButtonType.Normal)
              .fontSize(13)
              .layoutWeight(1)
              .onClick(()=>{
                this.loadNewerHistory()
              })
            Button('加载更早')
              .type(ButtonType.Normal)
              .fontSize(13)
              .layoutWeight(1)
              .onClick(()=>{
                this.loadOlderHistory()
              })
          }
          .width('100%')
          .margin({ top: 12 })
          .constraintSize({ minHeight: 36 })

          Text(`结果 ${this.displayMessages.length}`)
            .fontSize(12)
            .fontColor('#999999')
            .width('100%')
            .margin({ top: 12 })

          if(this.activeSearchKeyword != ''){
            Text(`关键字: ${this.activeSearchKeyword}`)
              .fontSize(12)
              .fontColor('#666666')
              .width('100%')
              .margin({ top: 6 })
          }
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ left: 16, right: 16, bottom: 16 })

        Refresh({ refreshing: $$this.refreshing, builder: this.refreshContent }) {
          List({ scroller: this.scroller }) {
            if(this.displayMessages.length == 0){
              ListItem() {
                Column() {
                  Text('暂无匹配消息')
                    .fontSize(14)
                    .fontColor('#999999')
                }
                .width('100%')
                .padding({ top: 48, bottom: 48 })
              }
            } else {
              ForEach(this.displayMessages, (item:MessageViewItem) => {
                ListItem() {
                  this.historyRow(item)
                }
                .onClick(()=>{
                  this.openConversation()
                })
              }, (item:MessageViewItem) => this.getItemKey(item))
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
          setTimeout(() => {
            this.loadOlderHistory()
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
    .title('历史消息')
  }
}
