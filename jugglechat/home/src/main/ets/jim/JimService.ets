import {JuggleIm} from 'juggleim'
import { RecallCmdMessage } from 'juggleim/src/main/ets/entries/message'
import { HashMap, JSON } from '@kit.ArkTS'

export function initJuggleIm(connectCallback:(status:number,code:number)=>void){
  JuggleIm.instance.init("ws://ws.juggleim.com/im","nsw3sue72begyv7y")
  JuggleIm.instance.getConnectionManager().addConnectStatusListener((status,code)=>{
    console.log("jimsdk_connect_status:",status,"\tcode:",code)
    connectCallback(status,code)
  })
  JuggleIm.instance.getConnectionManager().connect("ChBuc3czc3VlNzJiZWd5djd5GiC5pEcMb2Pa6WNhninw7ZEGQq9J9eQeR_VZs7UO7rpiJA==")
}