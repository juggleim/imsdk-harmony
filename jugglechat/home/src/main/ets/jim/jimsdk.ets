import { ConnStatus, JuggleIm } from 'juggleim'
import { PreferenceUtil } from './preferenceutil'
import { RealMessageUploadProvider } from './realmessageuploadprovider'
import { HarmonyPushManager } from './harmonypushmanager'

const CONNECT_STATUS_LISTENER_KEY:string = 'home_jimsdk_connect_status'
const JIM_INIT_TRACE_TAG:string = 'JIMTRACE'

class HomeConnectStatusListener {
  private connectCallback:(status:number, code:number) => void

  constructor(connectCallback:(status:number, code:number) => void) {
    this.connectCallback = connectCallback
  }

  onStatusChange(status:number, code:number, _userId:string):void{
    console.log("jimsdk_connect_status:",status,"\tcode:",code)
    if(status == ConnStatus.connected){
      void HarmonyPushManager.instance.onImConnected()
    }
    this.connectCallback(status, code)
  }

  onDbOpen():void{
    console.log("jimsdk_db_open")
  }

  onDbClose():void{
    console.log("jimsdk_db_close")
  }
}

export async function initJuggleIm(connectCallback:(status:number,code:number)=>void){
  console.log(`${JIM_INIT_TRACE_TAG} init_juggleim_start: imServer=${PreferenceUtil.getJImServer()}, appServer=${PreferenceUtil.getJChatServer()}, appkey=${PreferenceUtil.getAppkey()}`)
  JuggleIm.instance.init(PreferenceUtil.getJImServer(),PreferenceUtil.getAppkey())
  JuggleIm.instance.setAppServerUrl(PreferenceUtil.getJChatServer())
  JuggleIm.instance.getMessageManager().setMessageUploadProvider(new RealMessageUploadProvider())
  JuggleIm.instance.getConnectionManager().addConnectStatusListener(CONNECT_STATUS_LISTENER_KEY, new HomeConnectStatusListener(connectCallback))
  let cacheAuth = PreferenceUtil.getCacheAuth()
  if(cacheAuth!=undefined) {
    console.log(`${JIM_INIT_TRACE_TAG} init_juggleim_cached_auth: userId=${cacheAuth.user_id}, tokenLength=${cacheAuth.im_token.length}`)
    JuggleIm.instance.getConnectionManager()
      .connect(cacheAuth.im_token)
  }else{
    console.log(`${JIM_INIT_TRACE_TAG} init_juggleim_no_cached_auth`)
  }
}
