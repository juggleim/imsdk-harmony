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
import { ButtonInfo } from '../viewmodel/BottomTabViewModel';
import { TabInfoModel } from 'base';
import { HomeConstants } from '../constants/HomeConstants';

@Component
export struct HomeTab {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentPageIndex: number;

  build() {
    Column() {
      Tabs({
        barPosition: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarPosition.Start : BarPosition.End
      }) {
        TabContent()
          .tabBar(this.BottomNavigation(ButtonInfo[HomeConstants.TAB_MESSAGE_INDEX]))
        TabContent()
          .tabBar(this.BottomNavigation(ButtonInfo[HomeConstants.TAB_CONTACTS_INDEX]))
        TabContent()
          .tabBar(this.BottomNavigation(ButtonInfo[HomeConstants.TAB_SOCIAL_CIRCLE_INDEX]))
        TabContent()
          .tabBar(this.BottomNavigation(ButtonInfo[HomeConstants.TAB_ME_INDEX]))
      }
      .vertical(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG)
      .height(BaseConstants.FULL_HEIGHT)
      .margin({
        top: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? '' : $r('app.float.home_tab_top_lg'),
        bottom: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? '' : $r('app.float.home_tab_bottom_lg')
      })
    }
    .backgroundColor($r('app.color.background_color_grey_two'))
    .expandSafeArea([], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  BottomNavigation(button: TabInfoModel) {
    Column() {
      Image(this.currentPageIndex === button.index ? button.selectImg : button.img)
        .objectFit(ImageFit.Contain)
        .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? $r('app.float.main_image_size_lg') : $r('app.float.main_image_size'))
        .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? $r('app.float.main_image_size_lg') : $r('app.float.main_image_size'))
      Text(button.title)
        .fontColor(this.currentPageIndex === button.index ? $r('app.color.focus_color') : Color.Black)
        .opacity(this.currentPageIndex === button.index ? BaseConstants.FULL_OPACITY : BaseConstants.SIXTY_OPACITY)
        .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.micro_font_size'))
        .lineHeight($r('app.float.text_line_height_three'))
        .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
        .margin({ top: $r('app.float.document_text_top') })
    }

    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentPageIndex = button.index;
    })
  }
}