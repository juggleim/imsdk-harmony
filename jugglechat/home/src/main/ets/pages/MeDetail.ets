import { Adaptive, BaseConstants, BreakpointConstants } from "base";
import { StandardIcon } from 'base/src/main/ets/views/image/StandardIcon';
import { HomeConstants } from "../constants/HomeConstants";
import { deviceInfo } from "@kit.BasicServicesKit";
import { CommonUtil } from "../jim/common";
import { PreferenceUtil } from "../jim/preferenceutil";
import { JimServer } from "../jim/jimserver/jimserver";
import { SocialCirclePictures } from '../viewmodel/SocialCircleViewModel';
import FriendVerify from "../views/MySettings/FriendVerify";


@Component
export struct MeDetail {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  // @Consume('pageInfo') pageInfo: NavPathStack;
  @State private currentIndex: number = 0;
  @State private myUserId: string = ''
  @State private myName: string = ''
  @State private myAvatar: string = ''
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  aboutToAppear(): void {
    let auth = PreferenceUtil.getCacheAuth()
    if (auth != undefined) {
      this.myUserId = auth.user_id
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

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Column() {
      }
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
      .backgroundColor($r('app.color.background_color_pink'))
      .padding({
        top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? $r('app.float.zero') :
        $r('app.float.device_padding_top')
      })

      if (this.myAvatar != '') {
        Image(this.myAvatar)
          .height($r('app.float.contacts_detail_avatar_height'))
          .margin({ top: $r('app.float.contacts_detail_avatar_top') })
          .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
          .border({
            width: $r('app.float.contacts_detail_avatar_border_width'),
            color: Color.White,
            radius: $r('app.float.contacts_detail_avatar_border_radius')
          })
      } else {
        Stack() {
          Text(this.getNameFirstChar()).fontColor(Color.White).fontSize(58)
        }
        .backgroundColor(this.getDefaultBackgroundColor())
        .height(124)
        .width(124)
        .margin({ top: 84 })
        .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
        .border({
          width: 5,
          color: Color.White,
          radius: 100
        })
        .borderRadius(200)
      }

      Column() {
        Column() {
          Column() {
            Text(this.myName)
              .fontSize(BaseConstants.FONT_SIZE_THIRTY_TWO)
              .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
              .fontColor(Color.Black)
          }
          .width(BaseConstants.FULL_WIDTH)
          .alignItems(HorizontalAlign.Center)
          .padding({ top: $r('app.float.contacts_detail_user_top') })

          Column(){
            Row(){
              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_phone') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }
              .width('10%')
              .alignItems(HorizontalAlign.Start)
              .padding({
                left:15
              })

              Column(){
                Text('好友验证')
                  .fontSize(18)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              }.width('80%')
              .alignItems(HorizontalAlign.Start)
              .padding({left:20})

              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_more') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }.width('10%')
              .alignItems(HorizontalAlign.End)
            }.alignItems(VerticalAlign.Center)
            .height(BaseConstants.FULL_HEIGHT)
          }
          .height(40)
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#F1F3F5')
          .margin({top:45})
          .borderRadius({
            topLeft: 6,
            topRight: 6
          }).onClick(()=>{
            if (this.mySettingPageInfo.size() > 1) {
              this.mySettingPageInfo.pop()
            }
            this.mySettingPageInfo.pushPath({name:'FriendVerify'})
          })

          Divider().width('90%')

          Column(){
            Row(){
              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_phone') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }
              .width('10%')
              .alignItems(HorizontalAlign.Start)
              .padding({
                left:15
              })

              Column(){
                Text('免打扰设置')
                  .fontSize(18)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              }.width('80%')
              .alignItems(HorizontalAlign.Start)
              .padding({left:20})

              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_more') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }.width('10%')
              .alignItems(HorizontalAlign.End)
            }.alignItems(VerticalAlign.Center)
            .height(BaseConstants.FULL_HEIGHT)
          }
          .height(40)
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#F1F3F5')
          .borderRadius({
            bottomLeft:6,
            bottomRight:6,
          }).onClick(()=>{
            if (this.mySettingPageInfo.size() > 1) {
              this.mySettingPageInfo.pop()
            }
            this.mySettingPageInfo.pushPath({name:'FriendVerify'})
          })

          Column(){
            Row(){
              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_phone') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }
              .width('10%')
              .alignItems(HorizontalAlign.Start)
              .padding({
                left:15
              })

              Column(){
                Text('语言设置')
                  .fontSize(18)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              }.width('80%')
              .alignItems(HorizontalAlign.Start)
              .padding({left:20})

              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_more') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }.width('10%')
              .alignItems(HorizontalAlign.End)
            }.alignItems(VerticalAlign.Center)
            .height(BaseConstants.FULL_HEIGHT)
          }
          .height(40)
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#F1F3F5')
          .margin({top:20})
          .borderRadius({
            topLeft: 6,
            topRight: 6,
            bottomLeft:6,
            bottomRight:6,
          }).onClick(()=>{
            if (this.mySettingPageInfo.size() > 1) {
              this.mySettingPageInfo.pop()
            }
            this.mySettingPageInfo.pushPath({name:'FriendVerify'})
          })

          Column(){
            Row(){
              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_phone') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }
              .width('10%')
              .alignItems(HorizontalAlign.Start)
              .padding({
                left:15
              })

              Column(){
                Text('我的收藏')
                  .fontSize(18)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              }.width('80%')
              .alignItems(HorizontalAlign.Start)
              .padding({left:20})

              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_more') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }.width('10%')
              .alignItems(HorizontalAlign.End)
            }.alignItems(VerticalAlign.Center)
            .height(BaseConstants.FULL_HEIGHT)
          }
          .height(40)
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#F1F3F5')
          .margin({top:20})
          .borderRadius({
            topLeft: 6,
            topRight: 6,
            bottomLeft:6,
            bottomRight:6,
          }).onClick(()=>{
            if (this.mySettingPageInfo.size() > 1) {
              this.mySettingPageInfo.pop()
            }
            this.mySettingPageInfo.pushPath({name:'FriendVerify'})
          })

          Column(){
            Row(){
              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_phone') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }
              .width('10%')
              .alignItems(HorizontalAlign.Start)
              .padding({
                left:15
              })

              Column(){
                Text('用户协议')
                  .fontSize(18)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              }.width('80%')
              .alignItems(HorizontalAlign.Start)
              .padding({left:20})

              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_more') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }.width('10%')
              .alignItems(HorizontalAlign.End)
            }.alignItems(VerticalAlign.Center)
            .height(BaseConstants.FULL_HEIGHT)
          }
          .height(40)
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#F1F3F5')
          .margin({top:20})
          .borderRadius({
            topLeft: 6,
            topRight: 6
          }).onClick(()=>{
            if (this.mySettingPageInfo.size() > 1) {
              this.mySettingPageInfo.pop()
            }
            this.mySettingPageInfo.pushPath({name:'FriendVerify'})
          })
          Divider().width('90%')
          Column(){
            Row(){
              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_phone') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }
              .width('10%')
              .alignItems(HorizontalAlign.Start)
              .padding({
                left:15
              })

              Column(){
                Text('隐私协议')
                  .fontSize(18)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              }.width('80%')
              .alignItems(HorizontalAlign.Start)
              .padding({left:20})

              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_more') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }.width('10%')
              .alignItems(HorizontalAlign.End)
            }.alignItems(VerticalAlign.Center)
            .height(BaseConstants.FULL_HEIGHT)
          }
          .height(40)
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#F1F3F5')
          .borderRadius({
            bottomLeft:6,
            bottomRight:6
          }).onClick(()=>{
            if (this.mySettingPageInfo.size() > 1) {
              this.mySettingPageInfo.pop()
            }
            this.mySettingPageInfo.pushPath({name:'FriendVerify'})
          })
          Column(){
            Row(){
              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_phone') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }
              .width('10%')
              .alignItems(HorizontalAlign.Start)
              .padding({
                left:15
              })

              Column(){
                Text('退出登录')
                  .fontSize(18)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
              }.width('80%')
              .alignItems(HorizontalAlign.Start)
              .padding({left:20})

              Column(){
                StandardIcon({ icon: $r('app.media.ic_public_more') })
                  .margin({ right: $r('app.float.phone_icon_right') })
              }.width('10%')
              .alignItems(HorizontalAlign.End)
            }.alignItems(VerticalAlign.Center)
            .height(BaseConstants.FULL_HEIGHT)
          }
          .height(40)
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#F1F3F5')
          .margin({top:20})
          .borderRadius({
            topLeft: 6,
            topRight: 6,
            bottomLeft:6,
            bottomRight:6,
          }).onClick(()=>{
            if (this.mySettingPageInfo.size() > 1) {
              this.mySettingPageInfo.pop()
            }
            this.mySettingPageInfo.pushPath({name:'FriendVerify'})
          })
        }
        .margin(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? {} : {
          left: $r('app.float.images_column_left'),
          right: $r('app.float.images_column_right')
        })
        .height(Adaptive.ContactDetailHeight(this.currentBreakpoint))
        .borderRadius({
          topLeft: $r('app.float.contacts_detail_left'),
          topRight: $r('app.float.contacts_detail_right')
        })
        .backgroundColor(Color.White)
      }
      .margin({ top: $r('app.float.contacts_detail_column_top') })
      .width(BaseConstants.FULL_WIDTH)
      .alignItems(HorizontalAlign.Start)
    }
  }
}