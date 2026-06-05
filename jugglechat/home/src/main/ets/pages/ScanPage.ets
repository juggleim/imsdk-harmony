import { promptAction } from '@kit.ArkUI'
import { BaseConstants, StandardIcon } from 'base'
import { deviceInfo } from '@kit.BasicServicesKit'
import { ConversationDetailParams, NavSourceParam } from '../viewmodel/ConversationViewModel'
import { JuggleIm } from 'juggleim'

@Component
export struct ScanPage {
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo: NavPathStack
  @Consume('activeNavSource') activeNavSource: string
  @State private scanText: string = 'jchat://user/'
  @State private loading: boolean = false
  @State private activePageInfo: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    this.activePageInfo = this.resolveActivePageInfo()
  }

  private getStackSource(stack: NavPathStack): string {
    if (stack.size() <= 0) {
      return ''
    }
    let param = stack.getParamByIndex(stack.size() - 1) as NavSourceParam
    if (param != undefined && param.source != '') {
      return param.source
    }
    return ''
  }

  private resolveActivePageInfo(): NavPathStack {
    if (this.activeNavSource == 'settings') {
      return this.mySettingPageInfo
    }
    if (this.activeNavSource == 'home') {
      return this.pageInfo
    }
    let settingSource = this.getStackSource(this.mySettingPageInfo)
    if (settingSource == 'settings') {
      return this.mySettingPageInfo
    }
    let homeSource = this.getStackSource(this.pageInfo)
    if (homeSource == 'home') {
      return this.pageInfo
    }
    if (this.mySettingPageInfo.size() > this.pageInfo.size()) {
      return this.mySettingPageInfo
    }
    return this.pageInfo
  }

  private back():void{
    if(this.activePageInfo.size() > 1){
      this.activePageInfo.pop()
    }
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
  }

  private parseUserId(text:string):string{
    let value = text.trim()
    if(value.startsWith('jchat://user/')){
      return value.substring('jchat://user/'.length)
    }
    return value
  }

  private openConversation(userId:string, title:string):void{
    this.activePageInfo.pushPath({
      name: 'ConversationDetail',
      param: new ConversationDetailParams(userId, userId, 1, title, '')
    })
  }

  private scanAndOpen():void{
    if(this.loading){
      return
    }
    if(this.activeNavSource == 'settings'){
      this.showToast('当前入口暂不支持直接打开会话')
      return
    }
    let userId = this.parseUserId(this.scanText)
    if(userId == ''){
      this.showToast('请输入有效二维码内容')
      return
    }
    this.loading = true
    JuggleIm.instance.getUserInfoManager().queryUserInfo(userId, (code, user)=>{
      this.loading = false
      if(code != 0 || user == null){
        this.showToast('未识别到用户')
        return
      }
      this.openConversation(user.userId, user.nickname != '' ? user.nickname : user.userId)
    })
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              Column() {
              }
              .width(240)
              .height(240)
              .border({
                width: 2,
                color: '#CBD5E1'
              })
              .borderRadius(16)
              .backgroundColor('#F8FAFC')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            .padding({ top: 20, bottom: 20 })
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Text('识别二维码内容')
                .fontSize(14)
                .fontColor('#6B7280')
                .margin({ bottom: 8 })
              TextInput({ text: this.scanText, placeholder: '粘贴 jchat://user/xxx 或用户 ID' })
                .width('100%')
                .height(44)
                .fontSize(15)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .onChange((value:string)=>{
                  this.scanText = value
                })

              Button('打开会话')
                .width('100%')
                .height(44)
                .fontSize(15)
                .fontColor(Color.White)
                .backgroundColor('#4C8DFF')
                .borderRadius(6)
                .margin({ top: 16 })
                .onClick(()=>{
                  this.scanAndOpen()
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Column() {
              Text('这里先做成可用的入口页，真实相机扫描后续再接。')
                .fontSize(13)
                .fontColor('#6B7280')
                .lineHeight(20)
            }
            .width('100%')
            .padding({ top: 16, bottom: 24 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 24 })
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#F5F7FA')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .title('扫一扫')
  }
}
