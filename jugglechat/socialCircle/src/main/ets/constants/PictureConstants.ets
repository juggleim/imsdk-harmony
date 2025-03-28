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

import { PictureArrayInterface } from '../viewmodel/CommonViewModel';

export class PictureConstants {
  static readonly ICON_BORDER_RADIUS = 6;
  static readonly USER_NAME = $r('app.string.xiaole');
  static readonly USER_MESSAGE = $r('app.string.see');
  static readonly COLUMNS_TEMPLATE = '1fr 1fr 1fr';
  static readonly TEMPLATE_BUSINESS = '1fr';
  static readonly MAX_COLUMN_NUM = 3;
}

function getSocialCircleList(): PictureArrayInterface[] {
  const pictures: Resource[] = [
    $r('app.media.social_circle1'),
    $r('app.media.social_circle2'),
    $r('app.media.social_circle3'),
    $r('app.media.social_circle4'),
    $r('app.media.social_circle5'),
    $r('app.media.social_circle6'),
    $r('app.media.social_circle7'),
    $r('app.media.social_circle8'),
    $r('app.media.social_circle9')];
  const socialCircleList: PictureArrayInterface[] = new Array(9).fill(1)
    .map((item: number, index: number): PictureArrayInterface => {
      return new PictureArrayInterface(pictures.slice(0, index + 1))
    });
  return socialCircleList;
}

export default getSocialCircleList;