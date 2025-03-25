import { buffer } from '@kit.ArkTS';

// 字符串转成字节流
export function stringToUint8Array(str: string) {
  return new Uint8Array(buffer.from(str, 'utf-8').buffer);
}

// 字节流转成可理解的字符串
export function uint8ArrayToString(array: Uint8Array) {
  // 将UTF-8编码转换成Unicode编码
  let out: string = '';
  let index: number = 0;
  let len: number = array.length;
  while (index < len) {
    let character = array[index++];
    switch (character >> 4) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
        out += String.fromCharCode(character);
        break;
      case 12:
      case 13:
        out += String.fromCharCode(((character & 0x1F) << 6) | (array[index++] & 0x3F));
        break;
      case 14:
        out += String.fromCharCode(((character & 0x0F) << 12) | ((array[index++] & 0x3F) << 6) |
          ((array[index++] & 0x3F) << 0));
        break;
      default:
        break;
    }
  }
  return out;
}