import {ImClient,ConnStatusListener} from '../imclients/imclient'


export class ConnectionManager {
  private imclient:ImClient

  constructor(imclient:ImClient) {
    this.imclient = imclient
  }

  connect(token:string){
    this.imclient.connect(token)
  }

  addConnectStatusListener(l:ConnStatusListener){
    this.imclient.addConnectStatusListener(l)
  }

  removeConnectStatusListener(l:ConnStatusListener){
    this.imclient.removeConnectStatusListener(l)
  }
}
