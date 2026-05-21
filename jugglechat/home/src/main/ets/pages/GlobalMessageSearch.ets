import { promptAction } from '@kit.ArkUI'
import { ObservedArray, CommonUtil } from '../jim/common'
import {
  Conversation,
  GetMessageDirection,
  GroupInfo,
  JimMsgType,
  JuggleIm,
  Message,
  SearchParams
} from 'juggleim'
import { buildMessagePreview, isDisplayableMessage, MessageViewItem, toMessageViewItem } from '../viewmodel/MessageViewModel'
import { ConversationDetailParams, GlobalMessageSearchParams } from '../viewmodel/ConversationViewModel'

@Observed
class SearchConversationGroup {
  conversationId:string
  conversationType:number
  title:string
  icon:string
  matchedCount:number = 0
  latestTime:number = 0
  previews:ObservedArray<MessageViewItem> = new ObservedArray<MessageViewItem>([])

  constructor(conversationId:string, conversationType:number, title:string, icon:string) {
    this.conversationId = conversationId
    this.conversationType = conversationType
    this.title = title
    this.icon = icon
  }
}

@Component
export struct GlobalMessageSearch {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private searchInput:string = ''
  @State private activeSearchKeyword:string = ''
  @State private groups:ObservedArray<SearchConversationGroup> = new ObservedArray<SearchConversationGroup>([])
  @State private selectedMessageTypeFilter:string = 'all'
  @State private selectedTimeRangeFilter:string = 'all'
  private messageTypeFilters:string[] = ['all', 'text', 'image', 'file', 'video', 'voice']
  private timeRangeFilters:string[] = ['all', '7d', '30d']

