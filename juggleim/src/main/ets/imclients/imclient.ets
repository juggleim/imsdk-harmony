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
      console.log(`CONNTRACE client_connect_skip: address=${JuggleIm.instance.config.address}, appkey=${JuggleIm.instance.config.appkey}, tokenLength=${token?.length ?? 0}`)
      return
    }
    this.token = token
    this.suppressReconnect = false
    this.networkReconnectPending = false
    this.clearReconnectTimer()
    console.log(`CONNTRACE client_connect_before_refresh: status=${this.status}, networkAvailable=${this.networkAvailable}, pending=${this.networkReconnectPending}, tokenLength=${token.length}`)
    this.refreshNetworkState()
    console.log(`CONNTRACE client_connect_after_refresh: status=${this.status}, networkAvailable=${this.networkAvailable}, pending=${this.networkReconnectPending}`)
    if(!this.networkAvailable){
      this.networkReconnectPending = true
      this.status = ConnStatus.waiting
      console.log(`CONNTRACE client_connect_wait_network: status=${this.status}, pending=${this.networkReconnectPending}`)
      this.setConnectStatus(this.status, -3, JuggleIm.instance.userId)
      return
    }
    if (this.status === ConnStatus.connecting||this.status === ConnStatus.connected){
      return
    }
    this.status = ConnStatus.connecting
    console.log(`CONNTRACE client_connect_begin: address=${JuggleIm.instance.config.address}, tokenLength=${token.length}, appkey=${JuggleIm.instance.config.appkey}, userId=${JuggleIm.instance.userId}`)
    this.setConnectStatus(this.status,0,"")

    this.wsSocket = webSocket.createWebSocket()
    this.wsSocket.on('open',(err,value)=>{
      console.log(`CONNTRACE ws_open: err=${JSON.stringify(err)}, value=${JSON.stringify(value)}`)
      console.log(`PUSHTRACE connect_payload_prepare: pushChannel=${JuggleIm.instance.config.pushChannel}, pushTokenLength=${JuggleIm.instance.config.pushToken.length}, packageName=${JuggleIm.instance.config.packageName}`)
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
      console.log(`CONNTRACE ws_error: ${JSON.stringify(err)}`)
      console.log("jimsdk_connect_error:",JSON.stringify(err))
      this.handleSocketFailure(-1, JSON.stringify(err))
    })

    this.wsSocket.on('close',(_err,value)=>{
      console.log(`CONNTRACE ws_close: err=${JSON.stringify(_err)}, value=${JSON.stringify(value)}, suppressReconnect=${this.suppressReconnect}`)
      console.log("jimsdk_socket_close:",JSON.stringify(value))
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
      console.log(`CONNTRACE ws_message: err=${JSON.stringify(err)}, isString=${typeof value === 'string'}`)
      if (typeof value === 'string'){

      }else{
        let msg = imconnect.ImWebsocketMsg.decode(JimUtil.arrayBufferToUint8Array(value))
        console.log(`CONNTRACE ws_message_cmd: cmd=${msg.cmd}`)
        console.log("jimsdk_receive:",msg.cmd)
        this.onReceive(msg)
      }
    })
    let requestOptions: webSocket.WebSocketRequestOptions = {
      header: this.buildConnectRequestHeader(token)
    }
    console.log(`CONNTRACE ws_connect_request: headerKeys=${Object.keys(requestOptions.header as Object).join(',')}`)
    this.wsSocket.connect(JuggleIm.instance.config.address, requestOptions)
      .then((value)=>{
        console.log(`CONNTRACE ws_connect_promise_ok: ${JSON.stringify(value)}`)
        console.log("jimsdk_connect_succ:",JSON.stringify(value))
      })
      .catch((err:BusinessError)=>{
        console.error(`CONNTRACE ws_connect_promise_fail: ${JSON.stringify(err)}`)
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
    console.log(`CONNTRACE client_reconnect_call: tokenLength=${this.token.length}, status=${this.status}`)
    this.clearReconnectTimer()
    this.networkReconnectPending = false
    this.closeSocket(true)
    this.resetSocketAfterClose()
    this.connect(this.token)
  }

  disconnect(receivePush:boolean){
    console.log(`CONNTRACE client_disconnect_call: receivePush=${receivePush}, status=${this.status}, hasSocket=${this.wsSocket != undefined}`)
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
      console.log(`CONNTRACE client_disconnect_send: ext=${ext}, userId=${this.userId}`)
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
      console.log(`CONNTRACE client_disconnect_socket_missing`)
      this.closeSocket(true)
      return
    }
    console.log(`CONNTRACE client_disconnect_send_begin: cmd=${wsMsg.cmd}`)
    let data = imconnect.ImWebsocketMsg.encode(wsMsg).finish()
    socket.send(data.buffer)
      .then(()=>{
        console.log(`CONNTRACE client_disconnect_send_ok`)
        setTimeout(()=>{
          this.closeSocket(true, socket)
        }, 100)
      })
      .catch((err:BusinessError)=>{
        console.error(`CONNTRACE client_disconnect_send_fail: ${JSON.stringify(err)}`)
        console.error("jimsdk_disconnect_send_fail:",JSON.stringify(err))
        this.closeSocket(true, socket)
      })
  }

  private closeSocket(clearCache:boolean, targetSocket?:webSocket.WebSocket){
    let socket = targetSocket ?? this.wsSocket
    if(socket == undefined){
      console.log(`CONNTRACE client_close_socket_skip: socketMissing=true`)
      return
    }
    let isCurrentSocket = targetSocket == undefined || this.wsSocket == socket
    console.log(`CONNTRACE client_close_socket: clearCache=${clearCache}, isCurrentSocket=${isCurrentSocket}, hasCurrentSocket=${this.wsSocket != undefined}`)
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
      console.log(`CONNTRACE client_close_socket_done: hasSocket=${this.wsSocket != undefined}`)
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
    console.log(`jimsdk_socket_failure: code=${code}, reason=${reason}`)
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
      console.log(`jimsdk_reconnect_deferred: reasonCode=${reasonCode}, networkAvailable=${this.networkAvailable}`)
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
    console.log(`jimsdk_reconnect_scheduled: delay=${delay}, reasonCode=${reasonCode}, attempt=${this.reconnectAttempt}`)
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
      console.log(`CONNTRACE net_available_event: netId=${netHandle.netId}, status=${this.status}, pending=${this.networkReconnectPending}, suppressReconnect=${this.suppressReconnect}, tokenLength=${this.token.length}`)
      this.networkAvailable = true
      this.updateConnectNetworkState(netHandle)
      console.log(`jimsdk_network_available: netId=${netHandle.netId}, pending=${this.networkReconnectPending}, status=${this.status}`)
      if(this.networkReconnectPending && !this.suppressReconnect && !JimUtil.isEmpty(this.token ?? '') && this.status !== ConnStatus.connected && this.status !== ConnStatus.connecting){
        this.networkReconnectPending = false
        this.clearReconnectTimer()
        console.log(`CONNTRACE net_available_trigger_connect: netId=${netHandle.netId}, tokenLength=${this.token.length}`)
        this.connect(this.token)
      }
    })
    this.netConnection.on('netLost', (_netHandle)=>{
      console.log(`CONNTRACE net_lost_event: status=${this.status}, pending=${this.networkReconnectPending}, suppressReconnect=${this.suppressReconnect}`)
      this.onNetworkUnavailable('netLost')
    })
  }

  private onNetworkUnavailable(reason:string):void{
    console.log(`CONNTRACE network_unavailable_enter: reason=${reason}, status=${this.status}, networkAvailable=${this.networkAvailable}, pending=${this.networkReconnectPending}, tokenLength=${this.token.length}`)
    this.networkAvailable = false
    if(this.suppressReconnect){
      return
    }
    this.networkReconnectPending = !JimUtil.isEmpty(this.token ?? '')
    this.clearReconnectTimer()
    if(this.status === ConnStatus.connected || this.status === ConnStatus.connecting){
      console.log(`jimsdk_network_unavailable: reason=${reason}, status=${this.status}, pending=${this.networkReconnectPending}`)
      this.closeSocket(true)
      this.resetSocketAfterClose()
      this.status = ConnStatus.waiting
      this.setConnectStatus(this.status, -3, JuggleIm.instance.userId)
      return
    }
    console.log(`jimsdk_network_unavailable: reason=${reason}, status=${this.status}, pending=${this.networkReconnectPending}`)
  }

  private refreshNetworkState():void{
    try{
      let previousAvailable = this.networkAvailable
      console.log(`CONNTRACE refresh_network_state_begin: status=${this.status}, networkAvailable=${previousAvailable}, pending=${this.networkReconnectPending}`)
      let netHandle = connection.getDefaultNetSync()
      console.log(`CONNTRACE refresh_network_state_handle: netId=${netHandle.netId}`)
      let probedAvailable = netHandle.netId != 0
      if(probedAvailable){
        this.networkAvailable = true
        this.updateConnectNetworkState(netHandle)
      }else if(!previousAvailable){
        this.networkAvailable = false
      }else{
        console.log(`CONNTRACE refresh_network_state_preserve: previousAvailable=${previousAvailable}, probedAvailable=${probedAvailable}`)
      }
      console.log(`CONNTRACE refresh_network_state_end: networkAvailable=${this.networkAvailable}, status=${this.status}`)
    }catch(err){
      console.error(`jimsdk_refresh_network_state_fail: ${JSON.stringify(err)}`)
      console.log(`CONNTRACE refresh_network_state_preserve_on_error: networkAvailable=${this.networkAvailable}, status=${this.status}`)
    }
  }

  private updateConnectNetworkState(netHandle:connection.NetHandle):void{
    if(netHandle.netId == 0){
      console.log(`CONNTRACE update_network_state_skip: netId=0`)
      return
    }
    try{
      console.log(`CONNTRACE update_network_state_begin: netId=${netHandle.netId}`)
      this.buildConnectNetworkInfo(netHandle)
      console.log(`CONNTRACE update_network_state_end: netId=${netHandle.netId}`)
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
        console.log(`CONNTRACE build_connect_network_info_skip: netId=0`)
        return connectNetworkInfo
      }
      let netCapabilities = connection.getNetCapabilitiesSync(currentNetHandle)
      connectNetworkInfo.networkId = this.mapBearersToNetworkId(netCapabilities.bearerTypes)
      let connectionProperties = connection.getConnectionPropertiesSync(currentNetHandle)
      if(connectionProperties.linkAddresses.length > 0){
        let linkAddress = connectionProperties.linkAddresses[0]
        connectNetworkInfo.clientIp = linkAddress.address.address
      }
      console.log(`CONNTRACE build_connect_network_info_done: netId=${currentNetHandle.netId}, networkId=${connectNetworkInfo.networkId}, clientIp=${connectNetworkInfo.clientIp}`)
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
    console.log(`CONNTRACE connect_header_built: headerCount=${headerPairs.length}, signKeyLength=${signKey.length}, connectExtLength=${JuggleIm.instance.config.connectExt.length}, headerKeys=${headerPairs.map((item)=>item.split(':')[0].replaceAll('"', '')).join(',')}`)
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

  async onReceive(wsMsg:imconnect.ImWebsocketMsg){
    if(wsMsg.cmd == Cmd.connectAck){
      clearTimeout(this.connectTimeoutId)
      this.connectTimeoutId = 0
      let code = wsMsg.ConnectAckMsgBody?.code
      console.log(`CONNTRACE connect_ack_received: code=${code}, userId=${wsMsg.ConnectAckMsgBody?.userId ?? ''}, session=${wsMsg.ConnectAckMsgBody?.session ?? ''}, ext=${wsMsg.ConnectAckMsgBody?.ext ?? ''}`)
      console.log("jimsdk_connectAck:",code)
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
          console.log(`CONNTRACE connect_ack_success: userId=${uid}, reconnectAttempt=${this.reconnectAttempt}, pushTokenLength=${JuggleIm.instance.config.pushToken.length}`)
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
      console.log(`CONNTRACE disconnect_frame_received: code=${code}, userId=${JuggleIm.instance.userId}`)
      if(typeof  code == 'number'){
        this.closeSocket(true)
        this.resetSocketAfterClose()
        JimDbManager.instance.closeDb()
        this.setConnectStatus(this.status,code,JuggleIm.instance.userId)
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
    console.log("jimsdk_initlis_size:",this.connectStatusListeners.length)
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
    console.log("jinsdk_initlis_trisize:",this.connectStatusListeners.length)
    this.connectStatusListeners.forEach((listener)=>{
      console.log("jimsdk_initlis_trigger:",status,reasonCode,userId)
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

  pushSwitch(isBackground:boolean):void{
    if(this.status !== ConnStatus.connected || JuggleIm.instance.userId == ''){
      return
    }
    let switchValue = isBackground ? 1 : 0
    let data = immessage.PushSwitch.encode(immessage.PushSwitch.create({
      "switch": switchValue
    })).finish()
    this.query('push_switch', JuggleIm.instance.userId, data, (code, _qryAck)=>{
      console.log(`jimsdk_push_switch_ack: code=${code}, isBackground=${isBackground}, userId=${JuggleIm.instance.userId}`)
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
      console.log("jimsdk_ping:",this.latestPingTime)
    }
  }
}
