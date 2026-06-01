import webSocket from '@ohos.net.webSocket'
import { connection } from '@kit.NetworkKit'
import { systemDateTime } from '@kit.BasicServicesKit';
import deviceInfo from '@ohos.deviceInfo'
import cryptoFramework from '@ohos.security.cryptoFramework'
import {JuggleIm} from '../juggleim'
import { JimDbManager } from '../dbs/dbmanager';
import {JimUtil} from '../commons/jimutil'
import { HashMap } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import {imconnect} from '../improto/imconnect.js'
import { immessage } from '../improto/immessage'
import {Cmd,newConnectMessage, newUserPublishMessage,newQueryMessage, newUserPubAckMessage,
  newPingMessag, newDisconnectMessage} from '../improto/connectmsg'
import { PreferenceUtil } from '../commons/preferenceutil';

export class ConnStatus{
  static readonly unknown = 0
  static readonly connecting = 1
  static readonly connected = 2
  static readonly fail = 3
  static readonly disconnected = 4
  static readonly waiting = 5
}

export type ConnStatusListener = (status:number,reasonCode:number,userId:string)=>void
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

class ConnectNetworkInfo{
  networkId:string = ''
  clientIp:string = ''
}

export class ImClient{
  index:number = 0
  status:number = ConnStatus.unknown
  token:string = ''
  userId:string = ''
  wsSocket?:webSocket.WebSocket
  private connectStatusListeners:ConnStatusListener[] = new Array()
  private connectTimeoutId:number = 0
  private reconnectTimerId:number = 0
  private publishCache: HashMap<number, PublishCallbackWrap> = new HashMap()
  private queryCache:HashMap<number,QueryCallbackWrap> = new HashMap()
  private publishListenerMap:HashMap<string,PublishListener> = new HashMap()

  private pingTaskId:number = 0
  private latestPingTime:number = 0
  private latestPongTime:number = 0
  private reconnectAttempt:number = 0
  private reconnectDelayMs:number = 3000
  private suppressReconnect:boolean = false
  private networkAvailable:boolean = false
  private networkReconnectPending:boolean = false
  private netConnection?:connection.NetConnection

  constructor() {
    this.initNetworkMonitor()
  }

  connect(token:string){
    if(JimUtil.isEmpty(JuggleIm.instance.config.address ?? '')||
    JimUtil.isEmpty(JuggleIm.instance.config.appkey ?? '')||
    JimUtil.isEmpty(token ?? '')){
      return
    }
    this.token = token
    this.suppressReconnect = false
    this.networkReconnectPending = false
    this.clearReconnectTimer()
    this.refreshNetworkState()
    if(!this.networkAvailable){
      this.networkReconnectPending = true
      this.status = ConnStatus.waiting
      this.setConnectStatus(this.status, -3, JuggleIm.instance.userId)
      return
    }
    if (this.status === ConnStatus.connecting||this.status === ConnStatus.connected){
      return
    }
    this.status = ConnStatus.connecting
    this.setConnectStatus(this.status,0,"")

    this.wsSocket = webSocket.createWebSocket()
    this.wsSocket.on('open',(err,value)=>{
      let networkInfo = this.buildConnectNetworkInfo()
      let wsMsg = newConnectMessage(imconnect.ConnectMsgBody.create({
        "sdkVersion":JuggleIm.instance.config.sdkVersion,
        "protoId":JuggleIm.instance.config.protoId,
        "appkey":JuggleIm.instance.config.appkey,
        "token":token,
        "platform":JuggleIm.instance.config.platform,
        "deviceId":JuggleIm.instance.config.deviceId,
        "networkId":networkInfo.networkId,
        "ispNum":'',
        "clientIp":networkInfo.clientIp,
        "pushToken":JuggleIm.instance.config.pushToken,
        "packageName":JuggleIm.instance.config.packageName,
        "pushChannel":JuggleIm.instance.config.pushChannel,
        "language":JuggleIm.instance.config.language,
        "instanceId":JuggleIm.instance.config.instanceId,
        "isBackend":JuggleIm.instance.config.isBackend,
        "voipToken":'',
        "ext":JuggleIm.instance.config.connectExt
      }))
      this.writeImWsMessage(wsMsg)
    })
    this.wsSocket.on('error',(err)=>{
      this.handleSocketFailure(-1, JSON.stringify(err))
    })

    this.wsSocket.on('close',(_err,value)=>{
      if(this.suppressReconnect){
        this.suppressReconnect = false
        this.resetSocketAfterClose()
        return
      }
      let code = value != undefined && value != null && value.code != undefined ? value.code : -1
      let reason = value != undefined && value != null && value.reason != undefined ? value.reason : ''
      this.handleSocketFailure(code, reason)
    })

    this.wsSocket.on('message',(err,value)=>{
      if (typeof value === 'string'){

      }else{
        let msg = imconnect.ImWebsocketMsg.decode(JimUtil.arrayBufferToUint8Array(value))
        this.onReceive(msg)
      }
    })
    let requestOptions: webSocket.WebSocketRequestOptions = {
      header: this.buildConnectRequestHeader(token)
    }
    this.wsSocket.connect(JuggleIm.instance.config.address, requestOptions)
      .then((value)=>{
      })
      .catch((err:BusinessError)=>{
        console.error("jimsdk_connect_fail:",JSON.stringify(err))
        this.closeSocket(true)
        this.status = ConnStatus.waiting
        this.setConnectStatus(this.status, err.code, JuggleIm.instance.userId)
        this.scheduleReconnect(err.code)
      })
    let timeoutId = setTimeout(()=>{
      if(this.status==ConnStatus.connecting){
        this.closeSocket(true)
        this.status = ConnStatus.waiting
        this.setConnectStatus(this.status,-2,JuggleIm.instance.userId)
        this.scheduleReconnect(-2)
      }
      this.connectTimeoutId = 0
    },5000)
    this.connectTimeoutId = timeoutId
  }

