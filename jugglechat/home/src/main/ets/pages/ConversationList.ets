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
import { ConversationViewItem,ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import { ConversationItem } from '../views/Conversation/ConversationItem';
import { HomeTopSearch } from '../views/common/HomeTopSearch';
import { HomeConstants } from '../constants/HomeConstants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { CommonUtil, ObservedArray} from '../jim/common'
import {JuggleIm} from 'juggleim'
import { TextMessage } from 'juggleim/src/main/ets/entries/message'
import { ConnStatus } from 'juggleim/src/main/ets/imclients/imclient';

@Component
export struct ConversationList {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentConversationUserName: ResourceStr;
  @Link currentContactUserName: string;
  @State private currentIndex: number = 0;
  @State conversationList:ObservedArray<ConversationViewItem>=[]
  @Consume('pageInfo') pageInfo: NavPathStack;
  private scroller: ListScroller = new ListScroller()
  private maxConverSortTime:number = 0
  private minConverSortTime:number = Number.MAX_SAFE_INTEGER

  aboutToAppear(): void {
    this.maxConverSortTime = 0
    this.minConverSortTime = new Date().getTime()

    console.log("jimsdk_initlis_status:",JuggleIm.instance.getConnStatus())
    if(JuggleIm.instance.getConnStatus() == ConnStatus.connecting){
      console.log("jimsdk_initlis_regst")
      JuggleIm.instance.getConnectionManager().addConnectStatusListener((status,code)=>{
        console.log("jinsdk_initlis_tri:",status,code)
        if(status==ConnStatus.connected){
          console.log("jimsdk_initlis_load")
          this.loadMoreConvers()
          console.log("jimsdk_reload_connected:",this.conversationList.length)
        }
      })
    }

    // JuggleIm.instance.getMessageManager().addMsgReceivedListener((message)=>{
    //   let conversation = message.conversation
    //   if(this.conversationList.length === 0){
    //     return
    //   }
    //
    //   for(let i=0;i<this.conversationList.length;i++){
    //     if(this.conversationList[i].converId===conversation.conversationId
    //       &&this.conversationList[i].channelType===conversation.conversationType){
    //       if(message.msgType == 'jg:text') {
    //         let txtMsg = message.msgContent as TextMessage
    //         this.conversationList[i].msg = txtMsg.content
    //       }else {
    //         this.conversationList[i].msg = ''
    //       }
    //     }else{
    //       this.conversationList[i].msg = 'nnnnnn'
    //     }
    //   }
    //   let converList:ObservedArray<ConversationViewItem>=[]
    //   for(let i=0;i<this.conversationList.length;i++){
    //     converList.push(this.conversationList[i])
    //   }
    //   this.conversationList = converList
    // })
  }

  loadMoreConvers(){
    if(JuggleIm.instance.getConnStatus()==ConnStatus.connected) {
      console.log("jimsdk_load", "\tmin:", this.minConverSortTime)
      JuggleIm.instance.getConversationManager()
        .queryConversations(10, this.minConverSortTime, false, (code, convers) => {
          convers.forEach((conver) => {
            //portrait
            let iconUrl: ResourceStr = $r('app.media.avatar2')
            if (conver.conversation.conversationType == 2) {
              iconUrl = $r('app.media.img')
            }
            //title
            let title = ""
            if(conver.conversation.conversationType==1){
              let userInfo = JuggleIm.instance.getUserInfoManager().getLocalUserInfo(conver.conversation.conversationId)
              console.log("jimsdk_saveuser_check:",JSON.stringify(userInfo),conver.conversation.conversationId)
              if(userInfo!=null){
                title = userInfo.nickname
                if(userInfo.userPortrait!=''){
                  iconUrl = userInfo.userPortrait
                }
              }
            }else if(conver.conversation.conversationType==2){
              let grpInfo = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(conver.conversation.conversationId)
              if(grpInfo!=null){
                title = grpInfo.groupName
                if(grpInfo.groupPortrait!=''){
                  console.log("jimsdk_nullgrp:",grpInfo.groupPortrait,grpInfo.groupName)
                  iconUrl = grpInfo.groupPortrait
                }
              }
            }else{
              console.log("jimsdk_other:",conver.conversation.conversationId,conver.conversation.conversationType)
            }
            console.log("jimsdk_userinfo:",title,conver.conversation.conversationId,conver.conversation.conversationType)
            //latest msg content
            let msgStr = ""
            if (conver.lastMessage.msgType == 'jg:text') {
              let txtMsg = conver.lastMessage.msgContent as TextMessage
              msgStr = txtMsg.content

            }
            console.log("jimsdk_qryconvers_msg:",conver.lastMessage.msgType,msgStr,typeof conver.lastMessage.msgContent)
            //time str
            let timeStr = CommonUtil.getTimeToYYYYDDMMHHMMSS(conver.converTime)
            this.conversationList.push(new ConversationViewItem("", conver.conversation.conversationId,
              conver.conversation.conversationType, conver.lastMessage.sentTime, title,
              msgStr, timeStr, iconUrl))
            if (this.maxConverSortTime < conver.converTime) {
              this.maxConverSortTime = conver.converTime
            }
            if (this.minConverSortTime > conver.converTime) {
              this.minConverSortTime = conver.converTime
            }
          })
        })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      HomeTopSearch({ title: HomeConstants.CONVERSATION_TITLE })
        .height('13%')
      List({scroller:this.scroller}) {
        ForEach(this.conversationList, (item: ConversationViewItem, index: number) => {
          ListItem() {
            ConversationItem(item)
              .onClick(() => {
                if (this.pageInfo.size() > 1) {
                  this.pageInfo.pop();
                }
                this.pageInfo.pushPath({ name: 'ConversationDetail',param:new ConversationDetailParams(item.userId,item.converId,item.channelType)});
                this.currentConversationUserName = item.name;
                this.currentContactUserName = '';
                this.currentIndex = index;
              })
              .backgroundColor(this.currentIndex === index ? $r('app.color.conversation_clicked_bg_color') : Color.White)
          }
          .height(Adaptive.ContactItemHeight(this.currentBreakpoint))

        }, (item: ConversationViewItem, index: number) => index + JSON.stringify(item))
      }
      .onReachEnd(()=>{
        console.log("jimsdk_end, load more")
        this.loadMoreConvers()
        console.log("jimsdk_reload_onend:",this.conversationList.length)
      })
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