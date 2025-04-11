import { LoginResp } from "./entries/login"
import { UserManager } from "./usermanager"
import http from "@ohos.net.http";
import { doHttp } from "./httputil";

export type LoginCallback = (code:number,resp:LoginResp)=>void

export class JimServer{
  static instance = new JimServer()
  private serverUrl:string = 'https://ws.juggleim.com'
  private auth:string = ''
  private appkey:string = 'nsw3sue72begyv7y'

  private userManager:UserManager
  constructor() {
    this.userManager = new UserManager()
  }

  public phoneLogin(phone:string,verCode:string,callback:LoginCallback){
    doHttp(this.serverUrl+"/jim/sms_login",http.RequestMethod.POST,{
      appkey:this.appkey
    },JSON.stringify({"phone":phone,"code":verCode}),(code,data)=>{
      callback(code,data as LoginResp)
    })
  }
}