  reconnect(){
    this.clearReconnectTimer()
    this.networkReconnectPending = false
    this.closeSocket(true)
    this.resetSocketAfterClose()
    this.connect(this.token)
  }

  disconnect(receivePush:boolean){
    this.suppressReconnect = true
    this.networkReconnectPending = false
    this.clearReconnectTimer()
    this.reconnectAttempt = 0
    if(this.pingTaskId>0) {
      clearInterval(this.pingTaskId)
      this.pingTaskId = 0
    }
    if(this.status === ConnStatus.connected && this.wsSocket != undefined){
      let ext = receivePush ? 'receivePush=true' : 'receivePush=false'
      let wsMsg = newDisconnectMessage(imconnect.DisconnectMsgBody.create({
        code: 0,
        ext: ext
      }))
      this.sendDisconnectThenClose(wsMsg)
      this.status = ConnStatus.disconnected
      this.setConnectStatus(ConnStatus.disconnected,0,this.userId)
      return
    }
    this.closeSocket(true)
    this.status = ConnStatus.disconnected
    this.setConnectStatus(ConnStatus.disconnected,0,this.userId)
  }

  private sendDisconnectThenClose(wsMsg:imconnect.ImWebsocketMsg):void{
    let socket = this.wsSocket
    if(socket == undefined){
      this.closeSocket(true)
      return
    }
    let data = imconnect.ImWebsocketMsg.encode(wsMsg).finish()
    socket.send(data.buffer)
      .then(()=>{
        setTimeout(()=>{
          this.closeSocket(true, socket)
        }, 100)
      })
      .catch((err:BusinessError)=>{
        console.error("jimsdk_disconnect_send_fail:",JSON.stringify(err))
        this.closeSocket(true, socket)
      })
  }

  private closeSocket(clearCache:boolean, targetSocket?:webSocket.WebSocket){
    let socket = targetSocket ?? this.wsSocket
    if(socket == undefined){
      return
    }
    let isCurrentSocket = targetSocket == undefined || this.wsSocket == socket
    if(isCurrentSocket){
      if(this.connectTimeoutId > 0){
        clearTimeout(this.connectTimeoutId)
        this.connectTimeoutId = 0
      }
      if(clearCache){
        this.publishCache = new HashMap()
        this.queryCache = new HashMap()
      }
    }
    socket.off('open')
    socket.off('message')
    socket.off('error')
    socket.off('close')
    socket.close((err)=>{
      if(err){
        console.log("jimsdk_close_failed",err.code,"\t",err.message)
      }
      if(isCurrentSocket && this.wsSocket == socket){
        this.wsSocket = undefined
      }
    })
  }

