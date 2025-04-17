
// export class MsgFlag{
//   isCmd:boolean = false
//   isCount:boolean = false
//   isState:boolean = false
//   isStorage:boolean = false
//   isModified:boolean = false
//   isMerged:boolean = false
//   isUndisturb:boolean = false
//   isNoAffectSenderConver:boolean = false
//   isExtMsg:boolean = false
//   isReactionMsg:boolean = false
//   isStreamMsg:boolean = false
// }

export interface  MsgFlag{
  isCmd?:boolean
  isCount?:boolean
  isState?:boolean
  isStorage?:boolean
  isModified?:boolean
  isMerged?:boolean
  isUndisturb?:boolean
  isNoAffectSenderConver?:boolean
  isExtMsg?:boolean
  isReactionMsg?:boolean
  isStreamMsg?:boolean
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
    return {
      isCmd:(flag&0x1)==1,
      isCount:(flag&0x2)==2,
      isState:(flag&0x4)==4,
      isStorage:(flag&0x8)==8,
      isModified:(flag&0x10)==16,
      isMerged:(flag&0x20)==32,
      isUndisturb:(flag&0x40)==64,
      isNoAffectSenderConver:(flag&0x80)==128,
      isExtMsg:(flag&0x100)==256,
      isReactionMsg:(flag&0x200)==512,
      isStreamMsg:(flag&0x400)==1024
    }
  }
}