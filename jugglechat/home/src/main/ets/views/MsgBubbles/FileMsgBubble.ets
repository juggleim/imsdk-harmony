import { IntroduceText, NormalText } from "base"
import { FileMessage } from "juggleim/src/main/ets/entries/message"
import { HomeConstants } from "../../constants/HomeConstants"

@Component
export struct FileMsgBubble{
  private fileMsg?:FileMessage

  getFileName():string{
    if(this.fileMsg!==undefined){
      return this.fileMsg.name
    }else{
      return "Unknown"
    }
  }

  build(){
    Column() {
      Row() {
        NormalText({ data: this.getFileName() })
          .margin({ right: $r('app.float.applet_icon_right') })
          .width($r('app.float.document_text_width'))
        Image($r('app.media.ic_PDF'))
          .height($r('app.float.document_icon_size'))
          .width($r('app.float.document_icon_size'))
          .margin({ right: $r('app.float.document_icon_right') })
      }
      .margin({ bottom: $r('app.float.document_icon_bottom') })

      IntroduceText({ data: HomeConstants.DOCUMENT_SIZE, fontColor: $r('app.color.background_color_grey_three') })
        .margin({ bottom: $r('app.float.document_text_bottom') })
      Divider()
        .color($r('app.color.divider_background_color'))
        .strokeWidth(HomeConstants.DOCUMENT_DIVIDER_WIDTH).margin({ bottom: $r('app.float.divider_bottom') })
      Row() {
        Image($r('app.media.ic_file'))
          .width($r('app.float.document_small_icon_size'))
          .height($r('app.float.document_small_icon_size'))
          .margin({ right: $r('app.float.document_small_icon_right') })
        IntroduceText({
          data: HomeConstants.DOCUMENT_INTRODUCE,
          fontColor: $r('app.color.background_color_grey_three')
        })
          .margin({ top: $r('app.float.document_introduce_top') })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width($r('app.float.document_width'))
    .margin({ bottom: $r('app.float.document_bottom') })
  }
}