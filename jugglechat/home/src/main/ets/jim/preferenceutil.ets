import preferences from '@ohos.data.preferences';
import util from '@ohos.util'

let prefName = 'jchat_pref'
let authKey = 'jchat_auth'
let loginProfileKey = 'jchat_login_profile'
let serverConfigKey = 'jchat_server_config'

let defaultAppServer = 'https://ws.juggleim.com'
let defaultImServer = 'ws://ws.juggleim.com'
let defaultAppkey = 'nsw3sue72begyv7y'

/**
 * Declares the contract for Cache Auth.
 *
 * Example:
 * ```ts
 * const auth: CacheAuth = { user_id: "", server_auth: "", im_token: "" }
 * ```
 */
export interface CacheAuth{
  user_id:string
  server_auth:string
  im_token:string
}

/**
 * Declares the contract for Login Profile.
 *
 * Example:
 * ```ts
 * const profile: LoginProfile = { organization: "", username: "" }
 * ```
 */
export interface LoginProfile{
  organization:string
  username:string
}

/**
 * Declares the contract for Server Config.
 *
 * Example:
 * ```ts
 * const config: ServerConfig = { organization: "", appServer: "", imServer: "", appkey: "" }
 * ```
 */
export interface ServerConfig{
  organization:string
  appServer:string
  imServer:string
  appkey:string
}

function trimRightSlash(url:string):string{
  if(url.endsWith('/')){
    return url.substring(0,url.length - 1)
  }
  return url
}

/**
 * Represents Preference Util.
 *
 * Example:
 * ```ts
 * const appKey = PreferenceUtil.getAppkey()
 * ```
 */
export class PreferenceUtil{
  static getJChatServer():string{
    let config = PreferenceUtil.getServerConfig()
    if(config!=undefined && config.appServer!=''){
      return config.appServer
    }
    return defaultAppServer
  }
  static getJImServer():string{
    let config = PreferenceUtil.getServerConfig()
    if(config!=undefined && config.imServer!=''){
      return config.imServer
    }
    return defaultImServer
  }
  static getAppkey():string{
    let config = PreferenceUtil.getServerConfig()
    if(config!=undefined && config.appkey!=''){
      return config.appkey
    }
    return defaultAppkey
  }

  private static cacheAuth?:CacheAuth = undefined
  private static loginProfile?:LoginProfile = undefined
  private static serverConfig?:ServerConfig = undefined

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
    let cacheAuth:CacheAuth = {
      user_id : userId,
      server_auth : serverAuth,
      im_token : imToken
    }
    pref.putSync(authKey,JSON.stringify(cacheAuth))
    pref.flush()
    PreferenceUtil.cacheAuth = cacheAuth
  }

  static cleanCacheAuth(){
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    pref.deleteSync(authKey)
    pref.flush()
    PreferenceUtil.cacheAuth = undefined
  }

  static getLoginProfile():LoginProfile|undefined{
    if(PreferenceUtil.loginProfile!=undefined){
      return PreferenceUtil.loginProfile
    }
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    let profileStr = pref.getSync(loginProfileKey,"")
    if(profileStr!=""){
      let profile = JSON.parse(profileStr.toString()) as LoginProfile
      PreferenceUtil.loginProfile = profile
      return profile
    }
    return undefined
  }

  static setLoginProfile(organization:string, username:string){
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    let profile:LoginProfile = {
      organization: organization,
      username: username
    }
    pref.putSync(loginProfileKey,JSON.stringify(profile))
    pref.flush()
    PreferenceUtil.loginProfile = profile
  }

  static getServerConfig():ServerConfig|undefined{
    if(PreferenceUtil.serverConfig!=undefined){
      return PreferenceUtil.serverConfig
    }
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    let configStr = pref.getSync(serverConfigKey,"")
    if(configStr!=""){
      let config = JSON.parse(configStr.toString()) as ServerConfig
      PreferenceUtil.serverConfig = config
      return config
    }
    return undefined
  }

  static setServerConfig(organization:string, appServer:string, imServer:string, appkey:string){
    let ctx = getContext()
    let optionos:preferences.Options = {name:prefName}
    let pref = preferences.getPreferencesSync(ctx,optionos)
    let config:ServerConfig = {
      organization: organization,
      appServer: trimRightSlash(appServer),
      imServer: trimRightSlash(imServer),
      appkey: appkey
    }
    pref.putSync(serverConfigKey,JSON.stringify(config))
    pref.flush()
    PreferenceUtil.serverConfig = config
  }
}
