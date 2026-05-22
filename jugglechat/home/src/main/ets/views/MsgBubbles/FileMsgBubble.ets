import { FileMessage } from 'juggleim'

@Component
export struct FileMsgBubble{
  private fileMsg?:FileMessage

  getFileName():string{
    if(this.fileMsg!==undefined){
      return this.fileMsg.name
    }else{
      return "Unknown"
    }
  }

  getFileSize():string{
    if(this.fileMsg == undefined || this.fileMsg.size <= 0){
      return '未知大小'
    }
    let size = this.fileMsg.size
    if(size < 1024){
      return `${size} B`
    }
    if(size < 1024 * 1024){
      return `${(size / 1024).toFixed(1)} KB`
    }
    return `${(size / 1024 / 1024).toFixed(1)} MB`
  }

  getFileTypeText():string{
    if(this.fileMsg == undefined || this.fileMsg.type == ''){
      return '文件'
    }
    return this.fileMsg.type
  }

  build(){
    Column() {
      Row() {
        Column() {
          Text(this.getFileName())
            .fontSize(14)
            .fontColor('#111111')
            .maxLines(2)
            .margin({ right: 12 })
          Text(this.getFileSize())
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 6 })
        }
        .layoutWeight(1)
        Image($r('app.media.ic_PDF'))
          .height(44)
          .width(44)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      Divider()
        .color($r('app.color.divider_background_color'))
        .strokeWidth(1)
        .margin({ top: 14, bottom: 12 })
      Row() {
        Image($r('app.media.ic_file'))
          .width(18)
          .height(18)
          .margin({ right: 8 })
        Text(this.getFileTypeText())
          .fontSize(12)
          .fontColor('#999999')
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width(228)
    .padding({ left: 14, right: 14, top: 14, bottom: 12 })
  }
}
