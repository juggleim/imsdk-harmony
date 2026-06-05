import { BaseConstants, StandardIcon } from 'base'
import { deviceInfo } from '@kit.BasicServicesKit'
import { PreferenceUtil } from '../jim/preferenceutil'
import { JuggleIm } from 'juggleim'
import { NavSourceParam } from '../viewmodel/ConversationViewModel'

@Component
export struct QRCodeDisplay {
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo: NavPathStack
  @Consume('activeNavSource') activeNavSource: string
  @State private userId: string = ''
  @State private nickname: string = ''
  @State private avatar: ResourceStr = ''
  @State private qrText: string = ''
  @State private qrMatrix: boolean[][] = []
  @State private activePageInfo: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    this.activePageInfo = this.resolveActivePageInfo()
    this.loadProfile()
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

  private loadProfile():void{
    let auth = PreferenceUtil.getCacheAuth()
    if(auth == undefined){
      return
    }
    this.userId = auth.user_id
    let display = PreferenceUtil.getProfileDisplay()
    if(display != undefined && display.nickname != ''){
      this.nickname = display.nickname
      this.avatar = this.getAvatarResource(display.avatarIndex)
    }else{
      let localUser = JuggleIm.instance.userInfo
      this.nickname = localUser.nickname
      this.avatar = localUser.userPortrait
    }
    this.qrText = `jchat://user/${this.userId}`
    this.qrMatrix = this.buildMatrix(this.qrText)
  }

  private getAvatarResource(index:number):ResourceStr{
    const avatars:ResourceStr[] = [
      $r('app.media.avatar1'),
      $r('app.media.avatar2'),
      $r('app.media.avatar3'),
      $r('app.media.avatar4'),
      $r('app.media.avatar5'),
      $r('app.media.avatar6'),
      $r('app.media.avatar7'),
      $r('app.media.avatar8'),
      $r('app.media.avatar9'),
      $r('app.media.avatar10'),
      $r('app.media.avatar11')
    ]
    let safeIndex = index < 1 ? 1 : (index > avatars.length ? avatars.length : index)
    return avatars[safeIndex - 1]
  }

  private simpleHash(text:string):number{
    let hash = 0
    for(let i = 0; i < text.length; i++){
      hash = ((hash << 5) - hash + text.charCodeAt(i)) | 0
    }
    return Math.abs(hash)
  }

  private drawFinder(matrix:boolean[][], startRow:number, startCol:number):void{
    for(let r = 0; r < 7; r++){
      for(let c = 0; c < 7; c++){
        let isBorder = r == 0 || r == 6 || c == 0 || c == 6
        let isCenter = r >= 2 && r <= 4 && c >= 2 && c <= 4
        matrix[startRow + r][startCol + c] = isBorder || isCenter
      }
    }
  }

  private buildMatrix(text:string):boolean[][]{
    const size = 21
    let matrix:boolean[][] = []
    for(let r = 0; r < size; r++){
      let row:boolean[] = []
      for(let c = 0; c < size; c++){
        row.push(false)
      }
      matrix.push(row)
    }
    this.drawFinder(matrix, 0, 0)
    this.drawFinder(matrix, 0, size - 7)
    this.drawFinder(matrix, size - 7, 0)
    let hash = this.simpleHash(text)
    for(let r = 0; r < size; r++){
      for(let c = 0; c < size; c++){
        if(matrix[r][c]){
          continue
        }
        if(r == 6 || c == 6 || r == 13 || c == 13){
          matrix[r][c] = ((hash + r + c) % 2) == 0
          continue
        }
        matrix[r][c] = ((hash + r * 17 + c * 31 + text.length) % 7) < 3
      }
    }
    return matrix
  }

  private back():void{
    if(this.activePageInfo.size() > 1){
      this.activePageInfo.pop()
    }
  }

  private openScanPage():void{
    this.activePageInfo.pushPath({
      name: 'ScanPage',
      param: new NavSourceParam(this.activeNavSource)
    })
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Column() {
              if(this.avatar != ''){
                Image(this.avatar)
                  .width(72)
                  .height(72)
                  .borderRadius(36)
              }else{
                Stack() {
                  Text(this.nickname != '' ? this.nickname.charAt(0) : '我')
                    .fontSize(28)
                    .fontColor(Color.White)
                }
                .width(72)
                .height(72)
                .backgroundColor('#7C8DB5')
                .borderRadius(36)
              }
              Text(this.nickname == '' ? '未设置昵称' : this.nickname)
                .fontSize(22)
                .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                .margin({ top: 12 })
              Text(this.userId == '' ? '-' : this.userId)
                .fontSize(12)
                .fontColor('#6B7280')
                .margin({ top: 4 })
            }
            .width('100%')
            .padding({ top: 20, bottom: 24 })
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column() {
              Text('扫码识别此二维码')
                .fontSize(14)
                .fontColor('#6B7280')
                .margin({ bottom: 12 })
              Column() {
                ForEach(this.qrMatrix, (row:boolean[], rowIndex:number) => {
                  Row() {
                    ForEach(row, (cell:boolean, colIndex:number) => {
                      Column() {}
                        .width(10)
                        .height(10)
                        .backgroundColor(cell ? Color.Black : Color.White)
                    }, (cell:boolean, colIndex:number) => `${rowIndex}_${colIndex}`)
                  }
                }, (row:boolean[], rowIndex:number) => `row_${rowIndex}`)
              }
              .padding(12)
              .backgroundColor(Color.White)
              .border({
                width: 1,
                color: '#E5E7EB'
              })
              .borderRadius(12)
              .alignItems(HorizontalAlign.Center)

              Text(this.qrText)
                .fontSize(12)
                .fontColor('#6B7280')
                .margin({ top: 16 })

              Button('扫一扫')
                .width('100%')
                .height(44)
                .fontSize(15)
                .fontColor(Color.White)
                .backgroundColor('#4C8DFF')
                .borderRadius(6)
                .margin({ top: 16 })
                .onClick(()=>{
                  this.openScanPage()
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .backgroundColor(Color.White)
            .margin({ top: 12 })
            .borderRadius(8)

            Row() {
              Text('二维码内容已生成')
                .fontSize(14)
                .fontColor('#6B7280')
              Blank()
              Text('可用于进入扫一扫页面')
                .fontSize(12)
                .fontColor('#9CA3AF')
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
    .title('我的二维码')
  }
}
