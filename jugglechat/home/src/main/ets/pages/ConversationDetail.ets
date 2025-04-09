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
import { JuggleIm } from 'juggleim';
import { Conversation } from 'juggleim/src/main/ets/entries/conversation';
import { TextMessage } from 'juggleim/src/main/ets/entries/message'
import { QueryMsgOptions } from 'juggleim/src/main/ets/managers/messagemanager';
import { ConnStatus } from 'juggleim/src/main/ets/imclients/imclient';

@Component
export struct ConversationDetail {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Prop currentConversationUserName: string;
  @Prop currentFeatureIndex: number;
  @Prop conversationId:string
  @Prop conversationType:number
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State msgList:ObservedArray<MessageViewItem>=[]
  private maxMsgTime:number = 0
  private minMsgTime:number = Number.MAX_SAFE_INTEGER
  @State refreshing:boolean = false

  @Builder
  refreshContent() {
    Text('Loading...')
      .width('100%')
      .textAlign(TextAlign.Center)
  }

  private recordMsgTime(time:number){
    if(time>this.maxMsgTime){
      this.maxMsgTime = time
    }
    if(time<this.minMsgTime){
      this.minMsgTime = time
    }
  }

  aboutToAppear(): void {
    let param = this.pageInfo.getParamByIndex(0) as ConversationDetailParams
    console.log("jimsdk_param:",param.conversationId)
    this.conversationId = param.conversationId
    this.conversationType = param.converType

    JuggleIm.instance.getMessageManager().addMsgReceivedListener((message)=>{
      let conver = message.conversation
      let currentUserId = JuggleIm.instance.userInfo.userId
      if(conver?.conversationId===param.conversationId){
        let viewMsg = new MessageViewItem("","Unknown",message.sentTime)
        if(currentUserId==message.senderId){
          viewMsg.isReceived = false
        }
        if(message.msgType=="jg:text") {
          let txtMsg = message.msgContent as TextMessage
          viewMsg.content = txtMsg.content
        }
        this.msgList.push(viewMsg)
      }
    })
    this.loadMoreMsgs()
  }

  loadMoreMsgs(){
    console.log("jimsdk_top",this.conversationId,this.conversationType,this.currentConversationUserName)
    let options:QueryMsgOptions = new QueryMsgOptions()
    options.count = 10
    options.startTime = this.minMsgTime
    options.isPositive = false
    JuggleIm.instance.getMessageManager().queryRemoteMessages(new Conversation(this.conversationId,this.conversationType),options,(code,msgs)=>{
      let currentUserId = JuggleIm.instance.userInfo.userId
      msgs.forEach((msg)=>{
        let viewMsg = new MessageViewItem("","Unknown",msg.sentTime)
        if(currentUserId==msg.senderId){
          viewMsg.isReceived = false
        }
        if(msg.msgType=="jg:text") {
          let txtMsg = msg.msgContent as TextMessage
          viewMsg.content = txtMsg.content
        }
        this.msgList.push(viewMsg)
        this.recordMsgTime(msg.sentTime)
      })
      this.msgList = this.msgList.slice().sort((a,b)=>a.msgTime-b.msgTime)
    })
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column }) {
        ConversationDetailTopSearch({ currentConversationUserName: $currentConversationUserName, })
          .height(Adaptive.ContactItemHeight(this.currentBreakpoint))
        Refresh({refreshing:$$this.refreshing,builder:this.refreshContent}){
          List(){
            ForEach(this.msgList,(item:MessageViewItem,index:number)=>{
              ListItem(){
                ConversationDetailItem(item)
              }
            })
          }
        }.onRefreshing(()=>{
          setTimeout(()=>{
            this.loadMoreMsgs()
            this.refreshing = false
          },200)
        })
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