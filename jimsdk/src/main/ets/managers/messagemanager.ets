import {JuggleIm} from '../juggleim'
import {PublishCallback} from  './connectionmanager'
import {immessage} from  '../improto/immessage'
import {JimUtil} from '../commons/jimutil'
import { MsgFlag, MsgFlagTool} from '../improto/msgflag'

export class MessageManager{
  static instance:MessageManager = new MessageManager()
  send(channelType:number,targetId:string,callback:PublishCallback){
    let msgFlag = new MsgFlag()
    msgFlag.isStorage = true
    msgFlag.isCount = true
    let msg = immessage.UpMsg.create({
      "msgType":"jg:text",
      "msgContent":JimUtil.stringToUint8Array('{"content":"hello"}'),
      "flags":MsgFlagTool.toFlag(msgFlag)
    })
    let data = immessage.UpMsg.encode(msg).finish()
    JuggleIm.instance.connectionManager().publish("p_msg",targetId,data,callback)
  }
}