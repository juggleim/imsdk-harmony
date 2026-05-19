export interface LoginResp{
  user_id:string
  authorization:string
  nickname:string
  avatar:string
  im_token:string
}

export interface ServerInfoIndexResp{
  server_info_plain:string
}

export interface ServerInfoPlain{
  app_key:string
  im_servers:string[]
  app_servers:string[]
}
