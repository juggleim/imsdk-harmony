
export class MsgFlag{
  isStorage:boolean = false
  isCount:boolean = false
}

export class MsgFlagTool{
  static toFlag(f:MsgFlag):number{
    let flag:number = 0
    if(f.isCount){
      flag |= 2
    }
    if(f.isStorage){
      flag |= 8
    }
    return flag
  }

  static parseFlag(flag:number):MsgFlag{
    let msgFlag = new MsgFlag()
    if((flag&0x2)==2){
      msgFlag.isCount = true
    }
    if((flag&0x8)==8){
      msgFlag.isStorage = true
    }
    return msgFlag
  }
}