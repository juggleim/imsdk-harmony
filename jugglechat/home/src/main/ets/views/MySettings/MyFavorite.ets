import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants';
import { SettingTop } from './SettingTop';

@Component
export default struct MyFavorite{
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  build() {
    NavDestination(){
      Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Start}){
        Row(){
          SettingTop({ settingTitle: '我的收藏' })
        }.width(BaseConstants.FULL_WIDTH)
        .height(60)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .padding({top:20})


      }
      .backgroundColor(Color.White)
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }
    .hideTitleBar(true)
  }
}