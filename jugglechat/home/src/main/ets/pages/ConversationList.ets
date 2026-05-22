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
import { ConversationViewItem,ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import { ConversationItem } from '../views/Conversation/ConversationItem';
import { HomeTopSearch } from '../views/common/HomeTopSearch';
import { HomeConstants } from '../constants/HomeConstants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { ObservedArray} from '../jim/common'
import {
  Conversation,
  ConnStatus,
  ConversationAddListener,
  ConversationDeleteListener,
  ConversationUpdateListener,
  GetConversationDirection,
  GetConversationOptions,
  JuggleIm
} from 'juggleim'
import { toConverViewItem } from '../viewmodel/ConversationViewModel'

class DemoConversationTagOption {
  id:string
  label:string

  constructor(id:string, label:string) {
    this.id = id
    this.label = label
  }
}

const DEMO_CONVERSATION_TAG_OPTIONS:DemoConversationTagOption[] = [
  new DemoConversationTagOption('work', '项目'),
  new DemoConversationTagOption('follow_up', '待跟进'),
  new DemoConversationTagOption('important', '重要')
]

@Component
export struct ConversationList {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentConversationUserName: ResourceStr;
  @Link currentContactUserName: string;
  @State private currentIndex: number = 0;
  @State conversationList:ObservedArray<ConversationViewItem>=new ObservedArray<ConversationViewItem>([])
  @State private activeTagId:string = ''
  @State private tagUnreadCounts:number[] = [0, 0, 0]
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
    options.tagId = this.activeTagId
    return options
  }

  private hasActiveTagFilter():boolean{
    return this.activeTagId != ''
  }

  private conversationHasTag(item:ConversationViewItem, tagId:string):boolean{
    return item.tags.indexOf(tagId) >= 0
  }

  private refreshTagUnreadCounts():void{
    DEMO_CONVERSATION_TAG_OPTIONS.forEach((option, index)=>{
      JuggleIm.instance.getConversationManager().getTotalUnreadCountByTag(option.id, (code, count)=>{
        if(code != 0){
          return
        }
        let nextCounts = this.tagUnreadCounts.slice()
        nextCounts[index] = count
        this.tagUnreadCounts = nextCounts
      })
    })
  }

  private applyTagFilter(tagId:string):void{
    this.activeTagId = tagId
    this.reloadConversations()
  }

  private toggleConversationTag(item:ConversationViewItem, tagId:string):void{
    let conver = new Conversation(item.converId, item.converType)
    let callback = (code:number)=>{
      if(code == 0){
        this.refreshTagUnreadCounts()
        if(this.hasActiveTagFilter()){
          this.reloadConversations()
        }
      }
    }
    if(this.conversationHasTag(item, tagId)){
      JuggleIm.instance.getConversationManager().removeConversationTag(conver, tagId, callback)
    }else{
      JuggleIm.instance.getConversationManager().addConversationTag(conver, tagId, callback)
    }
  }

  private mergeConversationViewItem(converViewItem:ConversationViewItem):void{
    let foundIndex = this.conversationList.findIndex((item)=>{
      return item.converId == converViewItem.converId && item.converType == converViewItem.converType
    })
    if(foundIndex >= 0){
      this.conversationList[foundIndex] = converViewItem
    }else{
      this.conversationList.push(converViewItem)
    }
  }

  aboutToDisappear(): void {
    JuggleIm.instance.getConversationManager().removeConversationAddListener(this.converAddListener)
    JuggleIm.instance.getConversationManager().removeConversationUpdateListener(this.converUpdListener)
    JuggleIm.instance.getConversationManager().removeConversationDeleteListener(this.converDelListener)
  }

  aboutToAppear(): void {
    this.resetConverTimes()
    this.conversationList = new ObservedArray<ConversationViewItem>([])
    this.refreshTagUnreadCounts()

    if(JuggleIm.instance.getConnStatus() == ConnStatus.connecting){
      JuggleIm.instance.getConnectionManager().addConnectStatusListener((status,code)=>{
        if(status==ConnStatus.connected){
          this.reloadConversations()
        }
      })
    } else if (JuggleIm.instance.getConnStatus() == ConnStatus.connected) {
      this.reloadConversations()
    }

    //conver add
    this.converAddListener = (convers)=>{
      this.refreshTagUnreadCounts()
      if(this.hasActiveTagFilter()){
        this.reloadConversations()
        return
      }
      convers.forEach((conver)=>{
        this.mergeConversationViewItem(toConverViewItem(conver))
      })
      this.conversationList = new ObservedArray<ConversationViewItem>(this.conversationList.slice().sort((a,b)=>b.converTime - a.converTime))
      this.rebuildConverTimes()
    }
    JuggleIm.instance.getConversationManager().addConversationAddListener(this.converAddListener)

    //conver update
    this.converUpdListener = (convers)=>{
      console.log("jimsdk_msgrece_converupd:",JSON.stringify(convers))
      this.refreshTagUnreadCounts()
      if(this.hasActiveTagFilter()){
        this.reloadConversations()
        return
      }
      let updatedConverList:ConversationViewItem[] = new Array()
      let updatedConverKeys:Map<string,boolean> = new Map()
      convers.forEach((conver)=>{
        let converViewItem = toConverViewItem(conver)
        updatedConverList.push(converViewItem)
        let key:string = conver.conversation.conversationId+"_"+conver.conversation.conversationType
        updatedConverKeys.set(key,true)
      })
      let tmpConverList:ObservedArray<ConversationViewItem>=new ObservedArray<ConversationViewItem>([])
      this.conversationList.forEach((conver)=>{
        let key = conver.converId+"_"+conver.converType
        if(!updatedConverKeys.has(key)){
          tmpConverList.push(conver)
        }
      })
      updatedConverList.forEach((conver)=>{
        tmpConverList.push(conver)
      })
      tmpConverList = new ObservedArray<ConversationViewItem>(tmpConverList.slice().sort((a,b)=>b.converTime-a.converTime))
      this.conversationList = tmpConverList
      this.rebuildConverTimes()
    }
    JuggleIm.instance.getConversationManager().addConversationUpdateListener(this.converUpdListener)

    //conver del
    this.converDelListener = (convers)=>{
      console.log("jimsdk_msgrece_del",JSON.stringify(convers))
      this.refreshTagUnreadCounts()
      if(this.hasActiveTagFilter()){
        this.reloadConversations()
        return
      }
      let delConverKeys:Map<string,boolean> = new Map()
      convers.forEach((conver)=>{
        let key:string = conver.conversation.conversationId+"_"+conver.conversation.conversationType
        delConverKeys.set(key,true)
      })
      let tmpConverList:ObservedArray<ConversationViewItem>=new ObservedArray<ConversationViewItem>([])
      this.conversationList.forEach((conver)=>{
        let key = conver.converId+"_"+conver.converType
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
          this.conversationList = new ObservedArray<ConversationViewItem>(this.conversationList.slice().sort((a,b)=>b.converTime - a.converTime))
          this.rebuildConverTimes()
          this.refreshTagUnreadCounts()
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
    Column() {
      HomeTopSearch({ title: HomeConstants.CONVERSATION_TITLE, enableGlobalMessageSearch: true })
        .height(72)
      Column() {
        Scroll() {
          Row({ space: 8 }) {
            Text('全部')
              .fontSize(BaseConstants.FONT_SIZE_TWELVE)
              .fontColor(this.activeTagId == '' ? Color.White : '#55606D')
              .backgroundColor(this.activeTagId == '' ? '#0A59F7' : '#EEF2F7')
              .borderRadius(12)
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .onClick(()=>{
                this.applyTagFilter('')
              })
            ForEach(DEMO_CONVERSATION_TAG_OPTIONS, (option:DemoConversationTagOption) => {
              Text(option.label)
                .fontSize(BaseConstants.FONT_SIZE_TWELVE)
                .fontColor(this.activeTagId == option.id ? Color.White : '#55606D')
                .backgroundColor(this.activeTagId == option.id ? '#0A59F7' : '#EEF2F7')
                .borderRadius(12)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .onClick(()=>{
                  this.applyTagFilter(option.id)
                })
            }, (option:DemoConversationTagOption) => option.id)
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)

        Row({ space: 12 }) {
          ForEach(DEMO_CONVERSATION_TAG_OPTIONS, (option:DemoConversationTagOption, index:number) => {
            Text(`${option.label} ${this.tagUnreadCounts[index]}`)
              .fontSize(BaseConstants.FONT_SIZE_ELEVEN)
              .fontColor('#6B7280')
          }, (option:DemoConversationTagOption) => `${option.id}_stat`)
        }
        .margin({ top: 10 })
      }
      .width(BaseConstants.FULL_WIDTH)
      .padding({ left: 16, right: 16, bottom: 10 })
      .backgroundColor(Color.White)
      List() {
        ForEach(this.conversationList, (item: ConversationViewItem, index: number) => {
          ListItem() {
            Column() {
              ConversationItem(item)
                .onClick(() => {
                  if (this.pageInfo.size() > 1) {
                    this.pageInfo.pop();
                  }
                  this.pageInfo.pushPath({ name: 'ConversationDetail',param:new ConversationDetailParams(item.userId,item.converId,item.converType, item.name as string)});
                  this.currentConversationUserName = item.name;
                  this.currentContactUserName = '';
                  this.currentIndex = index;
                })
              Row({ space: 8 }) {
                ForEach(DEMO_CONVERSATION_TAG_OPTIONS, (option:DemoConversationTagOption) => {
                  Text(this.conversationHasTag(item, option.id) ? `${option.label} 已标记` : option.label)
                    .fontSize(BaseConstants.FONT_SIZE_ELEVEN)
                    .fontColor(this.conversationHasTag(item, option.id) ? '#0A59F7' : '#667085')
                    .backgroundColor(this.conversationHasTag(item, option.id) ? '#E8F0FE' : '#F4F5F7')
                    .borderRadius(12)
                    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                    .onClick(()=>{
                      this.toggleConversationTag(item, option.id)
                    })
                }, (option:DemoConversationTagOption) => `${item.converId}_${option.id}`)
              }
              .margin({ left: 72, right: 16, bottom: 12 })
            }
            .backgroundColor(this.currentIndex === index ? $r('app.color.conversation_clicked_bg_color') : Color.White)
          }
          .padding({ top: 4, bottom: 2 })

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
      .layoutWeight(1)
    }
    .height(BaseConstants.FULL_HEIGHT)
    .width(BaseConstants.FULL_WIDTH)
  }
}
