import { JimDbManager } from "../dbs/dbmanager";
import { GroupInfo, GroupMember } from "../entries/group";
import { ImClient } from "../imclients/imclient";
import { immessage } from "../improto/immessage";
import { JimUtil } from "../commons/jimutil";
import { IGroupInfoManager } from '../interfaces/igroupinfomanager'
import { GroupInfoCallback } from '../interfaces/igroupinfomanager'
import { GroupMemberCallback } from '../interfaces/igroupinfomanager'
import { GroupMembersCallback } from '../interfaces/igroupinfomanager'

export { GroupInfoCallback, GroupMemberCallback, GroupMembersCallback } from '../interfaces/igroupinfomanager'

export class GroupInfoManager implements IGroupInfoManager{
  private imclient:ImClient
  constructor(imclient:ImClient) {
    this.imclient = imclient
  }

  saveGroupInfo(grpInfo:GroupInfo){
    let dao = JimDbManager.instance.getGroupDao()
    if(dao.needUpdate(grpInfo.groupId,grpInfo.updTime)) {
      dao.upsert(grpInfo)
    }
  }

  getLocalGroupInfo(groupId:string):GroupInfo|null{
    let dao = JimDbManager.instance.getGroupDao()
    let dbGrp = dao.getGroupInfo(groupId)
    if(dbGrp!=null){
      let grp = new GroupInfo()
      grp.groupId = groupId
      grp.groupName = dbGrp.groupName
      grp.groupPortrait = dbGrp.groupPortrait
      grp.updTime = dbGrp.updTime
      return grp
    }
    return null
  }

  getGroupInfoList(groupIdList:string[]):GroupInfo[]{
    let dao = JimDbManager.instance.getGroupDao()
    return dao.getGroupList(groupIdList)
  }

  getGroupInfo(groupId:string):GroupInfo|null{
    if(groupId == ''){
      return null
    }
    let localGroup = this.getLocalGroupInfo(groupId)
    if(localGroup != null){
      return localGroup
    }
    this.qryGroupInfo(groupId).then((group)=>{
      if(group != null){
        this.saveGroupInfo(group)
      }
    })
    return null
  }

  queryGroupInfo(groupId:string, callback:GroupInfoCallback):void{
    if(groupId == ''){
      callback(-1, null)
      return
    }
    this.qryGroupInfo(groupId).then((group)=>{
      if(group == null){
        callback(-1, null)
        return
      }
      this.saveGroupInfo(group)
      callback(0, group)
    })
  }

  getLocalGroupMember(groupId:string, memberId:string):GroupMember|null{
    if(groupId == '' || memberId == ''){
      return null
    }
    return JimDbManager.instance.getGroupMemberDao().getGroupMember(groupId, memberId)
  }

  getGroupMember(groupId:string, memberId:string):GroupMember|null{
    if(groupId == '' || memberId == ''){
      return null
    }
    let localMember = this.getLocalGroupMember(groupId, memberId)
    if(localMember != null){
      return localMember
    }
    this.queryGroupMember(groupId, memberId, ()=>{})
    return null
  }

  queryGroupMember(groupId:string, memberId:string, callback:GroupMemberCallback):void{
    if(groupId == '' || memberId == ''){
      callback(-1, null)
      return
    }
    let localMember = this.getLocalGroupMember(groupId, memberId)
    if(localMember != null){
      callback(0, localMember)
      return
    }
    this.queryAllGroupMembers(groupId, (code, members)=>{
      if(code != 0){
        callback(code, null)
        return
      }
      let targetMember = members.find((member)=>{
        return member.memberId == memberId
      })
      callback(targetMember == undefined ? -1 : 0, targetMember == undefined ? null : targetMember)
    })
  }

  getLocalGroupMembers(groupId:string):GroupMember[]{
    return JimDbManager.instance.getGroupMemberDao().queryGroupMembers(groupId)
  }

  queryGroupMembers(groupId:string,callback:GroupMembersCallback):void{
    if(groupId == ''){
      callback(-1, [])
      return
    }
    this.queryAllGroupMembers(groupId, callback)
  }

  private queryAllGroupMembers(groupId:string, callback:GroupMembersCallback):void{
    let members:GroupMember[] = []
    this.queryGroupMembersPage(groupId, '', members, callback)
  }

  private queryGroupMembersPage(groupId:string, offset:string, members:GroupMember[], callback:GroupMembersCallback):void{
    let req = immessage.QryGroupMembersReq.create({
      groupId:groupId,
      limit:200,
      offset:offset
    })
    let data = immessage.QryGroupMembersReq.encode(req).finish()
    this.imclient.query("qry_group_members", groupId, data, (code, qryAck)=>{
      if(code != 0){
        callback(code, members)
        return
      }
      let result = immessage.GroupMembersResp.decode(qryAck.data as Uint8Array)
      result.items.forEach((item)=>{
        let member = new GroupMember()
        member.groupId = groupId
        member.memberId = item.memberId as string
        member.displayName = item.memberId as string
        members.push(member)
        JimDbManager.instance.getGroupMemberDao().upsert(member)
      })
      let nextOffset = result.offset != undefined ? result.offset as string : ''
      if(nextOffset != ''){
        this.queryGroupMembersPage(groupId, nextOffset, members, callback)
        return
      }
      callback(0, members)
    })
  }

  private qryGroupInfo(groupId:string):Promise<GroupInfo|null>{
    return new Promise((resolve)=>{
      let req = immessage.GroupInfoReq.create({
        groupId:groupId
      })
      let data = immessage.GroupInfoReq.encode(req).finish()
      this.imclient.query("qry_group_info",groupId,data,(code,qryAck)=>{
        if(code==0){
          let grp = new GroupInfo()
          grp.groupId = groupId
          let d = qryAck.data as Uint8Array
          let g = immessage.GroupInfo.decode(d)
          grp.groupName = g.groupName
          grp.groupPortrait = g.groupPortrait
          grp.updTime = JimUtil.toNumber(g.updatedTime)
          resolve(grp)
        }else{
          resolve(null)
        }
      })
    })
  }
}
