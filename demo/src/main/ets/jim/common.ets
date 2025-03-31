import { Conversation } from 'jimsdk/src/main/ets/entries/conversation';
import { Message } from 'jimsdk/src/main/ets/entries/message';

@Observed
export class ObservedArray<T> extends Array<T>{
  constructor(args: T[]) {
    if (args instanceof Array) {
      super(...args);
    } else {
      super(args)
    }
  }
}

export class CommonUtil{
  static getTimeToYYYYDDMMHHMMSS(str: number): string {
    let time: string = "";
    let date = new Date(str-1);
    try {
      let year = date.getFullYear();
      let month = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1);
      let day = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
      let hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
      let min = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
      let second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
      time = year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + second;
    } catch (e) {
      console.info(`Failed to get currentTime. message: ${e.message}, code: ${e.code}`);
    }
    return time;
  }
}