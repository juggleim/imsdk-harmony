import {JuggleIm} from 'jimsdk';

@Entry
@Component
struct Index {
  //连接、通讯历史记录
  @State msgHistory: string = ''
  //要发送的信息
  @State sendMsg: string = ''
  //ws服务端地址
  @State wsServerUrl: string = "ws://ws.juggleim.com/im"
  //是否可以连接
  @State canConnect: boolean = false

  //是否可以发送消息
  @State canSend: boolean = false
  scroller: Scroller = new Scroller()

  //是否绑定了事件处理程序
  eventHandleBinded:boolean=false

  build() {
    Row() {
      Column() {
        Text("WebSocket通讯示例")
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text("服务端url：")
            .fontSize(12)
            .width(70)
            .flexGrow(0)

          TextInput({ text: this.wsServerUrl })
            .onChange((value) => {
              this.wsServerUrl = value
            })
            .width(110)
            .fontSize(11)
            .flexGrow(1)

          Button("连接")
            .onClick(() => {
              this.connect2Server()
            })
            .width(60)
            .fontSize(14)
            .flexGrow(0)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: "输入要发送的消息" }).onChange((value) => {
            this.sendMsg = value
          })
            .width(200)
            .flexGrow(1)

          Button("发送")
            .enabled(true)
            .width(60)
            .fontSize(14)
            .flexGrow(0)
            .onClick(() => {
              this.send2Server()
            })
        }
        .width('100%')
        .padding(10)

        Scroll(this.scroller) {
          Text(this.msgHistory)
            .textAlign(TextAlign.Start)
            .padding(10)
            .width('100%')
            .backgroundColor(0xeeeeee)
        }
        .align(Alignment.Top)
        .backgroundColor(0xeeeeee)
        .height(300)
        .flexGrow(1)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarWidth(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height('100%')
    }
    .height('100%')
  }
  //连接服务端
  connect2Server() {
    JuggleIm.instance.init(this.wsServerUrl,"nsw3sue72begyv7y")
    JuggleIm.instance.connectionManager().addConnectStatusListener((status,code)=>{
      this.msgHistory += 'connect change. status:' + status +'\tcode:'+ code + '\r\n'
    })
    JuggleIm.instance.connectionManager().connect("ChBuc3czc3VlNzJiZWd5djd5GiAEjKM8NTdyzPyLBgNlHbLauqQLCf1jmgexbCUZUu4DmQ==")
    // wsSocket.connect(this.wsServerUrl)
    //   .then((value) => {
    //     this.msgHistory += 'connect success :'+JSON.stringify(value) + "\r\n";
    //     this.canSend = true
    //   })
    //   .catch(() => {
    //     this.msgHistory +='connect fail '  + "\r\n";
    //   })
  }
  send2Server(){
    JuggleIm.instance.messageManager().send(1,"userid2",(code:number,msgId:string,sendTime:number,msgSeqNo:number)=>{
      console.log("jimsdk_sendack",code,"\t",msgId)
    })
  }
}