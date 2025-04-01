import { relationalStore } from "@kit.ArkData";

export class JimDbUtil{
  static toString(resultSet:relationalStore.ResultSet,key:string):string{
    try{
      let index = resultSet.getColumnIndex(key)
      if(index>=0){
        return resultSet.getString(index)
      }
    }catch (e) {
      return ''
    }
    return ''
  }

  static toNumber(resultSet:relationalStore.ResultSet,key:string):number{
    try{
      let index = resultSet.getColumnIndex(key)
      if(index>=0){
        return resultSet.getLong(index)
      }
    }catch (e) {
      return 0
    }
    return 0
  }
}