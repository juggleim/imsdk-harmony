import http from '@ohos.net.http'
import { BusinessError } from '@kit.BasicServicesKit'
import { fileIo } from '@kit.CoreFileKit'
import {
  FileMessage,
  ImageMessage,
  IMessageUploadProvider,
  JuggleIm,
  MediaMessageContent,
  MediaUploadCredential,
  MediaUploadFileType,
  MediaUploadOssType,
  MediaUploadResult,
  JimUtil,
  VideoMessage,
  VoiceMessage
} from 'juggleim'

class UploadRequestHeaders {
  'Content-Type'?: string
  'content-type'?: string
  'content-length'?: string
  'x-amz-acl'?: string
  constructor() {
  }
}

/**
 * Represents Real Message Upload Provider.
 *
 * Example:
 * ```ts
 * const provider = new RealMessageUploadProvider()
 * ```
 */
export class RealMessageUploadProvider implements IMessageUploadProvider {
  uploadMediaMessage(
    msg: MediaMessageContent,
    onProgress: (progress: number) => void,
    onSuccess: (result: MediaUploadResult) => void,
    onError: (code: number, message: string) => void,
    onCancel: () => void
  ): void {
    let fileType = this.resolveFileType(msg)
    let ext = this.getFileExtension(msg.localPath)
    JuggleIm.instance.getMessageManager().queryUploadFileCredential(
      fileType,
      ext,
      (code: number, credential: MediaUploadCredential | null) => {
        if(code != 0 || credential == null){
          onError(code != 0 ? code : -1, 'query upload credential failed')
          return
        }
        console.info(`jimsdk_media_upload_credential:${credential.ossType}:${credential.uploadUrl}:${credential.downloadUrl}`)
        if(credential.ossType == MediaUploadOssType.qiNiu){
          onError(-4, 'qiniu upload is not supported in harmony yet')
          return
        }
        if(credential.uploadUrl == ''){
          onError(-5, 'upload url is empty')
          return
        }
        this.uploadByPreSign(msg, credential, onProgress, onSuccess, onError, onCancel)
      }
    )
  }

  private resolveFileType(msg:MediaMessageContent):number{
    if(msg instanceof ImageMessage){
      return MediaUploadFileType.image
    }
    if(msg instanceof VoiceMessage){
      return MediaUploadFileType.audio
    }
    if(msg instanceof VideoMessage){
      return MediaUploadFileType.video
    }
    return MediaUploadFileType.file
  }

  private getFileExtension(path:string):string{
    let normalized = path.split('?')[0]
    let dotIndex = normalized.lastIndexOf('.')
    if(dotIndex < 0 || dotIndex >= normalized.length - 1){
      return ''
    }
    return normalized.substring(dotIndex + 1)
  }

  private uploadByPreSign(
    msg:MediaMessageContent,
    credential:MediaUploadCredential,
    onProgress: (progress: number) => void,
    onSuccess: (result: MediaUploadResult) => void,
    onError: (code: number, message: string) => void,
    onCancel: () => void
  ): void {
    let payload:ArrayBuffer
    try{
      payload = this.readFileToBuffer(msg.localPath)
    }catch (error) {
      let err = error as BusinessError
      onError(err.code, err.message)
      return
    }

    let requestTask = http.createHttp()
    requestTask.on('dataSendProgress', (info:http.DataSendProgressInfo)=>{
      if(info.totalSize <= 0){
        return
      }
      let progress = Math.floor(info.sendSize * 100 / info.totalSize)
      if(progress < 0){
        progress = 0
      }
      if(progress > 100){
        progress = 100
      }
      onProgress(progress)
    })

    let headers:UploadRequestHeaders
    if(credential.ossType == MediaUploadOssType.s3){
      headers = {
        'content-length': `${payload.byteLength}`,
        'x-amz-acl': 'public-read'
      } as UploadRequestHeaders
    }else{
      headers = {
        'content-length': `${payload.byteLength}`
      } as UploadRequestHeaders
    }
    let requestContentType = headers['Content-Type'] ?? headers['content-type'] ?? ''
    let requestPathRaw = this.getUploadUrlPath(credential.uploadUrl)
    let requestPathDecoded = this.decodeUrlPath(requestPathRaw)
    console.info(
      `jimsdk_media_upload_request:${credential.ossType}:${credential.uploadUrl}:` +
      `contentType=${requestContentType}:rawPath=${requestPathRaw}:decodedPath=${requestPathDecoded}:headers=${JSON.stringify(headers)}`
    )

    let responseStatusCode = -1
    let responseBodyParts:string[] = []
    let responseEnded = false
    let responseLogged = false
    let cleanup = ():void => {
      requestTask.off('dataSendProgress')
      requestTask.off('dataReceive')
      requestTask.off('dataEnd')
      requestTask.destroy()
    }
    let tryFinalize = ():void => {
      if(responseLogged || !responseEnded || responseStatusCode < 0){
        return
      }
      responseLogged = true
      let responseBody = responseBodyParts.join('')
      console.info(`jimsdk_media_upload_response:${credential.ossType}:${responseStatusCode}:bodyLength=${responseBody.length}`)
      this.logHttpResponseBody(responseStatusCode, credential.uploadUrl, responseBody, requestContentType, requestPathRaw, requestPathDecoded)
      cleanup()
      if(responseStatusCode < 200 || responseStatusCode >= 300){
        console.error(`jimsdk_media_upload_response_fail:${credential.ossType}:${responseStatusCode}`)
        onError(responseStatusCode, `HTTP ${responseStatusCode}`)
        return
      }
      onProgress(100)
      onSuccess(this.buildUploadResult(msg, credential))
    }

    requestTask.on('dataReceive', (data:ArrayBuffer) => {
      responseBodyParts.push(JimUtil.uint8ArrayToString(JimUtil.arrayBufferToUint8Array(data)))
    })
    requestTask.on('dataEnd', () => {
      responseEnded = true
      tryFinalize()
    })

    requestTask.requestInStream(credential.uploadUrl, {
      method: http.RequestMethod.PUT,
      extraData: payload,
      header: headers,
      usingCache: false,
      readTimeout: 20000,
      connectTimeout: 20000
    }, (err: BusinessError | undefined, responseCodeValue: number)=>{
      if(err){
        cleanup()
        console.error(`jimsdk_media_upload_http_fail:${credential.ossType}:${err.code}:${err.message}`)
        onError(err.code, err.message)
        return
      }
      responseStatusCode = responseCodeValue
      tryFinalize()
    })
  }

