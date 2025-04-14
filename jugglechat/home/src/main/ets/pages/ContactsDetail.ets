/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { Adaptive, BaseConstants, BreakpointConstants, StandardIcon } from 'base';
import { HomeConstants } from '../constants/HomeConstants';
import { SocialCirclePictures } from '../viewmodel/SocialCircleViewModel';
import { deviceInfo } from '@kit.BasicServicesKit';
import { CommonUtil } from '../jim/common';

@Component
export struct ContactsDetail {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Prop currentContactUserId: string
  @Prop currentContactUserName: string
  @Prop currentContactUserIcon: ResourceStr
  @Consume('pageInfo') pageInfo: NavPathStack;

  aboutToAppear(): void {
    console.log("contws:",this.currentContactUserId,this.currentContactUserName)
  }

  private getDefaultBackgroundColor():string{
    return CommonUtil.getBackgroundColor(this.currentContactUserName as string)
  }

  private getNameFirstChar():string{
    let n = this.currentContactUserName as string
    if(n.length>0){
      return n.charAt(0)
    }else{
      return ''
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
          Column() {
            if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
              StandardIcon({ icon: $r('app.media.ic_public_back') })
                .onClick(() => {
                  this.pageInfo.clear();

                })
            }
          }
          .padding({ top: $r('app.float.back_icon_top'), left: $r('app.float.back_icon_left') })
          .alignItems(HorizontalAlign.Start)
          .width(BaseConstants.FULL_WIDTH)
        }
        .width(BaseConstants.FULL_WIDTH)
        .height(BaseConstants.FULL_HEIGHT)
        .backgroundColor($r('app.color.background_color_pink'))
        .padding({
          top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? $r('app.float.zero') : $r('app.float.device_padding_top')
        })

        if(this.currentContactUserIcon!='') {
          Image(this.currentContactUserIcon)
            .height($r('app.float.contacts_detail_avatar_height'))
            .margin({ top: $r('app.float.contacts_detail_avatar_top') })
            .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
            .border({
              width: $r('app.float.contacts_detail_avatar_border_width'),
              color: Color.White,
              radius: $r('app.float.contacts_detail_avatar_border_radius')
            })
        }else{
          Stack(){
            Text(this.getNameFirstChar()).fontColor(Color.White).fontSize(58)
          }.backgroundColor(this.getDefaultBackgroundColor())
          .height(124)
          .width(124)
          .margin({top:84})
          .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
          .border({
            width:5,
            color:Color.White,
            radius:100
          })
          .borderRadius(200)
        }

        Column() {
          Column() {
            Column() {
              Text(this.currentContactUserName || HomeConstants.CONTACTS_DEFAULT_SELECTED_NAME)
                .fontSize(BaseConstants.FONT_SIZE_THIRTY_TWO)
                .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                .fontColor(Color.Black)
            }
            .width(BaseConstants.FULL_WIDTH)
            .alignItems(HorizontalAlign.Center)
            .padding({ top: $r('app.float.contacts_detail_user_top') })

            Row() {
              Column() {
                Text(HomeConstants.USER_PHONE)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                  .fontSize(BaseConstants.FONT_SIZE_SIXTEEN)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
              }
              .margin({ left: $r('app.float.phone_left') })

              Blank()
              StandardIcon({ icon: $r('app.media.ic_public_phone') })
                .margin({ right: $r('app.float.phone_icon_right') })
              StandardIcon({ icon: $r('app.media.ic_public_video') })
                .margin({ right: $r('app.float.phone_icon_right') })
              StandardIcon({ icon: $r('app.media.ic_public_comments') })
                .margin({ right: $r('app.float.phone_icon_right') })
            }
            .width(BaseConstants.FULL_WIDTH)
            .padding({ top: $r('app.float.phone_column_top') })

            Column() {
              Divider()
                .color($r('app.color.line_color'))
                .width(BaseConstants.FULL_WIDTH)
                .margin({ left: $r('app.float.phone_divider_left'), right: $r('app.float.phone_divider_right') })
            }
            .width(BaseConstants.FULL_WIDTH)
            .padding({ top: $r('app.float.phone_divider_top') })

            Column() {
              Text(HomeConstants.LAST_POST)
                .fontSize(BaseConstants.FONT_SIZE_TWELVE)
                .fontColor(Color.Black)
                .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
                .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
            }
            .width(BaseConstants.FULL_WIDTH)
            .padding({ left: $r('app.float.last_post_left'), top: $r('app.float.last_post_top') })
            .alignItems(HorizontalAlign.Start)

            Column() {
              List({ space: HomeConstants.IMAGES_SCOPE }) {
                ForEach(SocialCirclePictures, (item: Resource) => {
                  ListItem() {
                    Image(item)
                      .width(Adaptive.ContactPhoneWidth(this.currentBreakpoint))
                      .aspectRatio(HomeConstants.IMAGE_ASPECT_RATIO)
                  }
                }, (item: Resource, index: number) => index + JSON.stringify(item))
              }
              .width(BaseConstants.FULL_WIDTH)
              .height(BaseConstants.FULL_HEIGHT)
              .listDirection(Axis.Horizontal)
            }
            .padding({ left: $r('app.float.images_left'), top: $r('app.float.images_top') })
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
    .hideTitleBar(true)
  }
}