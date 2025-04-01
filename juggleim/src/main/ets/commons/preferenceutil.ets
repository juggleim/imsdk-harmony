import preferences from '@ohos.data.preferences';
import util from '@ohos.util'

let prefName = 'jim_preferences'
let sqlVersionKey = 'jim_sql_max_version'

export class PreferenceUtil{
  static getDeviceId():string{
    let ctx = getContext()
    let key = "jim_device_id"
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    let deviceId = pref.getSync(key,"")
    if(deviceId == ""){
      deviceId = `${util.generateRandomUUID().replaceAll("-","")}`
      pref.putSync(key,deviceId)
      pref.flush()
    }
    return deviceId.toString()
  }

  static getSqlMaxVersion():number{
    let ctx = getContext()
    let options:preferences.Options={name:prefName}
    let pref = preferences.getPreferencesSync(ctx,options)
    let version = pref.getSync(sqlVersionKey,0) as number
    return version
  }

  static setSqlMaxVersion(version:number){
    let ctx = getContext()
    let options:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,options)
    pref.putSync(sqlVersionKey,version)
  }
}