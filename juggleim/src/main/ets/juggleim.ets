import {UserInfo} from './entries/user'
import { ConnectionManager } from './managers/connectionmanager';
import { ConversationManager } from './managers/conversationmanager';
import { MessageManager } from './managers/messagemanager';
import { ConnStatus, ImClient} from './imclients/imclient'
import { PreferenceUtil } from './commons/preferenceutil';
import { JimDbManager } from './dbs/dbmanager';
import { UserInfoManager } from './managers/userinfomanager';
import { GroupInfoManager } from './managers/groupinfomanager';

export class JimConfig{
  address:string = ''
  appkey:string = ''
  platform:string = 'Harmony'
  protoId:string = 'jug9le1m'
  deviceId:string = ''
}

export class JuggleIm{
  static instance = new JuggleIm();

  config:JimConfig
  userInfo:UserInfo
  userId:string
  private imclient:ImClient

  private connectManager:ConnectionManager
  private messageManager:MessageManager
  private converManager:ConversationManager
  private userInfoManager:UserInfoManager
  private groupInfoManager:GroupInfoManager

  private constructor() {
    this.config = new JimConfig();
    this.userInfo = new UserInfo();
    this.userId = ''
    this.imclient = new ImClient()
    this.connectManager = new ConnectionManager(this.imclient)
    this.messageManager = new MessageManager(this.imclient)
    this.converManager = new ConversationManager(this.imclient)
    this.userInfoManager = new UserInfoManager(this.imclient)
    this.groupInfoManager = new GroupInfoManager(this.imclient)
  }

  async init(address:string, appkey:string):Promise<void>{
    this.config.address = address
    this.config.appkey = appkey
    this.config.deviceId = PreferenceUtil.getDeviceId()
  }

  initDb(userId:string){
    let appkey = this.config.appkey
    if(userId!=''&&appkey!='') {
      JimDbManager.instance.init(appkey,userId)
    }
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

  getUserInfoManager():UserInfoManager{
    return this.userInfoManager
  }

  getGroupInfoManager():GroupInfoManager{
    return this.groupInfoManager
  }
}

