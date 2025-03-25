import {imconnect} from './imconnect'

export class Cmd{
  static readonly connect = 0
  static readonly connectAck = 1
  static readonly  disconnect = 2
  static readonly publish = 3
  static readonly  publishAck = 4
  static readonly  query = 5
  static readonly  queryAck = 6
  static readonly  queryConfirm = 7
  static readonly  ping = 8
  static readonly  pong = 9
}

function newImWsMsg(cmd:number):imconnect.ImWebsocketMsg{
  let msg = imconnect.ImWebsocketMsg.create({
    "version":1,
    "cmd":cmd
  })
  return msg
}

export function newConnectMessage(body:imconnect.ConnectMsgBody):Uint8Array{
  let wsMsg = newImWsMsg(Cmd.connect)
  wsMsg.connectMsgBody = body
  return imconnect.ImWebsocketMsg.encode(wsMsg).finish()
}

export function newUserPublishMessage(body:imconnect.PublishMsgBody):Uint8Array{
  let wsMsg = newImWsMsg(Cmd.publish)
  wsMsg.publishMsgBody = body
  let data:Uint8Array = imconnect.ImWebsocketMsg.encode(wsMsg).finish()
  return data
}