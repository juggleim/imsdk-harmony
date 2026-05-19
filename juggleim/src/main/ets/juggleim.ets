import {UserInfo} from './entries/user'
import { ConnectionManager } from './managers/connectionmanager';
import { ConversationManager } from './managers/conversationmanager';
import { MessageManager } from './managers/messagemanager';
import { ConnStatus, ImClient} from './imclients/imclient'
import { PreferenceUtil } from './commons/preferenceutil';
import { JimDbManager } from './dbs/dbmanager';
import { UserInfoManager } from './managers/userinfomanager';
import { GroupInfoManager } from './managers/groupinfomanager';
import { MsgSyncManager } from './managers/msgsyncmanager';
import { MsgHandler } from './entries/msghandler';
import { Conversation, ConversationInfo } from './entries/conversation';
import { Message } from './entries/message';
import { IConnectionManager } from './interfaces/iconnectionmanager'
import { IConversationManager } from './interfaces/iconversationmanager'
import { IMessageManager } from './interfaces/imessagemanager'
import { IUserInfoManager } from './interfaces/iuserinfomanager'
import { IGroupInfoManager } from './interfaces/igroupinfomanager'

export class JimConfig{
  address:string = ''
  healthCheckAddress:string = ''
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
  private msgSyncManager:MsgSyncManager
  private converManager:ConversationManager
  private userInfoManager:UserInfoManager
  private groupInfoManager:GroupInfoManager

  private constructor() {
    this.config = new JimConfig();
    this.userInfo = new UserInfo();
    this.userId = ''
    MsgHandler.init()
    this.imclient = new ImClient()
    this.connectManager = new ConnectionManager(this.imclient)
    this.msgSyncManager = new MsgSyncManager(this.imclient)
    this.messageManager = new MessageManager(this.imclient,this.msgSyncManager)
    this.converManager = new ConversationManager(this.imclient,this.msgSyncManager)
    this.userInfoManager = new UserInfoManager(this.imclient)
    this.groupInfoManager = new GroupInfoManager(this.imclient)
  }

  async init(address:string, appkey:string):Promise<void>{
    let normalizedAddress = address
    if(normalizedAddress.endsWith('/')){
      normalizedAddress = normalizedAddress.substring(0,normalizedAddress.length - 1)
    }
    if(normalizedAddress.endsWith('/im')){
      this.config.address = normalizedAddress
      this.config.healthCheckAddress = normalizedAddress.substring(0,normalizedAddress.length - 3) + '/health'
    }else{
      this.config.address = normalizedAddress+"/im"
      this.config.healthCheckAddress = normalizedAddress + "/health"
    }
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

  getConnectionManager():IConnectionManager{
    return this.connectManager
  }

  getMessageManager():IMessageManager{
    return this.messageManager
  }

  getMsgSyncManager():MsgSyncManager{
    return this.msgSyncManager
  }

  getConversationManager():IConversationManager{
    return this.converManager
  }

  getUserInfoManager():IUserInfoManager{
    return this.userInfoManager
  }

  getGroupInfoManager():IGroupInfoManager{
    return this.groupInfoManager
  }
}
