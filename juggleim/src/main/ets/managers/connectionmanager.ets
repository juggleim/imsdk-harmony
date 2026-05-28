import { JuggleIm } from '../juggleim'
import { PreferenceUtil } from '../commons/preferenceutil'
import { JimDbManager } from '../dbs/dbmanager'
import {ImClient,ConnStatus,ConnStatusListener} from '../imclients/imclient'
import { IConnectionManager } from '../interfaces/iconnectionmanager'
import { ChatroomManager } from './chatroommanager'
import { CommonCallback } from '../interfaces/commoncallback'
import { pushtoken } from '../improto/pushtoken.js'
import { JimErrorCode } from '../entries/errcode'
import { PushChannel, pushChannelToConnectName, pushChannelToDisplayName } from '../entries/push'
import { JimUtil } from '../commons/jimutil'

const PUSH_TRACE_TAG:string = 'PUSHTRACE'
const PUSH_PLATFORM_ANDROID:number = 1

export class ConnectionManager implements IConnectionManager {
  private imclient:ImClient
  private pushChannel:PushChannel = PushChannel.DefaultChannel
  private pushToken:string = ''

  constructor(imclient:ImClient) {
    this.imclient = imclient
  }

  connect(token:string){
    JuggleIm.instance.config.authToken = token
    if(!JimDbManager.instance.hasInit){
      let userId = PreferenceUtil.getUserIdByToken(JuggleIm.instance.config.appkey,token)
      if(userId!=''){
        JuggleIm.instance.initDb(userId)
      }
    }
    this.imclient.connect(token)
  }

  disconnect(receivePush:boolean = false){
    (JuggleIm.instance.getChatroomManager() as ChatroomManager).userDisconnect()
    this.imclient.disconnect(!receivePush)
    JimDbManager.instance.closeDb()
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

  setConnectParams(params:Map<string, string>):void{
    JuggleIm.instance.config.connectParams = params
    let serialized = ''
    if(params.size > 0){
      serialized = JSON.stringify(JimUtil.map2Obj(params))
    }
    JuggleIm.instance.config.connectExt = serialized
  }

  addConnectStatusListener(l:ConnStatusListener){
    this.imclient.addConnectStatusListener(l)
  }

  removeConnectStatusListener(l:ConnStatusListener){
    this.imclient.removeConnectStatusListener(l)
  }
}
