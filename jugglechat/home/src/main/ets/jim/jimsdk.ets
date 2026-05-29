import { ConnStatus, JuggleIm } from 'juggleim'
import { PreferenceUtil } from './preferenceutil'
import { RealMessageUploadProvider } from './realmessageuploadprovider'
import { HarmonyPushManager } from './harmonypushmanager'

const CONNECT_STATUS_LISTENER_KEY:string = 'home_jimsdk_connect_status'

export async function initJuggleIm(connectCallback:(status:number,code:number)=>void){
  JuggleIm.instance.init(PreferenceUtil.getJImServer(),PreferenceUtil.getAppkey())
  JuggleIm.instance.setAppServerUrl(PreferenceUtil.getJChatServer())
  JuggleIm.instance.getMessageManager().setMessageUploadProvider(new RealMessageUploadProvider())
  JuggleIm.instance.getConnectionManager().addConnectStatusListener(CONNECT_STATUS_LISTENER_KEY, {
    onStatusChange(status:number, code:number){
      console.log("jimsdk_connect_status:",status,"\tcode:",code)
      if(status == ConnStatus.connected){
        void HarmonyPushManager.instance.onImConnected()
      }
      connectCallback(status,code)
    },
    onDbOpen(){
      console.log("jimsdk_db_open")
    },
    onDbClose(){
      console.log("jimsdk_db_close")
    }
  })
  let cacheAuth = PreferenceUtil.getCacheAuth()
  if(cacheAuth!=undefined) {
    JuggleIm.instance.getConnectionManager()
      .connect(cacheAuth.im_token)
  }
}
