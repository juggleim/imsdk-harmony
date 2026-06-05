import http from '@ohos.net.http'
import { BusinessError } from '@kit.BasicServicesKit'
import { fileIo } from '@kit.CoreFileKit'
import { MediaUploadCredential, MediaUploadCredentialCallback, MediaUploadFileType, MediaUploadOssType, MediaUploadResult } from '../interfaces/imessageuploadprovider'
import { IMessageUploadProvider } from '../interfaces/imessageuploadprovider'
import { FileMessage, ImageMessage, MediaMessageContent, VideoMessage, VoiceMessage } from '../entries/message'
import { JimUtil } from '../commons/jimutil'

class UploadRequestHeaders {
  'Content-Type'?: string
  'Content-Length'?: string
  'x-amz-acl'?: string
}

export class DefaultMessageUploadProvider implements IMessageUploadProvider {
  private readonly queryUploadFileCredential: (fileType: number, ext: string, callback: MediaUploadCredentialCallback) => void
  private readonly traceTag:string = 'jimsdk_media_upload'
  private readonly uploadPreSignLocation:string = 'DefaultMessageUploadProvider.uploadByPreSign'
  private readonly uploadQiniuLocation:string = 'DefaultMessageUploadProvider.uploadByQiniu'

  constructor(queryUploadFileCredential: (fileType: number, ext: string, callback: MediaUploadCredentialCallback) => void) {
    this.queryUploadFileCredential = queryUploadFileCredential
  }

  uploadMediaMessage(
    msg: MediaMessageContent,
    onProgress: (progress: number) => void,
    onSuccess: (result: MediaUploadResult) => void,
    onError: (code: number, message: string) => void,
    onCancel: () => void
  ): void {
    let fileType = this.resolveFileType(msg)
    let ext = this.getFileExtension(msg.localPath)
    console.error(`jimsdk_media_upload_cred_fail: fileType=${fileType}， ext=${ext}`)
    this.queryUploadFileCredential(fileType, ext, (code: number, credential: MediaUploadCredential | null) => {
      if (code != 0 || credential == null) {
        console.error(`jimsdk_media_upload_cred_fail: code=${code}`)
        onError(code != 0 ? code : -1, 'query upload credential failed')
        return
      }
      console.info(
        `jimsdk_media_upload_credential: ossType=${credential.ossType}, ` +
        `uploadUrl=${credential.uploadUrl}, domain=${credential.domain}, downloadUrl=${credential.downloadUrl}`
      )
      if (this.isPreSignCredential(credential)) {
        this.uploadByPreSign(msg, credential, onProgress, onSuccess, onError, onCancel)
        return
      }
      if (this.isQiniuCredential(credential)) {
        this.uploadByQiniu(msg, credential, onProgress, onSuccess, onError, onCancel)
        return
      }
      console.error(`jimsdk_media_upload_cred_invalid: ossType=${credential.ossType}`)
      onError(-5, 'upload credential is invalid')
    })
  }

  private resolveFileType(msg: MediaMessageContent): number {
    if (msg instanceof ImageMessage) {
      return MediaUploadFileType.image
    }
    if (msg instanceof VoiceMessage) {
      return MediaUploadFileType.audio
    }
    if (msg instanceof VideoMessage) {
      return MediaUploadFileType.video
    }
    return MediaUploadFileType.file
  }

  private isQiniuCredential(credential: MediaUploadCredential): boolean {
    return credential.token.trim() != '' && credential.domain.trim() != ''
  }

  private isPreSignCredential(credential: MediaUploadCredential): boolean {
    return credential.uploadUrl.trim() != ''
  }

  private getFileExtension(path: string): string {
    let normalized = this.removeQueryString(path)
    let dotIndex = normalized.lastIndexOf('.')
    if (dotIndex < 0 || dotIndex >= normalized.length - 1) {
      return ''
    }
    return normalized.substring(dotIndex + 1)
  }

