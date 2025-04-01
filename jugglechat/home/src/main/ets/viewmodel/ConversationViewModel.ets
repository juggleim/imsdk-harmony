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

@Observed
class ConversationViewItem {
  userId:string
  converId:string
  channelType:number
  lastMsgTime:number
  name: ResourceStr
  msg: ResourceStr
  time: ResourceStr
  icon: ResourceStr
  constructor(userId:string,converId:string,channelType:number,lastMsgTime:number,name:ResourceStr,msg:ResourceStr,time:ResourceStr,icon:ResourceStr) {
    this.userId = userId
    this.converId = converId
    this.channelType = channelType
    this.lastMsgTime = lastMsgTime
    this.name = name
    this.msg = msg
    this.time = time
    this.icon = icon
  }
};

//const ConversationListData: ConversationDataInterface[] = [
  // { name: $r('app.string.Alan'), msg: $r('app.string.okay'), time: '13:55', icon: $r('app.media.avatar1') },
  // { name: $r('app.string.CaiLan'), msg: $r('app.string.okay'), time: '13:55', icon: $r('app.media.avatar2') },
  // { name: $r('app.string.FenFen'), msg: $r('app.string.okay'), time: '12:00', icon: $r('app.media.avatar11') },
  // { name: $r('app.string.FenFen'), msg: $r('app.string.okay'), time: '08:00', icon: $r('app.media.avatar4') },
  // { name: $r('app.string.FanYi'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar5') },
  // { name: $r('app.string.Deng'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar6') },
  // { name: $r('app.string.CaiLan'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar7') },
  // { name: $r('app.string.Alan'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar8') },
  // { name: $r('app.string.Alan'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar9') },
  // { name: $r('app.string.FanYi'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar10') },
  // { name: $r('app.string.Deng'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar11') },
  // { name: $r('app.string.ge'), msg: $r('app.string.okay'), time: $r('app.string.yesterday'), icon: $r('app.media.avatar1') },
// ];

class ConversationDetailParams{
  channelType:number
  conversationId:string
  userId:string
  constructor(userId:string,converId:string,channelType:number) {
    this.userId = userId
    this.conversationId = converId
    this.channelType = channelType
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

export { ConversationViewItem, ConversationViewModel, ConversationDetailParams };