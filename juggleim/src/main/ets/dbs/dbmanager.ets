import { relationalStore } from "@kit.ArkData";
import { JimUtil } from "../commons/jimutil";
import { PreferenceUtil } from "../commons/preferenceutil";
import { JuggleIm } from "../juggleim";

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
    this.onUpgrade()
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

  private onUpgrade(){
    let data = getContext().resourceManager.getRawFileContentSync('sqllist.txt')
    console.log("jimsdk_max_sql_after",data.length)
    let vals = JimUtil.uint8ArrayToString(data)
    let fileNames = vals.split(',')
    console.log("jimsdk_max_sql_upgrad",fileNames)
    let maxVersion = PreferenceUtil.getSqlMaxVersion()
    console.log("jimsdk_max_sql_version:",maxVersion)
    fileNames.forEach((name:string)=>{
      let verStr:string = name.replaceAll('\n','')
      let version:number = new Number(verStr).valueOf()
      if(version > maxVersion){
        let list = this.getSqlList(verStr)
        list.forEach((sql)=>{
          console.log("jimsdk_max_sql_list_item:",sql)
          try{
            this.getDb()?.executeSync(sql)
            if(version>maxVersion){
              maxVersion = version
            }
          }catch (e) {
            console.error(`execute sql failed. code:${e.code},message:${e.message}}`)
          }
        })
      }
    })
    if(maxVersion>0){
      PreferenceUtil.setSqlMaxVersion(maxVersion)
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