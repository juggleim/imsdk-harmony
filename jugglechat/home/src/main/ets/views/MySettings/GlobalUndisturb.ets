import { StandardIcon } from 'base';
import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants';
import { SettingTop } from './SettingTop';

@Component
export default struct GlobalUndisturb{
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  @State undisturbType:number = 0

  build() {
    NavDestination(){
      Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
        Row(){
          SettingTop({ settingTitle: '免打扰设置' })
        }.width(BaseConstants.FULL_WIDTH)
        .height(60)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .padding({top:20})


        Row(){
          Column(){
            Text('允许通知').fontSize(18)
          }
          .width(240)
          .alignItems(HorizontalAlign.Start)
          .margin({
            left:10
          })

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.undisturbType===0?Visibility.Visible:Visibility.None)
          }.width('25%')
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
          this.undisturbType = 0
        })

        Divider().width('90%')

        Row(){
          Column(){
            Text('免打扰时段：08:00 ~ 12:00').fontSize(18)
          }
          .width(240)
          .alignItems(HorizontalAlign.Start)
          .margin({left:10})

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.undisturbType===1?Visibility.Visible:Visibility.None)
          }.width('25%')
          .alignItems(HorizontalAlign.End)
        }.height(60)
        .width('90%')
        .backgroundColor('#F1F3F5')
        .onClick(()=>{
          this.undisturbType = 1
        })

        Divider().width('90%')

        Row(){
          Column(){
            Text('免打扰时段：23:00 ~ 06:00').fontSize(18)
          }
          .width(240)
          .alignItems(HorizontalAlign.Start)
          .margin({left:10})

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.undisturbType===2?Visibility.Visible:Visibility.None)
          }.width('25%')
          .alignItems(HorizontalAlign.End)
        }.height(60)
        .width('90%')
        .backgroundColor('#F1F3F5')
        .onClick(()=>{
          this.undisturbType = 2
        })
        Divider().width('90%')

        Row(){
          Column(){
            Text('全天免打扰').fontSize(18)
          }
          .width(240)
          .alignItems(HorizontalAlign.Start)
          .margin({left:10})

          Column(){
            StandardIcon({ icon: $r('app.media.ic_public_phone') })
              .margin({ right:10 })
              .visibility(this.undisturbType===3?Visibility.Visible:Visibility.None)
          }.width('25%')
          .alignItems(HorizontalAlign.End)
        }.height(60)
        .width('90%')
        .backgroundColor('#F1F3F5')
        .borderRadius({
          bottomLeft: 6,
          bottomRight: 6
        }).onClick(()=>{
          this.undisturbType = 3
        })
      }
      .backgroundColor(Color.White)
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }.hideTitleBar(true)
  }
}