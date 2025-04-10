
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
  static getTimeToYYYYDDMMHHMMSS(time: number): string {
    let timeStr: string = "";
    let date = new Date(time);
    let curr = new Date()
    try {
      let year = date.getFullYear()
      let currYear = curr.getFullYear()

      let month = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1)
      let currMonth = (curr.getMonth() + 1)<10 ? "0" + (curr.getMonth() + 1):(curr.getMonth() + 1)

      let day = date.getDate() < 10 ? "0" + date.getDate() : date.getDate()
      let currDay = curr.getDate()<10? "0" +curr.getDate() : curr.getDate()

      let hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours()
      let min = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()
      // let second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();

      if(year==currYear && month == currMonth && day == currDay){
        timeStr = hour + ":" + min
      }else{
        if(year==currYear){
          timeStr = month + "-" + day
        }else{
          timeStr = year + "-" + month + "-" + day
        }
      }
    } catch (e) {
      console.info(`Failed to get currentTime. message: ${e.message}, code: ${e.code}`);
    }
    return timeStr;
  }

  static sleepSync(ms:number){
    const end = Date.now()+ms
    while(Date.now()<end){}
  }

  private static defaultBackgroundColors:string[] = ['#D45246','#F68136','#6C61DF','#46BA43','#5CAFFA','#408ACF','#D95574']

  static getBackgroundColor(c:string):string{
    if(c===undefined||c.length<=0){
      return CommonUtil.defaultBackgroundColors[0]
    }
    let charCode:number = c.charCodeAt(0)
    return CommonUtil.defaultBackgroundColors[charCode%7]
  }

  static getFirstChar(c:string):string{
    if(c===undefined||c.length<=0){
      return ''
    }
    return c.charAt(0)
  }
}