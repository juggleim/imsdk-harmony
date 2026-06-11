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
  MediaMessageContent,
  MediaMessageUploadState,
  MessageSentState,
  VideoMessage,
  VoiceMessage} from '@juggleim/imlib';
import { HomeConstants } from '../constants/HomeConstants';
import { TextMsgBubble } from './MsgBubbles/TextMsgBubble';
import { ImageMsgBubble } from './MsgBubbles/ImageMsgBubble';
import { FileMsgBubble } from './MsgBubbles/FileMsgBubble';
import { VideoMsgBubble } from './MsgBubbles/VideoMsgBubble';
import { VoiceMsgBubble } from './MsgBubbles/VoiceMsgBubble';
import { CommonUtil } from '../jim/common';
import { buildMessagePreview, MediaDownloadState } from '../viewmodel/MessageViewModel';

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
  private isEdited?:boolean
  private hasRead?:boolean
  private readCount?:number
  private memberCount?:number
  private sentState?:number
  private conversationType?:number
  private downloadState?:number
  private downloadProgress?:number
  @Prop reactionSummaries?:string[]
  @Prop showDownloadAction?:boolean
  private onDownloadTap?:()=>void
  private onCancelDownloadTap?:()=>void
  private msgTime?:number

  private getMsgType():string{
    if(this.msgContent!==undefined){
      return this.msgContent.getMsgType()
    }
    return "unknown"
  }

  private getStatusText():string{
    if(this.isReceived){
      return ''
    }
    let mediaStatus = this.getMediaStatusText()
    if(mediaStatus != ''){
      return mediaStatus
    }
    if(this.sentState == MessageSentState.failed){
      return '发送失败'
    }
    if(this.sentState == MessageSentState.uploading){
      return '上传中'
    }
    if(this.sentState == MessageSentState.sending){
      return '发送中'
    }
    if(this.sentState != MessageSentState.success){
      return ''
    }
    if(this.conversationType == 1){
      return this.hasRead == true ? '已读' : '已发送'
    }
    if(this.conversationType == 2){
      let memberCount = this.memberCount ?? 0
      let readCount = this.readCount ?? 0
      if(readCount < 0){
        readCount = 0
      }
      if(memberCount < 0){
        memberCount = 0
      }
      if(readCount > memberCount){
        readCount = memberCount
      }
      return `${readCount}/${memberCount}`
    }
    return '已发送'
  }

  private getMediaStatusText():string{
    if(this.msgContent == undefined || !(this.msgContent instanceof MediaMessageContent)){
      return ''
    }
    let mediaMsg = this.msgContent as MediaMessageContent
    if(mediaMsg.uploadState == MediaMessageUploadState.uploading){
      if(mediaMsg.uploadProgress > 0 && mediaMsg.uploadProgress < 100){
        return `上传中 ${mediaMsg.uploadProgress}%`
      }
      return '上传中'
    }
    if(mediaMsg.uploadState == MediaMessageUploadState.failed){
      return '上传失败'
    }
    if(mediaMsg.uploadState == MediaMessageUploadState.canceled){
      return '已取消'
    }
    return ''
  }

  private isDownloadingMedia():boolean{
    return this.downloadState == MediaDownloadState.downloading
  }

  private getDownloadStatusText():string{
    if(this.downloadState == MediaDownloadState.downloading){
      let progress = this.downloadProgress ?? 0
      if(progress > 0 && progress < 100){
        return `下载中 ${progress}%`
      }
      return '下载中'
    }
    if(this.downloadState == MediaDownloadState.failed){
      return '下载失败'
    }
    if(this.downloadState == MediaDownloadState.canceled){
      return '已取消下载'
    }
    return ''
  }

  private getReactionSummaries():string[]{
    return this.reactionSummaries != undefined ? this.reactionSummaries : []
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
        voiceMsg:this.msgContent as VoiceMessage,
        isReceived:this.isReceived
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

    if(this.isEdited == true || this.getStatusText() != ''){
      Row() {
        if(this.isEdited == true){
          Text('已编辑')
            .fontSize(10)
            .fontColor('#999999')
        }
        if(this.isEdited == true && this.getStatusText() != ''){
          Text('·')
            .fontSize(10)
            .fontColor('#CCCCCC')
            .margin({ left: 4, right: 4 })
        }
        if(this.getStatusText() != ''){
          Text(this.getStatusText())
            .fontSize(10)
            .fontColor('#999999')
        }
      }
      .margin({ top: 6 })
    }

    if(this.getReactionSummaries().length > 0){
      Row({ space: 6 }) {
        ForEach(this.getReactionSummaries(), (summary:string)=>{
          Text(summary)
            .fontSize(11)
            .fontColor('#4B5563')
            .backgroundColor('#F3F4F6')
            .borderRadius(12)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        }, (summary:string)=>summary)
      }
      .width('100%')
      .margin({ top: 6 })
    }

    if(this.showDownloadAction == true){
      Row() {
        if(this.getDownloadStatusText() != ''){
          Text(this.getDownloadStatusText())
            .fontSize(10)
            .fontColor('#999999')
        }
        Blank()
        Button(this.isDownloadingMedia() ? '取消' : '下载')
          .type(ButtonType.Capsule)
          .height(26)
          .fontSize(12)
          .backgroundColor('#F3F4F6')
          .fontColor('#333333')
          .onClick(()=>{
            if(this.isDownloadingMedia()){
              if(this.onCancelDownloadTap != undefined){
                this.onCancelDownloadTap()
              }
            }else if(this.onDownloadTap != undefined){
              this.onDownloadTap()
            }
          })
      }
      .width('100%')
      .margin({ top: 6 })
    }
  }
}
