import { ImageMessage } from 'juggleim'

@Component
export struct ImageMsgBubble{
  private imgMsg?:ImageMessage
  private getImgUrl():string{
    if(this.imgMsg!==undefined){
      return this.imgMsg.url
    }else{
      return ''
    }
  }
  build(){
    Image(this.getImgUrl())
  }
}