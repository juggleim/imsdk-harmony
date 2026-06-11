import { UIAbility } from '@kit.AbilityKit'
import type Ability from '@ohos.app.ability.Ability'
import { AAID, pushService } from '@kit.PushKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { JuggleIm, PushChannel } from '@juggleim/imlib'

const PUSH_TRACE_TAG:string = 'PUSHTRACE'
const PUSH_CONNECTION_UNAVAILABLE:number = 21005
const PUSH_NO_TOKEN:number = -2
const PUSH_SUBSCRIBE_FAIL:number = -3
const PUSH_GET_AAID_FAIL:number = -4

class PushActionResult {
  code:number = 0
  message:string = ''
}

class PushDebugSnapshot {
  bundleName:string = ''
  aaid:string = ''
  token:string = ''
  channelName:string = 'Huawei'
  tokenSource:string = ''
  tokenTime:string = ''
  registerCode:number = 0
  registerMessage:string = '未上报'
  registerTime:string = ''
  subscribed:boolean = false
}

class HarmonyPushManager {
  static readonly instance:HarmonyPushManager = new HarmonyPushManager()

  private ability?:UIAbility
  private snapshot:PushDebugSnapshot = new PushDebugSnapshot()
  private tokenUpdateRegistered:boolean = false
  private tokenUpdateCallback?:(token:string)=>void

  init(ability:UIAbility):void {
    this.ability = ability
    this.snapshot.bundleName = ability.context.applicationInfo.name
    JuggleIm.instance.setPackageName(this.snapshot.bundleName)
    console.log(`${PUSH_TRACE_TAG} push_manager_init: bundleName=${this.snapshot.bundleName}`)
    this.registerTokenUpdate()
    void this.refreshAAID()
  }

  destroy():void {
    let currentCallback = this.tokenUpdateCallback
    if(!this.tokenUpdateRegistered || currentCallback == undefined){
      return
    }
    try{
      pushService.off('tokenUpdate', currentCallback)
      console.log(`${PUSH_TRACE_TAG} push_manager_token_update_off`)
    }catch(err){
      let bizError = err as BusinessError
      console.log(`${PUSH_TRACE_TAG} push_manager_token_update_off_fail: code=${bizError.code}, message=${bizError.message}`)
    }
    this.tokenUpdateRegistered = false
    this.snapshot.subscribed = false
    this.tokenUpdateCallback = undefined
  }

  getSnapshot():PushDebugSnapshot {
    let copy = new PushDebugSnapshot()
    copy.bundleName = this.snapshot.bundleName
    copy.aaid = this.snapshot.aaid
    copy.token = this.snapshot.token
    copy.channelName = this.snapshot.channelName
    copy.tokenSource = this.snapshot.tokenSource
    copy.tokenTime = this.snapshot.tokenTime
    copy.registerCode = this.snapshot.registerCode
    copy.registerMessage = this.snapshot.registerMessage
    copy.registerTime = this.snapshot.registerTime
    copy.subscribed = this.snapshot.subscribed
    return copy
  }

  async refreshAAID():Promise<PushActionResult> {
    let result = new PushActionResult()
    try{
      let aaid = await AAID.getAAID()
      this.snapshot.aaid = aaid
      result.code = 0
      result.message = 'AAID 获取成功'
      console.log(`${PUSH_TRACE_TAG} push_manager_get_aaid_success: aaid=${aaid}`)
    }catch(err){
      let bizError = err as BusinessError
      result.code = bizError.code == 0 ? PUSH_GET_AAID_FAIL : bizError.code
      result.message = `AAID 获取失败: ${bizError.message}`
      console.log(`${PUSH_TRACE_TAG} push_manager_get_aaid_fail: code=${bizError.code}, message=${bizError.message}`)
    }
    return result
  }

  async requestToken(registerRemote:boolean = true):Promise<PushActionResult> {
    try{
      let token = await pushService.getToken()
      console.log(`${PUSH_TRACE_TAG} push_manager_get_token_success: tokenLength=${token.length}, registerRemote=${registerRemote}`)
      return await this.handleToken(token, 'getToken', registerRemote)
    }catch(err){
      let bizError = err as BusinessError
      console.log(`${PUSH_TRACE_TAG} push_manager_get_token_fail: code=${bizError.code}, message=${bizError.message}`)
      return this.recordRegisterResult(bizError.code == 0 ? PUSH_NO_TOKEN : bizError.code, `Token 获取失败: ${bizError.message}`)
    }
  }