  private uploadByPreSign(
    msg: MediaMessageContent,
    credential: MediaUploadCredential,
    onProgress: (progress: number) => void,
    onSuccess: (result: MediaUploadResult) => void,
    onError: (code: number, message: string) => void,
    onCancel: () => void
  ): void {
    void (async (): Promise<void> => {
      let payload: ArrayBuffer
      try {
        payload = this.readFileToBuffer(msg.localPath)
      } catch (error) {
        let bizError = error as BusinessError
        console.error(`jimsdk_media_upload_read_fail: code=${bizError.code}, message=${bizError.message}`)
        onError(bizError.code, bizError.message)
        return
      }

      let requestTask = http.createHttp()
      requestTask.on('dataSendProgress', (info: http.DataSendProgressInfo) => {
        if (info.totalSize <= 0) {
          return
        }
        let progress = Math.floor(info.sendSize * 100 / info.totalSize)
        if (progress < 0) {
          progress = 0
        }
        if (progress > 100) {
          progress = 100
        }
        onProgress(progress)
      })

      let headers: UploadRequestHeaders
      if (credential.ossType == MediaUploadOssType.s3) {
        headers = {
          'Content-Type': '',
          'Content-Length': `${payload.byteLength}`,
          'x-amz-acl': 'public-read'
        } as UploadRequestHeaders
      } else {
        headers = {
          'Content-Type': '',
          'Content-Length': `${payload.byteLength}`
        } as UploadRequestHeaders
      }
      let requestContentType = ''
      let requestPathRaw = this.getUploadUrlPath(credential.uploadUrl)
      let requestPathDecoded = this.decodeUrlPath(requestPathRaw)
      let requestMsg = this.buildUploadMsgSummary(msg, credential.ossType, msg.localPath)
      console.info(
        `${this.traceTag}_http_request: location=${this.uploadPreSignLocation}, method=PUT, url=${credential.uploadUrl}, ` +
        `requestMsg=${requestMsg}, requestContentType=${requestContentType}, rawPath=${requestPathRaw}, decodedPath=${requestPathDecoded}, ` +
        `headers=${JSON.stringify(headers)}, ` +
        `curl=${this.buildPreSignCurl(credential.uploadUrl, msg.localPath, payload.byteLength, credential.ossType == MediaUploadOssType.s3)}`
      )

      try {
        let response = await requestTask.request(credential.uploadUrl, {
          method: http.RequestMethod.PUT,
          extraData: payload,
          header: headers,
          expectDataType: http.HttpDataType.STRING,
          readTimeout: 20000,
          connectTimeout: 20000
        })
        let responseStatusCode = response.responseCode
        let responseBody = response.result != undefined && response.result != null ? `${response.result}` : ''
        console.info(
          `${this.traceTag}_http_response: location=${this.uploadPreSignLocation}, ossType=${credential.ossType}, ` +
          `url=${credential.uploadUrl}, responseCode=${responseStatusCode}, responseBodyLength=${responseBody.length}`
        )
        this.logHttpResponseBody(
          responseStatusCode,
          credential.uploadUrl,
          responseBody,
          requestContentType,
          requestPathRaw,
          requestPathDecoded,
          requestMsg
        )
        if (responseStatusCode < 200 || responseStatusCode >= 300) {
          console.error(
            `${this.traceTag}_http_response_fail: location=${this.uploadPreSignLocation}, ossType=${credential.ossType}, ` +
            `url=${credential.uploadUrl}, responseCode=${responseStatusCode}`
          )
          onError(responseStatusCode, `HTTP ${responseStatusCode}`)
          return
        }
        onProgress(100)
        onSuccess(this.buildUploadResult(msg, credential, ''))
      } catch (error) {
        let bizError = error as BusinessError
        console.error(
          `${this.traceTag}_http_fail: location=${this.uploadPreSignLocation}, ossType=${credential.ossType}, ` +
          `url=${credential.uploadUrl}, code=${bizError.code}, message=${bizError.message}`
        )
        onError(bizError.code, bizError.message)
      } finally {
        requestTask.destroy()
      }
    })()
  }

