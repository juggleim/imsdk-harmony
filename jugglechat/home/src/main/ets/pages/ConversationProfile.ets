import { promptAction } from '@kit.ArkUI'
import { StandardIcon } from 'base'
import {
  ClearMsgOptions,
  Conversation,
  ConversationInfo,
  ConversationUpdateListener,
  GetConversationDirection,
  GetConversationOptions,
  GroupMember,
  JuggleIm
} from 'juggleim'
import { CommonUtil, ObservedArray } from '../jim/common'
import { GroupSettingStore } from '../jim/groupsettingstore'
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
  @State private conversationSubChannel:string = ''
  @State private typeLabel:string = ''
  @State private groupPortrait:string = ''
  @State private groupMembers:ObservedArray<GroupMemberPreviewItem> = new ObservedArray<GroupMemberPreviewItem>([])
  @State private groupMemberCount:number = 0
  @State private groupAnnouncement:string = ''
  @State private myGroupNickname:string = ''
  @State private friendStatus:string = ''
  @State private friendAlias:string = ''
  @State private isConversationTop:boolean = false
  @State private isUpdatingConversationTop:boolean = false
  @State private isConversationMute:boolean = false
  @State private isUpdatingConversationMute:boolean = false
  @State private isClearingMessages:boolean = false
  private conversationUpdateListener:ConversationUpdateListener = (_convers)=>{}

  aboutToAppear(): void {
    let params = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.conversationId = params.conversationId
    this.conversationType = params.converType
    this.title = params.title != '' ? params.title : '会话详情'
    this.conversationSubChannel = params.subChannel ?? ''
    console.log(`${TOP_TRACE_TAG} profile_appear: converId=${this.conversationId}, converType=${this.conversationType}, title=${this.title}`)
    this.typeLabel = this.conversationType == 2 ? '群聊' : '单聊'
    this.groupPortrait = ''
    this.groupMembers = new ObservedArray<GroupMemberPreviewItem>([])
    this.groupMemberCount = 0
    this.groupAnnouncement = ''
    this.myGroupNickname = ''
    this.friendStatus = ''
    this.friendAlias = ''
    this.isConversationTop = false
    this.isUpdatingConversationTop = false
    this.isConversationMute = false
    this.isUpdatingConversationMute = false
    this.isClearingMessages = false
    this.bindConversationUpdateListener()
    this.loadConversationMeta()
    this.loadConversationSettings()
    this.loadGroupLocalSettings()
  }

  onPageShow(): void {
    this.loadConversationMeta()
    this.loadConversationSettings()
    this.loadGroupLocalSettings()
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
    } else {
      this.title = this.conversationId
    }
    JuggleIm.instance.getUserInfoManager().queryUserInfo(this.conversationId, (code, remoteUser)=>{
      if(code == 0 && remoteUser.nickname != ''){
        this.title = remoteUser.nickname
      }
    })
    JuggleIm.instance.getUserInfoManager().queryFriendInfo(this.conversationId, (code, friendInfo)=>{
      if(code != 0 || friendInfo == null){
        this.friendStatus = '好友状态异常'
        this.friendAlias = ''
        return
      }
      this.friendStatus = friendInfo.isFriend ? '好友' : '非好友'
      this.friendAlias = friendInfo.alias != '' ? friendInfo.alias : ''
    })
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

  private loadGroupLocalSettings():void{
    if(this.conversationType != 2){
      return
    }
    let setting = GroupSettingStore.getGroupSetting(this.conversationId)
    if(setting != null){
      this.groupAnnouncement = setting.announcement
      this.myGroupNickname = setting.myNickname
      return
    }
    this.groupAnnouncement = ''
    this.myGroupNickname = ''
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

  private bindConversationUpdateListener():void{
    JuggleIm.instance.getConversationManager().removeConversationUpdateListener(this.conversationUpdateListener)
    this.conversationUpdateListener = (convers)=>{
      for(let i = 0; i < convers.length; i++){
        let item = convers[i]
        if(item.conversation.conversationId == this.conversationId &&
          item.conversation.conversationType == this.conversationType &&
          (item.conversation.subChannel ?? '') == this.conversationSubChannel){
          console.log(`${TOP_TRACE_TAG} profile_conversation_update: converId=${item.conversation.conversationId}, converType=${item.conversation.conversationType}, isTop=${item.isTop}, topTime=${item.topTime}, isMute=${item.isMute}`)
          this.applyConversationInfo(item)
          return
        }
      }
    }
    JuggleIm.instance.getConversationManager().addConversationUpdateListener(this.conversationUpdateListener)
  }

  private loadConversationSettings():void{
    this.loadConversationSettingsFromLocal()
  }

  private loadConversationSettingsFromRemote():void{
    let conversation = this.getConversation()
    JuggleIm.instance.getConversationManager().getConversation(conversation, (code, converInfo)=>{
      console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings_remote: converId=${conversation.conversationId}, converType=${conversation.conversationType}, code=${code}, hasInfo=${converInfo != null}`)
      if(code == 0 && converInfo != null){
        this.applyConversationInfo(converInfo)
      }
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
          item.conversation.conversationType == this.conversationType &&
          (item.conversation.subChannel ?? '') == this.conversationSubChannel){
          console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings_local_hit: converId=${item.conversation.conversationId}, converType=${item.conversation.conversationType}, isTop=${item.isTop}, topTime=${item.topTime}, isMute=${item.isMute}`)
          this.applyConversationInfo(item)
          return
        }
      }
      console.log(`${TOP_TRACE_TAG} profile_load_conversation_settings_local_miss: converId=${this.conversationId}, converType=${this.conversationType}`)
      this.loadConversationSettingsFromRemote()
    })
  }

  private applyConversationInfo(conversationInfo:ConversationInfo):void{
    console.log(`${TOP_TRACE_TAG} profile_apply_conversation_info: converId=${conversationInfo.conversation.conversationId}, converType=${conversationInfo.conversation.conversationType}, isTop=${conversationInfo.isTop}, topTime=${conversationInfo.topTime}, isMute=${conversationInfo.isMute}`)
    this.isConversationTop = conversationInfo.isTop
    this.isConversationMute = conversationInfo.isMute
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

  private updateConversationMute(nextValue:boolean):void{
    if(this.isUpdatingConversationMute || nextValue == this.isConversationMute){
      console.log(`${TOP_TRACE_TAG} profile_update_conversation_mute_skip: converId=${this.conversationId}, converType=${this.conversationType}, nextValue=${nextValue}, currentValue=${this.isConversationMute}, updating=${this.isUpdatingConversationMute}`)
      return
    }
    console.log(`${TOP_TRACE_TAG} profile_update_conversation_mute_start: converId=${this.conversationId}, converType=${this.conversationType}, from=${this.isConversationMute}, to=${nextValue}`)
    this.isUpdatingConversationMute = true
    JuggleIm.instance.getConversationManager().setMute(this.getConversation(), nextValue, (code)=>{
      this.isUpdatingConversationMute = false
      console.log(`${TOP_TRACE_TAG} profile_update_conversation_mute_finish: converId=${this.conversationId}, converType=${this.conversationType}, target=${nextValue}, code=${code}`)
      if(code != 0){
        this.showToast(`消息免打扰设置失败: ${code}`)
        return
      }
      this.isConversationMute = nextValue
      this.showToast(nextValue ? '已开启消息免打扰' : '已关闭消息免打扰')
    })
  }

  private confirmClearMessages():void{
    if(this.isClearingMessages){
      return
    }
    AlertDialog.show({
      title: '清空消息',
      message: '确认清空当前会话的历史消息吗？',
      autoCancel: true,
      primaryButton: {
        value: '取消',
        action: () => {}
      },
      secondaryButton: {
        value: '清空',
        action: () => {
          this.clearConversationMessages()
        }
      }
    })
  }

  private clearConversationMessages():void{
    if(this.isClearingMessages){
      return
    }
    this.isClearingMessages = true
    let options = new ClearMsgOptions()
    options.cleanTime = 0
    options.cleanScope = 0
    options.senderId = ''
    options.cleanTimeOffset = 0
    JuggleIm.instance.getMessageManager().clearMessages(this.getConversation(), options, (code)=>{
      this.isClearingMessages = false
      console.log(`${TOP_TRACE_TAG} profile_clear_messages_finish: converId=${this.conversationId}, converType=${this.conversationType}, code=${code}`)
      if(code != 0){
        this.showToast(`清空消息失败: ${code}`)
        return
      }
      this.showToast('已清空消息')
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
  private trailingMoreIcon() {
    Stack() {
      StandardIcon({ icon: $r('app.media.ic_public_more') })
        .width(16)
        .height(16)
        .opacity(0.55)
    }
    .width(20)
    .height(20)
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
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
  }

  @Builder
  private switchRow(label:string, isOn:boolean, isUpdating:boolean, activeText:string, inactiveText:string, onChanged:(value:boolean)=>void) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor('#666666')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .constraintSize({ maxWidth: '58%' })
      Text(isOn ? activeText : inactiveText)
        .fontSize(14)
        .fontColor(isOn ? '#4C8DFF' : '#999999')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: 12, right: 8 })
      Blank()
      if(isOn){
        Toggle({ type: ToggleType.Switch, isOn: true })
          .selectedColor('#4C8DFF')
          .enabled(!isUpdating)
          .onChange((value:boolean)=>{
            onChanged(value)
          })
      }else{
        Toggle({ type: ToggleType.Switch, isOn: false })
          .selectedColor('#4C8DFF')
          .enabled(!isUpdating)
          .onChange((value:boolean)=>{
            onChanged(value)
          })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .opacity(isUpdating ? 0.6 : 1)
  }

  @Builder
  private actionRow(label:string, color:ResourceColor = '#111111') {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor(color)
      Blank()
      this.trailingMoreIcon()
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
  }

  private openGroupPage(name:string):void{
    this.pageInfo.pushPath({
      name,
      param: new ConversationRouteParams(this.conversationId, this.conversationType, this.title, this.conversationSubChannel)
    })
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
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')
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
          if(this.conversationType == 1){
            this.infoRow('好友状态', this.friendStatus != '' ? this.friendStatus : '加载中')
            Divider().strokeWidth(1).color('#EAEAEA')
            this.infoRow('好友备注', this.friendAlias != '' ? this.friendAlias : '无')
            Divider().strokeWidth(1).color('#EAEAEA')
          }
          else{
            this.infoRow('会话类型', this.typeLabel)
            Divider().strokeWidth(1).color('#EAEAEA')
          }
          this.infoRow('会话 ID', this.conversationId)
          Divider().strokeWidth(1).color('#EAEAEA')
          this.switchRow('消息免打扰', this.isConversationMute, this.isUpdatingConversationMute, '已开启', '未开启', (value:boolean)=>{
            this.updateConversationMute(value)
          })
          Divider().strokeWidth(1).color('#EAEAEA')
          this.switchRow('会话置顶', this.isConversationTop, this.isUpdatingConversationTop, '已置顶', '未置顶', (value:boolean)=>{
            this.updateConversationTop(value)
          })
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
              this.trailingMoreIcon()
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .onClick(()=>{
            this.pageInfo.pushPath({
              name: 'ConversationHistory',
              param: new ConversationRouteParams(this.conversationId, this.conversationType, this.title, this.conversationSubChannel)
            })
          })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .margin({ top: 12 })

        Column() {
          this.actionRow('清空消息', '#E24A4A')
        }
        .width('100%')
        .backgroundColor(Color.White)
        .margin({ top: 12 })
        .opacity(this.isClearingMessages ? 0.6 : 1)
        .onClick(()=>{
          this.confirmClearMessages()
        })

        if(this.conversationType == 2){
          Column() {
            Row() {
              Text('提及我的消息')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
              this.trailingMoreIcon()
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .onClick(()=>{
              this.pageInfo.pushPath({
              name: 'MentionMessages',
              param: new MentionMessagesParams(this.conversationId, this.conversationType, this.title, this.conversationSubChannel)
            })
          })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 12 })
        }

        if(this.conversationType == 2){
          Column() {
            this.infoRow('群公告', this.groupAnnouncement != '' ? this.groupAnnouncement : '未设置')
            Divider().strokeWidth(1).color('#EAEAEA')
            this.infoRow('我的群昵称', this.myGroupNickname != '' ? this.myGroupNickname : '未设置')
            Divider().strokeWidth(1).color('#EAEAEA')
            Row() {
              Text('群管理总览')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
              this.trailingMoreIcon()
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openGroupPage('GroupManagement')
            })
            Divider().strokeWidth(1).color('#EAEAEA')
            Row() {
              Text('群公告设置')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
              this.trailingMoreIcon()
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openGroupPage('GroupAnnouncement')
            })
            Divider().strokeWidth(1).color('#EAEAEA')
            Row() {
              Text('群昵称设置')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
              this.trailingMoreIcon()
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openGroupPage('GroupNickname')
            })
            Divider().strokeWidth(1).color('#EAEAEA')
            Row() {
              Text('群成员管理')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
              this.trailingMoreIcon()
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openGroupPage('GroupMembers')
            })
            Divider().strokeWidth(1).color('#EAEAEA')
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
