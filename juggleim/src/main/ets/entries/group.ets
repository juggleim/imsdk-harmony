export class GroupInfo{
  groupId:string = ''
  groupName:string = ''
  groupPortrait:string = ''
  updTime:number = 0
  constructor() {
  }
}

export class GroupMember{
  groupId:string=''
  memberId:string=''
  displayName:string=''
  constructor() {
  }
}

export class GroupMessageReadInfo{
  readCount:number = 0
  memberCount:number = 0
  constructor() {
  }
}

export class GroupMessageMemberReadDetail{
  userId:string = ''
  nickname:string = ''
  portrait:string = ''
  readTime:number = 0
  constructor() {
  }
}

export class GroupMessageReadInfoDetail{
  readCount:number = 0
  memberCount:number = 0
  readMembers:GroupMessageMemberReadDetail[] = []
  unreadMembers:GroupMessageMemberReadDetail[] = []
  constructor() {
  }
}
