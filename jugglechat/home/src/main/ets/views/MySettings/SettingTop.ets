import { BaseConstants, StandardIcon } from "base";
import { deviceInfo } from "@kit.BasicServicesKit";

@Component
export struct SettingTop{
  @Prop settingTitle:string;
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack
  @Consume('activeNavSource') activeNavSource: string

  private back():void{
    if (this.activeNavSource == 'settings') {
      this.mySettingPageInfo.clear()
      return
    }
    if (this.pageInfo.size() > 1) {
      this.pageInfo.pop()
      return
    }
    this.pageInfo.clear()
  }

  build() {
    Flex({alignItems:ItemAlign.Center, justifyContent:FlexAlign.SpaceBetween}){
      Row(){
        Stack(){
          StandardIcon({icon:$r('app.media.ic_public_back')})
        }
        .width(30)
        .height(30)
        .onClick(()=>{
          this.back()
        })
        Column(){
          Text(this.settingTitle)
            .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
            .fontSize(BaseConstants.FONT_SIZE_EIGHTEEN)
            .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
            .fontColor($r('app.color.conversation_default_text_color'))
        }.width('80%')
      }.width(BaseConstants.FULL_WIDTH)
    }
    .width(BaseConstants.FULL_WIDTH)
    .height(BaseConstants.FULL_HEIGHT)
    .padding({
      left:24,
      right:24,
      top: deviceInfo.deviceType===BaseConstants.DEVICE_2IN1?0:36
    })
  }
}
