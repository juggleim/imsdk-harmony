
@Observed
class MessageViewItem{
  isReceived:boolean = true
  receivedName:string
  content:ResourceStr
  isAppletMsg:boolean = false
  isDocumentMsg:boolean = false
  msgTime:number = 0

  constructor(receivedName:string,content:ResourceStr,msgTime:number) {
    this.receivedName = receivedName
    this.content = content
    this.msgTime = msgTime
  }
}

export { MessageViewItem };