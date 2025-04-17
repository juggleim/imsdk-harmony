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

import { Adaptive, BaseConstants, BreakpointConstants, StandardIcon } from 'base';
import {ConversationDetailItem} from '../views/Conversation/ConversationDetailItem';
import { ConversationDetailTopSearch } from '../views/Conversation/ConversationDetailTopSearch';
import { deviceInfo } from '@kit.BasicServicesKit';
import { ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import {MessageViewItem} from '../viewmodel/MessageViewModel'
import { ObservedArray } from '../jim/common';
import { JuggleIm } from 'juggleim';
import { Conversation } from 'juggleim/src/main/ets/entries/conversation';
import { MsgReceivedListener, QueryMsgOptions } from 'juggleim/src/main/ets/managers/messagemanager';
import { HomeConstants } from '../constants/HomeConstants';
import { TextMessage } from 'juggleim/src/main/ets/entries/message';

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
  private scroller:Scroller = new Scroller()
  private msgReceiveListener:MsgReceivedListener = async (message)=>{}
  @State private text:string = ''

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
    this.conversationId = param.conversationId
    this.conversationType = param.converType
    console.log("jimsdk_video_converid:",this.conversationId)

    this.msgReceiveListener = async (message)=>{
      let conver = message.conversation
      let currentUserId = JuggleIm.instance.userInfo.userId
      if(conver?.conversationId===param.conversationId){
        let senderName:string = ''
        let senderIcon:string = ''
        await JuggleIm.instance.getUserInfoManager().getUserInfo(message.senderId).then((u)=>{
          senderName = u.nickname
          senderIcon = u.userPortrait
        })
        let selfName:string = ''
        let selfIcon:string = ''
        await JuggleIm.instance.getUserInfoManager().getUserInfo(JuggleIm.instance.userId).then((u)=>{
          selfName = u.nickname
          selfIcon = u.userPortrait
        })
        let viewMsg = new MessageViewItem(senderName,senderIcon,selfName,selfIcon,message.msgContent,message.sentTime)
        if(currentUserId==message.senderId){
          viewMsg.isReceived = false
        }
        this.msgList.push(viewMsg)
        this.scroller.scrollEdge(Edge.Bottom)
      }
    }

    JuggleIm.instance.getMessageManager().addMsgReceivedListener(this.msgReceiveListener)
    this.loadMoreMsgs()
  }

  aboutToDisappear(): void {
    JuggleIm.instance.getMessageManager().removeMsgReceivedListener(this.msgReceiveListener)
  }

  loadMoreMsgs(){
    let options:QueryMsgOptions = new QueryMsgOptions()
    options.count = 10
    options.startTime = this.minMsgTime
    options.isPositive = false
    JuggleIm.instance.getMessageManager().queryMessages(new Conversation(this.conversationId,this.conversationType),options,(code,msgs)=>{
      let currentUserId = JuggleIm.instance.userInfo.userId
      msgs.forEach(async (msg)=>{
        let senderName:string = ''
        let senderIcon:string = ''
        await JuggleIm.instance.getUserInfoManager().getUserInfo(msg.senderId).then((u)=>{
          senderName = u.nickname
          senderIcon = u.userPortrait
        })
        let selfName:string = ''
        let selfIcon:string = ''
        await JuggleIm.instance.getUserInfoManager().getUserInfo(JuggleIm.instance.userId).then((u)=>{
          selfName = u.nickname
          selfIcon = u.userPortrait
        })
        let viewMsg = new MessageViewItem(senderName,senderIcon,selfName,selfIcon,msg.msgContent,msg.sentTime)
        if(currentUserId==msg.senderId){
          viewMsg.isReceived = false
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
          List({scroller:this.scroller}){
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
        // ConversationDetailBottom()
        Row(){
          Column(){
            Column() {
              StandardIcon({ icon: $r('app.media.ic_public_add_norm') })
            }
            .flexBasis(HomeConstants.FLEX_BASIS_AUTO)
            .padding({
              left:10,
              right:10
            })
          }
          Blank()
          Column(){
            TextInput({text:this.text})
              .width('78%')
              .placeholderColor($r('app.color.text_input_default_color'))
              .caretColor($r('app.color.text_input_default_care_color'))
              .backgroundColor($r('app.color.text_input_default_background_color'))
              .borderRadius(HomeConstants.CONVERSATION_DETAIL_BOTTOM_TEXT_RADIUS)
              .flexGrow(BaseConstants.FLEX_GROW_ONE)
              .padding({ right: $r('app.float.conversation_detail_bottom_text_padding') })
              .backgroundColor(Color.White)
              .onChange((v)=>{
                this.text = v
              })
          }
          Column() {
            StandardIcon({ icon: $r('app.media.ic_public_email_send') }).onClick(async ()=>{
              let selfName:string = ''
              let selfIcon:string = ''
              let txtMsg:TextMessage = new TextMessage()
              txtMsg.content = this.text
              await JuggleIm.instance.getUserInfoManager().getUserInfo(JuggleIm.instance.userId).then((u)=>{
                selfName = u.nickname
                selfIcon = u.userPortrait
              })
              let viewMsg = new MessageViewItem('','',selfName,selfIcon,txtMsg,1)
              viewMsg.isReceived = false
              this.msgList.push(viewMsg)
              this.text = ''
              this.scroller.scrollEdge(Edge.Bottom)
              //send msg
              JuggleIm.instance.getMessageManager().sendMessage(txtMsg,new Conversation(this.conversationId,this.conversationType),(code,msg)=>{

              })
            })
          }
          .padding({
            left:10,
            right:10
          })
        }.width(BaseConstants.FULL_WIDTH)
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