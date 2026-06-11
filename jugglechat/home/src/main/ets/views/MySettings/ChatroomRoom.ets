import { promptAction } from '@kit.ArkUI'
import { CommonUtil, ObservedArray } from '../../jim/common'
import {
  ChatroomAttributesListener,
  ChatroomListener,
  Conversation,
  GetMessageDirection,
  GetMessageOptions,
  JuggleIm,
  Message,
  MsgModifiedListener,
  MsgReceivedListener,
  TextMessage
} from 'juggleim'
import { buildMessagePreview } from '../../viewmodel/MessageViewModel'
import { ChatroomRoomParams } from './ChatroomList'
import { PreferenceUtil, StoredChatroom } from '../../jim/preferenceutil'

const TOP_TRACE_TAG:string = 'TOPTRACE'

@Observed
class ChatroomMessageItem {
  key:string = ''
  senderId:string = ''
  preview:string = ''
  time:string = ''
  msgTime:number = 0
  isSelf:boolean = false

  constructor() {
  }
}

@Observed
class ChatroomAttributeItem {
  key:string = ''
  value:string = ''

  constructor() {
  }
}

interface ChatroomPageCallbacks {
  onChatroomJoin(chatroomId:string): void
  onChatroomQuit(chatroomId:string): void
  onChatroomJoinFail(chatroomId:string, errorCode:number): void
  onChatroomQuitFail(chatroomId:string, errorCode:number): void
  onChatroomKick(chatroomId:string): void
  onChatroomDestroy(chatroomId:string): void
  onAttributesUpdate(chatroomId:string, attributes:Map<string, string>): void
  onAttributesDelete(chatroomId:string, attributes:Map<string, string>): void
}

class ChatroomPageListener implements ChatroomListener {
  private page:ChatroomPageCallbacks

  constructor(page:ChatroomPageCallbacks) {
    this.page = page
  }

  onChatroomJoin(chatroomId:string): void {
    this.page.onChatroomJoin(chatroomId)
  }

  onChatroomQuit(chatroomId:string): void {
    this.page.onChatroomQuit(chatroomId)
  }

  onChatroomJoinFail(chatroomId:string, errorCode:number): void {
    this.page.onChatroomJoinFail(chatroomId, errorCode)
  }

  onChatroomQuitFail(chatroomId:string, errorCode:number): void {
    this.page.onChatroomQuitFail(chatroomId, errorCode)
  }

  onChatroomKick(chatroomId:string): void {
    this.page.onChatroomKick(chatroomId)
  }

  onChatroomDestroy(chatroomId:string): void {
    this.page.onChatroomDestroy(chatroomId)
  }
}

class ChatroomPageAttributesListener implements ChatroomAttributesListener {
  private page:ChatroomPageCallbacks

  constructor(page:ChatroomPageCallbacks) {
    this.page = page
  }

  onAttributesUpdate(chatroomId:string, attributes:Map<string, string>): void {
    this.page.onAttributesUpdate(chatroomId, attributes)
  }

  onAttributesDelete(chatroomId:string, attributes:Map<string, string>): void {
    this.page.onAttributesDelete(chatroomId, attributes)
  }
}

@Component
export default struct ChatroomRoomPage {
  @Consume('pageInfo') pageInfo: NavPathStack
  @Consume('mySettingPageInfo') mySettingPageInfo:NavPathStack
  @Consume('activeNavSource') activeNavSource: string

  @State private chatroomId:string = ''
  @State private title:string = '聊天室'
  @State private joinStatus:string = '加入中'
  @State private messageText:string = ''
  @State private attrKey:string = ''
  @State private attrValue:string = ''
  @State private messages:ObservedArray<ChatroomMessageItem> = new ObservedArray<ChatroomMessageItem>([])
  @State private attributes:ObservedArray<ChatroomAttributeItem> = new ObservedArray<ChatroomAttributeItem>([])

  private listenerKey:string = ''
  private attrListenerKey:string = ''
  private hasQuit:boolean = false
  private msgReceiveListener:MsgReceivedListener = async (_message)=>{}
  private msgModifiedListener:MsgModifiedListener = async (_message)=>{}

  private getActivePageInfo(): NavPathStack {
    if (this.activeNavSource == 'settings') {
      return this.mySettingPageInfo
    }
    return this.pageInfo
  }

