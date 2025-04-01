
export class MsgFlag{
  isCmd:boolean = false
  isCount:boolean = false
  isState:boolean = false
  isStorage:boolean = false
  isModified:boolean = false
  isMerged:boolean = false
  isUndisturb:boolean = false
  isNoAffectSenderConver:boolean = false
  isExtMsg:boolean = false
  isReactionMsg:boolean = false
  isStreamMsg:boolean = false
}

export class MsgFlagTool{
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
    if(f.isNoAffectSenderConver){
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
    let msgFlag = new MsgFlag()
    if((flag&0x1)==1){
      msgFlag.isCmd = true
    }
    if((flag&0x2)==2){
      msgFlag.isCount = true
    }
    if((flag&0x4)==4){
      msgFlag.isState = true
    }
    if((flag&0x8)==8){
      msgFlag.isStorage = true
    }
    if((flag&0x10)==16){
      msgFlag.isModified = true
    }
    if((flag&0x20)==32){
      msgFlag.isMerged = true
    }
    if((flag&0x40)==64){
      msgFlag.isUndisturb = true
    }
    if((flag&0x80)==128){
      msgFlag.isNoAffectSenderConver=true
    }
    if((flag&0x100)==256){
      msgFlag.isExtMsg = true
    }
    if((flag&0x200)==512){
      msgFlag.isReactionMsg = true
    }
    if((flag&0x400)==1024){
      msgFlag.isStreamMsg = true
    }
    return msgFlag
  }
}