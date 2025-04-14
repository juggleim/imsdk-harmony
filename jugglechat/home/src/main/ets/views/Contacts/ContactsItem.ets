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
import { CommonUtil } from '../../jim/common';

@Component
export struct ContactsItem {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  private name?: ResourceStr;
  private icon?: ResourceStr;

  private getDefaultBackgroundColor():string{
    return CommonUtil.getBackgroundColor(this.name as string)
  }

  private getNameFirstChar():string{
    let n = this.name as string
    if(n.length>0){
      return n.charAt(0)
    }else{
      return ''
    }
  }

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        if(this.icon!='') {
          Image(this.icon)
            .height($r('app.float.avatar_image_size'))
            .width($r('app.float.avatar_image_size'))
        }else{
          Stack(){
            Text(this.getNameFirstChar()).fontColor(Color.White)
          }.backgroundColor(this.getDefaultBackgroundColor())
          .width(45)
          .height(45)
          .borderRadius(30)
        }
      }
      .width($r('app.float.avatar_image_size'))
      .margin({ left: $r('app.float.icon_margin_two'), right: $r('app.float.icon_margin_one') })

      Column() {
        Text(this.name)
          .fontSize(BaseConstants.FONT_SIZE_SIXTEEN)
          .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
          .lineHeight($r('app.float.text_line_height_two'))
          .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
      }
      .flexShrink(BaseConstants.FLEX_SHRINK_ONE)
      .margin({ left: $r('app.float.icon_margin_one') })

      Blank()
    }
    .height(BaseConstants.FULL_HEIGHT)
    .width(BaseConstants.FULL_WIDTH)
  }
}