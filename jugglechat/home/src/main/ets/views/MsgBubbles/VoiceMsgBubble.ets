import { VoiceMessage } from "juggleim/src/main/ets/entries/message"

@Component
export struct VoiceMsgBubble{
  private voiceMsg?:VoiceMessage

  private getTimeStr():string{
    if(this.voiceMsg instanceof VoiceMessage){
      let date =  new Date(this.voiceMsg.duration)
      // let hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours()
      let min = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()
      let sec = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds()
      return min+":"+sec
    }
    return '00:00'
  }

  build() {
    Row() {
      Image($r('app.media.ic_public_play_norm'))
        .width(40)
        .height(40)
        .alignSelf(ItemAlign.Start)
      Text().width(70)
      Text(this.getTimeStr())
        .alignSelf(ItemAlign.Center)
    }.width(150)
  }
}