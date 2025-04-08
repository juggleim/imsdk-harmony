import { JimDbManager } from "../dbs/dbmanager";
import { GroupInfo } from "../entries/group";
import { ImClient } from "../imclients/imclient";
import { immessage } from "../improto/immessage";
import { JimUtil } from "../commons/jimutil";

export class GroupInfoManager{
  private imclient:ImClient
  constructor(imclient:ImClient) {
    this.imclient = imclient
  }

  saveGroupInfo(grpInfo:GroupInfo){
    let dao = JimDbManager.instance.getGroupDao()
    dao.upsert(grpInfo)
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