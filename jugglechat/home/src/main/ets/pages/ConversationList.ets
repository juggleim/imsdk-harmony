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
import { ObservedArray} from '../jim/common'
import {JuggleIm} from 'juggleim'
import { ConnStatus } from 'juggleim/src/main/ets/imclients/imclient';
import { toConverViewItem } from '../viewmodel/ConversationViewModel'
import {
  ConversationAddListener,
  ConversationDeleteListener,
  ConversationUpdateListener } from 'juggleim/src/main/ets/managers/conversationmanager';

@Component
export struct ConversationList {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentConversationUserName: ResourceStr;
  @Link currentContactUserName: string;
  @State private currentIndex: number = 0;
  @State conversationList:ObservedArray<ConversationViewItem>=[]
  @Consume('pageInfo') pageInfo: NavPathStack;
  // private scroller: ListScroller = new ListScroller()
  private maxConverSortTime:number = 0
  private minConverSortTime:number = Number.MAX_SAFE_INTEGER
  private converAddListener:ConversationAddListener = ()=>{}
  private converUpdListener:ConversationUpdateListener = ()=>{}
  private converDelListener:ConversationDeleteListener = ()=>{}

  private recordConverTime(time:number){
    if (this.maxConverSortTime < time) {
      this.maxConverSortTime = time
    }
    if (this.minConverSortTime > time) {
      this.minConverSortTime = time
    }
  }

  aboutToDisappear(): void {
    JuggleIm.instance.getConversationManager().removeConversationAddListener(this.converAddListener)
    JuggleIm.instance.getConversationManager().removeConversationUpdateListener(this.converUpdListener)
    JuggleIm.instance.getConversationManager().removeConversationDeleteListener(this.converDelListener)
  }

  aboutToAppear(): void {
    this.maxConverSortTime = 0
    this.minConverSortTime = new Date().getTime()

    if(JuggleIm.instance.getConnStatus() == ConnStatus.connecting){
      JuggleIm.instance.getConnectionManager().addConnectStatusListener((status,code)=>{
        if(status==ConnStatus.connected){
          this.loadMoreConvers()
        }
      })
    }

    //conver add
    this.converAddListener = (convers)=>{
      convers.forEach((conver)=>{
        this.conversationList.push(toConverViewItem(conver))
        this.recordConverTime(conver.converTime)
      })
      this.conversationList = this.conversationList.slice().sort((a,b)=>b.converTime - a.converTime)
    }
    JuggleIm.instance.getConversationManager().addConversationAddListener(this.converAddListener)

    //conver update
    this.converUpdListener = (convers)=>{
      console.log("jimsdk_msgrece_converupd:",JSON.stringify(convers))
      let updatedConverList:ConversationViewItem[] = new Array()
      let updatedConverKeys:Map<string,boolean> = new Map()
      convers.forEach((conver)=>{
        let converViewItem = toConverViewItem(conver)
        updatedConverList.push(converViewItem)
        let key:string = conver.conversation.conversationId+"_"+conver.conversation.conversationType
        updatedConverKeys.set(key,true)
      })
      let tmpConverList:ObservedArray<ConversationViewItem>=[]
      this.conversationList.forEach((conver)=>{
        let key = conver.converId+"_"+conver.converType
        if(!updatedConverKeys.has(key)){
          tmpConverList.push(conver)
        }
      })
      updatedConverList.forEach((conver)=>{
        tmpConverList.push(conver)
      })
      tmpConverList = tmpConverList.slice().sort((a,b)=>b.converTime-a.converTime)
      this.conversationList = tmpConverList
    }
    JuggleIm.instance.getConversationManager().addConversationUpdateListener(this.converUpdListener)

    //conver del
    this.converDelListener = (convers)=>{
      console.log("jimsdk_msgrece_del",JSON.stringify(convers))
      let delConverKeys:Map<string,boolean> = new Map()
      convers.forEach((conver)=>{
        let key:string = conver.conversation.conversationId+"_"+conver.conversation.conversationType
        delConverKeys.set(key,true)
      })
      let tmpConverList:ObservedArray<ConversationViewItem>=[]
      this.conversationList.forEach((conver)=>{
        let key = conver.converId+"_"+conver.converType
        if(!delConverKeys.has(key)){
          tmpConverList.push(conver)
        }
      })
      this.conversationList = tmpConverList
    }
    JuggleIm.instance.getConversationManager().addConversationDeleteListener(this.converDelListener)
  }

  loadMoreConvers(){
    if(JuggleIm.instance.getConnStatus()==ConnStatus.connected) {
      JuggleIm.instance.getConversationManager()
        .queryConversations(20, this.minConverSortTime, false, (code, convers) => {
          convers.forEach((conver) => {
            this.conversationList.push(toConverViewItem(conver))
            this.recordConverTime(conver.converTime)
          })
          this.conversationList = this.conversationList.slice().sort((a,b)=>b.converTime - a.converTime)
        })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      HomeTopSearch({ title: HomeConstants.CONVERSATION_TITLE })
        .height('13%')
      List() {
        ForEach(this.conversationList, (item: ConversationViewItem, index: number) => {
          ListItem() {
            ConversationItem(item)
              .onClick(() => {
                if (this.pageInfo.size() > 1) {
                  this.pageInfo.pop();
                }
                this.pageInfo.pushPath({ name: 'ConversationDetail',param:new ConversationDetailParams(item.userId,item.converId,item.converType)});
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