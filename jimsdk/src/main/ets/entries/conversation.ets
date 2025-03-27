export class Conversation{
  conversationId:string
  conversationType:number
  constructor(converId:string,converType:number) {
    this.conversationId = converId
    this.conversationType = converType
  }
}