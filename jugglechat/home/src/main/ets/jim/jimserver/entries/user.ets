export interface Users{
  items:User[]
}

export interface UserSettings{
  language:string
  friend_verify_type:number
  grp_verify_type:number,
  undisturb:string
}

export interface User{
  user_id:string
  nickname:string
  avatar:string
  pinyin?:string
  phone?:string
  status?:number
  settings?:UserSettings
}