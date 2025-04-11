import http from "@ohos.net.http";

export interface JimServerHeaders{
  appkey:string
  Authorization?:string
}

export type HttpCallback = (code:number,data?:Object)=>void

export function doHttp(url:string,method:http.RequestMethod,header?:JimServerHeaders,data?:string,callback?:HttpCallback) {
  let httpRequest = http.createHttp()
  httpRequest.request(url,{
    method:method,
    extraData:data,
    header:header,
    expectDataType:http.HttpDataType.OBJECT,
    readTimeout:5000,
    connectTimeout:5000,
  },(err,data)=>{
    if(err){
      if(callback){
        callback(-1,'')
      }
    }else{
      let retCode:number = 0
      if(data.responseCode!=200){
        retCode = -2
      }else{
        retCode = data.result["code"] as number
      }
      if(callback){
        callback(retCode,data.result["data"])
      }
    }
    httpRequest.destroy()
  })
}