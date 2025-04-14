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

interface ContactsDataInterface {
  user_id:string;
  name: ResourceStr;
  en_name: string;
  icon: ResourceStr;
}

const ContactsListData: ContactsDataInterface[] = [
  {user_id:'', name: $r('app.string.Alan'), en_name: '#Alan', icon: $r('app.media.avatar1') },
  {user_id:'', name: $r('app.string.AQin'), en_name: 'AQin', icon: $r('app.media.avatar1') },
  {user_id:'', name: $r('app.string.CaiLan'), en_name: 'CaiLan', icon: $r('app.media.avatar2') },
  {user_id:'', name: $r('app.string.Deng'), en_name: 'Deng', icon: $r('app.media.avatar3') },
  {user_id:'', name: $r('app.string.excel'), en_name: 'excel', icon: $r('app.media.avatar2') },
  {user_id:'', name: $r('app.string.FanYi'), en_name: 'FanYi', icon: $r('app.media.avatar2') },
  {user_id:'', name: $r('app.string.FenFen'), en_name: 'FenFen', icon: $r('app.media.avatar2') },
  {user_id:'', name: $r('app.string.ge'), en_name: 'ge', icon: $r('app.media.avatar4') },
  {user_id:'', name: $r('app.string.ge'), en_name: 'Idea', icon: $r('app.media.avatar4') },
  {user_id:'', name: $r('app.string.FenFen'), en_name: 'jack', icon: $r('app.media.avatar1') },
  {user_id:'', name: $r('app.string.CaiLan'), en_name: 'kat', icon: $r('app.media.avatar1') },
  {user_id:'', name: $r('app.string.LiX'), en_name: 'lily', icon: $r('app.media.avatar11') },
  {user_id:'', name: $r('app.string.LiX'), en_name: 'LiX', icon: $r('app.media.avatar8') },
  {user_id:'', name: $r('app.string.Ma'), en_name: 'Ma', icon: $r('app.media.avatar11') },
  {user_id:'', name: $r('app.string.Ma'), en_name: 'nie', icon: $r('app.media.avatar5') },
  {user_id:'', name: $r('app.string.FanYi'), en_name: 'tom', icon: $r('app.media.avatar10') },
  {user_id:'', name: $r('app.string.Deng'), en_name: 'Zhang', icon: $r('app.media.avatar6') },
  {user_id:'', name: $r('app.string.CaiLan'), en_name: 'Wang', icon: $r('app.media.avatar7') },
  {user_id:'', name: $r('app.string.CaiLan'), en_name: 'Zo', icon: $r('app.media.avatar9') },
];

const Alphabets: string[] = ['#', '☆', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
  'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

export { ContactsDataInterface, ContactsListData, Alphabets };