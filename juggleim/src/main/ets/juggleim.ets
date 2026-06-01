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
import { ChatroomManager } from './managers/chatroommanager';
import { IConnectionManager } from './interfaces/iconnectionmanager'
import { IChatroomManager } from './interfaces/ichatroommanager'
import { IConversationManager } from './interfaces/iconversationmanager'
import { IMessageManager } from './interfaces/imessagemanager'
import { IUserInfoManager } from './interfaces/iuserinfomanager'
import { IGroupInfoManager } from './interfaces/igroupinfomanager'
import { IMomentManager } from './interfaces/imomentmanager'
import { MomentManager } from './managers/momentmanager'

/**
 * Represents Jim Config.
 *
 * Example:
 * ```ts
 * const config = new JimConfig()
 * ```
 */
export class JimConfig{
  address:string = ''
  healthCheckAddress:string = ''
  appkey:string = ''
  platform:string = 'Harmony'
  sdkVersion:string = '1.8.47.1'
  protoId:string = 'jug9le1m'
  deviceId:string = ''
  packageName:string = ''
  pushToken:string = ''
  pushChannel:string = ''
  appServerUrl:string = ''
  authToken:string = ''
  language:string = ''
  instanceId:string = ''
  isBackend:boolean = false
  connectExt:string = ''
  connectParams:Map<string, string> = new Map<string, string>()
  connectSignKey:string = ''
  connectHeaders:Map<string, string> = new Map<string, string>()
}

/**
 * Represents Juggle Im.
 *
 * Example:
 * ```ts
 * const sdk = JuggleIm.instance
 * ```
 */
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
  private chatroomManager:ChatroomManager
  private momentManager:MomentManager

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
    this.chatroomManager = new ChatroomManager(this.imclient, this.msgSyncManager)
    this.momentManager = new MomentManager()
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
    this.config.instanceId = this.config.deviceId
  }

  setPackageName(packageName:string):void{
    this.config.packageName = packageName
  }

  setAppServerUrl(appServerUrl:string):void{
    let normalizedUrl = appServerUrl.trim()
    if (normalizedUrl.endsWith('/')) {
      normalizedUrl = normalizedUrl.substring(0, normalizedUrl.length - 1)
    }
    this.config.appServerUrl = normalizedUrl
  }

  async initDb(userId:string):Promise<void>{
    let appkey = this.config.appkey
    if(userId!=''&&appkey!='') {
      await JimDbManager.instance.init(appkey,userId)
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

  getChatroomManager():IChatroomManager{
    return this.chatroomManager
  }

  getUserInfoManager():IUserInfoManager{
    return this.userInfoManager
  }

  getGroupInfoManager():IGroupInfoManager{
    return this.groupInfoManager
  }

  getMomentManager():IMomentManager{
    return this.momentManager
  }
}
