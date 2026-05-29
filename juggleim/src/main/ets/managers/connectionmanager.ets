import { JuggleIm } from '../juggleim'
import { PreferenceUtil } from '../commons/preferenceutil'
import { DbLifecycleListener, JimDbManager } from '../dbs/dbmanager'
import {ImClient,ConnStatus} from '../imclients/imclient'
import { ConnectionStatusListenerValue, IConnectionManager } from '../interfaces/iconnectionmanager'
import { ChatroomManager } from './chatroommanager'
import { CommonCallback } from '../interfaces/commoncallback'
import { pushtoken } from '../improto/pushtoken.js'
import { JimErrorCode } from '../entries/errcode'
import { PushChannel, pushChannelToConnectName, pushChannelToDisplayName } from '../entries/push'
import { JimUtil } from '../commons/jimutil'
import { StringMapItem } from '../commons/jimutil'
import { JSON } from '@kit.ArkTS'

const PUSH_TRACE_TAG:string = 'PUSHTRACE'
const PUSH_PLATFORM_ANDROID:number = 1

class ConnectExtParams {
  signKey:string = ''
  headers:StringMapItem[] = []
  params:StringMapItem[] = []
}

class ConnectStatusListenerRecord {
  key:string = ''
  listener:ConnectionStatusListenerValue

  constructor(listener:ConnectionStatusListenerValue, key:string = '') {
    this.listener = listener
    this.key = key
  }
}

export class ConnectionManager implements IConnectionManager {
  private imclient:ImClient
  private pushChannel:PushChannel = PushChannel.DefaultChannel
  private pushToken:string = ''
  private connectInitPending:boolean = false
  private connectInitSeq:number = 0
  private connectStatusListeners:ConnectStatusListenerRecord[] = []
  private dbLifecycleListener:DbLifecycleListener = {
    onDbOpen: ()=>{
      this.notifyDbOpen()
    },
    onDbClose: ()=>{
      this.notifyDbClose()
    }
  }

  constructor(imclient:ImClient) {
    this.imclient = imclient
    this.imclient.addConnectStatusListener(this.onConnectStatusChanged)
    JimDbManager.instance.addDbLifecycleListener(this.dbLifecycleListener)
  }

  connect(token:string){
    if(this.connectInitPending){
      return
    }
    JuggleIm.instance.config.authToken = token
    if(!JimDbManager.instance.hasInit){
      let userId = PreferenceUtil.getUserIdByToken(JuggleIm.instance.config.appkey,token)
      if(userId!=''){
        this.connectInitPending = true
        let initSeq = ++this.connectInitSeq
        JuggleIm.instance.initDb(userId)
          .then(()=>{
            if(initSeq != this.connectInitSeq || !this.connectInitPending){
              return
            }
            this.connectInitPending = false
            this.imclient.connect(token)
          })
          .catch((err)=>{
            if(initSeq != this.connectInitSeq){
              return
            }
            this.connectInitPending = false
            console.error(`jimsdk_init_db_fail: ${JSON.stringify(err)}`)
            this.imclient.connect(token)
          })
        return
      }
    }
    this.imclient.connect(token)
  }

  disconnect(receivePush:boolean = false){
    this.connectInitSeq++
    this.connectInitPending = false
    (JuggleIm.instance.getChatroomManager() as ChatroomManager).userDisconnect()
    JimDbManager.instance.closeDb()
    this.imclient.disconnect(receivePush)
  }

  registerPushToken(channel:PushChannel, token:string, callback?:CommonCallback):void{
    let normalizedToken = token.trim()
    let packageName = JuggleIm.instance.config.packageName
    this.pushChannel = channel
    this.pushToken = normalizedToken
    JuggleIm.instance.config.pushChannel = pushChannelToConnectName(channel)
    JuggleIm.instance.config.pushToken = normalizedToken
    console.log(`${PUSH_TRACE_TAG} sdk_register_push_token_call: channel=${pushChannelToDisplayName(channel)}, tokenLength=${normalizedToken.length}, packageName=${packageName}, connStatus=${this.imclient.status}, userId=${JuggleIm.instance.userId}`)
    if(normalizedToken == ''){
      callback?.(new JimErrorCode().InvalidParam)
      return
    }
    if(this.imclient.status != ConnStatus.connected || JuggleIm.instance.userId == ''){
      console.log(`${PUSH_TRACE_TAG} sdk_register_push_token_deferred: channel=${pushChannelToDisplayName(channel)}, tokenLength=${normalizedToken.length}`)
      callback?.(new JimErrorCode().ConnectionUnavaliable)
      return
    }
    let data = pushtoken.RegPushTokenReq.encode(pushtoken.RegPushTokenReq.create({
      deviceId: JuggleIm.instance.config.deviceId,
      platform: PUSH_PLATFORM_ANDROID,
      pushChannel: channel,
      pushToken: normalizedToken,
      packageName: packageName
    })).finish()
    this.imclient.query('reg_push_token', JuggleIm.instance.userId, data, (code, _qryAck)=>{
      console.log(`${PUSH_TRACE_TAG} sdk_register_push_token_ack: channel=${pushChannelToDisplayName(channel)}, code=${code}, userId=${JuggleIm.instance.userId}`)
      callback?.(code)
    })
  }

