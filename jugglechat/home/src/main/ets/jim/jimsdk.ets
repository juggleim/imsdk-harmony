import { ConnStatus, JuggleIm } from 'juggleim'
import { PreferenceUtil } from './preferenceutil'
import { RealMessageUploadProvider } from './realmessageuploadprovider'

export async function initJuggleIm(connectCallback:(status:number,code:number)=>void){
  JuggleIm.instance.init(PreferenceUtil.getJImServer(),PreferenceUtil.getAppkey())
  JuggleIm.instance.getMessageManager().setMessageUploadProvider(new RealMessageUploadProvider())
  JuggleIm.instance.getConnectionManager().addConnectStatusListener((status,code)=>{
    console.log("jimsdk_connect_status:",status,"\tcode:",code)
    connectCallback(status,code)
  })
  let cacheAuth = PreferenceUtil.getCacheAuth()
  if(cacheAuth!=undefined) {
    JuggleIm.instance.getConnectionManager()
      .connect(cacheAuth.im_token)
  }
}
