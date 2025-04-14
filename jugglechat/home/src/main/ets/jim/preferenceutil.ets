import preferences from '@ohos.data.preferences';
import util from '@ohos.util'

let prefName = 'jchat_pref'
let authKey = 'jchat_auth'

export interface CacheAuth{
  user_id:string
  server_auth:string
  im_token:string
}

export class PreferenceUtil{
  static getJChatServer():string{
    return 'https://ws.juggleim.com'
  }
  static getJImServer():string{
    return "ws://ws.juggleim.com"
  }
  static getAppkey():string{
    return "nsw3sue72begyv7y"
  }

  private static cacheAuth?:CacheAuth = undefined

  static getCacheAuth():CacheAuth|undefined{
    if(PreferenceUtil.cacheAuth!=undefined){
      return PreferenceUtil.cacheAuth
    }
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    let authStr = pref.getSync(authKey,"")
    if(authStr!=""){
      let cacheAuth = JSON.parse(authStr.toString()) as CacheAuth
      PreferenceUtil.cacheAuth = cacheAuth
      return cacheAuth
    }else{
      return undefined
    }
  }

  static setCacheAuth(userId:string, serverAuth:string, imToken:string){
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    pref.putSync(authKey,JSON.stringify({
      user_id : userId,
      server_auth : serverAuth,
      im_token : imToken
    }))
    pref.flush()
  }

  static cleanCacheAuth(){
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    pref.deleteSync(authKey)
    pref.flush()
  }
}