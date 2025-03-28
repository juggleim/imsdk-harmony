import {JuggleIm} from 'jimsdk'

export function initJuggleIm(connectCallback:(status:number,code:number)=>void){
  JuggleIm.instance.init("ws://ws.juggleim.com/im","nsw3sue72begyv7y")
  JuggleIm.instance.connectionManager().addConnectStatusListener((status,code)=>{
    console.log("jimsdk_connect_status:",status,"\tcode:",code)
    connectCallback(status,code)
  })
  JuggleIm.instance.connectionManager().connect("ChBuc3czc3VlNzJiZWd5djd5GiC5pEcMb2Pa6WNhninw7ZEGQq9J9eQeR_VZs7UO7rpiJA==")
}