  private uploadByQiniu(
    msg: MediaMessageContent,
    credential: MediaUploadCredential,
    onProgress: (progress: number) => void,
    onSuccess: (result: MediaUploadResult) => void,
    onError: (code: number, message: string) => void,
    onCancel: () => void
  ): void {
    void (async (): Promise<void> => {
      let payload: ArrayBuffer
      try {
        payload = this.readFileToBuffer(msg.localPath)
      } catch (error) {
        let bizError = error as BusinessError
        console.error(`jimsdk_media_upload_read_fail: code=${bizError.code}, message=${bizError.message}`)
        onError(bizError.code, bizError.message)
        return
      }

      let fileName = this.getFileName(msg.localPath)
      if (fileName == '') {
        onError(-6, 'file name is empty')
        return
      }
      let key = credential.objKey.trim() != '' ? credential.objKey : fileName
      let boundary = this.buildMultipartBoundary()
      let multipart = this.buildQiniuMultipartBody(boundary, credential.token, key, fileName, payload)

      let requestTask = http.createHttp()
      requestTask.on('dataSendProgress', (info: http.DataSendProgressInfo) => {
        if (info.totalSize <= 0) {
          return
        }
        let progress = Math.floor(info.sendSize * 100 / info.totalSize)
        if (progress < 0) {
          progress = 0
        }
        if (progress > 100) {
          progress = 100
        }
        onProgress(progress)
      })

      let headers: UploadRequestHeaders = {
        'Content-Type': `multipart/form-data; boundary=${boundary}`,
        'Content-Length': `${multipart.byteLength}`
      } as UploadRequestHeaders
      let requestContentType = `multipart/form-data; boundary=${boundary}`
      let requestUrl = 'https://upload.qiniup.com'
      let requestMsg = this.buildUploadMsgSummary(msg, credential.ossType, msg.localPath)
      let requestPathRaw = this.getUploadUrlPath(requestUrl)
      let requestPathDecoded = this.decodeUrlPath(requestPathRaw)
      console.info(
        `${this.traceTag}_qiniu_request: location=${this.uploadQiniuLocation}, method=POST, url=${requestUrl}, ` +
        `requestMsg=${requestMsg}, requestContentType=${requestContentType}, rawPath=${requestPathRaw}, decodedPath=${requestPathDecoded}, ` +
        `headers=${JSON.stringify(headers)}, ` +
        `curl=${this.buildQiniuCurl(credential, key, msg.localPath, fileName, multipart.byteLength)}`
      )

      try {
        let response = await requestTask.request(requestUrl, {
          method: http.RequestMethod.POST,
          extraData: multipart,
          header: headers,
          expectDataType: http.HttpDataType.STRING,
          readTimeout: 20000,
          connectTimeout: 20000
        })
        let responseStatusCode = response.responseCode
        let responseBody = response.result != undefined && response.result != null ? `${response.result}` : ''
        console.info(
          `${this.traceTag}_qiniu_response: location=${this.uploadQiniuLocation}, url=${requestUrl}, ` +
          `responseCode=${responseStatusCode}, responseBodyLength=${responseBody.length}, requestContentType=${requestContentType}, ` +
          `rawPath=${requestPathRaw}, decodedPath=${requestPathDecoded}`
        )
        this.logHttpResponseBody(responseStatusCode, requestUrl, responseBody, requestContentType, requestPathRaw, requestPathDecoded, requestMsg)
        if (responseStatusCode < 200 || responseStatusCode >= 300) {
          console.error(
            `${this.traceTag}_qiniu_response_fail: location=${this.uploadQiniuLocation}, url=${requestUrl}, responseCode=${responseStatusCode}`
          )
          onError(responseStatusCode, `HTTP ${responseStatusCode}`)
          return
        }
        onProgress(100)
        onSuccess(this.buildUploadResult(msg, credential, key))
      } catch (error) {
        let bizError = error as BusinessError
        console.error(
          `${this.traceTag}_qiniu_fail: location=${this.uploadQiniuLocation}, url=${requestUrl}, ` +
          `code=${bizError.code}, message=${bizError.message}`
        )
        onError(bizError.code, bizError.message)
      } finally {
        requestTask.destroy()
      }
    })()
  }

