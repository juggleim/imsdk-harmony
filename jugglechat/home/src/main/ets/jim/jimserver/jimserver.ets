import { LoginResp, ServerInfoIndexResp, ServerInfoPlain } from "./entries/login"
import { UserManager } from "./usermanager"
import http from "@ohos.net.http";
import { doHttp, JimServerHeaders } from "./httputil";
import { PreferenceUtil } from "../preferenceutil";
import { FriendManager } from "./friendmanager";

export type LoginCallback = (code:number,resp:LoginResp,msg?:string)=>void

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
    this.serverUrl = PreferenceUtil.getJChatServer()
    return this.serverUrl
  }

  public getAppkey():string{
    this.appkey = PreferenceUtil.getAppkey()
    return this.appkey
  }

  public getCommonHeaders():JimServerHeaders{
    let retHeader:JimServerHeaders = {
      AppKey:this.getAppkey(),
      Authorization:this.getAuth()
    }
    return retHeader
  }

  public clearAuth(){
    this.auth = ''
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

  public clearAuth(){
    this.config.clearAuth()
  }

  public queryServerConfig(organization:string,callback:(code:number,serverInfo?:ServerInfoPlain,msg?:string)=>void){
    doHttp(`https://index.snailchat.im/serverinfos?no=${organization}`,http.RequestMethod.GET,undefined,'',(code,data,msg)=>{
      if(code!=0 || data==undefined){
        callback(code,undefined,msg)
        return
      }
      let resp = data as ServerInfoIndexResp
      if(resp.server_info_plain==undefined || resp.server_info_plain==''){
        callback(-3,undefined,'server_info_plain is empty')
        return
      }
      let serverInfo = JSON.parse(resp.server_info_plain) as ServerInfoPlain
      callback(0,serverInfo,msg)
    })
  }

  public phoneLogin(phone:string,verCode:string,callback:LoginCallback){
    doHttp(this.config.getServerUrl()+"/jim/sms_login",http.RequestMethod.POST,{
      AppKey:this.config.getAppkey(),
      'Content-Type':'application/json'
    },JSON.stringify({"phone":phone,"code":verCode}),(code,data,msg)=>{
      let resp = data as LoginResp
      callback(code,resp,msg)
    })
  }

  public accountLogin(organization:string,username:string,password:string,callback:LoginCallback){
    let url = this.config.getServerUrl()+"/jim/login"
    let body = JSON.stringify({
      account: username,
      password: password
    })
    console.log("jim_account_login_payload:", url, this.config.getAppkey(), organization, body)
    doHttp(this.config.getServerUrl()+"/jim/login",http.RequestMethod.POST,{
      AppKey:this.config.getAppkey(),
      'Content-Type':'application/json',
      'x-amz-acl':'public-read'
    },body,(code,data,msg)=>{
      let resp = data as LoginResp
      console.log("jim_account_login_result:", code, msg ?? '', JSON.stringify(resp))
      callback(code,resp,msg)
    })
  }
}
