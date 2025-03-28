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

import { HomeConstants } from '../../constants/HomeConstants';
import { MessageBubble } from '../MessageBubble';

@Component
export default struct ConversationDetailItem {
  @Link currentFeatureIndex: number;
  @Link receivedName: string;
  private isReceived: boolean = !HomeConstants.IS_RECEIVED;
  private content: ResourceStr = '';
  private isAppletMsg?: boolean;
  private isDocumentMsg?: boolean;

  build() {
    Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.End }) {
      MessageBubble({
        receivedName: $receivedName,
        currentFeatureIndex: $currentFeatureIndex,
        isReceived: this.isReceived,
        content: this.content,
        isAppletMsg: this.isAppletMsg,
        isDocumentMsg: this.isDocumentMsg
      })
    }
  }
}