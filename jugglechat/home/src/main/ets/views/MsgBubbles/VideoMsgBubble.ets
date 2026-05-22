import { VideoMessage } from 'juggleim'

@Component
export struct VideoMsgBubble{
  private videoMsg?:VideoMessage

  private getPoster():string{
    if(this.videoMsg!==undefined){
      if(this.videoMsg.poster != ''){
        return this.videoMsg.poster
      }
      return this.videoMsg.localPath
    }else{
      return ''
    }
  }

  private getDurationText():string{
    if(this.videoMsg == undefined || this.videoMsg.duration <= 0){
      return '视频'
    }
    let totalSeconds = Math.floor(this.videoMsg.duration / 1000)
    let minute = Math.floor(totalSeconds / 60)
    let second = totalSeconds % 60
    let minuteText = minute < 10 ? `0${minute}` : `${minute}`
    let secondText = second < 10 ? `0${second}` : `${second}`
    return `${minuteText}:${secondText}`
  }

  build() {
    Stack({alignContent:Alignment.Center}){
      if(this.getPoster() != ''){
        Image(this.getPoster())
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      }else{
        Blank()
          .width('100%')
          .height('100%')
          .backgroundColor('#1F2937')
      }
      Image($r('app.media.ic_public_play_white'))
        .width(48)
        .height(48)
      Row() {
        Text(this.getDurationText())
          .fontSize(11)
          .fontColor(Color.White)
      }
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .backgroundColor('#66000000')
      .borderRadius(10)
      .alignSelf(ItemAlign.End)
      .margin({ right: 10, bottom: 10 })
    }
    .width(210)
    .height(132)
    .borderRadius(14)
    .clip(true)
  }
}
