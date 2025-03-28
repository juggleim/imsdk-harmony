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

import { Adaptive, BaseConstants, BreakpointConstants } from 'base';
import { ConversationDataInterface, ConversationListData } from '../viewmodel/ConversationViewModel';
import { ConversationItem } from '../views/Conversation/ConversationItem';
import { HomeTopSearch } from '../views/common/HomeTopSearch';
import { HomeConstants } from '../constants/HomeConstants';
import { deviceInfo } from '@kit.BasicServicesKit';

@Component
export struct ConversationList {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentConversationUserName: Resource;
  @Link currentContactUserName: string;
  @State private currentIndex: number = 0;
  @Consume('pageInfo') pageInfo: NavPathStack;

  build() {
    Flex({ direction: FlexDirection.Column }) {
      HomeTopSearch({ title: HomeConstants.CONVERSATION_TITLE })
        .height('13%')
      List() {
        ForEach(ConversationListData, (item: ConversationDataInterface, index: number) => {
          ListItem() {
            ConversationItem(item)
              .onClick(() => {
                if (this.pageInfo.size() > 1) {
                  this.pageInfo.pop();
                }
                this.pageInfo.pushPath({ name: 'ConversationDetail' });
                this.currentConversationUserName = item.name;
                this.currentContactUserName = '';
                this.currentIndex = index;
              })
              .backgroundColor(this.currentIndex === index ? $r('app.color.conversation_clicked_bg_color') : Color.White)
          }
          .height(Adaptive.ContactItemHeight(this.currentBreakpoint))

        }, (item: ConversationDataInterface, index: number) => index + JSON.stringify(item))
      }
      .padding({
        bottom: deviceInfo.deviceType !== BaseConstants.DEVICE_2IN1 &&
          this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
        $r('app.float.tab_content_pb') : $r('app.float.zero')
      })
      .backgroundColor(Color.White)
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }

    .height(BaseConstants.FULL_HEIGHT)
    .width(BaseConstants.FULL_WIDTH)
  }
}