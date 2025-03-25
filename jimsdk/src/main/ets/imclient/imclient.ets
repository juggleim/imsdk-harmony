import webSocket from '@ohos.net.webSocket';
import {imconnect} from '../improto/imconnect.js'
import {uint8ArrayToString} from '../commons/convert'

@Observed
export class ImClient {
  address: string;
  appkey: string;
  token: string;

  state: number;
  wsSocket: webSocket.WebSocket;

  constructor(address: string, appkey: string, token: string) {
    this.address = address;
    this.appkey = appkey;
    this.token = token;
    this.state = 0;

    this.wsSocket = webSocket.createWebSocket();
  }

  connect(){
    if(this.state==0){
      this.wsSocket.on('open',(err,value)=>{
        console.log("gxg_open_err:",JSON.stringify(err))
        console.log("gxg_open_value:",JSON.stringify(value));
      })
      //error
      this.wsSocket.on('error',(err)=>{
        console.log("gxg_on_error:",JSON.stringify(err))
      })

      //connect
      this.wsSocket.connect(this.address)
        .then((value)=>{
          console.log("gxg_connect_success")
          this.state = 1
        })
        .catch(()=>{
          console.log("connect_error:Failed to connect.")
        })
    }
  }

  send(text: string){
    if(this.state == 1){
      this.wsSocket.send(text)
        .then((value)=>{
          console.log("send_succ:",text);
        })
        .catch(()=>{
          console.log("send_fail:",text)
        })
    }
  }
}

export const jim = new ImClient("ws://ws.juggleim.com/im","appkey","CgZhcHBrZXkaICAvo1UH53CiwR/aurQXCDBpogz9OGlWbbWDpDsMJ4dn");
const jimClient = new ImClient("","","");
export function initJim(address: string , appkey: string,token:string) {
  jimClient.address = address;
  jimClient.appkey = appkey;
  jimClient.token = token;
}

export function connect(){
  jimClient.connect();
}

export function send(){
  let msg = imconnect.ImWebsocketMsg.create();
  msg.version = 3
  msg.connectMsgBody = imconnect.ConnectMsgBody.create({
    "protoId":"jug9le1m",
    "appkey":jimClient.appkey,
    "token":jimClient.token,
    "platform":"iOS",
  })
  let  arrayBuffer:Uint8Array = imconnect.ImWebsocketMsg.encode(msg).finish();

  let str:string = uint8ArrayToString(arrayBuffer)
  console.log("gxg_msg:",str)

  jimClient.wsSocket.send(arrayBuffer.buffer)
    .then((value)=>{
      console.log("gxg_send_succ:",value)
    })
    .catch(()=>{
      console.log("gxg_send_fail")
    })
}