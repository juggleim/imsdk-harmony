import webSocket from '@ohos.net.webSocket'
import { systemDateTime } from '@kit.BasicServicesKit';
import {JuggleIm} from '../juggleim'
import {JimUtil} from '../commons/jimutil'
import { HashMap } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import {imconnect} from '../improto/imconnect.js'
import {Cmd,newConnectMessage, newUserPublishMessage,newQueryMessage, newUserPubAckMessage,
  newPingMessag} from '../improto/connectmsg'

export class ConnStatus{
  static readonly unknown = 0
  static readonly connecting = 1
  static readonly connected = 2
  static readonly fail = 3
  static readonly disconnected = 4
}

export type ConnStatusListener = (status:number,reasonCode:number)=>void
export type PublishCallback = (code:number,pubAck:imconnect.IPublishAckMsgBody)=>void
export type QueryCallback = (code:number,qryAck:imconnect.IQueryAckMsgBody)=>void
export type PublishListener = (index:number,data:Uint8Array)=>void


class PublishCallbackWrap{
  callback:PublishCallback
  timeoutId:number
  constructor(callback:PublishCallback,timeoutId:number) {
    this.callback = callback
    this.timeoutId = timeoutId
  }
}

class QueryCallbackWrap{
  callback:QueryCallback
  timeoutId:number
  constructor(callback:QueryCallback,timeoutId:number) {
    this.callback = callback
    this.timeoutId = timeoutId
  }
}

export class ImClient{
  index:number = 0
  status:number = ConnStatus.unknown
  wsSocket?:webSocket.WebSocket
  private connectStatusListeners:ConnStatusListener[] = new Array()
  private connectTimeoutId:number = 0
  private publishCache: HashMap<number, PublishCallbackWrap> = new HashMap()
  private queryCache:HashMap<number,QueryCallbackWrap> = new HashMap()
  private publishListenerMap:HashMap<string,PublishListener> = new HashMap()

  private pingTaskId:number = 0
  private latestPingTime:number = 0
  private latestPongTime:number = 0

  constructor() {
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
      let wsMsg = newConnectMessage(imconnect.ConnectMsgBody.create({
        "protoId":JuggleIm.instance.config.protoId,
        "appkey":JuggleIm.instance.config.appkey,
        "token":token,
        "platform":JuggleIm.instance.config.platform
      }))
      this.writeImWsMessage(wsMsg)
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
    if(this.pingTaskId>0) {
      clearInterval(this.pingTaskId)
    }
    this.close()
  }

  private close(){
    this.wsSocket?.off('open')
    this.wsSocket?.off('message')
    this.wsSocket?.off('error')
    this.wsSocket?.close((err)=>{
      if(err){
        console.log("jimsdk_close_failed",err.code,"\t",err.message)
      }
      this.status = ConnStatus.disconnected
      this.wsSocket = undefined
    })
  }

  writeImWsMessage(wsMsg:imconnect.ImWebsocketMsg){
    console.log("jimsdk_begin_send")
    let data = imconnect.ImWebsocketMsg.encode(wsMsg).finish()
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
          JuggleIm.instance.userInfo.userId = wsMsg.ConnectAckMsgBody?.userId as string
          //start ping
          this.pingTaskId = setInterval(()=>{
            this.ping()
          },30000)
          //sync offline msg
          JuggleIm.instance.getMessageManager().syncMsgs(0)
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
      let body = wsMsg.publishMsgBody
      if(body!=null&&body!=undefined){
        console.log("jimsdk_onpublish",body)
        this.triggerPublish(body)
      }
    }else if(wsMsg.cmd == Cmd.publishAck){
      let body = wsMsg.pubAckMsgBody
      if (body!=null&&body!=undefined){
        let code = body.code
        console.log("jimsdk_puback code:",code)
        let index = body.index
        if (this.publishCache.hasKey(index)){
          if(typeof code == 'number'){
            let wrap = this.publishCache.get(index)
            clearTimeout(wrap.timeoutId)
            wrap.callback(code,body)
          }
        }
      }
    }else if(wsMsg.cmd == Cmd.queryAck){
      let body = wsMsg.qryAckMsgBody
      if(body!=null&&body!=undefined){
        let code = body.code
        console.log("jimsdk_qryack code:",code)
        let index = body.index
        if(this.queryCache.hasKey(index)){
          if(typeof code == 'number'){
            let wrap = this.queryCache.get(index)
            clearTimeout(wrap.timeoutId)
            wrap.callback(code,body)
          }
        }
      }
    }else if(wsMsg.cmd == Cmd.pong){
      this.latestPongTime = systemDateTime.getTime(false)
      console.log("jimsdk_pong:",this.latestPongTime)
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

  registePublishListener(topic:string,l:PublishListener){
    this.publishListenerMap.set(topic,l)
  }

  unregistePublishListener(topic:string){
    this.publishListenerMap.remove(topic)
  }

  private triggerPublish(pubBody:imconnect.IPublishMsgBody){
    let topic = pubBody.topic as string
    if(this.publishListenerMap.hasKey(topic)){
      let listener = this.publishListenerMap.get(topic)
      listener(pubBody.index as number,pubBody.data as Uint8Array)
    }else{
      console.log("un support topic:",topic)
    }
  }

  publish(method:string,targetId:string,data:Uint8Array,callback:PublishCallback){
    if(this.status === ConnStatus.connected){
      let index = this.getIndex()
      let wsMsg = newUserPublishMessage(imconnect.PublishMsgBody.create({
        "index":index,
        "topic":method,
        "targetId":targetId,
        "data":data
      }))
      let timeoutId = setTimeout(()=>{
        if(this.publishCache.hasKey(index)){
          callback(-2,new imconnect.PublishAckMsgBody())
          this.publishCache.remove(index)
        }
      },5000)
      this.publishCache.set(index,new PublishCallbackWrap(callback,timeoutId))
      this.writeImWsMessage(wsMsg)
    }else{
      callback(-1,new imconnect.PublishAckMsgBody())
    }
  }

  query(method:string,targetId:string,data:Uint8Array,callback:QueryCallback){
    if(this.status === ConnStatus.connected){
      let index = this.getIndex()
      let wsMsg = newQueryMessage(imconnect.QueryMsgBody.create({
        "index":index,
        "topic":method,
        "targetId":targetId,
        "data":data
      }))
      let timeoutId = setTimeout(()=>{
        if(this.queryCache.hasKey(index)){
          callback(-2,new imconnect.QueryAckMsgBody())
          this.queryCache.remove(index)
        }
      },5000)
      this.queryCache.set(index,new QueryCallbackWrap(callback,timeoutId))
      this.writeImWsMessage(wsMsg)
    }else{
      callback(-1,new imconnect.QueryAckMsgBody())
    }
  }

  pubAck(index:number){
    if(this.status === ConnStatus.connected) {
      let wsMsg = newUserPubAckMessage(imconnect.PublishAckMsgBody.create({
        "index": index
      }))
      this.writeImWsMessage(wsMsg)
    }
  }

  ping(){
    if(this.status === ConnStatus.connected){
      this.latestPingTime = systemDateTime.getTime(false)
      let wsMsg = newPingMessag()
      this.writeImWsMessage(wsMsg)
      console.log("jimsdk_ping:",this.latestPingTime)
    }
  }
}