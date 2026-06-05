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
import { promptAction } from '@kit.ArkUI'
import { ConversationDetailParams, ConversationRouteParams, ConversationViewItem, NavSourceParam } from '../viewmodel/ConversationViewModel';
import { ConversationItem } from '../views/Conversation/ConversationItem';
import { HomeTopSearch } from '../views/common/HomeTopSearch';
import { HomeConstants } from '../constants/HomeConstants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { ObservedArray} from '../jim/common'
import {
  ConnStatus,
  ConversationAddListener,
  Conversation,
  ConversationInfo,
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
  @State private showConversationActionPanel:boolean = false
  @State private conversationActionBusy:boolean = false
  @State private selectedConversationKey:string = ''
  @State private showQuickActionPanel:boolean = false
  private touchStartTimeMap:Map<string,number> = new Map()
  private suppressClickKey:string = ''
  private suppressClickTimer:number = -1
  private converAddListener:ConversationAddListener = ()=>{}
  private converUpdListener:ConversationUpdateListener = ()=>{}
  private converDelListener:ConversationDeleteListener = ()=>{}

  private showToast(message:string):void{
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
  }

  private openQuickActionPanel():void{
    this.closeConversationActionPanel()
    this.showQuickActionPanel = true
  }

  private closeQuickActionPanel():void{
    this.showQuickActionPanel = false
  }

  private openQuickActionPage(name:string):void{
    this.closeQuickActionPanel()
    this.pageInfo.pushPath({
      name,
      param: new NavSourceParam('home')
    })
  }

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

  private applyConversationItems(convers:ConversationInfo[]):void{
    if(convers.length == 0){
      return
    }
    convers.forEach((conver)=>{
      this.mergeConversationViewItem(toConverViewItem(conver))
    })
    this.sortConversationList()
    this.rebuildConverTimes()
  }

  private removeConversationItems(convers:ConversationInfo[]):void{
    if(convers.length == 0){
      return
    }
    let removeKeys:string[] = []
    convers.forEach((conver)=>{
      removeKeys.push(`${conver.conversation.conversationType}_${conver.conversation.conversationId}_${conver.conversation.subChannel ?? ''}`)
    })
    let nextItems = this.conversationList.filter((item)=>{
      return removeKeys.indexOf(item.getKey()) < 0
    })
    if(nextItems.length == this.conversationList.length){
      return
    }
    this.conversationList = new ObservedArray<ConversationViewItem>(nextItems)
    this.sortConversationList()
    this.rebuildConverTimes()
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
      let route = this.pageInfo.getParamByIndex(index) as ConversationRouteParams
      if(route != undefined &&
        route.conversationId == item.converId &&
        route.converType == item.converType &&
        (route.subChannel ?? '') == item.subChannel){
        return true
      }
    }
    return false
  }

  private getSelectedConversationItem():ConversationViewItem|undefined{
    if(this.selectedConversationKey == ''){
      return undefined
    }
    return this.conversationList.find((item)=>{
      return item.getKey() == this.selectedConversationKey
    })
  }

  private getSelectedConversationTitle():ResourceStr{
    let item = this.getSelectedConversationItem()
    if(item == undefined){
      return '会话操作'
    }
    return item.name
  }

  private isSelectedConversationTop():boolean{
    let item = this.getSelectedConversationItem()
    if(item == undefined){
      return false
    }
    return item.isTop
  }

  private isSelectedConversationMute():boolean{
    let item = this.getSelectedConversationItem()
    if(item == undefined){
      return false
    }
    return item.isMute
  }

  private openConversation(item:ConversationViewItem, bypassSuppress:boolean = false):void{
    if(!bypassSuppress && this.suppressClickKey == item.getKey()){
      this.suppressClickKey = ''
      return
    }
    if (this.pageInfo.size() > 1) {
      this.pageInfo.pop();
    }
    this.pageInfo.pushPath({
      name: 'ConversationDetail',
      param: new ConversationDetailParams(item.userId, item.converId, item.converType, item.name as string, item.subChannel)
    });
    this.currentConversationUserName = item.name;
    this.currentContactUserName = '';
  }

  private openConversationActionPanel(item:ConversationViewItem):void{
    this.closeQuickActionPanel()
    this.selectedConversationKey = item.getKey()
    this.showConversationActionPanel = true
  }

  private closeConversationActionPanel():void{
    this.showConversationActionPanel = false
    this.conversationActionBusy = false
    this.selectedConversationKey = ''
  }

  private suppressConversationClick(itemKey:string):void{
    this.suppressClickKey = itemKey
    if(this.suppressClickTimer >= 0){
      clearTimeout(this.suppressClickTimer)
    }
    this.suppressClickTimer = setTimeout(()=>{
      if(this.suppressClickKey == itemKey){
        this.suppressClickKey = ''
      }
      this.suppressClickTimer = -1
    }, 600)
  }

  private async withConversationAction(action:()=>void):Promise<void>{
    if(this.conversationActionBusy){
      return
    }
    this.conversationActionBusy = true
    try{
      action()
    }finally{
      setTimeout(()=>{
        this.conversationActionBusy = false
      }, 350)
    }
  }

  private updateSelectedConversationTop():void{
    let selectedItem = this.getSelectedConversationItem()
    if(selectedItem == undefined){
      this.closeConversationActionPanel()
      return
    }
    let converId = selectedItem.converId
    let converType = selectedItem.converType
    let subChannel = selectedItem.subChannel
    let nextTopState = !selectedItem.isTop
    this.withConversationAction(()=>{
      JuggleIm.instance.getConversationManager().setTop(
        new Conversation(converId, converType, subChannel),
        nextTopState,
        (code)=>{
          if(code != 0){
            this.showToast(`置顶失败: ${code}`)
            this.showConversationActionPanel = false
            this.conversationActionBusy = false
            this.suppressClickKey = ''
            return
          }
          this.reloadConversations()
          this.closeConversationActionPanel()
        }
      )
    })
  }

  private updateSelectedConversationMute():void{
    let selectedItem = this.getSelectedConversationItem()
    if(selectedItem == undefined){
      this.closeConversationActionPanel()
      return
    }
    let converId = selectedItem.converId
    let converType = selectedItem.converType
    let subChannel = selectedItem.subChannel
    let nextMuteState = !selectedItem.isMute
    this.withConversationAction(()=>{
      JuggleIm.instance.getConversationManager().setMute(
        new Conversation(converId, converType, subChannel),
        nextMuteState,
        (code)=>{
          if(code != 0){
            this.showToast(`免打扰设置失败: ${code}`)
            this.conversationActionBusy = false
            return
          }
          this.reloadConversations()
          this.closeConversationActionPanel()
        }
      )
    })
  }

  private clearSelectedConversationUnread():void{
    let selectedItem = this.getSelectedConversationItem()
    if(selectedItem == undefined){
      this.closeConversationActionPanel()
      return
    }
    let converId = selectedItem.converId
    let converType = selectedItem.converType
    let subChannel = selectedItem.subChannel
    this.withConversationAction(()=>{
      let conver = new Conversation(converId, converType, subChannel)
      JuggleIm.instance.getConversationManager().clearUnreadCount(conver, (code)=>{
        if(code != 0){
          this.showToast(`清除未读失败: ${code}`)
          this.conversationActionBusy = false
          return
        }
        this.reloadConversations()
        this.closeConversationActionPanel()
      })
    })
  }

  private deleteSelectedConversation():void{
    let selectedItem = this.getSelectedConversationItem()
    if(selectedItem == undefined){
      this.closeConversationActionPanel()
      return
    }
    let converId = selectedItem.converId
    let converType = selectedItem.converType
    let subChannel = selectedItem.subChannel
    this.withConversationAction(()=>{
      let conver = new Conversation(converId, converType, subChannel)
      JuggleIm.instance.getConversationManager().delConversation(conver, (code)=>{
        if(code != 0){
          this.showToast(`删除会话失败: ${code}`)
          this.conversationActionBusy = false
          return
        }
        this.reloadConversations()
        this.closeConversationActionPanel()
      })
    })
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

    JuggleIm.instance.getConnectionManager().addConnectStatusListener(RECONNECT_RELOAD_LISTENER_KEY, (status, _code, _userId) => {
      if(status == ConnStatus.connected){
        this.reloadConversations()
      }
    })

    if (JuggleIm.instance.getConnStatus() == ConnStatus.connected) {
      this.reloadConversations()
    }

    //conver add
    this.converAddListener = (convers)=>{
      this.applyConversationItems(convers)
    }
    JuggleIm.instance.getConversationManager().addConversationAddListener(this.converAddListener)

    //conver update
    this.converUpdListener = (convers)=>{
      this.applyConversationItems(convers)
    }
    JuggleIm.instance.getConversationManager().addConversationUpdateListener(this.converUpdListener)

    //conver del
    this.converDelListener = (convers)=>{
      this.removeConversationItems(convers)
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
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        HomeTopSearch({
          title: HomeConstants.CONVERSATION_TITLE,
          enableGlobalMessageSearch: true,
          onAddTap: ()=>{
            this.openQuickActionPanel()
          }
        })
          .height('13%')
        List() {
          ForEach(this.conversationList, (item: ConversationViewItem, index: number) => {
            ListItem() {
              ConversationItem(item)
                .onClick(() => {
                  this.openConversation(item)
                })
                .backgroundColor(this.getConversationItemBackgroundColor(item))
            }
            .height(Adaptive.ContactItemHeight(this.currentBreakpoint))
            .onTouch((event: TouchEvent)=>{
              let itemKey = item.getKey()
              if(event.type == TouchType.Down){
                this.touchStartTimeMap.set(itemKey, new Date().getTime())
              }else if(event.type == TouchType.Up){
                let startTime = this.touchStartTimeMap.get(itemKey)
                if(startTime != undefined && (new Date().getTime() - startTime) >= 500){
                  this.suppressConversationClick(itemKey)
                  this.openConversationActionPanel(item)
                }
                this.touchStartTimeMap.delete(itemKey)
              }else if(event.type == TouchType.Cancel){
                this.touchStartTimeMap.delete(itemKey)
              }
            })
            .onMouse((event: MouseEvent)=>{
              if(event.action == MouseAction.Press && event.button == MouseButton.Right){
                this.suppressConversationClick(item.getKey())
                this.openConversationActionPanel(item)
              }
            })

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
        .layoutWeight(1)
      }
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
      .zIndex(1)

      if(this.showQuickActionPanel){
        Column() {
          Blank()
            .layoutWeight(1)
            .width('100%')
            .backgroundColor('#66000000')
            .onClick(()=>{
              this.closeQuickActionPanel()
            })

          Column() {
            Row() {
              Text('快捷入口')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#111827')
              Blank()
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 12 })

            Divider().strokeWidth(1).color('#EAEAEA')

            Row() {
              Text('添加好友')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openQuickActionPage('FriendRequestList')
            })

            Divider().strokeWidth(1).color('#EAEAEA')

            Row() {
              Text('创建群聊')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openQuickActionPage('CreateChatroom')
            })

            Divider().strokeWidth(1).color('#EAEAEA')

            Row() {
              Text('扫一扫')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openQuickActionPage('ScanPage')
            })

            Divider().strokeWidth(1).color('#EAEAEA')

            Row() {
              Text('我的二维码')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openQuickActionPage('QRCodeDisplay')
            })

            Divider().strokeWidth(1).color('#EAEAEA')

            Row() {
              Text('聊天室')
                .fontSize(16)
                .fontColor('#111111')
              Blank()
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 16 })
            .onClick(()=>{
              this.openQuickActionPage('ChatroomList')
            })

            Divider()
              .strokeWidth(1)
              .color('#EAEAEA')

            Row() {
              Blank()
              Text('取消')
                .fontSize(16)
                .fontColor('#111827')
                .padding({ top: 16, bottom: 16 })
                .onClick(()=>{
                  this.closeQuickActionPanel()
                })
              Blank()
            }
            .width('100%')
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius({
            topLeft: 16,
            topRight: 16
          })
          .zIndex(2)
        }
        .width('100%')
        .height('100%')
        .zIndex(100)
      }

      if(this.showConversationActionPanel){
        Column() {
          Blank()
            .layoutWeight(1)
            .width('100%')
            .backgroundColor('#66000000')
            .onClick(()=>{
              this.closeConversationActionPanel()
            })

          Column() {
            Row() {
              Text(this.getSelectedConversationTitle())
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#111827')
              Blank()
              Text(this.isSelectedConversationTop() ? '置顶中' : '')
                .fontSize(12)
                .fontColor('#6B7280')
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 12 })

            Divider()
              .strokeWidth(1)
              .color('#EAEAEA')

            Column() {
              Row() {
                Text('会话详情')
                  .fontSize(16)
                  .fontColor('#111111')
                Blank()
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 16, bottom: 16 })
              .onClick(()=>{
                let item = this.getSelectedConversationItem()
                if(item == undefined){
                  this.closeConversationActionPanel()
                  return
                }
                this.suppressClickKey = ''
                this.closeConversationActionPanel()
                this.openConversation(item, true)
              })

              Divider().strokeWidth(1).color('#EAEAEA')

              Row() {
                Text(this.isSelectedConversationTop() ? '取消置顶' : '置顶会话')
                  .fontSize(16)
                  .fontColor('#111111')
                Blank()
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 16, bottom: 16 })
              .onClick(()=>{
                this.updateSelectedConversationTop()
              })

              Divider().strokeWidth(1).color('#EAEAEA')

              Row() {
                Text(this.isSelectedConversationMute() ? '取消免打扰' : '消息免打扰')
                  .fontSize(16)
                  .fontColor('#111111')
                Blank()
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 16, bottom: 16 })
              .onClick(()=>{
                this.updateSelectedConversationMute()
              })

              Divider().strokeWidth(1).color('#EAEAEA')

              Row() {
                Text('清除未读')
                  .fontSize(16)
                  .fontColor('#111111')
                Blank()
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 16, bottom: 16 })
              .onClick(()=>{
                this.clearSelectedConversationUnread()
              })

              Divider().strokeWidth(1).color('#EAEAEA')

              Row() {
                Text('删除会话')
                  .fontSize(16)
                  .fontColor('#E24A4A')
                Blank()
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 16, bottom: 16 })
              .onClick(()=>{
                this.deleteSelectedConversation()
              })
            }

            Divider()
              .strokeWidth(1)
              .color('#EAEAEA')

            Row() {
              Blank()
              Text('取消')
                .fontSize(16)
                .fontColor('#111827')
                .padding({ top: 16, bottom: 16 })
                .onClick(()=>{
                  this.closeConversationActionPanel()
                })
              Blank()
            }
            .width('100%')
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius({
            topLeft: 16,
            topRight: 16
          })
          .opacity(this.conversationActionBusy ? 0.8 : 1)
          .zIndex(3)
        }
        .width('100%')
        .height('100%')
        .zIndex(101)
      }
    }
    .height(BaseConstants.FULL_HEIGHT)
    .width(BaseConstants.FULL_WIDTH)
  }
}
