/**
 * Declares the contract for Login Resp.
 *
 * Example:
 * ```ts
 * const resp: LoginResp = { user_id: "", authorization: "", nickname: "", avatar: "", im_token: "" }
 * ```
 */
export interface LoginResp{
  user_id:string
  authorization:string
  nickname:string
  avatar:string
  im_token:string
}

/**
 * Declares the contract for Server Info Index Resp.
 *
 * Example:
 * ```ts
 * const resp: ServerInfoIndexResp = { server_info_plain: "" }
 * ```
 */
export interface ServerInfoIndexResp{
  server_info_plain:string
}

/**
 * Declares the contract for Server Info Plain.
 *
 * Example:
 * ```ts
 * const resp: ServerInfoPlain = { app_key: "", im_servers: [], app_servers: [] }
 * ```
 */
export interface ServerInfoPlain{
  app_key:string
  im_servers:string[]
  app_servers:string[]
}