  private resetSocketAfterClose():void{
    if(this.connectTimeoutId > 0){
      clearTimeout(this.connectTimeoutId)
      this.connectTimeoutId = 0
    }
    if(this.pingTaskId>0) {
      clearInterval(this.pingTaskId)
      this.pingTaskId = 0
    }
    this.publishCache = new HashMap()
    this.queryCache = new HashMap()
    this.wsSocket = undefined
    this.status = ConnStatus.disconnected
  }

  private handleSocketFailure(code:number, reason:string):void{
    if(this.status == ConnStatus.disconnected && !this.suppressReconnect){
      return
    }
    if(this.reconnectTimerId > 0){
      return
    }
    this.resetSocketAfterClose()
    this.status = ConnStatus.waiting
    this.setConnectStatus(this.status, code, JuggleIm.instance.userId)
    this.scheduleReconnect(code)
  }

  private scheduleReconnect(reasonCode:number):void{
    if(this.suppressReconnect || JimUtil.isEmpty(this.token ?? '')){
      return
    }
    if(!this.networkAvailable){
      this.networkReconnectPending = true
      this.clearReconnectTimer()
      this.status = ConnStatus.waiting
      this.setConnectStatus(this.status, reasonCode, JuggleIm.instance.userId)
      return
    }
    this.clearReconnectTimer()
    let delay = this.reconnectDelayMs
    if(this.reconnectAttempt > 0){
      let factor = this.reconnectAttempt > 5 ? 5 : this.reconnectAttempt
      delay = this.reconnectDelayMs * (factor + 1)
    }
    this.reconnectAttempt = this.reconnectAttempt + 1
    this.reconnectTimerId = setTimeout(()=>{
      this.reconnectTimerId = 0
      if(this.suppressReconnect || this.status === ConnStatus.connected || this.status === ConnStatus.connecting){
        return
      }
      this.connect(this.token)
    }, delay)
  }

  private clearReconnectTimer():void{
    if(this.reconnectTimerId > 0){
      clearTimeout(this.reconnectTimerId)
      this.reconnectTimerId = 0
    }
  }

  private initNetworkMonitor():void{
    if(this.netConnection != undefined){
      return
    }
    this.netConnection = connection.createNetConnection()
    this.netConnection.register((err)=>{
      if(err){
        console.error(`jimsdk_network_monitor_register_fail: ${JSON.stringify(err)}`)
      }
    })
    this.netConnection.on('netAvailable', (netHandle)=>{
      this.networkAvailable = true
      this.updateConnectNetworkState(netHandle)
      if(this.networkReconnectPending && !this.suppressReconnect && !JimUtil.isEmpty(this.token ?? '') && this.status !== ConnStatus.connected && this.status !== ConnStatus.connecting){
        this.networkReconnectPending = false
        this.clearReconnectTimer()
        this.connect(this.token)
      }
    })
    this.netConnection.on('netLost', (_netHandle)=>{
      this.onNetworkUnavailable('netLost')
    })
  }

  private onNetworkUnavailable(reason:string):void{
    this.networkAvailable = false
    if(this.suppressReconnect){
      return
    }
    this.networkReconnectPending = !JimUtil.isEmpty(this.token ?? '')
    this.clearReconnectTimer()
    if(this.status === ConnStatus.connected || this.status === ConnStatus.connecting){
      this.closeSocket(true)
      this.resetSocketAfterClose()
      this.status = ConnStatus.waiting
      this.setConnectStatus(this.status, -3, JuggleIm.instance.userId)
      return
    }
  }

