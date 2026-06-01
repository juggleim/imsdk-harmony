import { MediaMessageContent } from '../entries/message'

/**
 * Represents Media Upload File Type.
 *
 * Example:
 * ```ts
 * const fileType = MediaUploadFileType.image
 * ```
 */
export class MediaUploadFileType {
  static readonly image:number = 1
  static readonly audio:number = 2
  static readonly video:number = 3
  static readonly file:number = 4
}

/**
 * Represents Media Upload Oss Type.
 *
 * Example:
 * ```ts
 * const ossType = MediaUploadOssType.defaultOss
 * ```
 */
export class MediaUploadOssType {
  static readonly defaultOss:number = 0
  static readonly qiNiu:number = 1
  static readonly s3:number = 2
  static readonly minio:number = 3
  static readonly oss:number = 4
}

/**
 * Represents Media Upload Credential.
 *
 * Example:
 * ```ts
 * const value = new MediaUploadCredential()
 * ```
 */
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

/**
 * Represents Media Upload Result.
 *
 * Example:
 * ```ts
 * const value = new MediaUploadResult()
 * ```
 */
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

/**
 * Defines the Media Upload Progress Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MediaUploadProgressCallback = (...args: unknown[]) => {}
 * ```
 */
export type MediaUploadProgressCallback = (progress: number) => void
/**
 * Defines the Media Upload Success Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MediaUploadSuccessCallback = (...args: unknown[]) => {}
 * ```
 */
export type MediaUploadSuccessCallback = (result: MediaUploadResult) => void
/**
 * Defines the Media Upload Error Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MediaUploadErrorCallback = (...args: unknown[]) => {}
 * ```
 */
export type MediaUploadErrorCallback = (code: number, message: string) => void
/**
 * Defines the Media Upload Cancel Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MediaUploadCancelCallback = (...args: unknown[]) => {}
 * ```
 */
export type MediaUploadCancelCallback = () => void
/**
 * Defines the Media Upload Credential Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MediaUploadCredentialCallback = (...args: unknown[]) => {}
 * ```
 */
export type MediaUploadCredentialCallback = (code: number, credential: MediaUploadCredential | null) => void

/**
 * Declares the contract for I Message Upload Provider.
 *
 * Example:
 * ```ts
 * class MyProvider implements IMessageUploadProvider { /* ... */ }
 * ```
 */
export interface IMessageUploadProvider {
  uploadMediaMessage(
    msg: MediaMessageContent,
    onProgress: MediaUploadProgressCallback,
    onSuccess: MediaUploadSuccessCallback,
    onError: MediaUploadErrorCallback,
    onCancel: MediaUploadCancelCallback
  ): void
}
