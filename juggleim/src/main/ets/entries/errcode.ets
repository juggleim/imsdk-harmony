export class JimErrorCode{
  Success:number = 0

  InvalidParam:number = 21003
  OperationTimeout:number = 21004
  ConnectionUnavaliable:number = 21005
  ServerSetError:number = 21006
  ConnectionAlreadyExist:number = 21007

  MessageNotExist:number = 22001
  MessageAlreadyRecalled:number = 22002
  MessageUploadError:number = 22003
  RecallExtrasTypeNotString:number = 22004

  DownloadNotMediaMessage:number = 23001
  MessageDownloadError:number = 23006
  DownloadAlreadyExist:number = 23008
  DownloadCanceled:number = 23009

  ChatroomBatchSetAttributeFail:number = 24001
}