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

import { BaseConstants, BreakpointConstants } from 'base'
import { FileMessage, ImageMessage, JimMsgType, MergeMessage, MessageContent, RecallInfoMessage, TextMessage,
  VideoMessage,
  VoiceMessage} from 'juggleim';
import { HomeConstants } from '../constants/HomeConstants';
import { TextMsgBubble } from './MsgBubbles/TextMsgBubble';
import { ImageMsgBubble } from './MsgBubbles/ImageMsgBubble';
import { FileMsgBubble } from './MsgBubbles/FileMsgBubble';
import { VideoMsgBubble } from './MsgBubbles/VideoMsgBubble';
import { VoiceMsgBubble } from './MsgBubbles/VoiceMsgBubble';
import { CommonUtil } from '../jim/common';
import { buildMessagePreview } from '../viewmodel/MessageViewModel';

@Component
export struct MessageBubble {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  // @Link currentFeatureIndex: number;
  private isReceived: boolean = !HomeConstants.IS_RECEIVED;
  private senderName?:string
  private senderIcon?:string
  private selfName?:string
  private selfIcon?:string
  private msgContent?:MessageContent
  private referenceText?:string
  private previewText?:string
  private msgType?:string
  private msgTime?:number

  private getMsgType():string{
    if(this.msgContent!==undefined){
      return this.msgContent.getMsgType()
    }
    return "unknown"
  }

  build() {
    Column() {
      Flex({ justifyContent: this.isReceived ? FlexAlign.Start : FlexAlign.End, direction: FlexDirection.Row }) {
        if (this.isReceived) {
          if(this.senderIcon!='') {
            Image(this.senderIcon)
              .width($r('app.float.avatar_image_size'))
              .height($r('app.float.avatar_image_size'))
              .flexShrink(BaseConstants.FLEX_SHRINK_ZERO)
              .borderRadius(20)
          }else{
            Stack() {
              Text(CommonUtil.getFirstChar(this.senderName as string)).fontColor(Color.White)
            }.backgroundColor(CommonUtil.getBackgroundColor(this.senderName as string))
            .width(40)
            .height(40)
            .borderRadius(30)
          }
        }
        Column() {
          Stack({ alignContent: this.isReceived ? Alignment.TopStart : Alignment.TopEnd }) {
            Path()
              .commands('M-10 1 L0 18 L32 1 Z')
              .fillOpacity(HomeConstants.CONVERSATION_DETAIL_FILL_OPACITY)
              .stroke(Color.White)
              .strokeWidth(HomeConstants.CONVERSATION_DETAIL_STROKE_WIDTH)
              .fill(Color.White)
              .visibility(this.isReceived ? Visibility.Visible : Visibility.None)
            Path()
              .commands('M0 1 L32 1 L42 18 Z')
              .fillOpacity(HomeConstants.CONVERSATION_DETAIL_FILL_OPACITY)
              .stroke(Color.White)
              .strokeWidth(HomeConstants.CONVERSATION_DETAIL_STROKE_WIDTH)
              .fill(Color.White)
              .visibility(this.isReceived ? Visibility.None : Visibility.Visible)
              .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
              .margin({ right: -10 })
            Column() {
              this.MessageContent()
            }
            .padding({
              left: $r('app.float.path_column_left'),
              right: $r('app.float.path_column_right'),
              top: $r('app.float.path_column_top'),
              bottom: $r('app.float.path_column_bottom')
            })
            .backgroundColor(Color.White)
            .borderRadius(HomeConstants.PATH_BORDER_RADIUS)
          }
          .padding({
            top: $r('app.float.path_top'),
            left: $r('app.float.path_left'),
            right: $r('app.float.path_right'),
            bottom: $r('app.float.path_bottom')
          })
          .width(BaseConstants.FULL_WIDTH)
        }
        .width(BaseConstants.FULL_WIDTH)

        if (!this.isReceived) {
          if(this.selfIcon!=undefined&&this.selfIcon!='') {
            Image(this.selfIcon)
              .width($r('app.float.avatar_image_size'))
              .height($r('app.float.avatar_image_size'))
              .flexShrink(BaseConstants.FLEX_SHRINK_ZERO)
              .borderRadius(20)
          }else{
            Stack() {
              Text(CommonUtil.getFirstChar(this.selfName as string)).fontColor(Color.White)
            }.backgroundColor(CommonUtil.getBackgroundColor(this.selfName as string))
            .width(40)
            .height(40)
            .borderRadius(30)
          }
        }
      }
    }
    .margin({ left: $r('app.float.message_bubble_left'), right: $r('app.float.message_bubble_right') })
  }

  private downTime:number = 0
  @Builder
  MessageContent() {
    if(this.referenceText != undefined && this.referenceText != ''){
      Column() {
        Text('引用')
          .fontSize(10)
          .fontColor('#999999')
        Text(this.referenceText)
          .fontSize(BaseConstants.FONT_SIZE_TWELVE)
          .fontColor('#666666')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .padding(8)
      .margin({ bottom: 8 })
      .backgroundColor('#F3F4F6')
      .borderRadius(8)
    }

    if(this.getMsgType() == JimMsgType.Text){
      TextMsgBubble({
        txtMsg:this.msgContent as TextMessage
      })
    } else if (this.getMsgType() == JimMsgType.Image){
      ImageMsgBubble({
        imgMsg:this.msgContent as ImageMessage
      })
    } else if (this.getMsgType() == JimMsgType.File){
      FileMsgBubble({
        fileMsg:this.msgContent as FileMessage
      })
    } else if(this.getMsgType() == JimMsgType.Video){
      VideoMsgBubble({
        videoMsg:this.msgContent as VideoMessage
      })
    } else if(this.getMsgType() == JimMsgType.Voice){
      VoiceMsgBubble({
        voiceMsg:this.msgContent as VoiceMessage
      })
    } else if(this.getMsgType() == JimMsgType.Merge){
      Text(buildMessagePreview(this.msgContent as MergeMessage))
        .fontSize(BaseConstants.FONT_SIZE_TWELVE)
        .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
        .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
        .lineHeight($r('app.float.conversation_default_text_line'))
        .fontColor($r('app.color.conversation_default_text_color'))
    } else if(this.getMsgType() == JimMsgType.RecallInfo){
      Text(buildMessagePreview(this.msgContent as RecallInfoMessage))
        .fontSize(BaseConstants.FONT_SIZE_TWELVE)
        .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
        .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
        .lineHeight($r('app.float.conversation_default_text_line'))
        .fontColor('#999999')
    } else {
      Text(buildMessagePreview(this.msgContent))
        .fontSize(BaseConstants.FONT_SIZE_TWELVE)
        .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
        .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
        .lineHeight($r('app.float.conversation_default_text_line'))
        .fontColor($r('app.color.conversation_default_text_color'))
        .copyOption(CopyOptions.LocalDevice)
    }
  }
}
