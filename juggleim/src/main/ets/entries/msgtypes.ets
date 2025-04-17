
export class JimMsgType{
  static Unknown:string = 'jg:unknown'

  static Text:string = 'jg:text'
  static Merge:string = 'jg:merge'
  static Voice:string = 'jg:voice'
  static Image:string = 'jg:img'
  static File:string = 'jg:file'
  static Video:string = 'jg:video'
  static RecallInfo:string = 'jg:recallinfo'

  static RecallCmd:string = 'jg:recall'
  static ReadNtf:string = 'jg:readntf'
  static ClearUnread:string = 'jg:clearunread'
  static ModifyMsg:string = 'jg:modify'
  static DelMsgs:string = `jg:delmsgs`
}