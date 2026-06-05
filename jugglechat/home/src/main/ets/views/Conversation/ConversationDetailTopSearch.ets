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

import { BaseConstants, BreakpointConstants, StandardIcon } from 'base';
import { HomeConstants } from '../../constants/HomeConstants';
import { ConversationRouteParams } from '../../viewmodel/ConversationViewModel';

@Component
export struct ConversationDetailTopSearch {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentConversationUserName: string;
  @Prop conversationId:string
  @Prop conversationType:number
  @Prop subChannel:string = ''
  @Prop showProfile:boolean = true
  @Consume('pageInfo') pageInfo: NavPathStack;

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Stack() {
        StandardIcon({ icon: $r('app.media.ic_public_back') })
      }
      .width(30)
      .height(30)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
          this.pageInfo.clear();
        } else if (this.pageInfo.size() === 1) {
          this.pageInfo.clear();
          this.pageInfo.pushPath({ name: 'ConversationDetailNone' });
        } else {
          this.pageInfo.clear();
          this.pageInfo.pushPath({ name: 'ConversationDetailNone' });
        }
      })
      Text(this.currentConversationUserName || HomeConstants.CONVERSATION_DETAIL_TOP_TITLE)
        .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
        .fontSize(BaseConstants.FONT_SIZE_EIGHTEEN)
        .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
        .fontColor($r('app.color.conversation_default_text_color'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
      StandardIcon({ icon: $r('app.media.ic_public_more') })
        .visibility(this.showProfile ? Visibility.Visible : Visibility.Hidden)
        .backgroundColor(Color.Transparent)
        .onClick(()=>{
          if(!this.showProfile){
            return
          }
          this.pageInfo.pushPath({
            name: 'ConversationProfile',
            param: new ConversationRouteParams(
              this.conversationId,
              this.conversationType,
              this.currentConversationUserName || HomeConstants.CONVERSATION_DETAIL_TOP_TITLE,
              this.subChannel
            )
          })
        })
    }
    .width(BaseConstants.FULL_WIDTH)
    .height(BaseConstants.FULL_HEIGHT)
    .padding({ left: $r('app.float.icon_margin_two'), right: $r('app.float.icon_margin_two') })
  }
}
