
/**
 * Represents Jim Msg Type.
 *
 * Example:
 * ```ts
 * const value = new JimMsgType()
 * ```
 */
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
  static GroupReadNtf:string = 'jg:grpreadntf'
  static ClearUnread:string = 'jg:clearunread'
  static ModifyMsg:string = 'jg:modify'
  static MsgExSet:string = 'jg:msgexset'
  static TopMsg:string = 'jg:topmsg'
  static DelMsgs:string = `jg:delmsgs`
}