  setLanguage(language:string):void{
    JuggleIm.instance.config.language = language.trim()
  }

  getLanguage():string{
    return JuggleIm.instance.config.language
  }

  getConnectionStatus():number{
    return this.imclient.status
  }

  pushSwitch(isBackground:boolean):void{
    console.log(`jimsdk_push_switch_call: isBackground=${isBackground}, connStatus=${this.imclient.status}, userId=${JuggleIm.instance.userId}`)
    this.imclient.pushSwitch(isBackground)
  }

  setConnectParams(params:Map<string, string>):void
  setConnectParams(signKey:string, headers:Map<string, string>):void
  setConnectParams(arg1:Map<string, string>|string, arg2?:Map<string, string>):void{
    if(typeof arg1 === 'string'){
      JuggleIm.instance.config.connectSignKey = arg1.trim()
      JuggleIm.instance.config.connectHeaders = arg2 ?? new Map<string, string>()
    }else{
      JuggleIm.instance.config.connectParams = arg1
    }
    this.refreshConnectExt()
  }

  addConnectStatusListener(l:ConnectionStatusListenerValue):void
  addConnectStatusListener(key:string, l:ConnectionStatusListenerValue):void
  addConnectStatusListener(arg1:string|ConnectionStatusListenerValue, arg2?:ConnectionStatusListenerValue):void{
    if(typeof arg1 === 'string'){
      let normalizedKey = arg1.trim()
      if(normalizedKey == '' || arg2 == undefined){
        return
      }
      this.removeConnectStatusListener(normalizedKey)
      this.connectStatusListeners.push(new ConnectStatusListenerRecord(arg2, normalizedKey))
      return
    }
    this.connectStatusListeners.push(new ConnectStatusListenerRecord(arg1))
  }

  removeConnectStatusListener(l:ConnectionStatusListenerValue):void
  removeConnectStatusListener(key:string):void
  removeConnectStatusListener(arg1:ConnectionStatusListenerValue|string):void{
    if(typeof arg1 === 'string'){
      let normalizedKey = arg1.trim()
      if(normalizedKey == ''){
        return
      }
      for(let i=0;i<this.connectStatusListeners.length;i++){
        let record = this.connectStatusListeners[i]
        if(record.key == normalizedKey){
          this.connectStatusListeners.splice(i,1)
          break
        }
      }
      return
    }
    for(let i=0;i<this.connectStatusListeners.length;i++){
      if(this.connectStatusListeners[i].listener===arg1){
        this.connectStatusListeners.splice(i,1)
        break
      }
    }
  }

  private onConnectStatusChanged = (status:number, reasonCode:number, userId:string)=>{
    this.notifyStatusChange(status, reasonCode, userId)
  }

  private notifyStatusChange(status:number, reasonCode:number, userId:string):void{
    this.connectStatusListeners.forEach((listener)=>{
      if(typeof listener.listener === 'function'){
        listener.listener(status, reasonCode, userId)
      }else{
        listener.listener.onStatusChange(status, reasonCode, userId)
      }
    })
  }

  private notifyDbOpen():void{
    this.connectStatusListeners.forEach((listener)=>{
      if(typeof listener.listener !== 'function'){
        listener.listener.onDbOpen?.()
      }
    })
  }

  private notifyDbClose():void{
    this.connectStatusListeners.forEach((listener)=>{
      if(typeof listener.listener !== 'function'){
        listener.listener.onDbClose?.()
      }
    })
  }

  private refreshConnectExt():void{
    let signKey = JuggleIm.instance.config.connectSignKey.trim()
    let headers = JuggleIm.instance.config.connectHeaders
    let params = JuggleIm.instance.config.connectParams
    if(signKey == '' && headers.size == 0){
      JuggleIm.instance.config.connectExt = params.size > 0 ? JSON.stringify(JimUtil.map2Obj(params)) : ''
      return
    }
    let payload = new ConnectExtParams()
    payload.signKey = signKey
    if(headers.size > 0){
      payload.headers = JimUtil.map2Obj(headers)
    }
    if(params.size > 0){
      payload.params = JimUtil.map2Obj(params)
    }
    JuggleIm.instance.config.connectExt = JSON.stringify(payload)
  }
}
