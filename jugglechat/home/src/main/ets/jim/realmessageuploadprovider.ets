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
  VideoMessage,
  VoiceMessage
} from 'juggleim'

class UploadRequestHeaders {
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

    requestTask.requestInStream(credential.uploadUrl, {
      method: http.RequestMethod.PUT,
      extraData: payload,
      header: headers,
      usingCache: false,
      readTimeout: 20000,
      connectTimeout: 20000
    }, (err: BusinessError | undefined, responseCode: number)=>{
      requestTask.off('dataSendProgress')
      requestTask.destroy()
      if(err){
        console.error(`jimsdk_media_upload_http_fail:${credential.ossType}:${err.code}:${err.message}`)
        onError(err.code, err.message)
        return
      }
      console.info(`jimsdk_media_upload_response_code:${credential.ossType}:${responseCode}`)
      if(responseCode < 200 || responseCode >= 300){
        console.error(`jimsdk_media_upload_response_fail:${credential.ossType}:${responseCode}`)
        onError(responseCode, `HTTP ${responseCode}`)
        return
      }
      onProgress(100)
      onSuccess(this.buildUploadResult(msg, credential))
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
}
