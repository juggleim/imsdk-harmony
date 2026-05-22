import { StandardIcon } from 'base'
import { promptAction } from '@kit.ArkUI'
import {
  Conversation,
  ConversationInfo,
  ConversationUpdateListener,
  GetConversationDirection,
  GetConversationOptions,
  GroupMember,
  JuggleIm
} from 'juggleim'
import { CommonUtil, ObservedArray } from '../jim/common'
import { ConversationRouteParams, MentionMessagesParams } from '../viewmodel/ConversationViewModel'

const TOP_TRACE_TAG:string = 'TOPTRACE'

@Observed
class GroupMemberPreviewItem {
  userId:string
  name:string
  portrait:string

  constructor(userId:string, name:string, portrait:string) {
    this.userId = userId
    this.name = name
    this.portrait = portrait
  }
}

@Component
export struct ConversationProfile {
  @Consume('pageInfo') pageInfo: NavPathStack
  @State private title:string = '会话详情'
  @State private conversationId:string = ''
  @State private conversationType:number = 1
  @State private typeLabel:string = ''
  @State private groupPortrait:string = ''
  @State private groupMembers:ObservedArray<GroupMemberPreviewItem> = new ObservedArray<GroupMemberPreviewItem>([])
  @State private groupMemberCount:number = 0
  @State private isConversationTop:boolean = false
  @State private isUpdatingConversationTop:boolean = false
  private conversationUpdateListener:ConversationUpdateListener = (_convers)=>{}

  aboutToAppear(): void {
    let params = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.conversationId = params.conversationId
    this.conversationType = params.converType
    this.title = params.title != '' ? params.title : '会话详情'
    console.log(`${TOP_TRACE_TAG} profile_appear: converId=${this.conversationId}, converType=${this.conversationType}, title=${this.title}`)
    this.typeLabel = this.conversationType == 2 ? '群聊' : '单聊'
    this.groupPortrait = ''
    this.groupMembers = new ObservedArray<GroupMemberPreviewItem>([])
    this.groupMemberCount = 0
    this.isConversationTop = false
    this.isUpdatingConversationTop = false
    this.bindConversationUpdateListener()
    this.loadConversationMeta()
    this.loadConversationSettings()
  }

  aboutToDisappear(): void {
    JuggleIm.instance.getConversationManager().removeConversationUpdateListener(this.conversationUpdateListener)
  }

  private loadConversationMeta():void{
    if(this.conversationType == 1){
      this.loadSingleConversationTitle()
      return
    }
    this.loadGroupInfo()
    this.loadGroupMembers()
  }

  private loadSingleConversationTitle():void{
    if(this.title != '' && this.title != '会话详情'){
      return
    }
    let user = JuggleIm.instance.getUserInfoManager().getLocalUserInfo(this.conversationId)
    if(user != null && user.nickname != ''){
      this.title = user.nickname
    }
  }

  private loadGroupInfo():void{
    let group = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(this.conversationId)
    if(group != null && group.groupName != ''){
      this.title = group.groupName
    }
    if(group != null && group.groupPortrait != ''){
      this.groupPortrait = group.groupPortrait
    }
    JuggleIm.instance.getGroupInfoManager().queryGroupInfo(this.conversationId, (code, remoteGroup)=>{
      if(code != 0 || remoteGroup == null){
        return
      }
      if(remoteGroup.groupName != ''){
        this.title = remoteGroup.groupName
      }
      if(remoteGroup.groupPortrait != ''){
        this.groupPortrait = remoteGroup.groupPortrait
      }
    })
  }

  private loadGroupMembers():void{
    let localMembers = JuggleIm.instance.getGroupInfoManager().getLocalGroupMembers(this.conversationId)
    if(localMembers.length > 0){
      this.groupMemberCount = localMembers.length
      this.buildGroupMemberPreview(localMembers)
    }
    JuggleIm.instance.getGroupInfoManager().queryGroupMembers(this.conversationId, (code, members)=>{
      if(code == 0){
        this.groupMemberCount = members.length
        this.buildGroupMemberPreview(members)
      }
    })
  }

