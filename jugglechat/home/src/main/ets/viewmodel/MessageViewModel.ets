
@Observed
class MessageViewItem{
  isReceived:boolean = true
  receivedName:string
  content:ResourceStr
  isAppletMsg:boolean = false
  isDocumentMsg:boolean = false

  constructor(receivedName:string,content:ResourceStr) {
    this.receivedName = receivedName
    this.content = content
  }
}

export { MessageViewItem };