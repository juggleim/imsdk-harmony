export class UserInfo{
  userId:string = ''
  nickname:string = ''
  userPortrait:string = ''
  userType:number = 0
  updTime:number = 0
  constructor() {
  }
}

export class FriendInfo{
  userId:string = ''
  isFriend:boolean = false
  alias:string = ''
  updTime:number = 0

  constructor() {
  }
}
