import { JuggleIm } from "../../../../Index";
import { JimDbManager } from "../dbs/dbmanager";
import { UserInfo } from "../entries/user";
import { ImClient } from "../imclients/imclient";
import { immessage } from "../improto/immessage";
import { JimUtil } from "../commons/jimutil";

export type UserInfoCallback = (code:number,userInfo:UserInfo)=>void

export class UserInfoManager{
  private imclient:ImClient
  constructor(imclient:ImClient) {
    this.imclient = imclient
  }

  saveUserInfo(userInfo:UserInfo){
    let userDao = JimDbManager.instance.getUserDao()
    if(userDao.needUpdate(userInfo.userId, userInfo.updTime)) {
      userDao.upsert(userInfo)
    }
  }

  getLocalUserInfo(userid:string):UserInfo|null{
    let userDao = JimDbManager.instance.getUserDao()
    let dbUser = userDao.getUser(userid)
    console.log("jimsdk_qryu:",JSON.stringify(dbUser),userid)
    if(dbUser!=null){
      let user = new UserInfo()
      user.userId = userid
      user.nickname = dbUser.nickname
      user.userPortrait = dbUser.userPortrait
      user.updTime = dbUser.updTime
      return user
    }
    return null
  }

  getUserInfo(userid:string):Promise<UserInfo>{
    return new Promise((resolve)=>{
      let user = new UserInfo()
      user.userId = userid
      let userDao = JimDbManager.instance.getUserDao()
      let dbUser = userDao.getUser(userid)
      console.log("jimsdk_qryu_db",JSON.stringify(dbUser))
      if(dbUser!=null){
        user.nickname = dbUser.nickname
        user.userPortrait = dbUser.userPortrait
        user.userType = dbUser.userType
        user.updTime = dbUser.updTime
        resolve(user)
      }else{
        this.getRemoteUserInfo(userid,(code,user)=>{
          if(code==0) {
            userDao.upsert(user)
          }
          resolve(user)
        })
      }
    })
  }

  public getRemoteUserInfo(userid:string,callback:UserInfoCallback){
    let req = immessage.UserIdReq.create({
      "userId":userid
    })
    let data = immessage.UserIdReq.encode(req).finish()
    this.imclient.query("qry_user_info",userid,data,(code,qryAck)=>{
      let user = new UserInfo()
      user.userId = userid
      if(code==0){
        let d = qryAck.data as Uint8Array
        let u = immessage.UserInfo.decode(d)
        user.nickname  = u.nickname
        user.userPortrait = u.userPortrait
        user.updTime = JimUtil.toNumber(u.updatedTime)
        user.userType = u.userType as number
        callback(code,user)
      }else{
        callback(code,user)
      }
    })
  }
}