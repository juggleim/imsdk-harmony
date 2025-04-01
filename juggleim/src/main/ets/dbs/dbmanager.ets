import { relationalStore } from "@kit.ArkData";
import { JimUtil } from "../commons/jimutil";
import { PreferenceUtil } from "../commons/preferenceutil";
import { MessageDao } from "./messagedao";

export class JimDbManager{
  static instance:JimDbManager = new JimDbManager()
  private constructor() {
  }

  private db?:relationalStore.RdbStore

  async init(appkey:string,userId:string){
    let dbName = `${appkey}_${userId}.db`
    const storeConfig:relationalStore.StoreConfig = {
      name:dbName,
      securityLevel:relationalStore.SecurityLevel.S1,
      encrypt:false
    }
    this.db = await relationalStore.getRdbStore(getContext(),storeConfig)
    this.onUpgrade(appkey,userId)
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

  getMessageDao():MessageDao{
    return MessageDao.instance
  }

  private onUpgrade(appkey:string,userId:string){
    let data = getContext().resourceManager.getRawFileContentSync('sqllist.txt')
    let vals = JimUtil.uint8ArrayToString(data)
    let fileNames = vals.split(',')
    let maxVersion = PreferenceUtil.getSqlMaxVersion(appkey,userId)
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
      PreferenceUtil.setSqlMaxVersion(appkey,userId,tmpMaxVersion)
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
}