  private refreshNetworkState():void{
    try{
      let previousAvailable = this.networkAvailable
      let netHandle = connection.getDefaultNetSync()
      let probedAvailable = netHandle.netId != 0
      if(probedAvailable){
        this.networkAvailable = true
        this.updateConnectNetworkState(netHandle)
      }else if(!previousAvailable){
        this.networkAvailable = false
      }
    }catch(err){
      console.error(`jimsdk_refresh_network_state_fail: ${JSON.stringify(err)}`)
    }
  }

  private updateConnectNetworkState(netHandle:connection.NetHandle):void{
    if(netHandle.netId == 0){
      return
    }
    try{
      this.buildConnectNetworkInfo(netHandle)
    }catch(err){
      console.error(`jimsdk_update_network_state_fail: ${JSON.stringify(err)}`)
    }
  }

  private buildConnectNetworkInfo(netHandle?:connection.NetHandle):ConnectNetworkInfo{
    let connectNetworkInfo = new ConnectNetworkInfo()
    try{
      let currentNetHandle = netHandle
      if(currentNetHandle == undefined){
        currentNetHandle = connection.getDefaultNetSync()
      }
      if(currentNetHandle.netId == 0){
        return connectNetworkInfo
      }
      let netCapabilities = connection.getNetCapabilitiesSync(currentNetHandle)
      connectNetworkInfo.networkId = this.mapBearersToNetworkId(netCapabilities.bearerTypes)
      let connectionProperties = connection.getConnectionPropertiesSync(currentNetHandle)
      if(connectionProperties.linkAddresses.length > 0){
        let linkAddress = connectionProperties.linkAddresses[0]
        connectNetworkInfo.clientIp = linkAddress.address.address
      }
    }catch(err){
      console.error(`jimsdk_build_connect_network_info_fail: ${JSON.stringify(err)}`)
    }
    return connectNetworkInfo
  }

  private buildConnectRequestHeader(token:string):Object{
    let headerPairs:string[] = []
    let addHeader = (key:string, value:string):void=>{
      headerPairs.push(`${JSON.stringify(key)}:${JSON.stringify(value)}`)
    }
    JuggleIm.instance.config.connectHeaders.forEach((value:string, key:string)=>{
      addHeader(key, value)
    })
    addHeader('x-appkey', JuggleIm.instance.config.appkey)
    addHeader('x-token', token)
    addHeader('x-platform', JuggleIm.instance.config.platform)
    addHeader('x-version', JuggleIm.instance.config.sdkVersion)
    addHeader('x-device', this.buildDeviceName())
    addHeader('x-device_id', JuggleIm.instance.config.deviceId)

    let signKey = JuggleIm.instance.config.connectSignKey.trim()
    let nonce = this.buildNonce()
    let timestamp = `${systemDateTime.getTime(false)}`
    addHeader('X-Nonce', nonce)
    addHeader('X-Timestamp', timestamp)
    addHeader('X-Signature', this.createSignature(nonce, timestamp, signKey))

    let headerJson = `{${headerPairs.join(',')}}`
    return JSON.parse(headerJson) as Object
  }

  private buildDeviceName():string{
    let brand = deviceInfo.brand.trim()
    let model = deviceInfo.productModel.trim()
    if(brand == ''){
      return model
    }
    if(model == ''){
      return brand
    }
    return `${brand}-${model}`
  }

  private buildNonce():string{
    let randomNum = Math.floor(Math.random() * 100000)
    return `${randomNum}`.padStart(5, '0')
  }

  private createSignature(nonce:string, timestamp:string, signKey:string):string{
    try{
      let mac = cryptoFramework.createMac('HMAC|SHA256')
      let keyGenerator = cryptoFramework.createSymKeyGenerator('HMAC|SHA256')
      let keyBlob: cryptoFramework.DataBlob = {
        data: JimUtil.stringToUint8Array(signKey)
      }
      let macKey = keyGenerator.convertKeySync(keyBlob)
      mac.initSync(macKey)
      let rawBlob: cryptoFramework.DataBlob = {
        data: JimUtil.stringToUint8Array(`${nonce}${timestamp}${signKey}`)
      }
      mac.updateSync(rawBlob)
      let digest = mac.doFinalSync()
      return this.bytesToHex(digest.data)
    }catch(err){
      console.error(`jimsdk_signature_fail: ${JSON.stringify(err)}`)
      return ''
    }
  }

