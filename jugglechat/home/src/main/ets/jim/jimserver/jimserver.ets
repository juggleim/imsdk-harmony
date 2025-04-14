import { LoginResp } from "./entries/login"
import { UserManager } from "./usermanager"
import http from "@ohos.net.http";
import { doHttp } from "./httputil";
import { PreferenceUtil } from "../preferenceutil";

export type LoginCallback = (code:number,resp:LoginResp)=>void



export class JimServer{
  static instance = new JimServer()
  private serverUrl:string = PreferenceUtil.getJChatServer()
  private auth:string = ''
  private appkey:string = PreferenceUtil.getAppkey()

  private userManager:UserManager
  constructor() {
    this.userManager = new UserManager()
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

  public phoneLogin(phone:string,verCode:string,callback:LoginCallback){
    doHttp(this.serverUrl+"/jim/sms_login",http.RequestMethod.POST,{
      appkey:this.appkey
    },JSON.stringify({"phone":phone,"code":verCode}),(code,data)=>{
      let resp = data as LoginResp
      callback(code,resp)
    })
  }
}