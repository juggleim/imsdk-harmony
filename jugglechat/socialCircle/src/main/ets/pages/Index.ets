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

import { BreakpointConstants, BaseConstants } from 'base';
import getSocialCircleList, { PictureConstants } from '../constants/PictureConstants';
import { PictureArrayInterface, PictureInterface } from '../viewmodel/CommonViewModel';
import { deviceInfo } from '@kit.BasicServicesKit';

@Entry
@Component
export struct SocialCircle {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  private socialCircleList: PictureArrayInterface[] = getSocialCircleList();

  getRowsTemplate(length: number): string {
    let rowNumber: number = length % PictureConstants.MAX_COLUMN_NUM === 0 ? length / PictureConstants.MAX_COLUMN_NUM :
      (Math.floor(length / PictureConstants.MAX_COLUMN_NUM) + 1)
    return new Array(rowNumber).fill(PictureConstants.TEMPLATE_BUSINESS).join(' ');
  }

  /**
   * get picture aspect ratio
   */
  getAspectRatio(length: number): number {
    let rowNumber: number = length % PictureConstants.MAX_COLUMN_NUM === 0 ? length / PictureConstants.MAX_COLUMN_NUM :
      (Math.floor(length / PictureConstants.MAX_COLUMN_NUM) + 1)

    return PictureConstants.MAX_COLUMN_NUM / rowNumber
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      List() {
        ForEach(this.socialCircleList, (item: PictureArrayInterface) => {
          ListItem() {
            this.CircleItem(item)
          }
        }, (item: PictureArrayInterface, index: number) => index + JSON.stringify(item))
      }
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }
    .backgroundColor(Color.White)
    .height(BaseConstants.FULL_HEIGHT)
    .width(BaseConstants.FULL_WIDTH)
    .padding({
      top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? $r('app.float.zero') : $r('app.float.device_padding_top')
    })
  }

  @Builder
  CircleItem(pictureArray: PictureArrayInterface) {
    Flex() {
      Image($r('app.media.icon_avatar'))
        .height($r('app.float.icon_height'))
        .width($r('app.float.icon_width'))
        .margin({ right: $r('app.float.icon_right') })
        .borderRadius(PictureConstants.ICON_BORDER_RADIUS)
        .objectFit(ImageFit.Auto)
      Column() {
        Text(PictureConstants.USER_NAME)
          .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
          .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
          .fontColor(Color.Black)
          .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
          .margin({ bottom: $r('app.float.user_name_bottom') })
        Text(PictureConstants.USER_MESSAGE)
          .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
          .fontSize(BaseConstants.FONT_SIZE_TWELVE)
          .fontColor(Color.Black)
          .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
          .margin({ bottom: $r('app.float.user_message_bottom') })

        Grid() {
          ForEach(pictureArray.pictures, (picture: PictureInterface) => {
            GridItem() {
              Image(picture.src)
                .height(BaseConstants.FULL_HEIGHT)
                .width(BaseConstants.FULL_WIDTH)
                .autoResize(true)

            }
          }, (picture: PictureInterface, index: number) => index + JSON.stringify(picture))
        }
        .rowsTemplate(this.getRowsTemplate(pictureArray.pictures.length))
        .columnsTemplate(PictureConstants.COLUMNS_TEMPLATE)
        .columnsGap($r('app.float.picture_gap'))
        .rowsGap($r('app.float.picture_gap'))
        .aspectRatio(this.getAspectRatio(pictureArray.pictures.length))
        .width(BaseConstants.FULL_WIDTH)
      }
      .alignItems(HorizontalAlign.Start)
      .flexShrink(BaseConstants.FLEX_SHRINK_ONE)
      .width(BaseConstants.FULL_WIDTH)
    }
    .padding({
      left: $r('app.float.header_left'),
      right: $r('app.float.header_right'),
      top: $r('app.float.header_top'),
      bottom: $r('app.float.header_bottom')
    })
    .width(BaseConstants.FULL_WIDTH)
  }
}