  private showToast(message:string):void {
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  private getConversation():Conversation {
    return new Conversation(this.chatroomId, 3, '')
  }

  aboutToAppear(): void {
    let param = this.mySettingPageInfo.getParamByIndex(this.mySettingPageInfo.size() - 1) as ChatroomRoomParams
    if (this.activeNavSource != 'settings') {
      param = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ChatroomRoomParams
    }
    this.chatroomId = param.chatroomId
    this.title = param.title
    this.listenerKey = `chatroom_room_${this.chatroomId}`
    this.attrListenerKey = `chatroom_attr_${this.chatroomId}`
    this.hasQuit = false
    console.log(`${TOP_TRACE_TAG} chatroom_page_appear: chatroomId=${this.chatroomId}, title=${this.title}`)
    JuggleIm.instance.getChatroomManager().addListener(this.listenerKey, new ChatroomPageListener(this))
    JuggleIm.instance.getChatroomManager().addAttributesListener(this.attrListenerKey, new ChatroomPageAttributesListener(this))
    this.msgReceiveListener = async (message)=>{
      if(message.conversation.conversationId != this.chatroomId || message.conversation.conversationType != 3){
        return
      }
      this.upsertMessage(message)
    }
    this.msgModifiedListener = async (message)=>{
      if(message.conversation.conversationId != this.chatroomId || message.conversation.conversationType != 3){
        return
      }
      this.upsertMessage(message)
    }
    JuggleIm.instance.getMessageManager().addMsgReceivedListener(this.msgReceiveListener)
    JuggleIm.instance.getMessageManager().addMsgModifiedListener(this.msgModifiedListener)
    JuggleIm.instance.getChatroomManager().joinChatroom(this.chatroomId, 20, param.isAutoCreate)
    this.loadLocalMessages()
    this.refreshAttributes()
  }

  aboutToDisappear(): void {
    JuggleIm.instance.getChatroomManager().removeListener(this.listenerKey)
    JuggleIm.instance.getChatroomManager().removeAttributesListener(this.attrListenerKey)
    JuggleIm.instance.getMessageManager().removeMsgReceivedListener(this.msgReceiveListener)
    JuggleIm.instance.getMessageManager().removeMsgModifiedListener(this.msgModifiedListener)
    if(!this.hasQuit && this.chatroomId != ''){
      this.hasQuit = true
      JuggleIm.instance.getChatroomManager().quitChatroom(this.chatroomId)
    }
  }

  private loadLocalMessages():void {
    let options = new GetMessageOptions()
    options.count = 50
    options.time = 0
    options.direction = GetMessageDirection.Backward
    JuggleIm.instance.getMessageManager().queryLocalMessages(this.getConversation(), options, (_code, messages)=>{
      let nextItems:ChatroomMessageItem[] = []
      messages.forEach((message)=>{
        nextItems.push(this.toMessageItem(message))
      })
      this.messages = new ObservedArray<ChatroomMessageItem>(nextItems)
    })
  }

  private toMessageItem(message:Message):ChatroomMessageItem {
    let item = new ChatroomMessageItem()
    item.key = message.messageId != '' ? message.messageId : message.clientId
    item.senderId = message.senderId
    item.preview = buildMessagePreview(message.msgContent)
    item.time = CommonUtil.getTimeToYYYYDDMMHHMMSS(message.sentTime)
    item.msgTime = message.sentTime
    item.isSelf = message.senderId == JuggleIm.instance.userId
    return item
  }

  private upsertMessage(message:Message):void {
    let nextItems = this.messages.slice()
    let current = this.toMessageItem(message)
    let foundIndex = nextItems.findIndex((item)=>{
      return item.key == current.key
    })
    if(foundIndex >= 0){
      nextItems[foundIndex] = current
    }else{
      nextItems.push(current)
    }
    nextItems = nextItems.slice().sort((a, b)=>{
      return a.msgTime - b.msgTime
    })
    this.messages = new ObservedArray<ChatroomMessageItem>(nextItems)
  }

  private sendTextMessage():void {
    let content = this.messageText.trim()
    if(content == ''){
      this.showToast('请输入消息内容')
      return
    }
    let msg = new TextMessage()
    msg.content = content
    console.log(`${TOP_TRACE_TAG} chatroom_page_send_start: chatroomId=${this.chatroomId}, textLength=${content.length}`)
    JuggleIm.instance.getMessageManager().sendMessage(msg, this.getConversation(), (code, message)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_page_send_finish: chatroomId=${this.chatroomId}, code=${code}`)
      if(code == 0 && message != null){
        this.messageText = ''
        this.upsertMessage(message)
        return
      }
      this.showToast(`发送失败: ${code}`)
    })
  }

  private refreshAttributes():void {
    JuggleIm.instance.getChatroomManager().getAllAttributes(this.chatroomId, (code, attributes)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_page_get_attrs_finish: chatroomId=${this.chatroomId}, code=${code}, count=${attributes != null ? attributes.size : 0}`)
      if(code != 0 || attributes == null){
        return
      }
      this.applyAttributes(attributes)
    })
  }

  private setAttribute():void {
    let key = this.attrKey.trim()
    if(key == ''){
      this.showToast('请输入属性 key')
      return
    }
    let attrs:Map<string, string> = new Map()
    attrs.set(key, this.attrValue)
    console.log(`${TOP_TRACE_TAG} chatroom_page_set_attr_start: chatroomId=${this.chatroomId}, key=${key}`)
    JuggleIm.instance.getChatroomManager().setAttributes(this.chatroomId, attrs, (code, _failedKeys)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_page_set_attr_finish: chatroomId=${this.chatroomId}, key=${key}, code=${code}`)
      if(code != 0){
        this.showToast(`设置属性失败: ${code}`)
        return
      }
      this.showToast('属性设置成功')
      this.refreshAttributes()
    })
  }

  private removeAttribute():void {
    let key = this.attrKey.trim()
    if(key == ''){
      this.showToast('请输入属性 key')
      return
    }
    console.log(`${TOP_TRACE_TAG} chatroom_page_remove_attr_start: chatroomId=${this.chatroomId}, key=${key}`)
    JuggleIm.instance.getChatroomManager().removeAttributes(this.chatroomId, [key], (code, _failedKeys)=>{
      console.log(`${TOP_TRACE_TAG} chatroom_page_remove_attr_finish: chatroomId=${this.chatroomId}, key=${key}, code=${code}`)
      if(code != 0){
        this.showToast(`删除属性失败: ${code}`)
        return
      }
      this.showToast('属性删除成功')
      this.refreshAttributes()
    })
  }

  private applyAttributes(attributes:Map<string, string>):void {
    let items:ChatroomAttributeItem[] = []
    attributes.forEach((value, key)=>{
      let item = new ChatroomAttributeItem()
      item.key = key
      item.value = value
      items.push(item)
    })
    items = items.slice().sort((a, b)=>{
      return a.key.localeCompare(b.key)
    })
    this.attributes = new ObservedArray<ChatroomAttributeItem>(items)
  }

  onChatroomJoin(chatroomId:string):void {
    if(chatroomId != this.chatroomId){
      return
    }
    this.joinStatus = '已加入'
    this.loadLocalMessages()
    this.refreshAttributes()
    // 保存到已加入聊天室列表
    let param = this.mySettingPageInfo.getParamByIndex(this.mySettingPageInfo.size() - 1) as ChatroomRoomParams
    if (this.activeNavSource != 'settings') {
      param = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ChatroomRoomParams
    }
    if (param.isAutoCreate) {
      let saved = PreferenceUtil.getJoinedChatrooms()
      let exists = saved.find((item: StoredChatroom) => item.chatroomId == chatroomId)
      if (!exists) {
        saved.push(new StoredChatroom(chatroomId, param.title || chatroomId))
        PreferenceUtil.saveJoinedChatrooms(saved)
      }
    }
  }

  onChatroomQuit(chatroomId:string):void {
    if(chatroomId != this.chatroomId){
      return
    }
    this.joinStatus = '已退出'
  }

  onChatroomJoinFail(chatroomId:string, errorCode:number):void {
    if(chatroomId != this.chatroomId){
      return
    }
    this.joinStatus = `加入失败(${errorCode})`
    this.showToast(`加入聊天室失败: ${errorCode}`)
  }

  onChatroomQuitFail(chatroomId:string, errorCode:number):void {
    if(chatroomId != this.chatroomId){
      return
    }
    this.showToast(`退出聊天室失败: ${errorCode}`)
  }

  onChatroomKick(chatroomId:string):void {
    if(chatroomId != this.chatroomId){
      return
    }
    this.joinStatus = '已被移出'
    this.showToast('已被移出聊天室')
  }

  onChatroomDestroy(chatroomId:string):void {
    if(chatroomId != this.chatroomId){
      return
    }
    this.joinStatus = '聊天室已销毁'
    this.showToast('聊天室已销毁')
    this.messages = new ObservedArray<ChatroomMessageItem>([])
    this.attributes = new ObservedArray<ChatroomAttributeItem>([])
  }

  onAttributesUpdate(chatroomId:string, attributes:Map<string, string>):void {
    if(chatroomId != this.chatroomId){
      return
    }
    let nextAttributes:Map<string, string> = new Map()
    this.attributes.forEach((item)=>{
      nextAttributes.set(item.key, item.value)
    })
    attributes.forEach((value, key)=>{
      nextAttributes.set(key, value)
    })
    this.applyAttributes(nextAttributes)
  }

  onAttributesDelete(chatroomId:string, attributes:Map<string, string>):void {
    if(chatroomId != this.chatroomId){
      return
    }
    let nextAttributes:Map<string, string> = new Map()
    this.attributes.forEach((item)=>{
      nextAttributes.set(item.key, item.value)
    })
    attributes.forEach((_value, key)=>{
      nextAttributes.delete(key)
    })
    this.applyAttributes(nextAttributes)
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text(this.chatroomId)
            .fontSize(12)
            .fontColor('#6B7280')
          Blank()
          Text(this.joinStatus)
            .fontSize(12)
            .fontColor('#4C8DFF')
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 10, bottom: 10 })
        .backgroundColor(Color.White)

        List() {
          ForEach(this.messages, (item:ChatroomMessageItem)=>{
            ListItem() {
              Column() {
                Row() {
                  Text(item.isSelf ? '我' : item.senderId)
                    .fontSize(12)
                    .fontColor('#6B7280')
                  Blank()
                  Text(item.time)
                    .fontSize(12)
                    .fontColor('#9CA3AF')
                }
                .width('100%')

                Text(item.preview)
                  .width('100%')
                  .fontSize(16)
                  .fontColor('#111827')
                  .margin({ top: 6 })
              }
              .width('100%')
              .padding(12)
              .backgroundColor(item.isSelf ? '#E8F1FF' : Color.White)
              .borderRadius(6)
            }
            .padding({ left: 12, right: 12, top: 8 })
          }, (item:ChatroomMessageItem)=>{
            return item.key
          })
        }
        .width('100%')
        .layoutWeight(1)

        Column() {
          Row() {
            TextInput({ text: this.attrKey, placeholder: '属性 Key' })
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(6)
              .onChange((value:string)=>{
                this.attrKey = value
              })
            TextInput({ text: this.attrValue, placeholder: '属性 Value' })
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(6)
              .margin({ left: 8 })
              .onChange((value:string)=>{
                this.attrValue = value
              })
          }

          Row() {
            Button('刷新')
              .height(36)
              .onClick(()=>{
                this.refreshAttributes()
              })
            Button('设置')
              .height(36)
              .margin({ left: 8 })
              .onClick(()=>{
                this.setAttribute()
              })
            Button('删除')
              .height(36)
              .margin({ left: 8 })
              .onClick(()=>{
                this.removeAttribute()
              })
          }
          .margin({ top: 8 })

          if(this.attributes.length > 0){
            Column() {
              ForEach(this.attributes, (item:ChatroomAttributeItem)=>{
                Row() {
                  Text(item.key)
                    .fontSize(12)
                    .fontColor('#6B7280')
                  Blank()
                  Text(item.value)
                    .fontSize(12)
                    .fontColor('#111827')
                }
                .width('100%')
                .padding({ top: 4, bottom: 4 })
              }, (item:ChatroomAttributeItem)=>{
                return item.key
              })
            }
            .width('100%')
            .margin({ top: 8 })
          }
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F3F4F6')

        Row() {
          TextInput({ text: this.messageText, placeholder: '输入聊天室消息' })
            .layoutWeight(1)
            .height(44)
            .backgroundColor(Color.White)
            .borderRadius(6)
            .onChange((value:string)=>{
              this.messageText = value
            })
          Button('发送')
            .height(44)
            .margin({ left: 8 })
            .onClick(()=>{
              this.sendTextMessage()
            })
        }
        .width('100%')
        .padding(12)
        .backgroundColor(Color.White)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FA')
    }
    .title(this.title)
  }
}
