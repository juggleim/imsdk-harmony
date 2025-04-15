import { StandardIcon } from 'base';
import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants';
import { SettingTop } from './SettingTop';

@Component
export default struct FriendVerify{
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack
  @State isOpen:boolean = true

  build() {
    NavDestination(){
      Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
        Row(){
          SettingTop({ settingTitle: '是否开启好友验证' })
        }.width(BaseConstants.FULL_WIDTH)
        .height(60)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .padding({top:20})

        Row(){
          Column(){
            Text('开启').fontSize(18)
          }
          .width(80)
          .alignItems(HorizontalAlign.Center)

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.isOpen?Visibility.Visible:Visibility.None)
          }.width('75%')
          .alignItems(HorizontalAlign.End)
        }.height(60)
        .width('90%')
        .backgroundColor('#F1F3F5')
        .margin({
          top:60
        })
        .borderRadius({
          topLeft: 6,
          topRight: 6
        }).onClick(()=>{
          this.isOpen = true
        })

        Divider().width('90%')

        Row(){
          Column(){
            Text('关闭').fontSize(18)
          }
          .width(80)
          .alignItems(HorizontalAlign.Center)

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.isOpen?Visibility.None:Visibility.Visible)
          }.width('75%')
          .alignItems(HorizontalAlign.End)
        }.height(60)
        .width('90%')
        .backgroundColor('#F1F3F5')
        .borderRadius({
          bottomLeft: 6,
          bottomRight: 6
        }).onClick(()=>{
          this.isOpen = false
        })
      }
      .backgroundColor(Color.White)
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }
    .hideTitleBar(true)
  }
}