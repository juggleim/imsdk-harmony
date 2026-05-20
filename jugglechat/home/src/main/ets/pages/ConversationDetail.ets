/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Adaptive, BaseConstants, BreakpointConstants, StandardIcon } from 'base';
import {ConversationDetailItem} from '../views/Conversation/ConversationDetailItem';
import { ConversationDetailTopSearch } from '../views/Conversation/ConversationDetailTopSearch';
import { deviceInfo } from '@kit.BasicServicesKit';
import { ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import { ConversationViewItem, toConverViewItem } from '../viewmodel/ConversationViewModel';
import { cloneMessageContent, isDisplayableMessage, MessageViewItem, toMessageViewItem } from '../viewmodel/MessageViewModel'
import { ObservedArray } from '../jim/common';
import {
  Conversation,
  GetConversationDirection,
  GetConversationOptions,
  GetMessageDirection,
  GetMessageOptions,
  JimMsgType,
  JuggleIm,
  Message,
  MessageMentionInfo,
  MessageOptions,
  MentionType,
  MsgModifiedListener,
  MsgReceivedListener,
  TextMessage,
  UserInfo
} from 'juggleim';
import { HomeConstants } from '../constants/HomeConstants';
import { promptAction } from '@kit.ArkUI'

@Observed
class MentionCandidate {
  memberId:string
  name:string
  portrait:string

  constructor(memberId:string, name:string, portrait:string) {
    this.memberId = memberId
    this.name = name
    this.portrait = portrait
  }
}

@Component
export struct ConversationDetail {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Prop currentConversationUserName: string;
  @Prop currentFeatureIndex: number;
  @Prop conversationId:string
  @Prop conversationType:number
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State private conversationTitle:string = ''
  @State msgList:ObservedArray<MessageViewItem>=new ObservedArray<MessageViewItem>([])
  private maxMsgTime:number = 0
  private minMsgTime:number = Number.MAX_SAFE_INTEGER
  @State refreshing:boolean = false
  private scroller:Scroller = new Scroller()
  private msgReceiveListener:MsgReceivedListener = async (message)=>{}
  private msgModifiedListener:MsgModifiedListener = async (message)=>{}
  @State private text:string = ''
  @State private showMessageActionPanel:boolean = false
  @State private showForwardPanel:boolean = false
  @State private selectedMessageIndex:number = -1
  @State private quotedMessageId:string = ''
  @State private quotedPreview:string = ''
  @State private quotedSender:string = ''
  @State private editingMessageId:string = ''
  @State private editingOriginalText:string = ''
  @State private forwardTargets:ObservedArray<ConversationViewItem> = new ObservedArray<ConversationViewItem>([])
  @State private mentionCandidates:ObservedArray<MentionCandidate> = new ObservedArray<MentionCandidate>([])
  @State private filteredMentionCandidates:ObservedArray<MentionCandidate> = new ObservedArray<MentionCandidate>([])
  @State private showMentionPanel:boolean = false
  private selectedMentionMap:Map<string, MentionCandidate> = new Map()
  private touchStartTimeMap:Map<string,number> = new Map()

  @Builder
  refreshContent() {
    Text('Loading...')
      .width('100%')
      .textAlign(TextAlign.Center)
  }

  private recordMsgTime(time:number){
    if(time>this.maxMsgTime){
      this.maxMsgTime = time
    }
    if(time<this.minMsgTime){
      this.minMsgTime = time
    }
  }

  private resetMessageList():void{
    this.msgList = new ObservedArray<MessageViewItem>([])
    this.maxMsgTime = 0
    this.minMsgTime = Number.MAX_SAFE_INTEGER
  }

  private getConversation():Conversation{
    return new Conversation(this.conversationId,this.conversationType)
  }

  private async resolveConversationTitle():Promise<void>{
    if(this.conversationTitle != ''){
      return
    }
    if(this.conversationType == 1){
      let user = await JuggleIm.instance.getUserInfoManager().getUserInfo(this.conversationId)
      if(user.nickname != ''){
        this.conversationTitle = user.nickname
        return
      }
    }else if(this.conversationType == 2){
      let group = JuggleIm.instance.getGroupInfoManager().getLocalGroupInfo(this.conversationId)
      if(group != null && group.groupName != ''){
        this.conversationTitle = group.groupName
        return
      }
    }
    this.conversationTitle = this.currentConversationUserName
  }

  private isGroupConversation():boolean{
    return this.conversationType == 2
  }

  private getItemKey(item:MessageViewItem):string{
    if(item.messageId != ''){
      return item.messageId
    }
    return item.clientId
  }

  private upsertViewItem(viewItem:MessageViewItem):void{
    let currentKey = this.getItemKey(viewItem)
    let foundIndex = this.msgList.findIndex((item)=>{
      return this.getItemKey(item) == currentKey ||
        (viewItem.messageId != '' && item.messageId == viewItem.messageId) ||
        (viewItem.clientId != '' && item.clientId == viewItem.clientId)
    })
    if(foundIndex >= 0){
      this.msgList[foundIndex] = viewItem
    }else{
      this.msgList.push(viewItem)
    }
    this.msgList = new ObservedArray<MessageViewItem>(this.msgList.slice().sort((a,b)=>a.msgTime-b.msgTime))
  }

  private async appendMessage(message:Message, scrollToBottom:boolean):Promise<void>{
    if(!isDisplayableMessage(message)){
      return
    }
    let viewMsg = await toMessageViewItem(message)
    this.upsertViewItem(viewMsg)
    this.recordMsgTime(message.sentTime)
    if(scrollToBottom){
      this.scroller.scrollEdge(Edge.Bottom)
    }
  }

  private getSelectedMessage():MessageViewItem|undefined{
    if(this.selectedMessageIndex < 0 || this.selectedMessageIndex >= this.msgList.length){
      return undefined
    }
    return this.msgList[this.selectedMessageIndex]
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message:message,
      duration:1500,
      bottom:100
    })
  }

  private buildMessageQueryOptions(direction:GetMessageDirection,time:number):GetMessageOptions{
    let options = new GetMessageOptions()
    options.count = 20
    options.time = time
    options.direction = direction
    return options
  }

  private queryMessagesByOptions(options:GetMessageOptions):void{
    JuggleIm.instance.getMessageManager().queryMessages(this.getConversation(), options, async (code,msgs)=>{
      if(code != 0){
        this.showToast(`消息加载失败: ${code}`)
        return
      }
      for(let i = 0;i < msgs.length;i++){
        await this.appendMessage(msgs[i], false)
      }
    })
  }

  private loadInitialMsgs():void{
    let options = this.buildMessageQueryOptions(GetMessageDirection.Backward, 0)
    this.queryMessagesByOptions(options)
  }

  private loadOlderMsgs():void{
    let anchorTime = this.minMsgTime == Number.MAX_SAFE_INTEGER ? 0 : this.minMsgTime
    let options = this.buildMessageQueryOptions(GetMessageDirection.Backward, anchorTime)
    this.queryMessagesByOptions(options)
  }

  private restoreDraft():void{
    let options = new GetConversationOptions()
    options.count = 200
    options.time = 0
    options.direction = GetConversationDirection.Backward
    JuggleIm.instance.getConversationManager().queryConversations(options, (code, convers)=>{
      if(code != 0){
        return
      }
      for(let i = 0; i < convers.length; i++){
        let item = convers[i]
        if(item.conversation.conversationId == this.conversationId &&
          item.conversation.conversationType == this.conversationType){
          this.text = item.draft
          return
        }
      }
      this.text = ''
    })
  }

  private persistDraft():void{
    if(this.text != ''){
      JuggleIm.instance.getConversationManager().setDraft(this.getConversation(), this.text)
    }else{
      JuggleIm.instance.getConversationManager().clearDraft(this.getConversation())
    }
  }

  private closePanels():void{
    this.showMessageActionPanel = false
    this.showForwardPanel = false
  }

  private openMessageActions(index:number):void{
    this.selectedMessageIndex = index
    this.showForwardPanel = false
    this.showMessageActionPanel = true
  }

  private quoteSelectedMessage():void{
    let item = this.getSelectedMessage()
    if(item == undefined){
      return
    }
    if(item.messageId == ''){
      this.showToast('消息仍在发送，暂时不能引用')
      return
    }
    this.cancelEdit()
    this.quotedMessageId = item.messageId
    this.quotedPreview = item.previewText
    this.quotedSender = item.isReceived ? item.senderName : item.selfName
    this.closePanels()
  }

  private isEditingMessage():boolean{
    return this.editingMessageId != ''
  }

  private canEditMessage(item?:MessageViewItem):boolean{
    if(item == undefined){
      return false
    }
    return !item.isReceived &&
      item.messageId != '' &&
      item.msgType == JimMsgType.Text
  }

  private startEditingSelectedMessage():void{
    let item = this.getSelectedMessage()
    if(!this.canEditMessage(item)){
      this.showToast('当前消息暂不支持编辑')
      return
    }
    let textMessage = item?.msgContent as TextMessage
    this.editingMessageId = item?.messageId as string
    this.editingOriginalText = textMessage.content
    this.text = textMessage.content
    this.cancelQuote()
    this.clearMentionState()
    this.closePanels()
  }

  private cancelEdit():void{
    this.editingMessageId = ''
    this.editingOriginalText = ''
    this.text = ''
    this.clearMentionState()
  }

  private cancelQuote():void{
    this.quotedMessageId = ''
    this.quotedPreview = ''
    this.quotedSender = ''
  }

  private clearMentionState():void{
    this.showMentionPanel = false
    this.filteredMentionCandidates = new ObservedArray<MentionCandidate>([])
    this.selectedMentionMap.clear()
  }

  private async saveEditedMessage():Promise<void>{
    if(!this.isEditingMessage()){
      return
    }
    let content = this.text.trim()
    if(content == ''){
      this.showToast('不能发送空消息')
      return
    }
    if(content == this.editingOriginalText.trim()){
      this.cancelEdit()
      return
    }
    let message = new TextMessage()
    message.content = content
    let editingMessageId = this.editingMessageId
    let originalText = this.editingOriginalText
    this.text = ''
    this.clearMentionState()
    JuggleIm.instance.getMessageManager().updateMessage(editingMessageId, message, this.getConversation(), (code, msg)=>{
      if(code == 0){
        JuggleIm.instance.getConversationManager().clearDraft(this.getConversation())
        this.editingMessageId = ''
        this.editingOriginalText = ''
      }else{
        this.text = originalText
        this.showToast(`编辑失败: ${code}`)
      }
    })
  }

  private async loadMentionCandidates():Promise<void>{
    if(!this.isGroupConversation()){
      return
    }
    let localMembers = JuggleIm.instance.getGroupInfoManager().getLocalGroupMembers(this.conversationId)
    if(localMembers.length > 0){
      await this.buildMentionCandidates(localMembers.map((member)=>member.memberId))
      return
    }
    JuggleIm.instance.getGroupInfoManager().queryGroupMembers(this.conversationId, async (code, members)=>{
      if(code == 0){
        let memberIds:string[] = []
        members.forEach((member)=>{
          memberIds.push(member.memberId)
        })
        await this.buildMentionCandidates(memberIds)
      }
    })
  }

  private async buildMentionCandidates(memberIds:string[]):Promise<void>{
    let candidates:MentionCandidate[] = []
    for(let i = 0; i < memberIds.length; i++){
      let user = await JuggleIm.instance.getUserInfoManager().getUserInfo(memberIds[i])
      let displayName = user.nickname != '' ? user.nickname : memberIds[i]
      candidates.push(new MentionCandidate(memberIds[i], displayName, user.userPortrait))
    }
    this.mentionCandidates = new ObservedArray<MentionCandidate>(candidates)
  }

  private getMentionKeyword():string{
    let lastAt = this.text.lastIndexOf('@')
    if(lastAt < 0){
      return ''
    }
    let suffix = this.text.substring(lastAt + 1)
    if(suffix.indexOf(' ') >= 0 || suffix.indexOf('\n') >= 0){
      return ''
    }
    return suffix
  }

  private updateMentionPanel():void{
    if(!this.isGroupConversation()){
      this.showMentionPanel = false
      return
    }
    let lastAt = this.text.lastIndexOf('@')
    if(lastAt < 0){
      this.showMentionPanel = false
      this.filteredMentionCandidates = new ObservedArray<MentionCandidate>([])
      return
    }
    let keyword = this.getMentionKeyword().toLowerCase()
    let list:MentionCandidate[] = []
    this.mentionCandidates.forEach((candidate)=>{
      if(keyword == '' || candidate.name.toLowerCase().indexOf(keyword) >= 0 || candidate.memberId.toLowerCase().indexOf(keyword) >= 0){
        list.push(candidate)
      }
    })
    this.filteredMentionCandidates = new ObservedArray<MentionCandidate>(list)
    this.showMentionPanel = list.length > 0
  }

  private selectMentionCandidate(candidate:MentionCandidate):void{
    let lastAt = this.text.lastIndexOf('@')
    if(lastAt < 0){
      return
    }
    let prefix = this.text.substring(0, lastAt)
    this.text = `${prefix}@${candidate.name} `
    this.selectedMentionMap.set(candidate.memberId, candidate)
    this.showMentionPanel = false
    this.filteredMentionCandidates = new ObservedArray<MentionCandidate>([])
  }

  private buildMentionOptions(text:string):MessageMentionInfo | undefined{
    if(!this.isGroupConversation() || this.selectedMentionMap.size == 0){
      return undefined
    }
    let users:UserInfo[] = []
    this.selectedMentionMap.forEach((candidate)=>{
      let token = `@${candidate.name}`
      if(text.indexOf(token) >= 0){
        let user = new UserInfo()
        user.userId = candidate.memberId
        user.nickname = candidate.name
        user.userPortrait = candidate.portrait
        users.push(user)
      }
    })
    if(users.length == 0){
      return undefined
    }
    let mentionInfo = new MessageMentionInfo()
    mentionInfo.mentionType = MentionType.Someone
    mentionInfo.targetUsers = users
    return mentionInfo
  }

  private loadForwardTargets():void{
    JuggleIm.instance.getConversationManager().queryConversations(20, 0, false, (code, convers)=>{
      if(code != 0){
        this.showToast(`会话加载失败: ${code}`)
        return
      }
      let targets:ConversationViewItem[] = []
      convers.forEach((conver)=>{
        targets.push(toConverViewItem(conver))
      })
      this.forwardTargets = new ObservedArray<ConversationViewItem>(targets)
      this.showMessageActionPanel = false
      this.showForwardPanel = true
    })
  }

  private forwardSelectedMessage():void{
    let item = this.getSelectedMessage()
    if(item == undefined){
      return
    }
    let forwardMsg = cloneMessageContent(item.msgContent)
    if(forwardMsg == null){
      this.showToast('当前消息类型暂不支持转发')
      return
    }
    this.loadForwardTargets()
  }

  private sendForwardMessage(target:ConversationViewItem):void{
    let item = this.getSelectedMessage()
    if(item == undefined){
      return
    }
    let forwardMsg = cloneMessageContent(item.msgContent)
    if(forwardMsg == null){
      this.showToast('当前消息类型暂不支持转发')
      return
    }
    JuggleIm.instance.getMessageManager().sendMessage(forwardMsg, new Conversation(target.converId, target.converType), (code, msg)=>{
      if(code == 0){
        this.showToast('已转发')
        this.closePanels()
      }else{
        this.showToast(`转发失败: ${code}`)
      }
    })
  }

  private async sendTextMessage():Promise<void>{
    if(this.isEditingMessage()){
      await this.saveEditedMessage()
      return
    }
    let content = this.text.trim()
    let draftText = this.text
    if(content == ''){
      this.showToast('不能发送空消息')
      return
    }
    let txtMsg:TextMessage = new TextMessage()
    txtMsg.content = content
    let mentionInfo = this.buildMentionOptions(content)
    this.text = ''
    this.showMentionPanel = false

    if(this.quotedMessageId != ''){
      let options = new MessageOptions()
      options.referredMessageId = this.quotedMessageId
      if(mentionInfo != undefined){
        options.mentionInfo = mentionInfo
      }
      JuggleIm.instance.getMessageManager().sendMessage(txtMsg, this.getConversation(), options, async (code, msg)=>{
        if(code == 0 && msg != null){
          JuggleIm.instance.getConversationManager().clearDraft(this.getConversation())
          await this.appendMessage(msg, false)
        }else{
          this.text = draftText
          this.persistDraft()
          this.showToast(`发送失败: ${code}`)
        }
      })
      this.cancelQuote()
      this.selectedMentionMap.clear()
      return
    }

    if(mentionInfo != undefined){
      let options = new MessageOptions()
      options.mentionInfo = mentionInfo
      JuggleIm.instance.getMessageManager().sendMessage(txtMsg, this.getConversation(), options, async (code, msg)=>{
        if(code == 0 && msg != null){
          JuggleIm.instance.getConversationManager().clearDraft(this.getConversation())
          await this.appendMessage(msg, false)
        }else{
          this.text = draftText
          this.persistDraft()
          this.showToast(`发送失败: ${code}`)
        }
      })
      this.selectedMentionMap.clear()
      return
    }

    JuggleIm.instance.getMessageManager().sendMessage(txtMsg, this.getConversation(), async (code, msg)=>{
      if(code == 0 && msg != null){
        JuggleIm.instance.getConversationManager().clearDraft(this.getConversation())
        await this.appendMessage(msg, false)
      }else{
        this.text = draftText
        this.persistDraft()
        this.showToast(`发送失败: ${code}`)
      }
    })
    this.selectedMentionMap.clear()
  }

  aboutToAppear(): void {
    let param = this.pageInfo.getParamByIndex(this.pageInfo.size() - 1) as ConversationDetailParams
    this.conversationId = param.conversationId
    this.conversationType = param.converType
    this.conversationTitle = param.title
    console.log("jimsdk_video_converid:",this.conversationId)

    this.msgReceiveListener = async (message)=>{
      let conver = message.conversation
      if(conver?.conversationId===param.conversationId && conver?.conversationType===param.converType){
        await this.appendMessage(message, true)
      }
    }
    this.msgModifiedListener = async (message)=>{
      let conver = message.conversation
      if(conver?.conversationId===param.conversationId && conver?.conversationType===param.converType){
        await this.appendMessage(message, false)
      }
    }

    JuggleIm.instance.getMessageManager().addMsgReceivedListener(this.msgReceiveListener)
    JuggleIm.instance.getMessageManager().addMsgModifiedListener(this.msgModifiedListener)
    this.resolveConversationTitle()
    this.loadMentionCandidates()
    this.restoreDraft()
    this.resetMessageList()
    this.loadInitialMsgs()
  }

  aboutToDisappear(): void {
    this.persistDraft()
    JuggleIm.instance.getMessageManager().removeMsgReceivedListener(this.msgReceiveListener)
    JuggleIm.instance.getMessageManager().removeMsgModifiedListener(this.msgModifiedListener)
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Flex({ direction: FlexDirection.Column }) {
          ConversationDetailTopSearch({
            currentConversationUserName: $conversationTitle,
            conversationId: this.conversationId,
            conversationType: this.conversationType
          })
            .height(Adaptive.ContactItemHeight(this.currentBreakpoint))
            .zIndex(1)
            .backgroundColor(Color.White)
            .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP])

          Refresh({ refreshing: $$this.refreshing, builder: this.refreshContent }) {
            List({ scroller: this.scroller }) {
              ForEach(this.msgList, (item: MessageViewItem, index: number) => {
                ListItem() {
                  ConversationDetailItem(item)
                }
                .onTouch((event: TouchEvent)=>{
                  let itemKey = this.getItemKey(item)
                  if(event.type == TouchType.Down){
                    this.touchStartTimeMap.set(itemKey, new Date().getTime())
                  }else if(event.type == TouchType.Up){
                    let startTime = this.touchStartTimeMap.get(itemKey)
                    if(startTime != undefined && (new Date().getTime() - startTime) >= 500){
                      this.openMessageActions(index)
                    }
                    this.touchStartTimeMap.delete(itemKey)
                  }else if(event.type == TouchType.Cancel){
                    this.touchStartTimeMap.delete(itemKey)
                  }
                })
                .onMouse((event: MouseEvent)=>{
                  if(event.action == MouseAction.Press && event.button == MouseButton.Right){
                    this.openMessageActions(index)
                  }
                })
              }, (item: MessageViewItem, index: number) => `${index}_${this.getItemKey(item)}`)
            }
          }.onRefreshing(() => {
            setTimeout(() => {
              this.loadOlderMsgs()
              this.refreshing = false
            }, 200)
          })

          Blank()

          Column() {
            if(this.showMentionPanel){
              Column() {
                List() {
                  ForEach(this.filteredMentionCandidates, (item:MentionCandidate, index:number)=>{
                    ListItem() {
                      Row() {
                        Text(item.name)
                          .fontSize(14)
                          .fontColor('#111111')
                        Blank()
                        Text(item.memberId)
                          .fontSize(12)
                          .fontColor('#999999')
                      }
                      .width('100%')
                      .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                    }
                    .onClick(()=>{
                      this.selectMentionCandidate(item)
                    })
                  }, (item:MentionCandidate, index:number)=>`${index}_${item.memberId}`)
                }
                .constraintSize({ maxHeight: 220 })
                .divider({
                  strokeWidth: 1,
                  color: '#EAEAEA',
                  startMargin: 16,
                  endMargin: 16
                })
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius({
                topLeft: 12,
                topRight: 12
              })
              .margin({ left: 12, right: 12, bottom: 8 })
            }

            if(this.quotedMessageId != ''){
              Row() {
                Column() {
                  Text(`引用 ${this.quotedSender}`)
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(this.quotedPreview)
                    .fontSize(13)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Button('取消')
                  .type(ButtonType.Normal)
                  .onClick(()=>{
                    this.cancelQuote()
                  })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .backgroundColor('#F3F4F6')
            }

            if(this.isEditingMessage()){
              Row() {
                Column() {
                  Text('编辑消息')
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(this.editingOriginalText)
                    .fontSize(13)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Button('取消')
                  .type(ButtonType.Normal)
                  .onClick(()=>{
                    this.cancelEdit()
                  })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .backgroundColor('#F3F4F6')
            }

            Row(){
              Column(){
                Column() {
                  StandardIcon({ icon: $r('app.media.ic_public_add_norm') })
                }
                .flexBasis(HomeConstants.FLEX_BASIS_AUTO)
                .padding({
                  left:10,
                  right:10
                })
              }
              Blank()
              Column(){
                TextInput({text:this.text})
                  .width('78%')
                  .placeholderColor($r('app.color.text_input_default_color'))
                  .caretColor($r('app.color.text_input_default_care_color'))
                  .backgroundColor($r('app.color.text_input_default_background_color'))
                  .borderRadius(HomeConstants.CONVERSATION_DETAIL_BOTTOM_TEXT_RADIUS)
                  .flexGrow(BaseConstants.FLEX_GROW_ONE)
                  .padding({ right: $r('app.float.conversation_detail_bottom_text_padding') })
                  .backgroundColor(Color.White)
                  .onChange((v)=>{
                    this.text = v
                    if(this.isEditingMessage()){
                      this.showMentionPanel = false
                    }else{
                      this.updateMentionPanel()
                    }
                  })
              }
              Column() {
                StandardIcon({ icon: $r('app.media.ic_public_email_send') }).onClick(async ()=>{
                  await this.sendTextMessage()
                })
              }
              .padding({
                left:10,
                right:10
              })
            }.width(BaseConstants.FULL_WIDTH)
          }
        }
        .height(BaseConstants.FULL_HEIGHT)
        .width(BaseConstants.FULL_WIDTH)
        .backgroundColor($r('app.color.background_color_grey'))
        .padding({
          bottom: deviceInfo.deviceType !== BaseConstants.DEVICE_2IN1 ?
          $r('app.float.tab_content_pb') : $r('app.float.zero')
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        if(this.showMessageActionPanel || this.showForwardPanel){
          Column() {
            Blank()
              .layoutWeight(1)
              .width('100%')
              .backgroundColor('#66000000')
              .onClick(()=>{
                this.closePanels()
              })

            if(this.showMessageActionPanel){
              Column() {
                if(this.canEditMessage(this.getSelectedMessage())){
                  Row() {
                    Text('编辑')
                      .fontSize(16)
                      .fontColor('#111111')
                    Blank()
                  }
                  .width('100%')
                  .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                  .onClick(()=>{
                    this.startEditingSelectedMessage()
                  })
                  Divider()
                    .strokeWidth(1)
                    .color('#EAEAEA')
                }

                Row() {
                  Text('引用')
                    .fontSize(16)
                    .fontColor('#111111')
                  Blank()
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                .onClick(()=>{
                  this.quoteSelectedMessage()
                })
                Divider()
                  .strokeWidth(1)
                  .color('#EAEAEA')

                Row() {
                  Text('转发')
                    .fontSize(16)
                    .fontColor('#111111')
                  Blank()
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                .onClick(()=>{
                  this.forwardSelectedMessage()
                })
                Divider()
                  .strokeWidth(1)
                  .color('#EAEAEA')

                Row() {
                  Text('取消')
                    .fontSize(16)
                    .fontColor('#666666')
                  Blank()
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                .onClick(()=>{
                  this.closePanels()
                })
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius({
                topLeft: 16,
                topRight: 16
              })
              .padding({ bottom: 24 })
            }

            if(this.showForwardPanel){
              Column() {
                Row() {
                  Text('选择转发会话')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#111111')
                  Blank()
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 18, bottom: 14 })
                Divider()
                  .strokeWidth(1)
                  .color('#EAEAEA')
                List() {
                  ForEach(this.forwardTargets, (item: ConversationViewItem, index: number) => {
                    ListItem() {
                      Row() {
                        Text(`${item.name}`)
                          .fontSize(15)
                          .fontColor('#111111')
                        Blank()
                      }
                      .width('100%')
                      .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                    }
                    .onClick(()=>{
                      this.sendForwardMessage(item)
                    })
                  }, (item: ConversationViewItem, index: number) => `${index}_${item.converId}_${item.converType}`)
                }
                .constraintSize({ maxHeight: '50%' })
                .divider({
                  strokeWidth: 1,
                  color: '#EAEAEA',
                  startMargin: 20,
                  endMargin: 20
                })
                Divider()
                  .strokeWidth(1)
                  .color('#EAEAEA')
                Row() {
                  Text('取消')
                    .fontSize(16)
                    .fontColor('#666666')
                  Blank()
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                .onClick(()=>{
                  this.closePanels()
                })
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius({
                topLeft: 16,
                topRight: 16
              })
              .padding({ bottom: 24 })
            }
          }
          .width('100%')
          .height('100%')
        }
      }
    }
    .hideTitleBar(true)
  }
}
