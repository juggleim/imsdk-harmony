import { BaseConstants } from "base";
import { TextMessage } from "juggleim/src/main/ets/entries/message";

@Component
export struct TextMsgBubble{
  private txtMsg?:TextMessage

  private getContent():string{
    if(this.txtMsg!==undefined){
      return this.txtMsg.content
    }else{
      return "Unknown"
    }
  }

  build() {
    Text(this.getContent())
      .fontSize(BaseConstants.FONT_SIZE_TWELVE)
      .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
      .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
      .lineHeight($r('app.float.conversation_default_text_line'))
      .fontColor($r('app.color.conversation_default_text_color'))
      .copyOption(CopyOptions.LocalDevice)
  }
}