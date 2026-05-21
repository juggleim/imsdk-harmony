import { StandardIcon } from 'base'
import { GroupMember, JuggleIm } from 'juggleim'
import { CommonUtil, ObservedArray } from '../jim/common'
import { ConversationRouteParams, MentionMessagesParams } from '../viewmodel/ConversationViewModel'

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

  aboutToAppear(): void {
    let params = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationRouteParams
    this.conversationId = params.conversationId
    this.conversationType = params.converType
    this.title = params.title != '' ? params.title : '会话详情'
    this.typeLabel = this.conversationType == 2 ? '群聊' : '单聊'
    this.groupPortrait = ''
    this.groupMembers = new ObservedArray<GroupMemberPreviewItem>([])
    this.groupMemberCount = 0
    this.loadConversationMeta()
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

  build() {
    NavDestination() {
      Column() {
        if(this.conversationType == 2){
          Column() {
            this.groupAvatar()
              .margin({ top: 20 })
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