  async registerCurrentToken(source:string = 'manual'):Promise<PushActionResult> {
    if(this.snapshot.token == ''){
      return await this.requestToken(true)
    }
    return await this.registerToken(this.snapshot.token, source)
  }

  async registerManualToken(token:string):Promise<PushActionResult> {
    let normalizedToken = token.trim()
    if(normalizedToken == ''){
      return this.recordRegisterResult(PUSH_NO_TOKEN, 'Token 不能为空')
    }
    return await this.handleToken(normalizedToken, 'manualInput', true)
  }

  async onImConnected():Promise<void> {
    console.log(`${PUSH_TRACE_TAG} push_manager_im_connected: hasToken=${this.snapshot.token != ''}, bundleName=${this.snapshot.bundleName}`)
    if(this.snapshot.token != ''){
      await this.registerCurrentToken('imConnected')
    }else{
      await this.requestToken(true)
    }
  }

  private registerTokenUpdate():void {
    let currentAbility = this.ability
    if(currentAbility == undefined || this.tokenUpdateRegistered){
      return
    }
    this.tokenUpdateCallback = (token:string)=>{
      console.log(`${PUSH_TRACE_TAG} push_manager_token_update: tokenLength=${token.length}`)
      void this.handleToken(token, 'tokenUpdate', true)
    }
    try{
      pushService.on('tokenUpdate', currentAbility as Ability, this.tokenUpdateCallback)
      this.tokenUpdateRegistered = true
      this.snapshot.subscribed = true
      console.log(`${PUSH_TRACE_TAG} push_manager_token_update_on_success`)
    }catch(err){
      let bizError = err as BusinessError
      this.snapshot.subscribed = false
      console.log(`${PUSH_TRACE_TAG} push_manager_token_update_on_fail: code=${bizError.code}, message=${bizError.message}`)
      this.recordRegisterResult(PUSH_SUBSCRIBE_FAIL, `订阅 tokenUpdate 失败: ${bizError.message}`)
    }
  }

  private async handleToken(token:string, source:string, registerRemote:boolean):Promise<PushActionResult> {
    this.snapshot.token = token
    this.snapshot.tokenSource = source
    this.snapshot.tokenTime = this.formatTime()
    if(registerRemote){
      return await this.registerToken(token, source)
    }
    let result = new PushActionResult()
    result.code = 0
    result.message = 'Token 获取成功'
    return result
  }

  private async registerToken(token:string, source:string):Promise<PushActionResult> {
    return await new Promise<PushActionResult>((resolve)=>{
      console.log(`${PUSH_TRACE_TAG} push_manager_register_remote: source=${source}, tokenLength=${token.length}, connStatus=${JuggleIm.instance.getConnStatus()}`)
      JuggleIm.instance.getConnectionManager().registerPushToken(PushChannel.Huawei, token, (code:number)=>{
        if(code == PUSH_CONNECTION_UNAVAILABLE){
          resolve(this.recordRegisterResult(code, '连接未建立，Token 已缓存，连接成功后会继续上报'))
          return
        }
        if(code == 0){
          resolve(this.recordRegisterResult(0, 'Push Token 上报成功'))
          return
        }
        resolve(this.recordRegisterResult(code, `Push Token 上报失败: ${code}`))
      })
    })
  }

  private recordRegisterResult(code:number, message:string):PushActionResult {
    this.snapshot.registerCode = code
    this.snapshot.registerMessage = message
    this.snapshot.registerTime = this.formatTime()
    console.log(`${PUSH_TRACE_TAG} push_manager_register_result: code=${code}, message=${message}`)
    let result = new PushActionResult()
    result.code = code
    result.message = message
    return result
  }

  private formatTime():string {
    let now = new Date()
    let year = `${now.getFullYear()}`
    let month = `${now.getMonth() + 1}`.padStart(2, '0')
    let day = `${now.getDate()}`.padStart(2, '0')
    let hours = `${now.getHours()}`.padStart(2, '0')
    let minutes = `${now.getMinutes()}`.padStart(2, '0')
    let seconds = `${now.getSeconds()}`.padStart(2, '0')
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
  }
}

export {
  HarmonyPushManager,
  PushActionResult,
  PushDebugSnapshot
}
