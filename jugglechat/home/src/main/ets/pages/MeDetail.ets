import { promptAction, router } from '@kit.ArkUI'
import { Adaptive, BaseConstants, BreakpointConstants } from "base";
import { StandardIcon } from 'base/src/main/ets/views/image/StandardIcon';
import { HomeConstants } from "../constants/HomeConstants";
import { deviceInfo } from "@kit.BasicServicesKit";
import { CommonUtil } from "../jim/common";
import { PreferenceUtil } from "../jim/preferenceutil";
import { JimServer } from "../jim/jimserver/jimserver";
import { JuggleIm } from '@juggleim/imlib'
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
export struct MeDetail {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  // @Consume('pageInfo') pageInfo: NavPathStack;
  @State private currentIndex: number = 0;
  @State private myUserId: string = ''
  @State private myName: string = ''
  @State private myAvatar: ResourceStr = HomeConstants.DEFAULT_AVATAR
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  aboutToAppear(): void {
    this.loadProfile()
  }

  onPageShow(): void {
    this.loadProfile()
  }

  private loadProfile():void{
    let auth = PreferenceUtil.getCacheAuth()
    if (auth != undefined) {
      this.myUserId = auth.user_id
      let profileDisplay = PreferenceUtil.getProfileDisplay()
      if(profileDisplay != undefined && profileDisplay.nickname != ''){
        this.myName = profileDisplay.nickname
        this.myAvatar = this.getAvatarResource(profileDisplay.avatarIndex)
        return
      }
      JimServer.instance.getUserManager().GetUserInfo(auth.user_id, (user) => {
        if (user != null) {
          this.myName = user.nickname
          this.myAvatar = user.avatar
        }
      })
    }
  }

  private getDefaultBackgroundColor(): string {
    return CommonUtil.getBackgroundColor(this.myName)
  }

  private getNameFirstChar(): string {
    let n = this.myName
    console.log("myinfo_", n)
    if (n.length > 0) {
      return n.charAt(0)
    } else {
      return ''
    }
  }

  private getAvatarResource(index:number):ResourceStr{
    let safeIndex = index
    if(safeIndex < 1 || safeIndex > PROFILE_AVATARS.length){
      safeIndex = 1
    }
    return PROFILE_AVATARS[safeIndex - 1]
  }

  private openProfileSetting():void{
    this.mySettingPageInfo.pushPath({ name: 'ProfileSetting', param: new NavSourceParam('settings') })
  }

  private openMyQrCode():void{
    this.mySettingPageInfo.pushPath({ name: 'QRCodeDisplay', param: new NavSourceParam('settings') })
  }

  private openScanPage():void{
    this.mySettingPageInfo.pushPath({ name: 'ScanPage', param: new NavSourceParam('settings') })
  }

  private openCreateChatroom():void{
    this.mySettingPageInfo.pushPath({ name: 'CreateChatroom', param: new NavSourceParam('settings') })
  }

  private openCreateGroup():void{
    this.mySettingPageInfo.pushPath({ name: 'CreateGroup', param: new NavSourceParam('settings') })
  }

  private logout() {
    JuggleIm.instance.getConnectionManager().disconnect()
    PreferenceUtil.cleanCacheAuth()
    PreferenceUtil.clearProfileDisplay()
    JimServer.instance.clearAuth()
    JuggleIm.instance.userId = ''
    JuggleIm.instance.userInfo.userId = ''
    JuggleIm.instance.userInfo.nickname = ''
    JuggleIm.instance.userInfo.userPortrait = ''
    this.mySettingPageInfo.clear()
    promptAction.showToast({
      message: '已退出登录',
      duration: 1000,
      bottom: 100
    })
    router.replaceUrl({
      url: 'pages/Login'
    })
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              if (this.myAvatar != '') {
                Image(this.myAvatar)
                  .height($r('app.float.contacts_detail_avatar_height'))
                  .width($r('app.float.contacts_detail_avatar_height'))
                  .borderRadius($r('app.float.contacts_detail_avatar_border_radius'))
              } else {
                Stack() {
                  Text(this.getNameFirstChar())
                    .fontColor(Color.White)
                    .fontSize(58)
                }
                .backgroundColor(this.getDefaultBackgroundColor())
                .height(124)
                .width(124)
                .border({
                  width: 5,
                  color: Color.White,
                  radius: 100
                })
                .borderRadius(200)
              }
              Text(this.myName)
                .fontSize(BaseConstants.FONT_SIZE_THIRTY_TWO)
                .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                .fontColor(Color.Black)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 12 })
            }
            .width('100%')
            .padding({ top: 20, bottom: 24 })
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('个人资料')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .borderRadius({
              topLeft: 6,
              topRight: 6
            })
            .onClick(()=>{
              this.openProfileSetting()
            })

            Divider().width('100%')

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('我的二维码')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .borderRadius({
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              this.openMyQrCode()
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('扫一扫')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6,
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              this.openScanPage()
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('创建群组')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6,
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              this.openCreateGroup()
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('好友验证')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'FriendVerify'})
            })

            Divider().width('100%')

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('免打扰设置')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .borderRadius({
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'GlobalUndisturb'})
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('推送设置')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6,
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'PushSetting'})
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('我的收藏')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6,
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'MyFavorite'})
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('广播消息')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6,
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'BroadcastMessage'})
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('聊天室')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6,
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'ChatroomList'})
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('用户协议')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'FriendVerify'})
            })

            Divider().width('100%')

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('隐私协议')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .borderRadius({
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              if (this.mySettingPageInfo.size() > 1) {
                this.mySettingPageInfo.pop()
              }
              this.mySettingPageInfo.pushPath({name:'FriendVerify'})
            })

            Column() {
              Row() {
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_phone') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 15 })

                Column() {
                  Text('退出登录')
                    .fontSize(18)
                    .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })

                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_more') })
                    .margin({ right: $r('app.float.phone_icon_right') })
                }
                .width('10%')
                .alignItems(HorizontalAlign.End)
              }
              .alignItems(VerticalAlign.Center)
              .height(BaseConstants.FULL_HEIGHT)
            }
            .height(40)
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#F1F3F5')
            .margin({ top: 20 })
            .borderRadius({
              topLeft: 6,
              topRight: 6,
              bottomLeft: 6,
              bottomRight: 6
            })
            .onClick(()=>{
              this.logout()
            })
          }
          .width('100%')
          .padding({
            left: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? 0 : $r('app.float.images_column_left'),
            right: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? 0 : $r('app.float.images_column_right')
          })
          .padding({ bottom: 24 })
        }
        .width(BaseConstants.FULL_WIDTH)
        .height(BaseConstants.FULL_HEIGHT)
        .scrollBar(BarState.Auto)
        .backgroundColor(Color.White)
      }
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
      .backgroundColor($r('app.color.background_color_pink'))
      .padding({
        top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? $r('app.float.zero') :
        $r('app.float.device_padding_top')
      })
    }
    .title('我')
    }
  }