  private buildQiniuMultipartBody(boundary: string, token: string, key: string, fileName: string, payload: ArrayBuffer): ArrayBuffer {
    let parts: Uint8Array[] = []
    parts.push(JimUtil.stringToUint8Array(`--${boundary}\r\n`))
    parts.push(JimUtil.stringToUint8Array(`Content-Disposition: form-data; name="token"\r\n\r\n${token}\r\n`))
    parts.push(JimUtil.stringToUint8Array(`--${boundary}\r\n`))
    parts.push(JimUtil.stringToUint8Array(`Content-Disposition: form-data; name="key"\r\n\r\n${key}\r\n`))
    parts.push(JimUtil.stringToUint8Array(`--${boundary}\r\n`))
    parts.push(JimUtil.stringToUint8Array(`Content-Disposition: form-data; name="file"; filename="${this.escapeMultipartValue(fileName)}"\r\n`))
    parts.push(JimUtil.stringToUint8Array(`Content-Type: application/octet-stream\r\n\r\n`))
    parts.push(new Uint8Array(payload))
    parts.push(JimUtil.stringToUint8Array(`\r\n--${boundary}--\r\n`))
    return this.concatParts(parts)
  }

  private buildMultipartBoundary(): string {
    return `----JuggleIm${Date.now()}${Math.floor(Math.random() * 100000)}`
  }

  private buildUploadMsgSummary(msg: MediaMessageContent, ossType: number, localPath: string): string {
    return `msgType=${msg.getContentType()}, localPath=${localPath}, ossType=${ossType}, uploadState=${msg.uploadState}, uploadProgress=${msg.uploadProgress}`
  }

  private buildPreSignCurl(url: string, filePath: string, contentLength: number, isS3: boolean): string {
    let parts:string[] = []
    parts.push(`curl -X PUT '${this.escapeCurlSingleQuote(url)}'`)
    parts.push(`-H 'Content-Length: ${contentLength}'`)
    if(isS3){
      parts.push(`-H 'x-amz-acl: public-read'`)
    }
    parts.push(`--data-binary '@${this.escapeCurlSingleQuote(filePath)}'`)
    return parts.join(' \\\n  ')
  }

  private buildQiniuCurl(credential: MediaUploadCredential, key: string, filePath: string, fileName: string, contentLength: number): string {
    let parts:string[] = []
    parts.push(`curl -X POST 'https://upload.qiniup.com'`)
    parts.push(`-H 'Content-Type: multipart/form-data'`)
    parts.push(`-H 'Content-Length: ${contentLength}'`)
    parts.push(`-F 'token=${this.escapeCurlSingleQuote(credential.token)}'`)
    parts.push(`-F 'key=${this.escapeCurlSingleQuote(key)}'`)
    parts.push(`-F 'file=@${this.escapeCurlSingleQuote(filePath)};filename=${this.escapeCurlSingleQuote(fileName)}'`)
    return parts.join(' \\\n  ')
  }

  private escapeCurlSingleQuote(value: string): string {
    return value.replaceAll("'", "'\"'\"'")
  }

