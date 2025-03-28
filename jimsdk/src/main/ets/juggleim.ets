import {UserInfo} from './entries/user'
import { ConnectionManager } from './managers/connectionmanager';
import { ConversationManager } from './managers/conversationmanager';
import { MessageManager } from './managers/messagemanager';

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

  private constructor() {
    this.config = new JimConfig();
    this.userInfo = new UserInfo();
  }

  async init(address:string, appkey:string):Promise<void>{
    this.config.address = address
    this.config.appkey = appkey
  }

  connectionManager():ConnectionManager{
    return ConnectionManager.instance
  }

  messageManager():MessageManager{
    return MessageManager.instance
  }

  conversationManager():ConversationManager{
    return ConversationManager.instance
  }
}

