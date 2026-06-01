import http from "@ohos.net.http";

/**
 * Declares the contract for Jim Server Headers.
 *
 * Example:
 * ```ts
 * const headers: JimServerHeaders = { AppKey: "", Authorization: "" }
 * ```
 */
export interface JimServerHeaders{
  AppKey?:string
  appkey?:string
  Authorization?:string
  'Content-Type'?:string
  'x-amz-acl'?:string
}

/**
 * Defines the Http Callback alias.
 *
 * Example:
 * ```ts
 * const callback: HttpCallback = (code, data, msg) => {}
 * ```
 */
export type HttpCallback = (code:number,data?:Object,msg?:string)=>void

/**
 * Provides the do Http helper.
 *
 * Example:
 * ```ts
 * doHttp("https://example.com", http.RequestMethod.GET)
 * ```
 */
export function doHttp(url:string,method:http.RequestMethod,header?:JimServerHeaders,data?:string,callback?:HttpCallback) {
  let httpRequest = http.createHttp()
  console.log("jim_http_request:", url, JSON.stringify(header ?? {}), data ?? '')
  httpRequest.request(url,{
    method:method,
    extraData:data,
    header:header,
    expectDataType:http.HttpDataType.OBJECT,
    readTimeout:5000,
    connectTimeout:5000,
  },(err,data)=>{
    if(err){
      console.log("jim_http_error:", url, JSON.stringify(err))
      if(callback){
        callback(-1,'',err.message)
      }
    }else{
      let retCode:number = 0
      let retMsg:string = ''
      if(data.responseCode!=200){
        retCode = -2
        retMsg = `HTTP ${data.responseCode}`
      }else{
        retCode = data.result["code"] as number
        retMsg = data.result["msg"] as string
      }
      console.log("jim_http_response:", url, data.responseCode, retCode, retMsg, JSON.stringify(data.result["data"]))
      if(callback){
        callback(retCode,data.result["data"],retMsg)
      }
    }
    httpRequest.destroy()
  })
}
