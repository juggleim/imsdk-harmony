import { JimDbManager } from "../dbs/dbmanager";
import { GroupInfo, GroupMember } from "../entries/group";
import { FriendInfo, UserInfo } from "../entries/user";
import { ImClient } from "../imclients/imclient";
import { immessage } from "../improto/immessage";
import { JimUtil } from "../commons/jimutil";
import { IUserInfoManager } from '../interfaces/iuserinfomanager'
import { GroupInfoCallback, GroupMemberCallback, GroupMembersCallback } from '../interfaces/igroupinfomanager'
import { FriendInfoCallback, UserInfoCallback } from '../interfaces/userinfotypes'
import { JuggleIm } from '../juggleim'

export { UserInfoCallback } from '../interfaces/userinfotypes'

export class UserInfoManager implements IUserInfoManager{
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

  getUserInfoList(userIdList:string[]):UserInfo[]{
    let userDao = JimDbManager.instance.getUserDao()
    return userDao.getUserList(userIdList)
  }

  getGroupInfoList(groupIdList:string[]):GroupInfo[]{
    return JuggleIm.instance.getGroupInfoManager().getGroupInfoList(groupIdList)
  }

  getFriendInfoList(friendIdList:string[]):FriendInfo[]{
    return JimDbManager.instance.getFriendDao().getFriendList(friendIdList)
  }

  getLocalGroupInfo(groupId:string):GroupInfo|null{
    return JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(groupId)
  }

  getGroupInfo(groupId:string):GroupInfo|null{
    return JuggleIm.instance.getGroupInfoManager().getGroupInfo(groupId)
  }

  queryGroupInfo(groupId:string, callback:GroupInfoCallback):void{
    JuggleIm.instance.getGroupInfoManager().queryGroupInfo(groupId, callback)
  }

  getLocalGroupMember(groupId:string, memberId:string):GroupMember|null{
    return JuggleIm.instance.getGroupInfoManager().getLocalGroupMember(groupId, memberId)
  }

  getGroupMember(groupId:string, memberId:string):GroupMember|null{
    return JuggleIm.instance.getGroupInfoManager().getGroupMember(groupId, memberId)
  }

  queryGroupMember(groupId:string, memberId:string, callback:GroupMemberCallback):void{
    JuggleIm.instance.getGroupInfoManager().queryGroupMember(groupId, memberId, callback)
  }

  getLocalGroupMembers(groupId:string):GroupMember[]{
    return JuggleIm.instance.getGroupInfoManager().getLocalGroupMembers(groupId)
  }

  queryGroupMembers(groupId:string, callback:GroupMembersCallback):void{
    JuggleIm.instance.getGroupInfoManager().queryGroupMembers(groupId, callback)
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

  saveFriendInfo(friendInfo:FriendInfo){
    JimDbManager.instance.getFriendDao().upsert(friendInfo)
  }

  getLocalFriendInfo(userid:string):FriendInfo|null{
    return JimDbManager.instance.getFriendDao().getFriend(userid)
  }

  getFriendInfo(userid:string):FriendInfo|null{
    if(userid == ''){
      return null
    }
    let localFriend = this.getLocalFriendInfo(userid)
    if(localFriend != null){
      return localFriend
    }
    this.fetchFriendInfo(userid).then((friendInfo)=>{
      if(friendInfo.updTime > 0){
        this.saveFriendInfo(friendInfo)
      }
    })
    return null
  }

  fetchFriendInfo(userid:string):Promise<FriendInfo>{
    return new Promise((resolve)=>{
      let friendInfo = new FriendInfo()
      friendInfo.userId = userid
      if(userid == ''){
        resolve(friendInfo)
        return
      }
      this.queryFriendPage(userid, '', friendInfo, resolve)
    })
  }

  checkFriend(userid:string, callback:FriendInfoCallback):void{
    if(userid == ''){
      callback(-1, new FriendInfo())
      return
    }
    let req = immessage.CheckFriendsReq.create({})
    req.friendIds = [userid]
    let data = immessage.CheckFriendsReq.encode(req).finish()
    this.imclient.query("check_friends", JuggleIm.instance.userId, data, (code, qryAck)=>{
      let friendInfo = this.getLocalFriendInfo(userid) ?? new FriendInfo()
      friendInfo.userId = userid
      friendInfo.updTime = Date.now()
      if(code != 0){
        callback(code, friendInfo)
        return
      }
      let resp = immessage.CheckFriendsResp.decode(qryAck.data as Uint8Array)
      friendInfo.isFriend = resp.checkResults != undefined && resp.checkResults[userid] == true
      this.saveFriendInfo(friendInfo)
      callback(0, friendInfo)
    })
  }

  private queryFriendPage(userid:string, offset:string, friendInfo:FriendInfo, resolve:(friendInfo:FriendInfo)=>void):void{
    let req = immessage.QryFriendsReq.create({})
    req.limit = 200
    req.offset = offset
    let data = immessage.QryFriendsReq.encode(req).finish()
    this.imclient.query("qry_friends", JuggleIm.instance.userId, data, (code, qryAck)=>{
      if(code != 0){
        resolve(friendInfo)
        return
      }
      let resp = immessage.QryFriendsResp.decode(qryAck.data as Uint8Array)
      let matched = resp.items.find((item)=>{
        return item.friendId == userid
      })
      if(matched != undefined){
        friendInfo.isFriend = true
        friendInfo.updTime = Date.now()
        this.saveFriendInfo(friendInfo)
        resolve(friendInfo)
        return
      }
      let nextOffset = resp.offset != undefined ? resp.offset as string : ''
      if(nextOffset != ''){
        this.queryFriendPage(userid, nextOffset, friendInfo, resolve)
        return
      }
      let localFriend = this.getLocalFriendInfo(userid)
      if(localFriend != null){
        resolve(localFriend)
        return
      }
      friendInfo.isFriend = false
      friendInfo.updTime = Date.now()
      this.saveFriendInfo(friendInfo)
      resolve(friendInfo)
    })
  }
}
