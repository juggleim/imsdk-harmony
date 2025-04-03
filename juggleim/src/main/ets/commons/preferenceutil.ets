import preferences from '@ohos.data.preferences';
import util from '@ohos.util'

let prefName = 'jim_preferences'

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

  static getUserIdByToken(appkey:string,token:string):string{
    let ctx = getContext()
    let options:preferences.Options={name:prefName}
    let pref = preferences.getPreferencesSync(ctx,options)
    let uKey = `userid_${appkey}_${token}`
    return pref.getSync(uKey,"").toString()
  }

  static setUserIdByToken(appkey:string,token:string,userId:string){
    let ctx = getContext()
    let options:preferences.Options={name:prefName}
    let pref = preferences.getPreferencesSync(ctx,options)
    let uKey = `userid_${appkey}_${token}`
    pref.putSync(uKey,userId)
    pref.flush()
  }

  // static getSqlMaxVersion(appkey:string,userId:string):number{
  //   let ctx = getContext()
  //   let options:preferences.Options={name:prefName}
  //   let pref = preferences.getPreferencesSync(ctx,options)
  //   let sqlVerKey = `sql_max_version_${appkey}_${userId}`
  //   let version = pref.getSync(sqlVerKey,0) as number
  //   return version
  // }
  //
  // static setSqlMaxVersion(appkey:string,userId:string,version:number){
  //   let ctx = getContext()
  //   let options:preferences.Options = {name:prefName}
  //   let pref = preferences.getPreferencesSync(ctx,options)
  //   let sqlVerKey = `sql_max_version_${appkey}_${userId}`
  //   pref.putSync(sqlVerKey,version)
  //   pref.flush()
  // }
}