  private readFileToBuffer(path:string):ArrayBuffer{
    let stat = fileIo.statSync(path)
    let fd = fileIo.openSync(path)
    try{
      let totalSize = stat.size
      if(totalSize <= 0){
        return new ArrayBuffer(0)
      }
      let buffer = new ArrayBuffer(totalSize)
      let readSize = fileIo.readSync(fd.fd, buffer)
      if(readSize >= totalSize){
        return buffer
      }
      return buffer.slice(0, readSize)
    } finally {
      fileIo.closeSync(fd)
    }
  }

  private buildUploadResult(msg:MediaMessageContent, credential:MediaUploadCredential):MediaUploadResult{
    let result = new MediaUploadResult()
    result.url = credential.downloadUrl != '' ? credential.downloadUrl : this.removeQueryString(credential.uploadUrl)
    if(msg instanceof ImageMessage){
      result.width = msg.width
      result.height = msg.height
      result.size = msg.size
      result.thumbnail = result.url
      return result
    }
    if(msg instanceof FileMessage){
      result.name = msg.name
      result.type = msg.type
      result.size = msg.size
      return result
    }
    if(msg instanceof VideoMessage){
      result.width = msg.width
      result.height = msg.height
      result.size = msg.size
      result.duration = msg.duration
      result.poster = msg.poster
      return result
    }
    if(msg instanceof VoiceMessage){
      result.type = msg.type
      result.duration = msg.duration
      return result
    }
    return result
  }

  private removeQueryString(url:string):string{
    let queryIndex = url.indexOf('?')
    if(queryIndex < 0){
      return url
    }
    return url.substring(0, queryIndex)
  }

  private getUploadUrlPath(url:string):string{
    let normalizedUrl = this.removeQueryString(url)
    let schemeIndex = normalizedUrl.indexOf('://')
    let pathIndex = schemeIndex >= 0 ? normalizedUrl.indexOf('/', schemeIndex + 3) : normalizedUrl.indexOf('/')
    if(pathIndex < 0){
      return '/'
    }
    return normalizedUrl.substring(pathIndex)
  }

  private decodeUrlPath(path:string):string{
    try{
      return decodeURIComponent(path)
    }catch (error) {
      console.error(`jimsdk_media_upload_decode_path_fail:${path}:${error}`)
      return path
    }
  }

  private extractXmlTagValue(body:string, tagName:string):string{
    let openTag = `<${tagName}>`
    let closeTag = `</${tagName}>`
    let startIndex = body.indexOf(openTag)
    if(startIndex < 0){
      return ''
    }
    startIndex += openTag.length
    let endIndex = body.indexOf(closeTag, startIndex)
    if(endIndex < 0 || endIndex < startIndex){
      return ''
    }
    return body.substring(startIndex, endIndex).trim()
  }

  private logHttpResponseBody(
    responseCode:number,
    url:string,
    body:string,
    requestContentType:string,
    rawPath:string,
    decodedPath:string
  ):void{
    console.info(
      `jimsdk_media_upload_body_hint:url=${url}:code=${responseCode}:contentType=${requestContentType}:rawPath=${rawPath}:decodedPath=${decodedPath}`
    )
    if(responseCode != 403){
      return
    }
    let trimmedBody = body.trim()
    if(trimmedBody == ''){
      console.error(`jimsdk_media_upload_403_body_empty:${url}`)
      return
    }
    let sanitizedBody = trimmedBody.replaceAll('\r', '\\r').replaceAll('\n', '\\n')
    console.error(`jimsdk_media_upload_403_body:${url}:${sanitizedBody}`)
    console.error(
      `jimsdk_media_upload_403_fields:${url}:` +
      `Code=${this.extractXmlTagValue(trimmedBody, 'Code')}:` +
      `Message=${this.extractXmlTagValue(trimmedBody, 'Message')}:` +
      `StringToSign=${this.extractXmlTagValue(trimmedBody, 'StringToSign')}:` +
      `SignatureProvided=${this.extractXmlTagValue(trimmedBody, 'SignatureProvided')}`
    )
  }
}
