import { JimDbManager } from "../dbs/dbmanager";
import { GroupInfo, GroupMember } from "../entries/group";
import { ImClient } from "../imclients/imclient";
import { immessage } from "../improto/immessage";
import { JimUtil } from "../commons/jimutil";
import { IGroupInfoManager } from '../interfaces/igroupinfomanager'
import { GroupMembersCallback } from '../interfaces/igroupinfomanager'

export { GroupMembersCallback } from '../interfaces/igroupinfomanager'

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

  getGroupInfo(groupId:string):GroupInfo|null{
    return null
  }

  getLocalGroupMembers(groupId:string):GroupMember[]{
    return JimDbManager.instance.getGroupMemberDao().queryGroupMembers(groupId)
  }

  queryGroupMembers(groupId:string,callback:GroupMembersCallback):void{
    let req = immessage.QryGroupMembersReq.create({
      groupId:groupId,
      limit:200,
      offset:''
    })
    let data = immessage.QryGroupMembersReq.encode(req).finish()
    this.imclient.query("qry_group_members", groupId, data, (code, qryAck)=>{
      let members:GroupMember[] = []
      if(code == 0){
        let result = immessage.GroupMembersResp.decode(qryAck.data as Uint8Array)
        result.items.forEach((item)=>{
          let member = new GroupMember()
          member.groupId = groupId
          member.memberId = item.memberId as string
          member.displayName = item.memberId as string
          members.push(member)
          JimDbManager.instance.getGroupMemberDao().upsert(member)
        })
      }
      callback(code, members)
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
