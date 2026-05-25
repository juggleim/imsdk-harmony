import util from '@ohos.util';
import Long from 'long';

export class StringMapItem {
  key: string = ''
  value: string = ''
}

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

  static map2Obj(m:Map<string,string>):StringMapItem[]{
    let jsonObj:StringMapItem[] = []
    m.forEach((v,k)=>{
      let item = new StringMapItem()
      item.key = k
      item.value = v
      jsonObj.push(item)
    })
    return jsonObj
  }

  static obj2Map(obj:StringMapItem[]|null|undefined):Map<string,string>{
    let m:Map<string,string> = new Map()
    if(obj == undefined || obj == null){
      return m
    }
    obj.forEach((item)=>{
      if(item.key == ''){
        return
      }
      m.set(item.key, item.value)
    })
    return m
  }

  static toNumber(value:number|Long|null):number{
    if(value instanceof Long){
      return value.toNumber()
    }else if(value!==null){
      return value
    }else{
      return 0
    }
  }

  static getUuid():string{
    return `${util.generateRandomUUID().replaceAll("-","")}`
  }

  static getClientMsgNo():number{
    let base = new Date().getTime() * 1000
    let suffix = Math.floor(Math.random() * 1000)
    return base + suffix
  }
}
