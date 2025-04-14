import { JimServerConfig } from "./jimserver";
import { User } from "./entries/user";
import { doHttp } from "./httputil";
import http from "@ohos.net.http";

export type UserCallback = (user:User|null)=>void

export class UserManager{
  private config:JimServerConfig
  constructor(config:JimServerConfig) {
    this.config = config
  }

  public GetUserInfo(userId:string,callback:UserCallback){
    doHttp(this.config.getServerUrl()+`/jim/users/info?user_id=${userId}`,http.RequestMethod.GET,this.config.getCommonHeaders(),'',(code,data)=>{
      if(code==0){
        callback(data as User)
      }else{
        callback(null)
      }
    })
  }
}