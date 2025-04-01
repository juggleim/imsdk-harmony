import {UserInfo} from './entries/user'
import { ConnectionManager } from './managers/connectionmanager';
import { ConversationManager } from './managers/conversationmanager';
import { MessageManager } from './managers/messagemanager';
import { ConnStatus, ImClient} from './imclients/imclient'
import { PreferenceUtil } from './commons/preferenceutil';
import { JimDbManager } from './dbs/dbmanager';
import { Message } from './entries/message';
import { Conversation } from './entries/conversation';

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

  private constructor() {
    this.config = new JimConfig();
    this.userInfo = new UserInfo();
    this.userId = ''
    this.imclient = new ImClient()
    this.connectManager = new ConnectionManager(this.imclient)
    this.messageManager = new MessageManager(this.imclient)
    this.converManager = new ConversationManager(this.imclient)
  }

  async init(address:string, appkey:string):Promise<void>{
    this.config.address = address
    this.config.appkey = appkey
    this.config.deviceId = PreferenceUtil.getDeviceId()
  }

  async initDb(){
    let appkey = this.config.appkey
    let userId = this.userId
    if(userId!=''&&appkey!='') {
      JimDbManager.instance.init(appkey,userId)
    }
  }

  testDb(){
    let msgDao = JimDbManager.instance.getMessageDao()
    let msg = new Message()
    msg.conversation = new Conversation('userid2',1)
    msg.msgType = 'jg:text'
    msg.messageId = 'msgid3'
    msg.clientId = 'clientid3'
    let result = msgDao.insert(msg)
    console.log("jimsdk_dbinsert",result)

    let msgs = msgDao.queryMessages('userid2',1,0,10)
    console.log("jimsdk_dbinsert_query:",msgs.length);
    if(msgs.length>0){
      msgs.forEach((msg)=>{
        console.log("jimsdk_dbinsert_query_item:",msg.messageId,msg.conversation?.conversationId,msg.conversation?.conversationType)
      })
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
}

