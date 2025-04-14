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
import { Alphabets, ContactsListData, ContactsDataInterface } from '../viewmodel/ConstactsViewModel';
import { ConversationViewItem,ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import { ContactsItem } from '../views/Contacts/ContactsItem';
import { HomeConstants } from '../constants/HomeConstants';
import { HomeTopSearch } from '../views/common/HomeTopSearch';
import { ObservedArray } from '../jim/common';
import { JimServer } from '../jim/jimserver/jimserver';

@Component
export struct ContactsList {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Link currentContactUserId:string
  @Link currentContactUserName: ResourceStr;
  @Link currentContactUserIcon: ResourceStr;
  @Link currentConversationUserName: string;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State selectedIndex: number = HomeConstants.CONTACTS_DEFAULT_SELECTED_INDEX;
  @State private currentIndex: number = 0;
  private listScroller: Scroller = new Scroller();
  @State contactList:ObservedArray<ContactsDataInterface> = []

  aboutToAppear(): void {
    JimServer.instance.getFriendManager().QueryFriends(1,50,'',(users)=>{
      console.log("jchat_contact_code:",users.items.length)
      this.contactList.push(ContactsListData[0])
      users.items.forEach((val)=>{
        console.log("jchat_contact_list:",JSON.stringify(val))
        this.contactList.push({
          user_id:val.user_id,
          name:val.nickname,
          en_name:val.pinyin as string,
          icon:val.avatar
        })
      })
    })
  }

  /**
   * Find checked contact
   */
  findContactsItemIndex(index: number): number {
    if (index < 0) return 0;
    const currentIndex = ContactsListData.findIndex(item => item.en_name[0].toUpperCase() === Alphabets[index]);
    if (currentIndex === -1) {
      return this.findContactsItemIndex(index - 1);
    } else {
      return currentIndex;
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      HomeTopSearch({ title: HomeConstants.CONTACTS_NAME })
        .height('13%')
      Stack({ alignContent: Alignment.End }) {
        List({ scroller: this.listScroller }) {
          ListItem() {
            ContactsItem({ name: HomeConstants.CONTACTS_LIST[0], icon: $r('app.media.ic_public_groups') })
          }
          .height(Adaptive.ContactItemHeight(this.currentBreakpoint))
          .backgroundColor(Color.White)

          ListItem() {
            ContactsItem({ name: HomeConstants.CONTACTS_LIST[1], icon: $r('app.media.ic_public_names') })
          }
          .height(Adaptive.ContactItemHeight(this.currentBreakpoint))
          .backgroundColor(Color.White)

          ForEach(this.contactList, (item: ContactsDataInterface, index: number) => {
            ListItem() {
              ContactsItem({ name: item.name, icon: item.icon })
                .onClick(() => {
                  if (this.pageInfo.size() > 1) {
                    this.pageInfo.pop();
                  }

                  // this.pageInfo.pushPath({ name: 'ContactsDetail' });
                  // this.currentContactUserId = item.user_id
                  // this.currentContactUserName = item.name;
                  // this.currentContactUserIcon = item.icon;

                  this.pageInfo.pushPath({ name: 'ConversationDetail',param:new ConversationDetailParams(item.user_id,item.user_id,1)});

                  // this.currentConversationUserName = '';
                  this.currentIndex = index;
                })
                .height(BaseConstants.FULL_HEIGHT)
                .padding($r('app.float.contacts_item_padding'))
                .backgroundColor(this.currentIndex === index ? $r('app.color.conversation_clicked_bg_color') : Color.White)
            }
            .height(Adaptive.ContactItemHeight(this.currentBreakpoint))
          }, (item: ContactsDataInterface, index: number) => index + JSON.stringify(item))
        }
        .width(BaseConstants.FULL_WIDTH)
        .height(BaseConstants.FULL_HEIGHT)
        .onScrollIndex((firstIndex: number) => {
          this.selectedIndex = firstIndex;
        })

        AlphabetIndexer({ arrayValue: Alphabets, selected: 0 })
          .onSelect((index: number) => {
            const currentIndex = this.findContactsItemIndex(index);
            this.listScroller.scrollToIndex(currentIndex + 2);
          })
          .margin({ right: $r('app.float.alphabet_indexer_right') })
          .color(Color.Black)
          .font({
            size: BaseConstants.FONT_SIZE_TWELVE,
            weight: BaseConstants.FONT_WEIGHT_FIVE,
            family: BaseConstants.FONT_FAMILY_MEDIUM
          })
      }
    }
    .height(BaseConstants.FULL_HEIGHT)
    .width(BaseConstants.FULL_WIDTH)
  }
}
