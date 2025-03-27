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

export function newConnectMessage(body:imconnect.ConnectMsgBody):imconnect.ImWebsocketMsg{
  let wsMsg = newImWsMsg(Cmd.connect)
  wsMsg.connectMsgBody = body
  return wsMsg
}

export function newUserPublishMessage(body:imconnect.PublishMsgBody):imconnect.ImWebsocketMsg{
  let wsMsg = newImWsMsg(Cmd.publish)
  wsMsg.publishMsgBody = body
  return wsMsg
}

export function newUserPubAckMessage(body:imconnect.PublishAckMsgBody):imconnect.ImWebsocketMsg{
  let wsMsg = newImWsMsg(Cmd.publishAck)
  wsMsg.pubAckMsgBody = body
  return wsMsg
}

export function newQueryMessage(body:imconnect.QueryMsgBody):imconnect.ImWebsocketMsg{
  let wsMsg = newImWsMsg(Cmd.query)
  wsMsg.qryMsgBody = body
  return wsMsg
}