import { VideoMessage } from "juggleim/src/main/ets/entries/message"

@Component
export struct VideoMsgBubble{
  private videoMsg?:VideoMessage

  private getPoster():string{
    if(this.videoMsg!==undefined){
      return this.videoMsg.poster
    }else{
      return ''
    }
  }

  build() {
    Stack({alignContent:Alignment.Center}){
      Image(this.getPoster())
        .width('100%')
        .height('50%')
      Image($r('app.media.ic_public_play_white'))
        .width(80)
        .height(80)
        .alignSelf(ItemAlign.Center)
    }
  }
}