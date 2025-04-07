import { Conf } from "../entries/conf"
import { relationalStore } from "@kit.ArkData"
import { JimDbUtil } from "./dbutil"
import { JimDbManager } from "./dbmanager"
import { JimUtil } from "../commons/jimutil"

export class ConfDao{
  static instance:ConfDao = new ConfDao()
  private tableName:string = 'confs'
  private constructor() {
  }

  query():Conf[]{
    let sql = `SELECT * FROM ${this.tableName}`
    let args:Array<relationalStore.ValueType> = []
    let resultSet:relationalStore.ResultSet|undefined
    let list:Conf[] = []
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      while(resultSet?.goToNextRow()){
        let conf = this.toConf(resultSet)
        list.push(conf)
      }
      return list
    }catch (e) {
    }finally {
      resultSet?.close()
    }
    return list
  }

  upsert(conf:Conf):number{
    let sql = `INSERT OR REPLACE INTO ${this.tableName} (conf_key,conf_value) VALUES (?,?)`
    let args:Array<relationalStore.ValueType> = []
    args.push(conf.key)
    args.push(conf.value)
    try {
      let vt = JimDbManager.instance.getDb()?.executeSync(sql, args)
      return vt as number
    }catch (e) {
    }
    return 0
  }

  getByKey(key:string):string{
    let sql = `SELECT conf_key,conf_value from ${this.tableName} WHERE conf_key=?`
    let args:Array<relationalStore.ValueType> = []
    args.push(key)
    let resultSet:relationalStore.ResultSet|undefined
    try{
      resultSet = JimDbManager.instance.getDb()?.querySqlSync(sql,args)
      if(resultSet?.goToNextRow()){
        let conf = this.toConf(resultSet)
        return conf.value
      }else{
        console.log("jimsdk_db_",resultSet)
      }
    }catch (e) {
      console.log("jimsdk_db_error:",JSON.stringify(e))
    }finally {
      resultSet?.close()
    }
    return ""
  }

  getConverSyncTime():number{
    let syncTimeStr = this.getByKey("conver_sync_time")
    return JimUtil.stringToNumber(syncTimeStr)
  }

  setConverSyncTime(t:number){
    let conf = new Conf()
    conf.key = "conver_sync_time"
    conf.value = t.toString()
    this.upsert(conf)
  }

  private getValuesBucket(conf:Conf):relationalStore.ValuesBucket{
    let valuesBucket:relationalStore.ValuesBucket={
      "conf_key":conf.key,
      "conf_value":conf.value
    }
    return valuesBucket
  }

  private toConf(resultSet:relationalStore.ResultSet):Conf{
    let conf = new Conf()
    conf.key = JimDbUtil.toString(resultSet,"conf_key")
    conf.value = JimDbUtil.toString(resultSet,"conf_value")
    return conf
  }
}