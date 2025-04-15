import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants';
import { deviceInfo } from '@kit.BasicServicesKit';

@Component
export default struct FriendVerify{
  build() {
    NavDestination(){
      Flex({justifyContent:FlexAlign.Center, alignItems:ItemAlign.Center}){
        Image($r('app.media.ic_none_message'))
          .width($r('app.float.conversation_none_icon_width'))
          .height($r('app.float.conversation_none_icon_height'))
      }
      .backgroundColor($r('app.color.conversation_none_icon_bg_color'))
      .height(BaseConstants.FULL_HEIGHT)
    }.padding({
      top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? $r('app.float.zero') : $r('app.float.device_padding_top')
    })
  }
}