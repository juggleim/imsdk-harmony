import { MediaMessageContent } from '../entries/message'

export class MediaUploadFileType {
  static readonly image:number = 1
  static readonly audio:number = 2
  static readonly video:number = 3
  static readonly file:number = 4
}

export class MediaUploadOssType {
  static readonly defaultOss:number = 0
  static readonly qiNiu:number = 1
  static readonly s3:number = 2
  static readonly minio:number = 3
  static readonly oss:number = 4
}

export class MediaUploadCredential {
  ossType:number = MediaUploadOssType.defaultOss
  uploadUrl:string = ''
  downloadUrl:string = ''
  domain:string = ''
  token:string = ''
  objKey:string = ''
  constructor() {
  }
}

export class MediaUploadResult {
  url:string = ''
  thumbnail:string = ''
  poster:string = ''
  name:string = ''
  type:string = ''
  size:number = 0
  duration:number = 0
  width:number = 0
  height:number = 0
  constructor() {
  }
}

export type MediaUploadProgressCallback = (progress: number) => void
export type MediaUploadSuccessCallback = (result: MediaUploadResult) => void
export type MediaUploadErrorCallback = (code: number, message: string) => void
export type MediaUploadCancelCallback = () => void
export type MediaUploadCredentialCallback = (code: number, credential: MediaUploadCredential | null) => void

export interface IMessageUploadProvider {
  uploadMediaMessage(
    msg: MediaMessageContent,
    onProgress: MediaUploadProgressCallback,
    onSuccess: MediaUploadSuccessCallback,
    onError: MediaUploadErrorCallback,
    onCancel: MediaUploadCancelCallback
  ): void
}
