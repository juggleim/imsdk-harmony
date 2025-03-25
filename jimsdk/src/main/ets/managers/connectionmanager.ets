import webSocket from '@ohos.net.webSocket'
import {JuggleIm} from '../juggleim'
import {JimUtil} from '../commons/jimutil'
import json from '@ohos.util.json';
import { HashMap } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import {imconnect} from '../improto/imconnect.js'
import {Cmd,newConnectMessage, newUserPublishMessage} from '../improto/connectmsg'
import call from '@ohos.telephony.call';

export class ConnStatus{
  static readonly unknown = 0
  static readonly connecting = 1
  static readonly connected = 2
  static readonly fail = 3
  static readonly disconnected = 4
}

export type ConnStatusListener = (status:number,reasonCode:number)=>void
export type PublishCallback = (code:number,msgId:string,sendTime:number,msgSeq:number)=>void

class PublishCallbackWrap{
  callback:PublishCallback
  timeoutId:number
  constructor(callback:PublishCallback,timeoutId:number) {
    this.callback = callback
    this.timeoutId = timeoutId
  }
}

export class ConnectionManager {
  static instance: ConnectionManager = new ConnectionManager();
  index:number = 0
  status:number = ConnStatus.unknown;
  wsSocket?: webSocket.WebSocket;
  private connectStatusListeners:ConnStatusListener[]
  private connectTimeoutId:number = 0
  private publishCache: HashMap<number, PublishCallbackWrap> = new HashMap()
  private queryCache:HashMap<number,PublishCallback> = new HashMap()

  constructor() {
    this.connectStatusListeners = new Array()
  }

  connect(token:string){
    if(JimUtil.isEmpty(JuggleIm.instance.config.address ?? '')||
    JimUtil.isEmpty(JuggleIm.instance.config.appkey ?? '')||
    JimUtil.isEmpty(token ?? '')){
      console.error("jimsdk_noinit")
      return
    }
    if (this.status === ConnStatus.connecting||this.status === ConnStatus.connected){
      console.log("jimsdk_connecting");
      return
    }
    this.status = ConnStatus.connecting
    this.setConnectStatus(this.status,0)

    this.wsSocket = webSocket.createWebSocket()
    this.wsSocket.on('open',(err,value)=>{
      console.log("jimsdk_open:",JSON.stringify(err),JSON.stringify(value))
      let data:Uint8Array = newConnectMessage(imconnect.ConnectMsgBody.create({
        "protoId":JuggleIm.instance.config.protoId,
        "appkey":JuggleIm.instance.config.appkey,
        "token":token,
        "platform":JuggleIm.instance.config.platform
      }))
      this.writeMessage(data)
      console.log("jimsdk_after_send")
    })
    this.wsSocket.on('error',(err)=>{
      console.log("jimsdk_connect_error:",JSON.stringify(err))
    })

    this.wsSocket.on('message',(err,value)=>{
      console.log("jimsdk_receive:",value)
      if (typeof value === 'string'){

      }else{
       let msg = imconnect.ImWebsocketMsg.decode(JimUtil.arrayBufferToUint8Array(value))
        console.log("jimsdk_receive:",msg.cmd)
        this.onReceive(msg)
      }
    })
   console.log("jimsdk_begin")
   this.wsSocket.connect(JuggleIm.instance.config.address)
      .then((value)=>{
        console.log("jimsdk_connect_succ:",JSON.stringify(value))
      })
      .catch((err:BusinessError)=>{
        console.error("jimsdk_connect_fail:",JSON.stringify(err))
        this.status = ConnStatus.fail
      })
    let timeoutId = setTimeout(()=>{
      if(this.status==ConnStatus.connecting){
        this.status = ConnStatus.fail
        this.setConnectStatus(this.status,-2)
      }
      this.connectTimeoutId = 0
    },5000)
    this.connectTimeoutId = timeoutId
  }

  reconnect(){

  }

  disconnect(isLogout:boolean){

  }

  close(){
    this.wsSocket?.off('open')
    this.wsSocket?.off('message')
    this.wsSocket?.off('error')
  }

  writeMessage(data:Uint8Array){
    console.log("jimsdk_begin_send")
    this.wsSocket?.send(data.buffer)
      .then((value)=>{
        console.log("jimsdk_send_succ:",JSON.stringify(value))
      })
      .catch((err:BusinessError)=>{
        console.error("jimsdk_send_fail:",JSON.stringify(err))
      })
  }

  onReceive(wsMsg:imconnect.ImWebsocketMsg){
    if(wsMsg.cmd == Cmd.connectAck){
      clearTimeout(this.connectTimeoutId)
      this.connectTimeoutId = 0
      let code = wsMsg.ConnectAckMsgBody?.code
      console.log("jimsdk_connectAck:",code)
      if(typeof code == 'number'){
        if (code === 0){
          this.status = ConnStatus.connected
        }else{
          this.status = ConnStatus.fail
        }
        this.setConnectStatus(this.status,code)
      }else{
        this.status = ConnStatus.fail
        this.setConnectStatus(this.status,-1)
      }
    }else if (wsMsg.cmd == Cmd.disconnect){
      let code = wsMsg.disconnectMsgBody?.code
      if(typeof  code == 'number'){
        this.status = ConnStatus.disconnected
        this.setConnectStatus(this.status,code)
      }
    }else if(wsMsg.cmd == Cmd.publish){

    }else if(wsMsg.cmd == Cmd.publishAck){
      let body = wsMsg.pubAckMsgBody
      if (body!=undefined && body!=null){
        let code = body.code
        console.log("jimsdk_puback code:",code)
        let index = body.index
        if (this.publishCache.hasKey(index)){
          clearTimeout(index)
          let wrap  = this.publishCache.get(index)
          if (typeof code == 'number'
            && typeof index == 'number'
            && typeof body.msgId == 'string'
            && typeof body.timestamp == 'number'
            && typeof body.msgSeqNo == 'number'){
            wrap.callback(code,body.msgId,body.timestamp,body.msgSeqNo)
          }
        }
      }
    }else if(wsMsg.cmd == Cmd.queryAck){

    }
  }

  getIndex():number{
    this.index = this.index + 1
    return this.index
  }

  addConnectStatusListener(l:ConnStatusListener){
    this.connectStatusListeners.push(l)
  }
  removeConnectStatusListener(l:ConnStatusListener){
    for (let i=0;i<this.connectStatusListeners.length;i++){
      if(this.connectStatusListeners[i]===l){
        this.connectStatusListeners.splice(i,1)
        break
      }
    }
  }

  private setConnectStatus(status:number,reasonCode:number){
    this.connectStatusListeners.forEach((listener)=>{
      listener(status,reasonCode)
    })
  }

  publish(method:string,targetId:string,data:Uint8Array,callback:PublishCallback){
    if(this.status === ConnStatus.connected){
      let index = this.getIndex()
      let msg = newUserPublishMessage(imconnect.PublishMsgBody.create({
        "index":index,
        "topic":method,
        "targetId":targetId,
        "data":data
      }))
      let timeoutId = setTimeout(()=>{
        if(this.publishCache.hasKey(index)){
          callback(-2,"",0,0)
          this.publishCache.remove(index)
        }
      },5000)
      this.publishCache.set(index,new PublishCallbackWrap(callback,timeoutId))
      this.writeMessage(msg)
    }else{
      callback(-1,"",0,0)
    }
  }
}
