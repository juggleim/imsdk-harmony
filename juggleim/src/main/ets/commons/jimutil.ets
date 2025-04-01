import util from '@ohos.util';
import { JSON } from '@kit.ArkTS';

export class JimUtil{
  static isEmpty(str:Object):boolean{
    if(str===null||str===undefined){
      return true
    }
    return str.toString().length == 0
  }

  static stringToUint8Array(str: string) {
    let textEncoder = new util.TextEncoder();
    return textEncoder.encodeInto(str);
  }

  static uint8ArrayToString(array: Uint8Array) {
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true })
    return textDecoder.decodeToString(new Uint8Array(array));
  }

  /**
   * arrayBuffer转Uint8Array
   * @param buffer
   * @returns
   */
  static arrayBufferToUint8Array(buffer: ArrayBuffer): Uint8Array {
    let temp = new Uint8Array(buffer);
    return temp;
  }

  /**
   * uint8Array转ArrayBuffer
   * @param buffer
   * @returns
   */
  static uint8ArrayToArrayBuffer(array: Uint8Array): ArrayBuffer {
    let temp = array.buffer as ArrayBuffer;
    return temp;
  }
}