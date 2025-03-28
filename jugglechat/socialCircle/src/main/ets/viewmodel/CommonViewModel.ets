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


interface SocialCircleItemInterface {
  icon: Resource;
  name: string;
  msg: string;
  pictureList: PictureInterface[];
};

/**
 * Picture array interface
 */
class PictureArrayInterface {
  pictures: PictureInterface[] = [];

  constructor(pictureSource: Resource[]) {
    pictureSource.forEach(item => {
      this.pictures.push(new PictureInterface(item));
    })
  }
}

/**
 * Picture interface
 */
class PictureInterface {
  src: Resource;

  constructor(src: Resource) {
    this.src = src;
  }
}

export { SocialCircleItemInterface, PictureArrayInterface, PictureInterface };