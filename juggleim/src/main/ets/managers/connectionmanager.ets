import { JuggleIm } from '../juggleim'
import { PreferenceUtil } from '../commons/preferenceutil'
import { JimDbManager } from '../dbs/dbmanager'
import {ImClient,ConnStatusListener} from '../imclients/imclient'


export class ConnectionManager {
  private imclient:ImClient

  constructor(imclient:ImClient) {
    this.imclient = imclient
  }

  connect(token:string){
    if(!JimDbManager.instance.hasInit){
      let userId = PreferenceUtil.getUserIdByToken(JuggleIm.instance.config.appkey,token)
      if(userId!=''){
        JuggleIm.instance.initDb(userId)
      }
    }
    this.imclient.connect(token)
  }

  addConnectStatusListener(l:ConnStatusListener){
    this.imclient.addConnectStatusListener(l)
  }

  removeConnectStatusListener(l:ConnStatusListener){
    this.imclient.removeConnectStatusListener(l)
  }
}
