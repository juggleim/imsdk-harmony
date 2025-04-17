import { StandardIcon } from 'base';
import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants';
import { SettingTop } from './SettingTop';

@Component
export default struct LanguageSetting{
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack
  @State curLanguage:string = 'zh-cn'

  build() {
    NavDestination(){
      Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
        Row(){
          SettingTop({ settingTitle: '语言设置' })
        }.width(BaseConstants.FULL_WIDTH)
        .height(60)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .padding({top:20})

        Row(){
          Column(){
            Text('简体中文').fontSize(18)
          }
          .width(80)
          .alignItems(HorizontalAlign.Center)

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.curLanguage=='zh-cn'?Visibility.Visible:Visibility.None)
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
          this.curLanguage = 'zh-cn'
        })

        Divider().width('90%')

        Row(){
          Column(){
            Text('English').fontSize(18)
          }
          .width(80)
          .alignItems(HorizontalAlign.Center)

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.curLanguage=='en-us'?Visibility.Visible:Visibility.None)
          }.width('75%')
          .alignItems(HorizontalAlign.End)
        }.height(60)
        .width('90%')
        .backgroundColor('#F1F3F5')
        .borderRadius({
          bottomLeft: 6,
          bottomRight: 6
        }).onClick(()=>{
          this.curLanguage = 'en-us'
        })
      }
      .backgroundColor(Color.White)
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }
    .hideTitleBar(true)
  }
}