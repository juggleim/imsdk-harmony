import util from '@ohos.util';
import { JSON } from '@kit.ArkTS';

export class JimUtil{
  static isEmpty(str:Object):boolean{
    if(str===null||str===undefined){
      return true
    }
    return str.toString().length == 0
  }

  static stringToNumber(str:string):number{
    let num = Number(str)
    if(isNaN(num)){
      return 0
    }
    return num
  }

  static stringToUint8Array(str: string) {
    let textEncoder = new util.TextEncoder();
    return textEncoder.encodeInto(str);
  }

  static uint8ArrayToString(array: Uint8Array) {
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true })
    return textDecoder.decodeToString(new Uint8Array(array));
  }

  static arrayBufferToUint8Array(buffer: ArrayBuffer): Uint8Array {
    let temp = new Uint8Array(buffer);
    return temp;
  }

  static uint8ArrayToArrayBuffer(array: Uint8Array): ArrayBuffer {
    let temp = array.buffer as ArrayBuffer;
    return temp;
  }

  static map2Obj(m:Map<string,string>):Record<string,string>{
    let jsonObj:Record<string,string> = {}
    m.forEach((v,k)=>{
      jsonObj[k] = v
    })
    return jsonObj
  }

  static obj2Map(obj:Object):Map<string,string>{
    let record = (obj as Record<string,string>)
    let keys = Object.keys(record)
    let m:Map<string,string> = new Map()
    keys.forEach((key)=>{
      m.set(key,record[key])
    })
    return m
  }
}