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

import { BaseConstants, BreakpointConstants, IntroduceText, NormalText } from 'base'
import { HomeConstants } from '../constants/HomeConstants';
import { ConversationDataInterface, ConversationListData } from '../viewmodel/ConversationViewModel';

@Component
export struct MessageBubble {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link receivedName: Resource;
  @Link currentFeatureIndex: number;
  private isReceived: boolean = !HomeConstants.IS_RECEIVED;
  private content: ResourceStr = "";
  private isAppletMsg?: boolean;
  private isDocumentMsg?: boolean;
  avatar1: Resource = $r('app.media.avatar1');
  avatar2: Resource = $r('app.media.avatar7');

  build() {
    Column() {
      Flex({ justifyContent: this.isReceived ? FlexAlign.Start : FlexAlign.End, direction: FlexDirection.Row }) {
        if (this.isReceived) {
          Image(ConversationListData.find((item) => item.name === this.receivedName)?.icon || this.avatar1)
            .width($r('app.float.avatar_image_size'))
            .height($r('app.float.avatar_image_size'))
            .flexShrink(BaseConstants.FLEX_SHRINK_ZERO)
        }
        Column() {
          Stack({ alignContent: this.isReceived ? Alignment.TopStart : Alignment.TopEnd }) {
            Path()
              .commands('M-10 1 L0 18 L32 1 Z')
              .fillOpacity(HomeConstants.CONVERSATION_DETAIL_FILL_OPACITY)
              .stroke(Color.White)
              .strokeWidth(HomeConstants.CONVERSATION_DETAIL_STROKE_WIDTH)
              .fill(Color.White)
              .visibility(this.isReceived ? Visibility.Visible : Visibility.None)
            Path()
              .commands('M23 1 L0 28 L-10 1 Z')
              .fillOpacity(HomeConstants.CONVERSATION_DETAIL_FILL_OPACITY)
              .stroke(Color.White)
              .strokeWidth(HomeConstants.CONVERSATION_DETAIL_STROKE_WIDTH)
              .fill(Color.White)
              .visibility(this.isReceived ? Visibility.None : Visibility.Visible)
              .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
              .margin({ right: $r('app.float.conversation_detail_path_right') })
            Column() {
              this.MessageContent()
            }
            .padding({
              left: $r('app.float.path_column_left'),
              right: $r('app.float.path_column_right'),
              top: $r('app.float.path_column_top'),
              bottom: $r('app.float.path_column_bottom')
            })
            .backgroundColor(Color.White)
            .borderRadius(HomeConstants.PATH_BORDER_RADIUS)
          }
          .padding({
            top: $r('app.float.path_top'),
            left: $r('app.float.path_left'),
            right: $r('app.float.path_right'),
            bottom: $r('app.float.path_bottom')
          })
          .width(BaseConstants.FULL_WIDTH)
        }
        .width(BaseConstants.FULL_WIDTH)

        if (!this.isReceived) {
          Image(this.avatar2)
            .width($r('app.float.icon_width'))
            .height($r('app.float.icon_height'))
            .flexShrink(BaseConstants.FLEX_SHRINK_ZERO)
        }
      }
    }
    .margin({ left: $r('app.float.message_bubble_left'), right: $r('app.float.message_bubble_right') })
  }

  @Builder
  MessageContent() {
    if (this.isAppletMsg) {
      Column() {
        Row() {
          Image($r('app.media.ic_tea'))
            .height($r('app.float.applet_icon_size'))
            .width($r('app.float.applet_icon_size'))
            .margin({ right: $r('app.float.applet_icon_right') })
          Text(HomeConstants.APPLET_TITLE)
            .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
            .fontSize(BaseConstants.FONT_SIZE_TWELVE)
            .fontColor($r('app.color.conversation_default_text_color'))
            .textAlign(TextAlign.Start)
            .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
        }
        .margin({ bottom: $r('app.float.applet_title_bottom') })

        Text(this.content)
          .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
          .fontSize(BaseConstants.FONT_SIZE_TWELVE)
          .fontColor($r('app.color.conversation_default_text_color'))
          .textAlign(TextAlign.Start)
          .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
          .margin({ bottom: $r('app.float.applet_introduce_bottom') })
          .copyOption(CopyOptions.LocalDevice)
        Flex() {
        }
        .height($r('app.float.applet_image_height'))
        .width($r('app.float.applet_image_width'))
        .backgroundImage($r('app.media.picture_applet_link'))
        .backgroundImageSize({ width: $r('app.float.applet_image_width'), height: $r('app.float.applet_image_height') })
        .constraintSize({ maxWidth: BaseConstants.FULL_WIDTH })
        .margin({ bottom: $r('app.float.applet_image_bottom') })

        Text(HomeConstants.APPLET_DESCRIBE)
          .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
          .fontSize(BaseConstants.FONT_SIZE_TEN)
          .fontColor($r('app.color.background_color_grey_three'))
          .textAlign(TextAlign.Start)
          .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
      }
      .alignItems(HorizontalAlign.Start)
    } else if (this.isDocumentMsg) {
      Column() {
        Row() {
          NormalText({ data: this.content })
            .margin({ right: $r('app.float.applet_icon_right') })
            .width($r('app.float.document_text_width'))
          Image($r('app.media.ic_PDF'))
            .height($r('app.float.document_icon_size'))
            .width($r('app.float.document_icon_size'))
            .margin({ right: $r('app.float.document_icon_right') })
        }
        .margin({ bottom: $r('app.float.document_icon_bottom') })

        IntroduceText({ data: HomeConstants.DOCUMENT_SIZE, fontColor: $r('app.color.background_color_grey_three') })
          .margin({ bottom: $r('app.float.document_text_bottom') })
        Divider()
          .color($r('app.color.divider_background_color'))
          .strokeWidth(HomeConstants.DOCUMENT_DIVIDER_WIDTH).margin({ bottom: $r('app.float.divider_bottom') })
        Row() {
          Image($r('app.media.ic_file'))
            .width($r('app.float.document_small_icon_size'))
            .height($r('app.float.document_small_icon_size'))
            .margin({ right: $r('app.float.document_small_icon_right') })
          IntroduceText({
            data: HomeConstants.DOCUMENT_INTRODUCE,
            fontColor: $r('app.color.background_color_grey_three')
          })
            .margin({ top: $r('app.float.document_introduce_top') })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .width($r('app.float.document_width'))
      .margin({ bottom: $r('app.float.document_bottom') })
    } else {
      Text(this.content)
        .fontSize(BaseConstants.FONT_SIZE_TWELVE)
        .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
        .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
        .lineHeight($r('app.float.conversation_default_text_line'))
        .fontColor($r('app.color.conversation_default_text_color'))
        .copyOption(CopyOptions.LocalDevice)
    }
  }
}