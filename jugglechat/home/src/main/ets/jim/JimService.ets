import {JuggleIm} from 'juggleim'
import { Conversation, ConversationInfo } from 'juggleim/src/main/ets/entries/conversation'
import { BusinessError } from '@kit.BasicServicesKit'

export function initJuggleIm(connectCallback:(status:number,code:number)=>void){
  JuggleIm.instance.init("ws://ws.juggleim.com/im","nsw3sue72begyv7y")
  JuggleIm.instance.getConnectionManager().addConnectStatusListener((status,code)=>{
    console.log("jimsdk_connect_status:",status,"\tcode:",code)
    connectCallback(status,code)
  })
  JuggleIm.instance.getConnectionManager().connect("ChBuc3czc3VlNzJiZWd5djd5GiC5pEcMb2Pa6WNhninw7ZEGQq9J9eQeR_VZs7UO7rpiJA==")

  setTimeout(()=>{
    test()
    console.log("jimsdk_call_finish")
  },2000)

}

async function test(){
  let p = Asy()
  p.then((conver)=>{
    return Asy2(conver)
  }).then((a)=>{
    console.log("jimsdk_call_d:",a)
  })
}

function  Asy():Promise<ConversationInfo>{
  return new Promise((resolve,reject)=>{
    JuggleIm.instance.getConversationManager().getConversation(new Conversation("userid1",1),(code,conver)=>{
      console.log("jimsdk_call:",JSON.stringify(conver))
      if(code==0) {
        resolve(conver as ConversationInfo)
      }else{
        reject(new Error("sb"))
      }
    })
  })
}

function Asy2(conver:ConversationInfo):Promise<number>{
  return new Promise((resolve)=>{
    resolve(conver.conversation.conversationType)
  })
}