import { relationalStore } from "@kit.ArkData";
import { JimUtil } from "../commons/jimutil";
import { ConverTagDao } from "./convertagdao"
import { ConversationDao } from "./conversationdao";
import { MessageDao } from "./messagedao";
import { UserDao } from "./userdao";
import { GroupDao } from "./groupdao";
import { GroupMemberDao } from "./groupmemberdao";
import { ConfDao } from "./confdao";
import { Conf } from "../entries/conf";

export class JimDbManager{
  static instance:JimDbManager = new JimDbManager()
  private constructor() {
  }

  private db?:relationalStore.RdbStore
  public hasInit:boolean = false

  async init(appkey:string,userId:string){
    let dbName = `${appkey}_${userId}.db`
    const storeConfig:relationalStore.StoreConfig = {
      name:dbName,
      securityLevel:relationalStore.SecurityLevel.S1,
      encrypt:false
    }
    this.db = await relationalStore.getRdbStore(getContext(),storeConfig)
    this.onUpgrade()
    this.hasInit = true
  }

  getDb():relationalStore.RdbStore|undefined{
    return this.db
  }

  closeDb(){
    if(this.db!==undefined){
      this.db.close()
      this.db = undefined
    }
  }

  getConfDao():ConfDao{
    return ConfDao.instance
  }

  getMessageDao():MessageDao{
    return MessageDao.instance
  }

  getConversationDao():ConversationDao{
    return ConversationDao.instance
  }

  getConverTagDao():ConverTagDao{
    return ConverTagDao.instance
  }

  getUserDao():UserDao{
    return UserDao.instance
  }

  getGroupDao():GroupDao{
    return GroupDao.instance
  }

  getGroupMemberDao():GroupMemberDao{
    return GroupMemberDao.instance
  }

  private onUpgrade(){
    let data = getContext().resourceManager.getRawFileContentSync('sqllist.txt')
    let vals = JimUtil.uint8ArrayToString(data)
    let fileNames = vals.split(',')
    let maxVersion = this.getSqlVersion()
    let tmpMaxVersion = maxVersion
    fileNames.forEach((name:string)=>{
      let verStr:string = name.replaceAll('\n','')
      let version:number = new Number(verStr).valueOf()
      if(version > tmpMaxVersion){
        let list = this.getSqlList(verStr)
        list.forEach((sql)=>{
          try{
            this.getDb()?.executeSync(sql)
            if(version>tmpMaxVersion){
              tmpMaxVersion = version
            }
          }catch (e) {
            console.error(`execute sql failed. code:${e.code},message:${e.message}}`)
          }
        })
      }
    })
    if(tmpMaxVersion>maxVersion){
      this.setSqlVersion(tmpMaxVersion)
    }
  }

  private getSqlList(fileName:string){
    let list:string[] = []
    let data = getContext().resourceManager.getRawFileContentSync(`${fileName}.sql`)
    let vals = JimUtil.uint8ArrayToString(data)
    if(vals.indexOf(';')>0){
      let sqls = vals.split(';')
      sqls.forEach((sql:string)=>{
        if(sql.replaceAll('\n','').replaceAll(' ','') !== ''){
          list.push(sql)
        }
      })
    }else{
      list.push(vals)
    }
    return list
  }

  private getSqlVersion():number{
    let verStr = ConfDao.instance.getByKey("sql_version")
    console.log("jimsdk_db_version:",verStr)
    return JimUtil.stringToNumber(verStr)
  }

  private setSqlVersion(version:number){
    let conf = new Conf()
    conf.key = "sql_version"
    conf.value = version.toString()
    ConfDao.instance.upsert(conf)
  }
}