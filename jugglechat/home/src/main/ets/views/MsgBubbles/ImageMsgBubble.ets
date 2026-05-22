import { ImageMessage } from 'juggleim'

@Component
export struct ImageMsgBubble{
  private imgMsg?:ImageMessage

  private getImgUrl():string{
    if(this.imgMsg!==undefined){
      if(this.imgMsg.localPath != ''){
        return this.imgMsg.localPath
      }
      if(this.imgMsg.url != ''){
        return this.imgMsg.url
      }
      return this.imgMsg.thumbnail
    }else{
      return ''
    }
  }

  private getBubbleWidth():number{
    if(this.imgMsg != undefined && this.imgMsg.width > 0 && this.imgMsg.height > 0){
      let ratio = this.imgMsg.width / this.imgMsg.height
      if(ratio >= 1.2){
        return 220
      }
      if(ratio <= 0.75){
        return 150
      }
    }
    return 180
  }

  private getBubbleHeight():number{
    if(this.imgMsg != undefined && this.imgMsg.width > 0 && this.imgMsg.height > 0){
      let ratio = this.imgMsg.height / this.imgMsg.width
      if(ratio >= 1.4){
        return 220
      }
      if(ratio <= 0.7){
        return 132
      }
    }
    return 160
  }

  build(){
    Stack() {
      if(this.getImgUrl() != ''){
        Image(this.getImgUrl())
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      }else{
        Text('图片')
          .fontSize(13)
          .fontColor('#999999')
      }
    }
    .width(this.getBubbleWidth())
    .height(this.getBubbleHeight())
    .borderRadius(14)
    .clip(true)
    .backgroundColor('#F5F5F5')
  }
}
