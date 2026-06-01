import { JimServerConfig } from "./jimserver";
import { User } from "./entries/user";
import { doHttp } from "./httputil";
import http from "@ohos.net.http";

/**
 * Defines the User Callback alias.
 *
 * Example:
 * ```ts
 * const callback: UserCallback = (user) => {}
 * ```
 */
export type UserCallback = (user:User|null)=>void

/**
 * Represents User Manager.
 *
 * Example:
 * ```ts
 * const manager = new UserManager(new JimServerConfig())
 * ```
 */
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