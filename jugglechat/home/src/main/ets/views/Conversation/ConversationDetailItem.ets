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

import { MessageContent } from 'juggleim';
import { MessageBubble } from '../MessageBubble';

@Component
export struct ConversationDetailItem {
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
  private showDownloadAction?:boolean
  private onDownloadTap?:()=>void
  private onCancelDownloadTap?:()=>void

  private isReceived?: boolean = false;
  private msgTime:number=0

  build() {
    Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.End }) {
      MessageBubble({
        senderName:this.senderName,
        senderIcon:this.senderIcon,
        selfName:this.selfName,
        selfIcon:this.selfIcon,
        msgContent:this.msgContent,
        referenceText:this.referenceText,
        previewText:this.previewText,
        msgType:this.msgType,
        isEdited:this.isEdited,
        hasRead:this.hasRead,
        readCount:this.readCount,
        memberCount:this.memberCount,
        sentState:this.sentState,
        conversationType:this.conversationType,
        downloadState:this.downloadState,
        downloadProgress:this.downloadProgress,
        showDownloadAction:this.showDownloadAction,
        onDownloadTap:this.onDownloadTap,
        onCancelDownloadTap:this.onCancelDownloadTap,
        isReceived: this.isReceived,
        msgTime:this.msgTime
      })
    }
  }
}