  private logHttpResponseBody(
    responseCode:number,
    url:string,
    body:string,
    requestContentType:string,
    rawPath:string,
    decodedPath:string,
    requestMsg:string
  ):void{
    console.info(
      `${this.traceTag}_response_body_hint: url=${url}, responseCode=${responseCode}, ` +
      `requestMsg=${requestMsg}, requestContentType=${requestContentType}, rawPath=${rawPath}, decodedPath=${decodedPath}, searchKey=jimsdk_media_upload_403`
    )
    if(responseCode != 403){
      return
    }
    let trimmedBody = body.trim()
    if(trimmedBody == ''){
      console.error(`${this.traceTag}_response_403_body_empty: url=${url}, requestMsg=${requestMsg}, searchKey=jimsdk_media_upload_403`)
      console.error(`${this.traceTag}_response_403_search_keys: searchKey=jimsdk_media_upload_403|StringToSign|SignatureProvided|RequestId|RequestID|ErrorCode|Code|Message|HostId`)
      return
    }
    let sanitizedBody = trimmedBody.replaceAll('\r', '\\r').replaceAll('\n', '\\n')
    let code = this.extractXmlTagValue(trimmedBody, 'Code')
    let message = this.extractXmlTagValue(trimmedBody, 'Message')
    let stringToSign = this.extractXmlTagValue(trimmedBody, 'StringToSign')
    let signatureProvided = this.extractXmlTagValue(trimmedBody, 'SignatureProvided')
    let requestId = this.extractXmlTagValue(trimmedBody, 'RequestId')
    if(requestId == ''){
      requestId = this.extractXmlTagValue(trimmedBody, 'RequestID')
    }
    let hostId = this.extractXmlTagValue(trimmedBody, 'HostId')
    console.error(`${this.traceTag}_response_403_body: url=${url}, requestMsg=${requestMsg}, body=${sanitizedBody}, searchKey=jimsdk_media_upload_403`)
    console.error(
      `${this.traceTag}_response_403_fields: url=${url}, ` +
      `Code=${code}, Message=${message}, StringToSign=${stringToSign}, SignatureProvided=${signatureProvided}, ` +
      `RequestId=${requestId}, HostId=${hostId}, requestMsg=${requestMsg}, searchKey=jimsdk_media_upload_403`
    )
    console.error(`${this.traceTag}_response_403_search_keys: searchKey=jimsdk_media_upload_403|StringToSign|SignatureProvided|RequestId|RequestID|ErrorCode|Code|Message|HostId`)
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
    }catch (e) {
      console.error(`${this.traceTag}_decode_url_path_fail: path=${path}, error=${e}`)
      return path
    }
  }

  private escapeMultipartValue(value: string): string {
    return value.replaceAll('"', '_')
  }

  private concatParts(parts: Uint8Array[]): ArrayBuffer {
    let totalLength = 0
    for (let part of parts) {
      totalLength += part.byteLength
    }
    let merged = new Uint8Array(totalLength)
    let offset = 0
    for (let part of parts) {
      merged.set(part, offset)
      offset += part.byteLength
    }
    return merged.buffer.slice(0, totalLength)
  }

  private readFileToBuffer(path: string): ArrayBuffer {
    let stat = fileIo.statSync(path)
    let fd = fileIo.openSync(path)
    try {
      let totalSize = stat.size
      if (totalSize <= 0) {
        return new ArrayBuffer(0)
      }
      let buffer = new ArrayBuffer(totalSize)
      let readSize = fileIo.readSync(fd.fd, buffer)
      if (readSize >= totalSize) {
        return buffer
      }
      return buffer.slice(0, readSize)
    } finally {
      fileIo.closeSync(fd)
    }
  }

  private buildUploadResult(msg: MediaMessageContent, credential: MediaUploadCredential, key: string): MediaUploadResult {
    let result = new MediaUploadResult()
    if (credential.downloadUrl.trim() != '') {
      result.url = credential.downloadUrl
    } else if (credential.uploadUrl.trim() != '') {
      result.url = this.removeQueryString(credential.uploadUrl)
    } else if (credential.domain.trim() != '') {
      result.url = this.joinUrl(credential.domain, key)
    }
    if (msg instanceof ImageMessage) {
      result.width = msg.width
      result.height = msg.height
      result.size = msg.size
      result.thumbnail = result.url
      return result
    }
    if (msg instanceof FileMessage) {
      result.name = msg.name
      result.type = msg.type
      result.size = msg.size
      return result
    }
    if (msg instanceof VideoMessage) {
      result.width = msg.width
      result.height = msg.height
      result.size = msg.size
      result.duration = msg.duration
      result.poster = msg.poster
      return result
    }
    if (msg instanceof VoiceMessage) {
      result.type = msg.type
      result.duration = msg.duration
      return result
    }
    return result
  }

  private getFileName(path: string): string {
    let normalized = this.removeQueryString(path)
    let slashIndex = normalized.lastIndexOf('/')
    if (slashIndex < 0 || slashIndex >= normalized.length - 1) {
      return ''
    }
    return normalized.substring(slashIndex + 1)
  }

  private joinUrl(base: string, path: string): string {
    let normalizedBase = base.trim()
    if (normalizedBase.endsWith('/')) {
      normalizedBase = normalizedBase.substring(0, normalizedBase.length - 1)
    }
    let normalizedPath = path.trim()
    if (normalizedBase == '') {
      return normalizedPath
    }
    if (normalizedPath == '') {
      return normalizedBase
    }
    return `${normalizedBase}/${normalizedPath}`
  }

  private removeQueryString(url: string): string {
    let index = url.indexOf('?')
    if (index < 0) {
      return url
    }
    return url.substring(0, index)
  }
}
