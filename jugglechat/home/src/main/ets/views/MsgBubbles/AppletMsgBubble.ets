import { BaseConstants } from "base"
import { HomeConstants } from "../../constants/HomeConstants"

@Component
export struct AppleMsgBubble{

  build(){
    Column() {
      Row() {
        Image($r('app.media.ic_tea'))
          .height($r('app.float.applet_icon_size'))
          .width($r('app.float.applet_icon_size'))
          .margin({ right: $r('app.float.applet_icon_right') })
        Text('title')
          .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
          .fontSize(BaseConstants.FONT_SIZE_TWELVE)
          .fontColor($r('app.color.conversation_default_text_color'))
          .textAlign(TextAlign.Start)
          .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
      }
      .margin({ bottom: $r('app.float.applet_title_bottom') })

      Text('description')
        .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
        .fontSize(BaseConstants.FONT_SIZE_TWELVE)
        .fontColor($r('app.color.conversation_default_text_color'))
        .textAlign(TextAlign.Start)
        .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
        .margin({ bottom: $r('app.float.applet_introduce_bottom') })
        .copyOption(CopyOptions.LocalDevice)
      Flex() {
      }
      .height($r('app.float.applet_image_height'))
      .width($r('app.float.applet_image_width'))
      .backgroundImage($r('app.media.picture_applet_link'))
      .backgroundImageSize({ width: $r('app.float.applet_image_width'), height: $r('app.float.applet_image_height') })
      .constraintSize({ maxWidth: BaseConstants.FULL_WIDTH })
      .margin({ bottom: $r('app.float.applet_image_bottom') })

      Text(HomeConstants.APPLET_DESCRIBE)
        .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
        .fontSize(BaseConstants.FONT_SIZE_TEN)
        .fontColor($r('app.color.background_color_grey_three'))
        .textAlign(TextAlign.Start)
        .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
    }
    .alignItems(HorizontalAlign.Start)
  }
}