  private bytesToHex(data:Uint8Array):string{
    let parts:string[] = []
    for(let i = 0; i < data.length; i++){
      parts.push(data[i].toString(16).padStart(2, '0'))
    }
    return parts.join('')
  }

  private mapBearersToNetworkId(bearerTypes:Array<connection.NetBearType>):string{
    if(bearerTypes == undefined || bearerTypes.length == 0){
      return ''
    }
    if(bearerTypes.indexOf(connection.NetBearType.BEARER_WIFI) >= 0){
      return 'wifi'
    }
    if(bearerTypes.indexOf(connection.NetBearType.BEARER_CELLULAR) >= 0){
      return '4G'
    }
    if(bearerTypes.indexOf(connection.NetBearType.BEARER_ETHERNET) >= 0){
      return 'ethernet'
    }
    if(bearerTypes.indexOf(connection.NetBearType.BEARER_BLUETOOTH) >= 0){
      return 'bluetooth'
    }
    if(bearerTypes.indexOf(connection.NetBearType.BEARER_VPN) >= 0){
      return 'vpn'
    }
    return ''
  }

  writeImWsMessage(wsMsg:imconnect.ImWebsocketMsg){
    let data = imconnect.ImWebsocketMsg.encode(wsMsg).finish()
    this.wsSocket?.send(data.buffer)
      .then((value)=>{
      })
      .catch((err:BusinessError)=>{
        console.error("jimsdk_send_fail:",JSON.stringify(err))
      })
  }

  async onReceive(wsMsg:imconnect.ImWebsocketMsg){
    if(wsMsg.cmd == Cmd.connectAck){
      clearTimeout(this.connectTimeoutId)
      this.connectTimeoutId = 0
      let code = wsMsg.ConnectAckMsgBody?.code
      if(typeof code == 'number'){
        if (code === 0){
          this.status = ConnStatus.connected
          this.reconnectAttempt = 0
          this.clearReconnectTimer()
          this.networkReconnectPending = false
          let uid = wsMsg.ConnectAckMsgBody?.userId as string
          JuggleIm.instance.userInfo.userId = uid
          JuggleIm.instance.userId = uid
          this.userId = uid
          PreferenceUtil.setUserIdByToken(JuggleIm.instance.config.appkey,this.token,uid)
          //start ping
          this.pingTaskId = setInterval(()=>{
            this.ping()
          },30000)
        }else{
          this.status = ConnStatus.fail
        }
        this.setConnectStatus(this.status,code,JuggleIm.instance.userId)
      }
    }else if (wsMsg.cmd == Cmd.disconnect){
      let code = wsMsg.disconnectMsgBody?.code
      if(typeof  code == 'number'){
        this.closeSocket(true)
        this.resetSocketAfterClose()
        JimDbManager.instance.closeDb()
        this.setConnectStatus(this.status,code,JuggleIm.instance.userId)
      }
    }else if(wsMsg.cmd == Cmd.publish){
      let body = wsMsg.publishMsgBody
      if(body!=null&&body!=undefined){
        this.triggerPublish(body)
      }
    }else if(wsMsg.cmd == Cmd.publishAck){
      let body = wsMsg.pubAckMsgBody
      if (body!=null&&body!=undefined){
        let code = body.code
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

  private setConnectStatus(status:number,reasonCode:number,userId:string){
    this.connectStatusListeners.forEach((listener)=>{
      listener(status,reasonCode,userId)
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

  pushSwitch(isBackground:boolean):void{
    if(this.status !== ConnStatus.connected || JuggleIm.instance.userId == ''){
      return
    }
    let switchValue = isBackground ? 1 : 0
    let data = immessage.PushSwitch.encode(immessage.PushSwitch.create({
      "switch": switchValue
    })).finish()
    this.query('push_switch', JuggleIm.instance.userId, data, (code, _qryAck)=>{
    })
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
    }
  }
}
