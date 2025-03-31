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
import { ConversationDetailBottom } from '../views/Conversation/ConversationDetailBottom';
import {ConversationDetailItem} from '../views/Conversation/ConversationDetailItem';
import { ConversationDetailTopSearch } from '../views/Conversation/ConversationDetailTopSearch';
import { HomeConstants } from '../constants/HomeConstants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import {MessageViewItem} from '../viewmodel/MessageViewModel'
import { ObservedArray } from '../jim/common';
import { JuggleIm } from 'jimsdk';
import { Conversation } from 'jimsdk/src/main/ets/entries/conversation';
import { TextMessage } from 'jimsdk/src/main/ets/entries/message'

@Component
export struct ConversationDetail {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Prop currentConversationUserName: string;
  @Prop currentFeatureIndex: number;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State msgList:ObservedArray<MessageViewItem>=[]

  aboutToAppear(): void {
    let param = this.pageInfo.getParamByIndex(0) as ConversationDetailParams
    console.log("jimsdk_param:",param.conversationId)
    JuggleIm.instance.getMessageManager().addMessageListener((message)=>{
      let conver = message.conversation
      let currentUserId = JuggleIm.instance.userInfo.userId
      if(conver.conversationId===param.conversationId){
        let viewMsg = new MessageViewItem("","Unknown")
        if(message.sender!=undefined&&currentUserId==message.sender.userId){
          viewMsg.isReceived = false
        }
        console.log("jimsdk_his converId:",message.conversation.conversationId,"\tcur:",currentUserId,"\tsender:",message.sender?.userId,"\tisRec:",viewMsg.isReceived)
        if(message.msgType=="jg:text") {
          let txtMsg = message.msgContent as TextMessage
          viewMsg.content = txtMsg.content
        }
        this.msgList.push(viewMsg)
      }
    })
    JuggleIm.instance.getMessageManager().queryHistoryMsgs(new Conversation(param.conversationId,param.channelType),10,0,false,(msgs)=>{
      let currentUserId = JuggleIm.instance.userInfo.userId
      console.log("jimsdk_hismsgs:",msgs.length,currentUserId)
      msgs.forEach((msg)=>{
        let viewMsg = new MessageViewItem("","Unknown")
        if(msg.sender!=undefined&&currentUserId==msg.sender.userId){
          viewMsg.isReceived = false
        }
        console.log("jimsdk_his converId:",msg.conversation.conversationId,"\tcur:",currentUserId,"\tsender:",msg.sender?.userId,"\tisRec:",viewMsg.isReceived)
        if(msg.msgType=="jg:text") {
          let txtMsg = msg.msgContent as TextMessage
          viewMsg.content = txtMsg.content
        }
        this.msgList.push(viewMsg)
      })
    })
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column }) {
        ConversationDetailTopSearch({ currentConversationUserName: $currentConversationUserName, })
          .height(Adaptive.ContactItemHeight(this.currentBreakpoint))
        List(){
          ForEach(this.msgList,(item:MessageViewItem,index:number)=>{
            ListItem(){
              ConversationDetailItem(item)
            }
          })
        }
        Blank()
        ConversationDetailBottom()
      }
      .height(BaseConstants.FULL_HEIGHT)
      .width(BaseConstants.FULL_WIDTH)
      .backgroundColor($r('app.color.background_color_grey'))
      .padding({
        bottom: deviceInfo.deviceType !== BaseConstants.DEVICE_2IN1 ?
        $r('app.float.tab_content_pb') : $r('app.float.zero')
      })
    }
    .hideTitleBar(true)
  }
}