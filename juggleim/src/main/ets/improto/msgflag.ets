
export class MsgFlag{
  isCmd:boolean = false
  isCount:boolean = false
  isState:boolean = false
  isStorage:boolean = false
  isModified:boolean = false
  isMerged:boolean = false
  isUndisturb:boolean = false
  isBroadcast:boolean = false
  isNoAffectSenderConver:boolean = false
  isExtMsg:boolean = false
  isReactionMsg:boolean = false
  isStreamMsg:boolean = false
}

export class MsgFlagTool{
  static commandFlag():MsgFlag{
    let flag = new MsgFlag()
    flag.isCmd = true
    return flag
  }

  static storageCountFlag():MsgFlag{
    let flag = new MsgFlag()
    flag.isStorage = true
    flag.isCount = true
    return flag
  }

  static broadcastFlag():MsgFlag{
    let flag = new MsgFlag()
    flag.isBroadcast = true
    return flag
  }

  static toFlag(f:MsgFlag):number{
    let flag:number = 0
    if(f.isCmd){
      flag |= 1
    }
    if(f.isCount){
      flag |= 2
    }
    if(f.isState){
      flag |= 4
    }
    if(f.isStorage){
      flag |= 8
    }
    if(f.isModified){
      flag |= 16
    }
    if(f.isMerged){
      flag |= 32
    }
    if(f.isUndisturb){
      flag |= 64
    }
    if(f.isBroadcast || f.isNoAffectSenderConver){
      flag |= 128
    }
    if(f.isExtMsg){
      flag |= 256
    }
    if(f.isReactionMsg){
      flag |=512
    }
    if(f.isStreamMsg){
      flag |=1024
    }
    return flag
  }

  static parseFlag(flag:number):MsgFlag{
    let result = new MsgFlag()
    result.isCmd = (flag&0x1)==1
    result.isCount = (flag&0x2)==2
    result.isState = (flag&0x4)==4
    result.isStorage = (flag&0x8)==8
    result.isModified = (flag&0x10)==16
    result.isMerged = (flag&0x20)==32
    result.isUndisturb = (flag&0x40)==64
    result.isBroadcast = (flag&0x80)==128
    result.isNoAffectSenderConver = (flag&0x80)==128
    result.isExtMsg = (flag&0x100)==256
    result.isReactionMsg = (flag&0x200)==512
    result.isStreamMsg = (flag&0x400)==1024
    return result
  }
}
