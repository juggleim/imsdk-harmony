import { promptAction } from '@kit.ArkUI'
import { BaseConstants, StandardIcon } from 'base'
import { HomeConstants } from '../constants/HomeConstants'
import { deviceInfo } from '@kit.BasicServicesKit'
import { JuggleIm } from 'juggleim'
import { JimServer } from '../jim/jimserver/jimserver'
import { PreferenceUtil } from '../jim/preferenceutil'
import { NavSourceParam } from '../viewmodel/ConversationViewModel'

const PROFILE_AVATARS: ResourceStr[] = [
  $r('app.media.avatar1'),
  $r('app.media.avatar2'),
  $r('app.media.avatar3'),
  $r('app.media.avatar4'),
  $r('app.media.avatar5'),
  $r('app.media.avatar6'),
  $r('app.media.avatar7'),
  $r('app.media.avatar8'),
  $r('app.media.avatar9'),
  $r('app.media.avatar10'),
  $r('app.media.avatar11')
]

@Component
export struct ProfileSetting {
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo: NavPathStack
  @Consume('activeNavSource') activeNavSource: string
  @State private userId: string = ''
  @State private nickname: string = ''
  @State private selectedAvatarIndex: number = 1
  @State private previewAvatar: ResourceStr = HomeConstants.DEFAULT_AVATAR
  @State private activePageInfo: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    this.activePageInfo = this.resolveActivePageInfo()
    this.loadProfile()
  }

  private getStackSource(stack: NavPathStack): string {
    if (stack.size() <= 0) {
      return ''
    }
    let param = stack.getParamByIndex(stack.size() - 1) as NavSourceParam
    if (param != undefined && param.source != '') {
      return param.source
    }
    return ''
  }

  private resolveActivePageInfo(): NavPathStack {
    if (this.activeNavSource == 'settings') {
      return this.mySettingPageInfo
    }
    if (this.activeNavSource == 'home') {
      return this.pageInfo
    }
    let settingSource = this.getStackSource(this.mySettingPageInfo)
    if (settingSource == 'settings') {
      return this.mySettingPageInfo
    }
    let homeSource = this.getStackSource(this.pageInfo)
    if (homeSource == 'home') {
      return this.pageInfo
    }
    if (this.mySettingPageInfo.size() > this.pageInfo.size()) {
      return this.mySettingPageInfo
    }
    return this.pageInfo
  }

  private loadProfile():void{
    let auth = PreferenceUtil.getCacheAuth()
    if(auth == undefined){
      return
    }
    this.userId = auth.user_id
    let localProfile = PreferenceUtil.getProfileDisplay()
    if(localProfile != undefined && localProfile.nickname != ''){
      this.nickname = localProfile.nickname
      this.selectedAvatarIndex = this.normalizeAvatarIndex(localProfile.avatarIndex)
      this.previewAvatar = this.getAvatarResource(this.selectedAvatarIndex)
      return
    }
    let localUser = JuggleIm.instance.userInfo
    if(localUser.nickname != ''){
      this.nickname = localUser.nickname
    }
    if(localUser.userPortrait != ''){
      this.previewAvatar = localUser.userPortrait
    }
    JimServer.instance.getUserManager().GetUserInfo(this.userId, (user)=>{
      if(user == null){
        return
      }
      if(this.nickname == ''){
        this.nickname = user.nickname
      }
      if(user.avatar != ''){
        this.previewAvatar = user.avatar
      }
    })
  }

  private normalizeAvatarIndex(index:number):number{
    if(index < 1 || index > PROFILE_AVATARS.length){
      return 1
    }
    return index
  }

  private getAvatarResource(index:number):ResourceStr{
    return PROFILE_AVATARS[this.normalizeAvatarIndex(index) - 1]
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

  private selectAvatar(index:number):void{
    this.selectedAvatarIndex = this.normalizeAvatarIndex(index)
    this.previewAvatar = this.getAvatarResource(this.selectedAvatarIndex)
  }

  private saveProfile():void{
    let cleanName = this.nickname.trim()
    if(cleanName == ''){
      this.showToast('请输入昵称')
      return
    }
    PreferenceUtil.setProfileDisplay(cleanName, this.selectedAvatarIndex)
    JuggleIm.instance.userInfo.nickname = cleanName
    if (typeof this.previewAvatar === 'string') {
      JuggleIm.instance.userInfo.userPortrait = this.previewAvatar
    }
    this.showToast('已保存')
    this.back()
  }

  private resetProfile():void{
    PreferenceUtil.clearProfileDisplay()
    this.nickname = ''
    this.selectedAvatarIndex = 1
    this.previewAvatar = HomeConstants.DEFAULT_AVATAR
    this.loadProfile()
    this.showToast('已恢复默认')
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              if(this.previewAvatar != ''){
                Image(this.previewAvatar)
                  .width(104)
                  .height(104)
                  .borderRadius(52)
              }else{
                Stack() {
                  Text(this.nickname != '' ? this.nickname.charAt(0) : '我')
                    .fontSize(36)
                    .fontColor(Color.White)
                }
                .width(104)
                .height(104)
                .backgroundColor('#7C8DB5')
                .borderRadius(52)
              }
              Text(this.nickname == '' ? '未设置昵称' : this.nickname)
                .fontSize(22)
                .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                .margin({ top: 12 })
              Text(this.userId == '' ? '-' : this.userId)
                .fontSize(12)
                .fontColor('#6B7280')
                .margin({ top: 4 })
            }
            .width('100%')
            .padding({ top: 20, bottom: 24 })
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Text('昵称')
                .fontSize(14)
                .fontColor('#6B7280')
                .margin({ bottom: 8 })
              TextInput({ text: this.nickname, placeholder: '请输入昵称' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .onChange((value:string)=>{
                  this.nickname = value
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Column() {
              Row() {
                Text('头像')
                  .fontSize(14)
                  .fontColor('#6B7280')
                Blank()
                Text('点击选择')
                  .fontSize(12)
                  .fontColor('#9CA3AF')
              }
              .width('100%')
              .padding({ bottom: 12 })

              List() {
                ForEach(PROFILE_AVATARS, (avatar:ResourceStr, index:number) => {
                  ListItem() {
                    Column() {
                      Image(avatar)
                        .width(72)
                        .height(72)
                        .borderRadius(36)
                        .border({
                          width: this.selectedAvatarIndex === index + 1 ? 3 : 1,
                          color: this.selectedAvatarIndex === index + 1 ? '#4C8DFF' : '#E5E7EB'
                        })
                      Text(`头像 ${index + 1}`)
                        .fontSize(11)
                        .fontColor(this.selectedAvatarIndex === index + 1 ? '#4C8DFF' : '#6B7280')
                        .margin({ top: 6 })
                    }
                    .width(88)
                    .alignItems(HorizontalAlign.Center)
                    .padding({ right: 8 })
                    .onClick(()=>{
                      this.selectAvatar(index + 1)
                    })
                  }
                }, (avatar:ResourceStr, index:number) => `${index}_${JSON.stringify(avatar)}`)
              }
              .width('100%')
              .height(108)
              .listDirection(Axis.Horizontal)
              .scrollBar(BarState.Off)
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Row() {
              Button('恢复默认')
                .layoutWeight(1)
                .height(44)
                .fontSize(15)
                .fontColor('#111827')
                .backgroundColor('#E5E7EB')
                .borderRadius(6)
                .onClick(()=>{
                  this.resetProfile()
                })
              Button('保存')
                .layoutWeight(1)
                .height(44)
                .fontSize(15)
                .fontColor(Color.White)
                .backgroundColor('#4C8DFF')
                .borderRadius(6)
                .margin({ left: 12 })
                .onClick(()=>{
                  this.saveProfile()
                })
            }
            .width('100%')
            .padding({ top: 16, bottom: 24 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 24 })
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#F5F7FA')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .title('个人资料')
  }
}
