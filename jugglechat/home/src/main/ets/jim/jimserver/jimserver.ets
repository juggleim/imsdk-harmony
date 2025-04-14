import { LoginResp } from "./entries/login"
import { UserManager } from "./usermanager"
import http from "@ohos.net.http";
import { doHttp, JimServerHeaders } from "./httputil";
import { PreferenceUtil } from "../preferenceutil";
import { FriendManager } from "./friendmanager";

export type LoginCallback = (code:number,resp:LoginResp)=>void

export class JimServerConfig{
  serverUrl:string
  appkey:string
  auth:string = ''

  constructor() {
    this.serverUrl = PreferenceUtil.getJChatServer()
    this.appkey = PreferenceUtil.getAppkey()
  }

  public getAuth(){
    if(this.auth==''){
      let cacheAuth = PreferenceUtil.getCacheAuth()
      if(cacheAuth!=undefined){
        this.auth = cacheAuth.server_auth
      }
    }
    return this.auth
  }

  public getServerUrl():string{
    return this.serverUrl
  }

  public getAppkey():string{
    return this.appkey
  }

  public getCommonHeaders():JimServerHeaders{
    let retHeader:JimServerHeaders = {
      appkey:this.getAppkey(),
      Authorization:this.getAuth()
    }
    return retHeader
  }
}


export class JimServer{
  static instance = new JimServer()

  private config:JimServerConfig

  private userManager:UserManager
  private friendManager:FriendManager
  constructor() {
    this.config = new JimServerConfig()
    this.userManager = new UserManager(this.config)
    this.friendManager = new FriendManager(this.config)
  }

  public getUserManager():UserManager{
    return this.userManager
  }

  public getFriendManager():FriendManager{
    return this.friendManager
  }

  public phoneLogin(phone:string,verCode:string,callback:LoginCallback){
    doHttp(this.config.getServerUrl()+"/jim/sms_login",http.RequestMethod.POST,{
      appkey:this.config.getAppkey()
    },JSON.stringify({"phone":phone,"code":verCode}),(code,data)=>{
      let resp = data as LoginResp
      callback(code,resp)
    })
  }
}