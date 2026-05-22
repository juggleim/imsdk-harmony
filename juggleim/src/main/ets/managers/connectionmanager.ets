import { JuggleIm } from '../juggleim'
import { PreferenceUtil } from '../commons/preferenceutil'
import { JimDbManager } from '../dbs/dbmanager'
import {ImClient,ConnStatusListener} from '../imclients/imclient'
import { IConnectionManager } from '../interfaces/iconnectionmanager'
import { ChatroomManager } from './chatroommanager'


export class ConnectionManager implements IConnectionManager {
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

  disconnect(){
    (JuggleIm.instance.getChatroomManager() as ChatroomManager).userDisconnect()
    this.imclient.disconnect(true)
  }

  addConnectStatusListener(l:ConnStatusListener){
    this.imclient.addConnectStatusListener(l)
  }

  removeConnectStatusListener(l:ConnStatusListener){
    this.imclient.removeConnectStatusListener(l)
  }
}
