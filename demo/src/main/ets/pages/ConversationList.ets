import { BreakpointConstants } from "base";
import { ObservedArray } from "../jim/common";
import { ConversationItem } from "../viewmodels/ConversationViewModel";

@Entry
@Component
struct ConversationList{
  // @StorageProp('currentBreadpoint') currentBreakpoint:string = BreakpointConstants.BREAKPOINT_SM
  // @Link currentConversationUserName:ResourceStr
  // @Link currentContactUserName:string;
  // @State private currentIndex:number = 0;
  // @State conversationList:ObservedArray<ConversationItem>=[]
  // @Consume('pageInfo') pageInfo:NavPathStack

  aboutToAppear(): void {

  }

  build() {
    Row() {
      Column() {
        Text('欢迎登录JuggleChat $token').fontSize(35).margin({
          bottom: 10,
        }).textAlign(TextAlign.Center).width('90%')
      }
    }
  }
}