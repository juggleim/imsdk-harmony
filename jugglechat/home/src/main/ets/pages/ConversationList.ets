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
import { ConversationDetailParams, ConversationRouteParams, ConversationViewItem } from '../viewmodel/ConversationViewModel';
import { ConversationItem } from '../views/Conversation/ConversationItem';
import { HomeTopSearch } from '../views/common/HomeTopSearch';
import { HomeConstants } from '../constants/HomeConstants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { ObservedArray} from '../jim/common'
import {
  ConnStatus,
  ConversationAddListener,
  ConversationDeleteListener,
  ConversationUpdateListener,
  GetConversationDirection,
  GetConversationOptions,
  JuggleIm
} from 'juggleim'
import { toConverViewItem } from '../viewmodel/ConversationViewModel'

const RECONNECT_RELOAD_LISTENER_KEY:string = 'conversation_list_reconnect_reload'

@Component
export struct ConversationList {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentConversationUserName: ResourceStr;
  @Link currentContactUserName: string;
  @State conversationList:ObservedArray<ConversationViewItem>=new ObservedArray<ConversationViewItem>([])
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

  private resetConverTimes():void{
    this.maxConverSortTime = 0
    this.minConverSortTime = Number.MAX_SAFE_INTEGER
  }

  private rebuildConverTimes():void{
    this.resetConverTimes()
    this.conversationList.forEach((item)=>{
      this.recordConverTime(item.converTime)
    })
  }

  private buildConversationQueryOptions(direction:GetConversationDirection, time:number):GetConversationOptions{
    let options = new GetConversationOptions()
    options.count = 20
    options.time = time
    options.direction = direction
    return options
  }

  private mergeConversationViewItem(converViewItem:ConversationViewItem):void{
    let foundIndex = this.conversationList.findIndex((item)=>{
      return item.getKey() == converViewItem.getKey()
    })
    if(foundIndex >= 0){
      this.conversationList[foundIndex] = converViewItem
    }else{
      this.conversationList.push(converViewItem)
    }
  }

  private compareConversation(left:ConversationViewItem, right:ConversationViewItem):number{
    if(left.isTop != right.isTop){
      return left.isTop ? -1 : 1
    }
    if(left.isTop && right.isTop && left.topTime != right.topTime){
      return right.topTime - left.topTime
    }
    return right.converTime - left.converTime
  }

  private sortConversationList():void{
    this.conversationList = new ObservedArray<ConversationViewItem>(
      this.conversationList.slice().sort((a,b)=>this.compareConversation(a, b))
    )
  }

  private isConversationActive(item:ConversationViewItem):boolean{
    for(let index = this.pageInfo.size() - 1; index >= 0; index--){
      let route = this.pageInfo.getParamByIndex(index) as ConversationRouteParams | undefined
      if(route != undefined &&
        route.conversationId == item.converId &&
        route.converType == item.converType &&
        (route.subChannel ?? '') == item.subChannel){
        return true
      }
    }
    return false
  }

  private getConversationItemBackgroundColor(item:ConversationViewItem):ResourceColor{
    if(this.isConversationActive(item)){
      return $r('app.color.conversation_clicked_bg_color')
    }
    if(item.isTop){
      return $r('app.color.conversation_top_bg_color')
    }
    return Color.White
  }

  aboutToDisappear(): void {
    JuggleIm.instance.getConnectionManager().removeConnectStatusListener(RECONNECT_RELOAD_LISTENER_KEY)
    JuggleIm.instance.getConversationManager().removeConversationAddListener(this.converAddListener)
    JuggleIm.instance.getConversationManager().removeConversationUpdateListener(this.converUpdListener)
    JuggleIm.instance.getConversationManager().removeConversationDeleteListener(this.converDelListener)
  }

