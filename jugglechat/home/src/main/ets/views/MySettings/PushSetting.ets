import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants'
import { SettingTop } from './SettingTop'
import { HarmonyPushManager, PushDebugSnapshot } from '../../jim/harmonypushmanager'

@Component
export default struct PushSetting {
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  @State private snapshot:PushDebugSnapshot = new PushDebugSnapshot()
  @State private loading:boolean = false
  @State private manualToken:string = ''

  aboutToAppear(): void {
    this.refreshState()
  }

  private refreshState():void {
    this.snapshot = HarmonyPushManager.instance.getSnapshot()
    if(this.manualToken == '' && this.snapshot.token != ''){
      this.manualToken = this.snapshot.token
    }
  }

  private showToast(message:string):void {
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private async loadAAID():Promise<void> {
    if(this.loading){
      return
    }
    this.loading = true
    let result = await HarmonyPushManager.instance.refreshAAID()
    this.loading = false
    this.refreshState()
    this.showToast(result.message)
  }

  private async fetchAndRegisterToken():Promise<void> {
    if(this.loading){
      return
    }
    this.loading = true
    let result = await HarmonyPushManager.instance.requestToken(true)
    this.loading = false
    this.refreshState()
    this.showToast(result.message)
  }

  private async registerCurrentToken():Promise<void> {
    if(this.loading){
      return
    }
    this.loading = true
    let result = await HarmonyPushManager.instance.registerCurrentToken('settingsPage')
    this.loading = false
    this.refreshState()
    this.showToast(result.message)
  }

  private async registerManualToken():Promise<void> {
    if(this.loading){
      return
    }
    this.loading = true
    let result = await HarmonyPushManager.instance.registerManualToken(this.manualToken)
    this.loading = false
    this.refreshState()
    this.showToast(result.message)
  }

  @Builder
  private infoRow(title:string, value:string) {
    Row() {
      Text(title)
        .fontSize(14)
        .fontColor('#6B7280')
        .width(108)
      Text(value == '' ? '-' : value)
        .fontSize(14)
        .fontColor('#111827')
        .layoutWeight(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
  }

  @Builder
  private actionButton(title:string, backgroundColor:string, action:()=>void) {
    Button(title)
      .width('100%')
      .height(44)
      .fontSize(15)
      .fontColor(Color.White)
      .backgroundColor(backgroundColor)
      .borderRadius(6)
      .margin({ top: 12 })
      .enabled(!this.loading)
      .onClick(()=>{
        action()
      })
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          SettingTop({ settingTitle: '推送设置' })
        }
        .width(BaseConstants.FULL_WIDTH)
        .height(60)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .padding({ top: 20 })

        Scroll() {
          Column() {
            Column() {
              this.infoRow('应用包名', this.snapshot.bundleName)
              Divider()
              this.infoRow('Push 渠道', this.snapshot.channelName)
              Divider()
              this.infoRow('AAID', this.snapshot.aaid)
              Divider()
              this.infoRow('当前 Token', this.snapshot.token)
              Divider()
              this.infoRow('Token 来源', this.snapshot.tokenSource)
              Divider()
              this.infoRow('Token 时间', this.snapshot.tokenTime)
              Divider()
              this.infoRow('订阅状态', this.snapshot.subscribed ? 'tokenUpdate 已订阅' : 'tokenUpdate 未订阅')
              Divider()
              this.infoRow('上报结果', this.snapshot.registerMessage)
              Divider()
              this.infoRow('上报时间', this.snapshot.registerTime)
            }
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(6)

            Column() {
              TextInput({ text: this.manualToken, placeholder: '手动输入 Push Token' })
                .width('100%')
                .height(44)
                .fontSize(14)
                .backgroundColor('#F3F4F6')
                .borderRadius(6)
                .onChange((value:string)=>{
                  this.manualToken = value
                })

              Column() {
                this.actionButton('获取并上报华为 Token', '#4C8DFF', ()=>{
                  void this.fetchAndRegisterToken()
                })
                this.actionButton('上报当前 Token', '#111827', ()=>{
                  void this.registerCurrentToken()
                })
                this.actionButton('上报输入框 Token', '#16A34A', ()=>{
                  void this.registerManualToken()
                })
                this.actionButton('刷新 AAID', '#6B7280', ()=>{
                  void this.loadAAID()
                })
                Button('推送语言设置')
                  .width('100%')
                  .height(44)
                  .fontSize(15)
                  .fontColor('#111827')
                  .backgroundColor('#E5E7EB')
                  .borderRadius(6)
                  .onClick(()=>{
                    this.mySettingPageInfo.pushPath({ name: 'LanguageSetting' })
                  })
              }
              .width('100%')
              .margin({ top: 16 })
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .margin({ top: 20 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 24 })
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .hideTitleBar(true)
  }
}
