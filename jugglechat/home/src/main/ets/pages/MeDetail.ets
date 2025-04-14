import { BaseConstants, BreakpointConstants } from "base";
import { StandardIcon } from 'base/src/main/ets/views/image/StandardIcon';
import { HomeConstants } from "../constants/HomeConstants";
import { deviceInfo } from "@kit.BasicServicesKit";
import { CommonUtil } from "../jim/common";
import { PreferenceUtil } from "../jim/preferenceutil";
import { JimServer } from "../jim/jimserver/jimserver";

@Component
export struct MeDetail{
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State private currentIndex: number = 0;
  @State private myUserId:string = ''
  @State private myName:string = ''
  @State private myAvatar:string = ''

  aboutToAppear(): void {
    let auth = PreferenceUtil.getCacheAuth()
    if(auth!=undefined){
      this.myUserId = auth.user_id
      JimServer.instance.getUserManager().GetUserInfo(auth.user_id,(user)=>{
        if(user!=null){
          this.myName = user.nickname
          this.myAvatar = user.avatar
        }
      })
    }
  }

  private getDefaultBackgroundColor():string{
    return CommonUtil.getBackgroundColor(this.myName)
  }

  private getNameFirstChar():string{
    let n = this.myName
    console.log("myinfo_",n)
    if(n.length>0){
      return n.charAt(0)
    }else{
      return ''
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Column() {
          Text('我的')
            .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
            .fontSize(BaseConstants.FONT_SIZE_TWENTY_FOUR)
            .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
            .width(BaseConstants.FULL_WIDTH)
            .margin({
              left: 24
            })
        }.flexBasis(HomeConstants.SEARCH_TEXT_FLEX_BASIS)

        Blank().width('52%')
        Column() {
          StandardIcon({ icon: $r('app.media.ic_public_add_norm') })
            .flexBasis(HomeConstants.FLEX_BASIS_AUTO)
            .margin({ right: 24 })
        }
      }

      Row() {
        Column() {
          if (this.myAvatar != '') {
            Image(this.myAvatar)
              .height($r('app.float.contacts_detail_avatar_height'))
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
            .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
            .border({
              width: 5,
              color: Color.White,
              radius: 100
            })
            .borderRadius(200)
          }
        }.width(BaseConstants.FULL_WIDTH)
      }

      Row() {
        Column() {
          Text(this.myName).fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
            .fontSize(BaseConstants.FONT_SIZE_TWENTY_FOUR)
            .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
        }.width(BaseConstants.FULL_WIDTH)
        .margin({
          top: 5
        })
      }
    }
    .backgroundColor(Color.White)
    .height('100%')
    .width('100%')
    .padding({
      left: 0,
      top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? $r('app.float.zero') :
      $r('app.float.device_padding_top')
    })
  }
}