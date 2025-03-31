import {UserInfo} from './entries/user'
import { ConnectionManager } from './managers/connectionmanager';
import { ConversationManager } from './managers/conversationmanager';
import { MessageManager } from './managers/messagemanager';
import { ConnStatus, ImClient} from './imclients/imclient'

export class JimConfig{
  address:string = ''
  appkey:string = ''
  platform:string = 'iOS'
  protoId:string = 'jug9le1m'
}

export class JuggleIm{
  static instance = new JuggleIm();

  config:JimConfig
  userInfo:UserInfo
  private imclient:ImClient

  private connectManager:ConnectionManager
  private messageManager:MessageManager
  private converManager:ConversationManager

  private constructor() {
    this.config = new JimConfig();
    this.userInfo = new UserInfo();
    this.imclient = new ImClient()
    this.connectManager = new ConnectionManager(this.imclient)
    this.messageManager = new MessageManager(this.imclient)
    this.converManager = new ConversationManager(this.imclient)
  }

  async init(address:string, appkey:string):Promise<void>{
    this.config.address = address
    this.config.appkey = appkey
  }

  getConnStatus():ConnStatus{
    return this.imclient.status
  }

  getConnectionManager():ConnectionManager{
    return this.connectManager
  }

  getMessageManager():MessageManager{
    return this.messageManager
  }

  getConversationManager():ConversationManager{
    return this.converManager
  }
}

