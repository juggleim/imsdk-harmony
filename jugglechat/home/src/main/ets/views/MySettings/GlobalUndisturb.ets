import { promptAction } from '@kit.ArkUI'
import { BaseConstants } from 'base/src/main/ets/constants/BaseConstants'
import { JuggleIm, TimePeriod } from 'juggleim'

const TOP_TRACE_TAG:string = 'TOPTRACE'

enum GlobalUndisturbType {
  Allow = 0,
  T8_12 = 1,
  T19_20 = 2,
  T23_06 = 3,
  Disturb = 4
}

class GlobalUndisturbOption {
  type:GlobalUndisturbType
  title:string
  startTime:string
  endTime:string

  constructor(type:GlobalUndisturbType, title:string, startTime:string = '', endTime:string = '') {
    this.type = type
    this.title = title
    this.startTime = startTime
    this.endTime = endTime
  }
}

const GLOBAL_UNDISTURB_OPTIONS:GlobalUndisturbOption[] = [
  new GlobalUndisturbOption(GlobalUndisturbType.Allow, '允许通知'),
  new GlobalUndisturbOption(GlobalUndisturbType.T8_12, '免打扰时段 08:00 ~ 12:00', '08:00', '12:00'),
  new GlobalUndisturbOption(GlobalUndisturbType.T19_20, '免打扰时段 19:00 ~ 20:00', '19:00', '20:00'),
  new GlobalUndisturbOption(GlobalUndisturbType.T23_06, '免打扰时段 23:00 ~ 06:00', '23:00', '06:00'),
  new GlobalUndisturbOption(GlobalUndisturbType.Disturb, '全天免打扰')
]

@Component
export default struct GlobalUndisturb {
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack

  @State private selectedType:GlobalUndisturbType = GlobalUndisturbType.Allow
  @State private isLoading:boolean = false
  @State private timezone:string = ''

  private options:GlobalUndisturbOption[] = GLOBAL_UNDISTURB_OPTIONS

  aboutToAppear(): void {
    this.timezone = this.resolveLocalTimezone()
    this.loadMuteStatus()
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private loadMuteStatus():void{
    if(this.isLoading){
      return
    }
    this.isLoading = true
    console.log(`${TOP_TRACE_TAG} global_undisturb_page_load_start`)
    JuggleIm.instance.getMessageManager().getMuteStatus((code, isMute, timezone, periods)=>{
      this.isLoading = false
      console.log(`${TOP_TRACE_TAG} global_undisturb_page_load_finish: code=${code}, isMute=${isMute}, timezone=${timezone}, periods=${JSON.stringify(periods)}`)
      if(code != 0){
        this.showToast(`免打扰状态加载失败: ${code}`)
        return
      }
      if(timezone != ''){
        this.timezone = timezone
      }
      this.selectedType = this.resolveUndisturbType(isMute, periods)
    })
  }

  private updateSelection(type:GlobalUndisturbType):void{
    if(this.isLoading || this.selectedType == type){
      console.log(`${TOP_TRACE_TAG} global_undisturb_page_set_skip: type=${type}, currentType=${this.selectedType}, loading=${this.isLoading}`)
      return
    }
    let option = this.findOption(type)
    let isMute = type != GlobalUndisturbType.Allow
    let periods = this.buildPeriodsForOption(option)
    console.log(`${TOP_TRACE_TAG} global_undisturb_page_set_start: type=${type}, isMute=${isMute}, periods=${JSON.stringify(periods)}`)
    this.isLoading = true
    JuggleIm.instance.getMessageManager().setMute(isMute, periods, (code)=>{
      this.isLoading = false
      console.log(`${TOP_TRACE_TAG} global_undisturb_page_set_finish: type=${type}, isMute=${isMute}, periods=${JSON.stringify(periods)}, code=${code}`)
      if(code != 0){
        this.showToast(`免打扰设置失败: ${code}`)
        return
      }
      this.selectedType = type
      this.showToast(type == GlobalUndisturbType.Allow ? '已恢复通知' : '已更新免打扰设置')
      this.loadMuteStatus()
    })
  }

  private resolveUndisturbType(isMute:boolean, periods:TimePeriod[]):GlobalUndisturbType{
    if(!isMute){
      return GlobalUndisturbType.Allow
    }
    if(periods.length == 0){
      return GlobalUndisturbType.Disturb
    }
    let firstPeriod = periods[0]
    for(let i = 0; i < this.options.length; i++){
      let option = this.options[i]
      if(option.startTime == '' || option.endTime == ''){
        continue
      }
      if(option.startTime == firstPeriod.startTime && option.endTime == firstPeriod.endTime){
        return option.type
      }
    }
    return GlobalUndisturbType.Disturb
  }

  private findOption(type:GlobalUndisturbType):GlobalUndisturbOption{
    for(let i = 0; i < this.options.length; i++){
      if(this.options[i].type == type){
        return this.options[i]
      }
    }
    return this.options[0]
  }

  private buildPeriodsForOption(option:GlobalUndisturbOption):TimePeriod[]{
    if(option.startTime == '' || option.endTime == ''){
      return []
    }
    let period = new TimePeriod()
    period.startTime = option.startTime
    period.endTime = option.endTime
    return [period]
  }

  private resolveLocalTimezone():string{
    try{
      let localTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone
      if(localTimezone != undefined && localTimezone != null){
        return localTimezone
      }
    }catch (error) {
    }
    return ''
  }

  @Builder
  private optionItem(option:GlobalUndisturbOption, isLast:boolean) {
    Column() {
      Row() {
        Text(option.title)
          .fontSize(16)
          .fontColor('#111111')
        Blank()
        if(this.selectedType == option.type){
          Text('✓')
            .fontSize(20)
            .fontColor('#4C8DFF')
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .opacity(this.isLoading ? 0.6 : 1)
      .onClick(()=>{
        this.updateSelection(option.type)
      })

      if(!isLast){
        Divider()
          .strokeWidth(1)
          .color('#EAEAEA')
      }
    }
    .width('100%')
  }

  build() {
    NavDestination(){
      Column(){
        if(this.isLoading){
          Column(){
            LoadingProgress()
              .width(28)
              .height(28)
            Text('加载中')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 12 })
          }
          .width('100%')
          .margin({ top: 48, bottom: 24 })
        }

        Column() {
          ForEach(this.options, (option:GlobalUndisturbOption)=>{
            this.optionItem(option, option.type == this.options[this.options.length - 1].type)
          }, (option:GlobalUndisturbOption)=>`${option.type}`)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .margin({ top: this.isLoading ? 0 : 32 })

        if(this.timezone != ''){
          Text(`当前时区 ${this.timezone}`)
            .fontSize(13)
            .fontColor('#999999')
            .width('100%')
            .padding({ left: 16, right: 16, top: 16 })
        }

        Blank()
      }
      .backgroundColor('#F5F6F8')
      .width(BaseConstants.FULL_WIDTH)
      .height(BaseConstants.FULL_HEIGHT)
    }
    .title('免打扰设置')
  }
}