  aboutToAppear(): void {
    let params = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as GlobalMessageSearchParams
    this.searchInput = params.keywords
    if(this.searchInput.trim() != ''){
      this.performSearch()
    }
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
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

  private buildSearchParams():SearchParams{
    let params = new SearchParams()
    params.keywords = this.activeSearchKeyword
    params.msgTypes = this.buildContentTypes()
    params.startTime = this.getSearchStartTime()
    params.endTime = 0
    params.count = 200
    params.direction = GetMessageDirection.Backward
    return params
  }

  private async getConversationDisplayMeta(conversation:Conversation):Promise<SearchConversationGroup>{
    if(conversation.conversationType == 1){
      let user = await JuggleIm.instance.getUserInfoManager().getUserInfo(conversation.conversationId)
      let title = user.nickname != '' ? user.nickname : conversation.conversationId
      return new SearchConversationGroup(conversation.conversationId, conversation.conversationType, title, user.userPortrait)
    }
    let localGroup = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(conversation.conversationId)
    if(localGroup != null){
      let title = localGroup.groupName != '' ? localGroup.groupName : conversation.conversationId
      return new SearchConversationGroup(conversation.conversationId, conversation.conversationType, title, localGroup.groupPortrait)
    }
    let remoteGroup = await new Promise<GroupInfo | null>((resolve)=>{
      JuggleIm.instance.getGroupInfoManager().queryGroupInfo(conversation.conversationId, (code, group)=>{
        resolve(code == 0 ? group : null)
      })
    })
    if(remoteGroup != null){
      let title = remoteGroup.groupName != '' ? remoteGroup.groupName : conversation.conversationId
      return new SearchConversationGroup(conversation.conversationId, conversation.conversationType, title, remoteGroup.groupPortrait)
    }
    return new SearchConversationGroup(conversation.conversationId, conversation.conversationType, conversation.conversationId, '')
  }

  private async performSearch():Promise<void>{
    let keyword = this.searchInput.trim()
    this.activeSearchKeyword = keyword
    if(keyword == ''){
      this.groups = new ObservedArray<SearchConversationGroup>([])
      return
    }
    let params = this.buildSearchParams()
    JuggleIm.instance.getMessageManager().searchMessages(params, async (code, msgs)=>{
      if(code != 0){
        this.showToast(`搜索失败: ${code}`)
        return
      }
      let groupedMap:Map<string, SearchConversationGroup> = new Map()
      for(let i = 0; i < msgs.length; i++){
        let message:Message = msgs[i]
        if(!isDisplayableMessage(message)){
          continue
        }
        let conversation = message.conversation
        let key = `${conversation.conversationId}_${conversation.conversationType}`
        let group = groupedMap.get(key)
        if(group == undefined){
          group = await this.getConversationDisplayMeta(conversation)
          groupedMap.set(key, group)
        }
        let item = await toMessageViewItem(message)
        group.matchedCount = group.matchedCount + 1
        if(message.sentTime > group.latestTime){
          group.latestTime = message.sentTime
        }
        if(group.previews.length < 3){
          group.previews.push(item)
        }
      }
      let list:SearchConversationGroup[] = []
      groupedMap.forEach((group)=>{
        group.previews = new ObservedArray<MessageViewItem>(group.previews.slice().sort((a,b)=>b.msgTime-a.msgTime))
        list.push(group)
      })
      list = list.slice().sort((a,b)=>b.latestTime-a.latestTime)
      this.groups = new ObservedArray<SearchConversationGroup>(list)
    })
  }

  private clearSearch():void{
    this.searchInput = ''
    this.activeSearchKeyword = ''
    this.groups = new ObservedArray<SearchConversationGroup>([])
  }

  private applyMessageTypeFilter(filterKey:string):void{
    if(this.selectedMessageTypeFilter == filterKey){
      return
    }
    this.selectedMessageTypeFilter = filterKey
    if(this.activeSearchKeyword != ''){
      this.performSearch()
    }
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

  private openConversation(group:SearchConversationGroup):void{
    let userId = group.conversationType == 1 ? group.conversationId : ''
    this.pageInfo.pushPath({
      name: 'ConversationDetail',
      param: new ConversationDetailParams(userId, group.conversationId, group.conversationType, group.title)
    })
  }

  @Builder
  private groupItem(group:SearchConversationGroup) {
    Column() {
      Row() {
        if(group.icon != ''){
          Image(group.icon)
            .width(42)
            .height(42)
            .borderRadius(21)
        }else{
          Stack() {
            Text(CommonUtil.getFirstChar(group.title))
              .fontColor(Color.White)
          }
          .backgroundColor(CommonUtil.getBackgroundColor(group.title))
          .width(42)
          .height(42)
          .borderRadius(21)
        }

        Column() {
          Row() {
            Text(group.title)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#111111')
            Blank()
            Text(`${group.matchedCount} 条`)
              .fontSize(12)
              .fontColor('#2563EB')
          }
          .width('100%')

          Text(group.conversationType == 2 ? '群聊' : '单聊')
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
      }
      .width('100%')

      Column() {
        ForEach(group.previews, (item:MessageViewItem) => {
          Row() {
            Text(buildMessagePreview(item.msgContent))
              .fontSize(13)
              .fontColor('#555555')
              .layoutWeight(1)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Text(CommonUtil.getTimeToYYYYDDMMHHMMSS(item.msgTime))
              .fontSize(11)
              .fontColor('#AAAAAA')
          }
          .width('100%')
          .margin({ top: 8 })
        }, (item:MessageViewItem) => `${group.conversationId}_${item.messageId}_${item.clientId}`)
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
    .onClick(()=>{
      this.openConversation(group)
    })
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Row() {
            TextInput({ text: this.searchInput, placeholder: '搜索全部会话消息内容' })
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

          Text(`会话结果 ${this.groups.length}`)
            .fontSize(12)
            .fontColor('#999999')
            .width('100%')
            .margin({ top: 12 })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })

        List() {
          if(this.groups.length == 0){
            ListItem() {
              Column() {
                Text(this.activeSearchKeyword == '' ? '输入关键字开始搜索' : '暂无匹配会话')
                  .fontSize(14)
                  .fontColor('#999999')
              }
              .width('100%')
              .padding({ top: 48, bottom: 48 })
            }
          }else{
            ForEach(this.groups, (group:SearchConversationGroup) => {
              ListItem() {
                this.groupItem(group)
              }
            }, (group:SearchConversationGroup) => `${group.conversationId}_${group.conversationType}`)
          }
        }
        .divider({
          strokeWidth: 1,
          color: '#F3F4F6',
          startMargin: 16,
          endMargin: 16
        })
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_color_grey'))
    }
    .title('消息搜索')
  }
}