  private getConversation():Conversation{
    return new Conversation(this.conversationId, this.conversationType)
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private bindConversationUpdateListener():void{
    JuggleIm.instance.getConversationManager().removeConversationUpdateListener(this.conversationUpdateListener)
    this.conversationUpdateListener = (convers)=>{
      for(let i = 0; i < convers.length; i++){
        let item = convers[i]
        if(item.conversation.conversationId == this.conversationId &&
          item.conversation.conversationType == this.conversationType){
          console.log(`${TOP_TRACE_TAG} profile_conversation_update: converId=${item.conversation.conversationId}, converType=${item.conversation.conversationType}, isTop=${item.isTop}, topTime=${item.topTime}`)
          this.applyConversationInfo(item)
          return
        }
      }
    }
    JuggleIm.instance.getConversationManager().addConversationUpdateListener(this.conversationUpdateListener)
  }

  private loadConversationSettings():void{
    let conversation = this.getConversation()
    JuggleIm.instance.getConversationManager().getConversation(conversation, (code, converInfo)=>{
      console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings: converId=${conversation.conversationId}, converType=${conversation.conversationType}, code=${code}, hasInfo=${converInfo != null}`)
      if(code == 0 && converInfo != null){
        this.applyConversationInfo(converInfo)
        return
      }
      this.loadConversationSettingsFromLocal()
    })
  }

  private loadConversationSettingsFromLocal():void{
    let options = new GetConversationOptions()
    options.count = 200
    options.time = 0
    options.direction = GetConversationDirection.Backward
    console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings_local_request: converId=${this.conversationId}, converType=${this.conversationType}, direction=${options.direction}, time=${options.time}, count=${options.count}, types=${JSON.stringify(options.conversationTypes)}, tagId=${options.tagId}`)
    JuggleIm.instance.getConversationManager().queryConversations(options, (code, convers)=>{
      console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings_local: converId=${this.conversationId}, converType=${this.conversationType}, code=${code}, count=${convers.length}`)
      if(code != 0){
        return
      }
      for(let i = 0; i < convers.length; i++){
        let item = convers[i]
        if(item.conversation.conversationId == this.conversationId &&
          item.conversation.conversationType == this.conversationType){
          console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings_local_hit: converId=${item.conversation.conversationId}, converType=${item.conversation.conversationType}, isTop=${item.isTop}, topTime=${item.topTime}`)
          this.applyConversationInfo(item)
          return
        }
      }
      console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings_local_miss: converId=${this.conversationId}, converType=${this.conversationType}`)
    })
  }

  private applyConversationInfo(conversationInfo:ConversationInfo):void{
    console.log(`${TOP_TRACE_TAG} profile_apply_conversation_info: converId=${conversationInfo.conversation.conversationId}, converType=${conversationInfo.conversation.conversationType}, isTop=${conversationInfo.isTop}, topTime=${conversationInfo.topTime}`)
    this.isConversationTop = conversationInfo.isTop
  }

  private updateConversationTop(nextValue:boolean):void{
    if(this.isUpdatingConversationTop || nextValue == this.isConversationTop){
      console.log(`${TOP_TRACE_TAG} profile_update_conversation_top_skip: converId=${this.conversationId}, converType=${this.conversationType}, nextValue=${nextValue}, currentValue=${this.isConversationTop}, updating=${this.isUpdatingConversationTop}`)
      return
    }
    console.log(`${TOP_TRACE_TAG} profile_update_conversation_top_start: converId=${this.conversationId}, converType=${this.conversationType}, from=${this.isConversationTop}, to=${nextValue}`)
    this.isUpdatingConversationTop = true
    JuggleIm.instance.getConversationManager().setTop(this.getConversation(), nextValue, (code)=>{
      this.isUpdatingConversationTop = false
      console.log(`${TOP_TRACE_TAG} profile_update_conversation_top_finish: converId=${this.conversationId}, converType=${this.conversationType}, target=${nextValue}, code=${code}`)
      if(code != 0){
        this.showToast(`会话置顶设置失败: ${code}`)
        return
      }
      this.isConversationTop = nextValue
      this.showToast(nextValue ? '已开启会话置顶' : '已取消会话置顶')
    })
  }

  private async buildGroupMemberPreview(members:GroupMember[]):Promise<void>{
    let previews:GroupMemberPreviewItem[] = []
    let limit = Math.min(members.length, 8)
    for(let i = 0; i < limit; i++){
      let member = members[i]
      let user = await JuggleIm.instance.getUserInfoManager().getUserInfo(member.memberId)
      let name = user.nickname != '' ? user.nickname : (member.displayName != '' ? member.displayName : member.memberId)
      previews.push(new GroupMemberPreviewItem(member.memberId, name, user.userPortrait))
    }
    this.groupMembers = new ObservedArray<GroupMemberPreviewItem>(previews)
  }

  private getGroupInitial():string{
    let value = this.title != '' && this.title != '会话详情' ? this.title : this.conversationId
    return CommonUtil.getFirstChar(value)
  }

  @Builder
  private groupAvatar() {
    if(this.groupPortrait != ''){
      Image(this.groupPortrait)
        .width(64)
        .height(64)
        .borderRadius(32)
        .margin({ top: 20 })
    }else{
      Stack() {
        Text(this.getGroupInitial())
          .fontSize(24)
          .fontColor(Color.White)
      }
      .width(64)
      .height(64)
      .borderRadius(32)
      .backgroundColor(CommonUtil.getBackgroundColor(this.getGroupInitial()))
      .margin({ top: 20 })
    }
  }

  @Builder
  private groupMemberAvatar(item:GroupMemberPreviewItem) {
    if(item.portrait != ''){
      Image(item.portrait)
        .width(44)
        .height(44)
        .borderRadius(22)
    }else{
      Stack() {
        Text(CommonUtil.getFirstChar(item.name))
          .fontSize(16)
          .fontColor(Color.White)
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .backgroundColor(CommonUtil.getBackgroundColor(item.name))
    }
  }

  @Builder
  private infoRow(label:string, value:string) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor('#666666')
      Blank()
      Text(value)
        .fontSize(15)
        .fontColor('#111111')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
  }

  @Builder
  private switchRow(label:string) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor('#666666')
      Text(this.isConversationTop ? '已置顶' : '未置顶')
        .fontSize(14)
        .fontColor(this.isConversationTop ? '#4C8DFF' : '#999999')
        .margin({ left: 12 })
      Blank()
      if(this.isConversationTop){
        Toggle({ type: ToggleType.Switch, isOn: true })
          .selectedColor('#4C8DFF')
          .enabled(!this.isUpdatingConversationTop)
          .onChange((value:boolean)=>{
            this.updateConversationTop(value)
          })
      }else{
        Toggle({ type: ToggleType.Switch, isOn: false })
          .selectedColor('#4C8DFF')
          .enabled(!this.isUpdatingConversationTop)
          .onChange((value:boolean)=>{
            this.updateConversationTop(value)
          })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .opacity(this.isUpdatingConversationTop ? 0.6 : 1)
  }

  build() {
    NavDestination() {
      Column() {
        if(this.conversationType == 2){
          Column() {
            this.groupAvatar()
            Text(this.title != '' ? this.title : this.conversationId)
              .fontSize(20)
              .fontColor('#111111')
              .margin({ top: 12 })
            Text(`${this.groupMemberCount} 位成员`)
              .fontSize(13)
              .fontColor('#666666')
              .margin({ top: 6, bottom: 20 })
          }
          .width('100%')
          .backgroundColor(Color.White)
        }

        Column() {
          this.infoRow('会话名称', this.title)
          Divider().strokeWidth(1).color('#EAEAEA')
          this.infoRow('会话类型', this.typeLabel)
          Divider().strokeWidth(1).color('#EAEAEA')
          this.infoRow('会话 ID', this.conversationId)
          Divider().strokeWidth(1).color('#EAEAEA')
          this.switchRow('会话置顶')
        }
        .width('100%')
        .backgroundColor(Color.White)
        .margin({ top: this.conversationType == 2 ? 12 : 0 })

        Column() {
          Row() {
            Text('历史消息')
              .fontSize(16)
              .fontColor('#111111')
            Blank()
            StandardIcon({ icon: $r('app.media.ic_public_more') })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .onClick(()=>{
            this.pageInfo.pushPath({
              name: 'ConversationHistory',
              param: new ConversationRouteParams(this.conversationId, this.conversationType, this.title)
            })
          })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .margin({ top: 12 })

        if(this.conversationType == 2){
          Column() {
            Row() {
              Text('提及我的消息')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
              StandardIcon({ icon: $r('app.media.ic_public_more') })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .onClick(()=>{
              this.pageInfo.pushPath({
                name: 'MentionMessages',
                param: new MentionMessagesParams(this.conversationId, this.conversationType, this.title)
              })
            })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 12 })
        }

        if(this.conversationType == 2){
          Column() {
            Row() {
              Text('群成员')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
              Text(`${this.groupMemberCount} 人`)
                .fontSize(14)
                .fontColor('#666666')
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16 })

            if(this.groupMembers.length > 0){
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.groupMembers, (item:GroupMemberPreviewItem)=>{
                  Column() {
                    this.groupMemberAvatar(item)
                    Text(item.name)
                      .fontSize(12)
                      .fontColor('#333333')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .width(56)
                      .textAlign(TextAlign.Center)
                      .margin({ top: 8 })
                  }
                  .width(56)
                  .margin({ right: 16, bottom: 16 })
                }, (item:GroupMemberPreviewItem)=>item.userId)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 16 })
            }else{
              Text('暂无群成员数据')
                .fontSize(13)
                .fontColor('#999999')
                .width('100%')
                .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            }
          }
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 12 })
        }

        Blank()
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_color_grey'))
    }
    .title('会话详情')
  }
}
