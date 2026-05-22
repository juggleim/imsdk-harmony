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

import { Want, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Logger } from 'base';
import { JuggleIm } from 'juggleim';
import { ConversationInfo } from 'juggleim';
import { CommonUtil } from '../jim/common';
import { buildMessagePreview } from './MessageViewModel';

@Observed
class ConversationViewItem {
  userId:string
  converId:string
  converType:number
  lastMsgTime:number
  converTime:number
  isTop:boolean
  topTime:number
  isDraft:boolean
  tags:string[]
  name: ResourceStr
  msg: ResourceStr
  time: ResourceStr
  icon: ResourceStr
  constructor(
    userId:string,
    converId:string,
    converType:number,
    lastMsgTime:number,
    converTime:number,
    isTop:boolean,
    topTime:number,
    isDraft:boolean,
    tags:string[],
    name:ResourceStr,
    msg:ResourceStr,
    time:ResourceStr,
    icon:ResourceStr
  ) {
    this.userId = userId
    this.converId = converId
    this.converType = converType
    this.lastMsgTime = lastMsgTime
    this.converTime = converTime
    this.isTop = isTop
    this.topTime = topTime
    this.isDraft = isDraft
    this.tags = tags
    this.name = name
    this.msg = msg
    this.time = time
    this.icon = icon
  }
};

export function toConverViewItem(conver:ConversationInfo):ConversationViewItem{
  //portrait
  let iconUrl: ResourceStr = ''//$r('app.media.avatar2')
  // if (conver.conversation.conversationType == 2) {
  //   iconUrl = $r('app.media.img')
  // }
  //title
  let title = ""
  if(conver.conversation.conversationType==1){
    let userInfo = JuggleIm.instance.getUserInfoManager().getLocalUserInfo(conver.conversation.conversationId)
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
        iconUrl = grpInfo.groupPortrait
      }
    }
  }
  if(title == ''){
    title = conver.conversation.conversationId
  }
  //latest msg content
  let msgStr = ""
  let isDraft = conver.draft.trim() != ''
  let tags = conver.tags.map((tag)=>tag.tagId)
  if(isDraft){
    msgStr = `[草稿] ${conver.draft}`
  } else if(conver.lastMessage!=undefined&&conver.lastMessage!=null) {
    msgStr = buildMessagePreview(conver.lastMessage.msgContent)
  }
  //time str
  let timeStr = CommonUtil.getTimeToYYYYDDMMHHMMSS(conver.converTime)

  return new ConversationViewItem("", conver.conversation.conversationId,
    conver.conversation.conversationType, conver.lastMessage.sentTime, conver.converTime,
    conver.isTop, conver.topTime, isDraft, tags, title,
    msgStr, timeStr, iconUrl)
}

class ConversationDetailParams{
  converType:number
  conversationId:string
  userId:string
  title:string
  constructor(userId:string,converId:string,converType:number, title:string = '') {
    this.userId = userId
    this.conversationId = converId
    this.converType = converType
    this.title = title
  }
}

class ConversationRouteParams {
  converType:number
  conversationId:string
  title:string

  constructor(conversationId:string, converType:number, title:string) {
    this.conversationId = conversationId
    this.converType = converType
    this.title = title
  }
}

class GlobalMessageSearchParams {
  keywords:string

  constructor(keywords:string = '') {
    this.keywords = keywords
  }
}

class MentionMessagesParams {
  conversationId:string
  converType:number
  title:string

  constructor(conversationId:string, converType:number, title:string) {
    this.conversationId = conversationId
    this.converType = converType
    this.title = title
  }
}

class ConversationViewModel {
  public startAppletAbility(context: common.UIAbilityContext, index: number): void {
    const want: Want = {
      bundleName: getContext(context).applicationInfo.name,
      abilityName: 'AppletAbility',
      parameters: {
        position: index
      }
    };
    try {
      context.startAbility(want, (err: BusinessError) => {
        if (err.code) {
          Logger.error(`startAbility failed, code is ${err.code}, message is ${err.message}`);
        }
      });
    } catch (error) {
      hilog.error(0x00004, 'ConversationViewModel', '%{public}s', error);
    }
  }

  public startDocumentAbility(context: common.UIAbilityContext, index: number): void {
    const want: Want = {
      bundleName: getContext(context).applicationInfo.name,
      abilityName: 'DocumentAbility',
      parameters: {
        position: index
      }
    };
    try {
      context.startAbility(want, (err: BusinessError) => {
        if (err.code) {
          Logger.error(`startAbility failed, code is ${err.code}, message is ${err.message}`);
        }
      });
    } catch (error) {
      Logger.error(`startAbility failed,  message is ${error}`);
    }
  }
}

export {
  ConversationViewItem,
  ConversationViewModel,
  ConversationDetailParams,
  ConversationRouteParams,
  GlobalMessageSearchParams,
  MentionMessagesParams
};