  aboutToAppear(): void {
    this.resetConverTimes()
    this.conversationList = new ObservedArray<ConversationViewItem>([])

    if(JuggleIm.instance.getConnStatus() == ConnStatus.connecting || JuggleIm.instance.getConnStatus() == ConnStatus.waiting){
      JuggleIm.instance.getConnectionManager().addConnectStatusListener(RECONNECT_RELOAD_LISTENER_KEY, (status, _code, _userId) => {
        if(status==ConnStatus.connected){
          this.reloadConversations()
        }
      })
    } else if (JuggleIm.instance.getConnStatus() == ConnStatus.connected) {
      this.reloadConversations()
    }

    //conver add
    this.converAddListener = (convers)=>{
      convers.forEach((conver)=>{
        this.mergeConversationViewItem(toConverViewItem(conver))
      })
      this.sortConversationList()
      this.rebuildConverTimes()
    }
    JuggleIm.instance.getConversationManager().addConversationAddListener(this.converAddListener)

    //conver update
    this.converUpdListener = (convers)=>{
      let updatedConverList:ConversationViewItem[] = new Array()
      let updatedConverKeys:Map<string,boolean> = new Map()
      convers.forEach((conver)=>{
        let converViewItem = toConverViewItem(conver)
        updatedConverList.push(converViewItem)
        let key:string = converViewItem.getKey()
        updatedConverKeys.set(key,true)
      })
      let tmpConverList:ObservedArray<ConversationViewItem>=new ObservedArray<ConversationViewItem>([])
      this.conversationList.forEach((conver)=>{
        let key = conver.getKey()
        if(!updatedConverKeys.has(key)){
          tmpConverList.push(conver)
        }
      })
      updatedConverList.forEach((conver)=>{
        tmpConverList.push(conver)
      })
      this.conversationList = tmpConverList
      this.sortConversationList()
      this.rebuildConverTimes()
    }
    JuggleIm.instance.getConversationManager().addConversationUpdateListener(this.converUpdListener)

    //conver del
    this.converDelListener = (convers)=>{
      let delConverKeys:Map<string,boolean> = new Map()
      convers.forEach((conver)=>{
        let key:string = `${conver.conversation.conversationType}_${conver.conversation.conversationId}_${conver.conversation.subChannel}`
        delConverKeys.set(key,true)
      })
      let tmpConverList:ObservedArray<ConversationViewItem>=new ObservedArray<ConversationViewItem>([])
      this.conversationList.forEach((conver)=>{
        let key = conver.getKey()
        if(!delConverKeys.has(key)){
          tmpConverList.push(conver)
        }
      })
      this.conversationList = tmpConverList
      this.rebuildConverTimes()
    }
    JuggleIm.instance.getConversationManager().addConversationDeleteListener(this.converDelListener)
  }

  private queryConversations(direction:GetConversationDirection, time:number, reset:boolean):void{
    if(JuggleIm.instance.getConnStatus()==ConnStatus.connected) {
      if(reset){
        this.resetConverTimes()
        this.conversationList = new ObservedArray<ConversationViewItem>([])
      }
      let options = this.buildConversationQueryOptions(direction, time)
      JuggleIm.instance.getConversationManager()
        .queryConversations(options, (code, convers) => {
          convers.forEach((conver) => {
            this.mergeConversationViewItem(toConverViewItem(conver))
          })
          this.sortConversationList()
          this.rebuildConverTimes()
        })
    }
  }

  loadMoreConvers(){
    let anchorTime = this.minConverSortTime == Number.MAX_SAFE_INTEGER ? 0 : this.minConverSortTime
    this.queryConversations(GetConversationDirection.Backward, anchorTime, false)
  }

  private reloadConversations():void{
    this.queryConversations(GetConversationDirection.Backward, 0, true)
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      HomeTopSearch({ title: HomeConstants.CONVERSATION_TITLE, enableGlobalMessageSearch: true })
        .height('13%')
      List() {
        ForEach(this.conversationList, (item: ConversationViewItem, index: number) => {
          ListItem() {
            ConversationItem(item)
              .onClick(() => {
                if (this.pageInfo.size() > 1) {
                  this.pageInfo.pop();
                }
                this.pageInfo.pushPath({ name: 'ConversationDetail',param:new ConversationDetailParams(item.userId,item.converId,item.converType, item.name as string, item.subChannel)});
                this.currentConversationUserName = item.name;
                this.currentContactUserName = '';
              })
              .backgroundColor(this.getConversationItemBackgroundColor(item))
          }
          .height(Adaptive.ContactItemHeight(this.currentBreakpoint))

        }, (item: ConversationViewItem) => item.getKey())
      }
      .onReachEnd(()=>{
        this.loadMoreConvers()
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
