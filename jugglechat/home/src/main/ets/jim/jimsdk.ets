import { ConnStatus, JuggleIm } from 'juggleim'
import { PreferenceUtil } from './preferenceutil'
import { RealMessageUploadProvider } from './realmessageuploadprovider'
import { HarmonyPushManager } from './harmonypushmanager'

const CONNECT_STATUS_LISTENER_KEY:string = 'home_jimsdk_connect_status'

class HomeConnectStatusListener {
  private connectCallback:(status:number, code:number) => void

  constructor(connectCallback:(status:number, code:number) => void) {
    this.connectCallback = connectCallback
  }

  onStatusChange(status:number, code:number, _userId:string):void{
    if(status == ConnStatus.connected){
      void HarmonyPushManager.instance.onImConnected()
    }
    this.connectCallback(status, code)
  }

  onDbOpen():void{
  }

  onDbClose():void{
  }
}

/**
 * Initializes the SDK and restores cached auth if available.
 *
 * Example:
 * ```ts
 * await initJuggleIm((status, code) => {
 *   console.log(status, code)
 * })
 * ```
 */
export async function initJuggleIm(connectCallback:(status:number,code:number)=>void){
  JuggleIm.instance.init(PreferenceUtil.getJImServer(),PreferenceUtil.getAppkey())
  JuggleIm.instance.setAppServerUrl(PreferenceUtil.getJChatServer())
  JuggleIm.instance.getMessageManager().setMessageUploadProvider(new RealMessageUploadProvider())
  JuggleIm.instance.getConnectionManager().addConnectStatusListener(CONNECT_STATUS_LISTENER_KEY, new HomeConnectStatusListener(connectCallback))
  let cacheAuth = PreferenceUtil.getCacheAuth()
  if(cacheAuth!=undefined) {
    JuggleIm.instance.getConnectionManager()
      .connect(cacheAuth.im_token)
  }
}
