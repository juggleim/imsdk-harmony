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

import { BaseConstants, BreakpointConstants } from 'base';
import { HomeConstants } from '../../constants/HomeConstants';

@Component
export struct ConversationItem {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  private name?: ResourceStr;
  private msg?: ResourceStr;
  private time?: ResourceStr;
  private icon?: ResourceStr;

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        Image(this.icon)
          .height($r('app.float.avatar_image_size'))
          .width($r('app.float.avatar_image_size'))
      }
      .width($r('app.float.avatar_image_size'))
      .margin({ left: $r('app.float.icon_margin_two'), right: $r('app.float.icon_margin_one') })

      Flex({ direction: FlexDirection.Column,justifyContent:FlexAlign.Center }) {
        Text(this.name)
          .fontSize(BaseConstants.FONT_SIZE_SIXTEEN)
          .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
          .lineHeight($r('app.float.text_line_height_two'))
          .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
        Text(this.msg)
          .maxLines(HomeConstants.CONVERSATION_DETAIL_MAX_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
          .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
          .lineHeight($r('app.float.text_line_height_one'))
          .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
          .fontColor(Color.Grey)
          .width(BaseConstants.FULL_WIDTH)
      }
      .flexShrink(BaseConstants.FLEX_SHRINK_ONE)
      .margin({ left: $r('app.float.icon_margin_one') })

      Blank()
      Column() {
        Text(this.time)
          .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
          .fontSize(BaseConstants.FONT_SIZE_TEN)
          .fontColor(Color.Grey)
          .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
          .width($r('app.float.conversation_list_time_width'))
      }
      .flexBasis(HomeConstants.FLEX_BASIS_AUTO)
      .margin({ left: $r('app.float.icon_margin_two'), right: $r('app.float.icon_margin_one') })
    }
    .width(BaseConstants.FULL_WIDTH)
    .padding($r('app.float.conversation_list_time_padding'))
  }
}