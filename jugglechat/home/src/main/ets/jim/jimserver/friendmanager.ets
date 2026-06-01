import { User, Users } from "./entries/user";
import { doHttp } from "./httputil";
import http from "@ohos.net.http";
import { JimServerConfig } from "./jimserver";

/**
 * Defines the Friends Callback alias.
 *
 * Example:
 * ```ts
 * const callback: FriendsCallback = (users) => {}
 * ```
 */
export type FriendsCallback = (users:Users)=>void

/**
 * Represents Friend Manager.
 *
 * Example:
 * ```ts
 * const manager = new FriendManager(new JimServerConfig())
 * ```
 */
export class FriendManager{
  private config:JimServerConfig
  constructor(config:JimServerConfig) {
    this.config = config
  }

  public QueryFriends(page:number,size:number,orderTag:string, callback:FriendsCallback){
    doHttp(this.config.getServerUrl()+`/jim/friends/list?size=${size}&page=${page}&order_tag=${orderTag}`,http.RequestMethod.GET,this.config.getCommonHeaders(),'',(code,data)=>{
      if(code==0){
        callback(data as Users)
      }else{
        callback({
          items:[]
        })
      }
    })
  }
}