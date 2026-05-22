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
import { common } from '@kit.AbilityKit';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { fileIo, fileUri, picker } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import { ConversationViewItem, toConverViewItem } from '../viewmodel/ConversationViewModel';
import { cloneMessageContent, isDisplayableMessage, MediaDownloadState, MessageViewItem, toMessageViewItem } from '../viewmodel/MessageViewModel'
import { ObservedArray } from '../jim/common';
import {
  Conversation,
  DownloadMediaMessageCancelCallback,
  DownloadMediaMessageErrorCallback,
  DownloadMediaMessageProgressCallback,
  DownloadMediaMessageSuccessCallback,
  FileMessage,
  GetConversationDirection,
  GetConversationOptions,
  GetMessageDirection,
  GetMessageOptions,
  GroupMessageReadInfoDetail,
  ImageMessage,
  JimMsgType,
  JuggleIm,
  MediaMessageContent,
  Message,
  MessageMentionInfo,
  MessageOptions,
  MentionType,
  MsgGroupReadReceiptListener,
  MsgModifiedListener,
  MsgReadReceiptListener,
  MsgReceivedListener,
  TextMessage,
  UserInfo,
  VideoMessage,
  VoiceMessage
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

@Observed
class GroupReadMemberItem {
  userId:string
  name:string
  readTime:number
  isRead:boolean

  constructor(userId:string, name:string, readTime:number, isRead:boolean) {
    this.userId = userId
    this.name = name
    this.readTime = readTime
    this.isRead = isRead
  }
}

const DEMO_REACTION_OPTIONS:string[] = ['👍', '❤️', '😂', '👏']

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
  private maxMsgIndex:number = 0
  @State refreshing:boolean = false
  private scroller:Scroller = new Scroller()
  private msgReceiveListener:MsgReceivedListener = async (message)=>{}
  private msgModifiedListener:MsgModifiedListener = async (message)=>{}
  private readReceiptListener:MsgReadReceiptListener = async (conver, msgIds)=>{}
  private groupReadReceiptListener:MsgGroupReadReceiptListener = async (conver, messages)=>{}
  @State private text:string = ''
  @State private showMessageActionPanel:boolean = false
  @State private showForwardPanel:boolean = false
  @State private showGroupReadDetailPanel:boolean = false
  @State private showMediaPanel:boolean = false
  @State private useVoiceInput:boolean = false
  @State private isRecordingVoice:boolean = false
  @State private recordingDurationMs:number = 0
  @State private selectedMessageIndex:number = -1
  @State private quotedMessageId:string = ''
  @State private quotedPreview:string = ''
  @State private quotedSender:string = ''
  @State private editingMessageId:string = ''
  @State private editingOriginalText:string = ''
  @State private forwardTargets:ObservedArray<ConversationViewItem> = new ObservedArray<ConversationViewItem>([])
  @State private mentionCandidates:ObservedArray<MentionCandidate> = new ObservedArray<MentionCandidate>([])
  @State private filteredMentionCandidates:ObservedArray<MentionCandidate> = new ObservedArray<MentionCandidate>([])
  @State private groupReadMembers:ObservedArray<GroupReadMemberItem> = new ObservedArray<GroupReadMemberItem>([])
  @State private groupUnreadMembers:ObservedArray<GroupReadMemberItem> = new ObservedArray<GroupReadMemberItem>([])
  @State private groupReadCount:number = 0
  @State private groupMemberCount:number = 0
  @State private groupReadDetailMessageId:string = ''
  @State private showMentionPanel:boolean = false
  private selectedMentionMap:Map<string, MentionCandidate> = new Map()
  private touchStartTimeMap:Map<string,number> = new Map()
  private recorder:media.AVRecorder | null = null
  private recorderFile:fileIo.File | null = null
  private recorderFilePath:string = ''
  private recordingStartTime:number = 0
  private recordingTimer:number = -1
  private isPreparingRecording:boolean = false
  private isVoicePressing:boolean = false

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
    this.maxMsgIndex = 0
  }

  private getConversation():Conversation{
    let conversation = new Conversation(this.conversationId,this.conversationType)
    conversation.msgIndex = this.maxMsgIndex
    return conversation
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
      JuggleIm.instance.getGroupInfoManager().queryGroupInfo(this.conversationId, (code, remoteGroup)=>{
        if(code == 0 && remoteGroup != null && remoteGroup.groupName != ''){
          this.conversationTitle = remoteGroup.groupName
        }
      })
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
      let currentItem = this.msgList[foundIndex]
      if(this.shouldKeepDownloadState(viewItem, currentItem)){
        viewItem.downloadState = currentItem.downloadState
        viewItem.downloadProgress = currentItem.downloadProgress
      }
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
    if(message.msgUnreadIndex > this.maxMsgIndex){
      this.maxMsgIndex = message.msgUnreadIndex
    }
    if(scrollToBottom){
      this.scroller.scrollEdge(Edge.Bottom)
    }
  }

  private async refreshMessagesByIds(msgIds:string[]):Promise<void>{
    if(msgIds.length == 0){
      return
    }
    JuggleIm.instance.getMessageManager().getMessagesByMessageIds(this.getConversation(), msgIds, async (code, msgs)=>{
      if(code != 0){
        return
      }
      for(let i = 0; i < msgs.length; i++){
        await this.appendMessage(msgs[i], false)
      }
    })
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

  private isPrivateConversation():boolean{
    return this.conversationType == 1
  }

  private markConversationRead():void{
    let conversation = this.getConversation()
    if(conversation.conversationId == ''){
      return
    }
    JuggleIm.instance.getConversationManager().clearUnreadCount(conversation, (code)=>{
      if(code != 0){
        console.error(`jimsdk_clear_unread_fail:${code}`)
      }
    })
  }

  private shouldSendReadReceipt(message:Message):boolean{
    return this.isPrivateConversation() &&
      message.direction == 1 &&
      message.messageId != '' &&
      !message.hasRead
  }

  private sendReadReceiptIfNeeded(messages:Message[]):void{
    if(!this.isPrivateConversation() || messages.length == 0){
      return
    }
    let messageIds:string[] = []
    messages.forEach((message)=>{
      if(this.shouldSendReadReceipt(message)){
        messageIds.push(message.messageId)
      }
    })
    if(messageIds.length == 0){
      return
    }
    JuggleIm.instance.getMessageManager().sendReadReceipt(this.getConversation(), messageIds, (code)=>{
      if(code != 0){
        console.error(`jimsdk_send_read_receipt_fail:${code}`)
      }
    })
  }

  private fetchMessageReactions(messages:Message[]):void{
    let messageIds:string[] = []
    messages.forEach((message)=>{
      if(!isDisplayableMessage(message) || message.messageId == ''){
        return
      }
      if(messageIds.indexOf(message.messageId) < 0){
        messageIds.push(message.messageId)
      }
    })
    if(messageIds.length == 0){
      return
    }
    JuggleIm.instance.getMessageManager().getMessagesReaction(this.getConversation(), messageIds, (_code, _items)=>{})
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
      this.fetchMessageReactions(msgs)
      this.markConversationRead()
      this.sendReadReceiptIfNeeded(msgs)
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
    this.showGroupReadDetailPanel = false
    this.showMediaPanel = false
    this.showMentionPanel = false
  }

  private toggleMediaPanel():void{
    if(this.isRecordingVoice || this.isPreparingRecording){
      return
    }
    this.showMessageActionPanel = false
    this.showForwardPanel = false
    this.showGroupReadDetailPanel = false
    this.showMentionPanel = false
    this.useVoiceInput = false
    this.showMediaPanel = !this.showMediaPanel
  }

  private openMessageActions(index:number):void{
    this.selectedMessageIndex = index
    this.showForwardPanel = false
    this.showMessageActionPanel = true
  }

  private canReactMessage(item?:MessageViewItem):boolean{
    if(item == undefined){
      return false
    }
    return item.messageId != ''
  }

  private hasSelectedReaction(item:MessageViewItem | undefined, reactionId:string):boolean{
    if(item == undefined){
      return false
    }
    return item.selectedReactionIds.indexOf(reactionId) >= 0
  }

  private toggleSelectedReaction(reactionId:string):void{
    let item = this.getSelectedMessage()
    if(!this.canReactMessage(item)){
      this.showToast('当前消息暂不支持 reaction')
      return
    }
    let callback = (code:number)=>{
      if(code != 0){
        this.showToast(`reaction 失败: ${code}`)
        return
      }
      this.closePanels()
    }
    if(this.hasSelectedReaction(item, reactionId)){
      JuggleIm.instance.getMessageManager().removeMessageReaction(item?.messageId as string, reactionId, callback)
    }else{
      JuggleIm.instance.getMessageManager().addMessageReaction(item?.messageId as string, reactionId, callback)
    }
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

  private canShowGroupReadDetail(item?:MessageViewItem):boolean{
    if(item == undefined){
      return false
    }
    return this.isGroupConversation() && !item.isReceived && item.messageId != ''
  }

  private shouldKeepDownloadState(nextItem:MessageViewItem, currentItem:MessageViewItem):boolean{
    if(!(nextItem.msgContent instanceof MediaMessageContent)){
      return false
    }
    let mediaMsg = nextItem.msgContent as MediaMessageContent
    return mediaMsg.localPath == '' && currentItem.downloadState != MediaDownloadState.none
  }

  private canDownloadMedia(item?:MessageViewItem):boolean{
    if(item == undefined || !(item.msgContent instanceof MediaMessageContent)){
      return false
    }
    let mediaMsg = item.msgContent as MediaMessageContent
    return item.messageId != '' && mediaMsg.url != '' && mediaMsg.localPath == ''
  }

  private shouldShowDownloadAction(item?:MessageViewItem):boolean{
    if(item == undefined){
      return false
    }
    return this.canDownloadMedia(item) || item.downloadState == MediaDownloadState.downloading
  }

  private updateDownloadState(messageId:string, state:number, progress:number):void{
    let foundIndex = this.msgList.findIndex((item)=>{
      return item.messageId == messageId
    })
    if(foundIndex < 0){
      return
    }
    this.msgList[foundIndex].downloadState = state
    this.msgList[foundIndex].downloadProgress = progress
  }

  private startMediaDownload(item:MessageViewItem):void{
    if(!this.canDownloadMedia(item)){
      return
    }
    let onProgress:DownloadMediaMessageProgressCallback = (progress:number, _msg:Message)=>{
      this.updateDownloadState(item.messageId, MediaDownloadState.downloading, progress)
    }
    let onSuccess:DownloadMediaMessageSuccessCallback = async (msg:Message)=>{
      this.updateDownloadState(item.messageId, MediaDownloadState.none, 0)
      await this.refreshMessagesByIds([msg.messageId])
      this.showToast('下载完成')
    }
    let onError:DownloadMediaMessageErrorCallback = (code:number)=>{
      this.updateDownloadState(item.messageId, MediaDownloadState.failed, 0)
      this.showToast(`下载失败: ${code}`)
    }
    let onCancel:DownloadMediaMessageCancelCallback = (_msg:Message)=>{
      this.updateDownloadState(item.messageId, MediaDownloadState.canceled, 0)
      this.showToast('已取消下载')
    }
    this.updateDownloadState(item.messageId, MediaDownloadState.downloading, 0)
    JuggleIm.instance.getMessageManager().downloadMediaMessage(item.messageId, onProgress, onSuccess, onError, onCancel)
  }

  private cancelMediaDownload(item:MessageViewItem):void{
    if(item.messageId == ''){
      return
    }
    JuggleIm.instance.getMessageManager().cancelDownloadMediaMessage(item.messageId)
  }

  private applyGroupReadDetail(detail:GroupMessageReadInfoDetail):void{
    let readMembers:GroupReadMemberItem[] = []
    detail.readMembers.forEach((member)=>{
      let name = member.nickname != '' ? member.nickname : member.userId
      readMembers.push(new GroupReadMemberItem(member.userId, name, member.readTime, true))
    })
    let unreadMembers:GroupReadMemberItem[] = []
    detail.unreadMembers.forEach((member)=>{
      let name = member.nickname != '' ? member.nickname : member.userId
      unreadMembers.push(new GroupReadMemberItem(member.userId, name, member.readTime, false))
    })
    this.groupReadCount = detail.readCount
    this.groupMemberCount = detail.memberCount
    this.groupReadMembers = new ObservedArray<GroupReadMemberItem>(readMembers)
    this.groupUnreadMembers = new ObservedArray<GroupReadMemberItem>(unreadMembers)
  }

  private loadGroupReadDetail(messageId:string):void{
    JuggleIm.instance.getMessageManager().getGroupMessageReadInfoDetail(this.getConversation(), messageId, (code, detail)=>{
      if(code != 0 || detail == null){
        this.showToast(`已读详情获取失败: ${code}`)
        return
      }
      this.groupReadDetailMessageId = messageId
      this.applyGroupReadDetail(detail)
      this.showMessageActionPanel = false
      this.showGroupReadDetailPanel = true
    })
  }

  private refreshOpenedGroupReadDetail(messageIds:Map<string, boolean>):void{
    if(!this.showGroupReadDetailPanel || this.groupReadDetailMessageId == ''){
      return
    }
    if(!messageIds.has(this.groupReadDetailMessageId)){
      return
    }
    JuggleIm.instance.getMessageManager().getGroupMessageReadInfoDetail(this.getConversation(), this.groupReadDetailMessageId, (code, detail)=>{
      if(code == 0 && detail != null){
        this.applyGroupReadDetail(detail)
      }
    })
  }

  private openSelectedGroupReadDetail():void{
    let item = this.getSelectedMessage()
    if(!this.canShowGroupReadDetail(item)){
      this.showToast('当前消息暂无群已读详情')
      return
    }
    this.loadGroupReadDetail(item?.messageId as string)
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

  private getAbilityContext():common.UIAbilityContext | null{
    let hostContext = getContext(this) as common.UIAbilityContext
    if(hostContext == undefined){
      return null
    }
    return hostContext
  }

  private async requestMicrophonePermission():Promise<boolean>{
    let context = this.getAbilityContext()
    if(context == null){
      this.showToast('当前页面上下文不可用')
      return false
    }
    try{
      let atManager = abilityAccessCtrl.createAtManager()
      let permissions:Array<Permissions> = ['ohos.permission.MICROPHONE']
      let result = await atManager.requestPermissionsFromUser(context, permissions)
      if(result.authResults.length > 0 && result.authResults[0] == 0){
        return true
      }
    }catch(error){
      let err = error as BusinessError
      console.error(`jimsdk_request_microphone_fail:${err.code}:${err.message}`)
    }
    this.showToast('未获得麦克风权限')
    return false
  }

  private stopRecordingTimer():void{
    if(this.recordingTimer >= 0){
      clearInterval(this.recordingTimer)
      this.recordingTimer = -1
    }
  }

  private startRecordingTimer():void{
    this.stopRecordingTimer()
    this.recordingTimer = setInterval(()=>{
      if(this.recordingStartTime <= 0){
        this.recordingDurationMs = 0
        return
      }
      this.recordingDurationMs = new Date().getTime() - this.recordingStartTime
    }, 200)
  }

  private buildVoiceRecordPath(context:common.UIAbilityContext):string{
    let dir = `${context.cacheDir}/voice`
    try{
      fileIo.mkdirSync(dir, true)
    }catch(error){
    }
    return `${dir}/voice_${new Date().getTime()}.m4a`
  }

  private resetRecordingState():void{
    this.isRecordingVoice = false
    this.isPreparingRecording = false
    this.recordingDurationMs = 0
    this.recordingStartTime = 0
    this.stopRecordingTimer()
  }

  private closeRecorderFile():void{
    if(this.recorderFile == null){
      return
    }
    try{
      fileIo.closeSync(this.recorderFile)
    }catch(error){
    }
    this.recorderFile = null
  }

  private async releaseRecorder():Promise<void>{
    if(this.recorder == null){
      return
    }
    try{
      await this.recorder.release()
    }catch(error){
    }
    this.recorder = null
  }

  private disposeRecordingResources(removeFile:boolean):void{
    let activeRecorder:media.AVRecorder | null = this.recorder
    let recordPath = this.recorderFilePath
    this.recorder = null
    this.recorderFilePath = ''
    this.closeRecorderFile()
    if(activeRecorder != null){
      let recorder:media.AVRecorder = activeRecorder
      recorder.stop()
        .catch(()=>{
        })
        .then(()=>{
          recorder.release().catch(()=>{
          })
        })
    }
    if(removeFile){
      this.removeRecordingFile(recordPath)
    }
    this.resetRecordingState()
  }

  private removeRecordingFile(path:string):void{
    if(path == ''){
      return
    }
    try{
      fileIo.unlinkSync(path)
    }catch(error){
    }
  }

  private getRecordingSeconds():number{
    let duration = this.recordingDurationMs
    if(duration <= 0 && this.recordingStartTime > 0){
      duration = new Date().getTime() - this.recordingStartTime
    }
    if(duration <= 0){
      return 0
    }
    return Math.floor((duration + 999) / 1000)
  }

  private getRecordingTimeText():string{
    let totalSeconds = this.getRecordingSeconds()
    let minute = Math.floor(totalSeconds / 60)
    let second = totalSeconds % 60
    let minuteText = minute < 10 ? `0${minute}` : `${minute}`
    let secondText = second < 10 ? `0${second}` : `${second}`
    return `${minuteText}:${secondText}`
  }

  private getRecordButtonText():string{
    if(this.isPreparingRecording){
      return '准备录音中...'
    }
    if(this.isRecordingVoice){
      return `松开发送 ${this.getRecordingTimeText()}`
    }
    return '按住说话'
  }

  private getRecordStatusText():string{
    if(this.isPreparingRecording){
      return '正在申请录音权限并准备录音'
    }
    if(this.isRecordingVoice){
      return `录音中 ${this.getRecordingTimeText()}`
    }
    return '轻触切换输入方式，按住录音，松开发送'
  }

  private hasInputText():boolean{
    return this.text.trim() != ''
  }

  private async beginVoiceRecording():Promise<void>{
    if(this.isRecordingVoice || this.isPreparingRecording){
      return
    }
    if(!this.useVoiceInput){
      return
    }
    let granted = await this.requestMicrophonePermission()
    if(!granted || !this.isVoicePressing){
      return
    }

    let context = this.getAbilityContext()
    if(context == null){
      this.showToast('当前页面上下文不可用')
      return
    }

    this.closePanels()
    this.showMentionPanel = false
    this.isPreparingRecording = true
    let recordPath = ''

    try{
      recordPath = this.buildVoiceRecordPath(context)
      let recordFile = fileIo.openSync(
        recordPath,
        fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC
      )
      let recorder = await media.createAVRecorder()
      let profile:media.AVRecorderProfile = {
        audioBitrate: 64000,
        audioChannels: 1,
        audioCodec: media.CodecMimeType.AUDIO_AAC,
        audioSampleRate: 44100,
        fileFormat: media.ContainerFormatType.CFT_MPEG_4A
      }
      let config:media.AVRecorderConfig = {
        audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
        profile: profile,
        url: `fd://${recordFile.fd}`
      }
      await recorder.prepare(config)
      if(!this.isVoicePressing){
        await recorder.release()
        fileIo.closeSync(recordFile)
        this.removeRecordingFile(recordPath)
        this.resetRecordingState()
        return
      }
      await recorder.start()
      this.recorder = recorder
      this.recorderFile = recordFile
      this.recorderFilePath = recordPath
      this.recordingStartTime = new Date().getTime()
      this.recordingDurationMs = 0
      this.isPreparingRecording = false
      this.isRecordingVoice = true
      this.startRecordingTimer()
    }catch(error){
      let err = error as BusinessError
      console.error(`jimsdk_voice_record_start_fail:${err.code}:${err.message}`)
      this.closeRecorderFile()
      await this.releaseRecorder()
      this.removeRecordingFile(recordPath)
      this.recorderFilePath = ''
      this.resetRecordingState()
      this.showToast('录音启动失败')
    }
  }

  private async completeVoiceRecording(shouldSend:boolean):Promise<void>{
    if(this.isPreparingRecording){
      this.isVoicePressing = false
      return
    }
    if(!this.isRecordingVoice || this.recorder == null){
      return
    }
    let recorder = this.recorder
    let recordPath = this.recorderFilePath
    let durationSeconds = this.getRecordingSeconds()
    this.resetRecordingState()

    try{
      await recorder.stop()
    }catch(error){
      let err = error as BusinessError
      console.error(`jimsdk_voice_record_stop_fail:${err.code}:${err.message}`)
    }
    this.recorder = null
    this.closeRecorderFile()
    await this.releaseRecorder()
    this.recorderFilePath = ''

    if(!shouldSend){
      this.removeRecordingFile(recordPath)
      this.showToast('已取消录音')
      return
    }
    if(durationSeconds <= 0){
      this.removeRecordingFile(recordPath)
      this.showToast('录音时间太短')
      return
    }

    let msg = new VoiceMessage()
    msg.localPath = recordPath
    msg.type = 'audio/m4a'
    msg.duration = durationSeconds * 1000
    await this.sendSelectedMediaMessage(msg, '语音')
  }

  private toggleVoiceInputMode():void{
    if(this.isEditingMessage()){
      this.showToast('编辑消息时不能切换语音输入')
      return
    }
    if(this.isRecordingVoice || this.isPreparingRecording){
      return
    }
    this.useVoiceInput = !this.useVoiceInput
    this.showMediaPanel = false
    this.showMentionPanel = false
  }

  private getFileNameFromUri(uri:string):string{
    try{
      return new fileUri.FileUri(uri).name
    }catch(error){
      let uriWithoutQuery = uri.split('?')[0]
      let index = uriWithoutQuery.lastIndexOf('/')
      if(index >= 0 && index < uriWithoutQuery.length - 1){
        return uriWithoutQuery.substring(index + 1)
      }
      return 'unknown'
    }
  }

  private getFileSizeFromUri(uri:string):number{
    try{
      let stat = fileIo.statSync(uri)
      return stat.size
    }catch(error){
      return 0
    }
  }

  private inferFileMimeType(fileName:string):string{
    let lowerName = fileName.toLowerCase()
    if(lowerName.endsWith('.pdf')){
      return 'application/pdf'
    }
    if(lowerName.endsWith('.doc')){
      return 'application/msword'
    }
    if(lowerName.endsWith('.docx')){
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    }
    if(lowerName.endsWith('.xls')){
      return 'application/vnd.ms-excel'
    }
    if(lowerName.endsWith('.xlsx')){
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    }
    if(lowerName.endsWith('.ppt')){
      return 'application/vnd.ms-powerpoint'
    }
    if(lowerName.endsWith('.pptx')){
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    }
    if(lowerName.endsWith('.zip')){
      return 'application/zip'
    }
    if(lowerName.endsWith('.txt')){
      return 'text/plain'
    }
    return 'application/octet-stream'
  }

  private async sendSelectedMediaMessage(msg:ImageMessage|FileMessage|VideoMessage|VoiceMessage, fallbackName:string):Promise<void>{
    this.showMediaPanel = false
    JuggleIm.instance.getMessageManager().sendMediaMessage(msg, this.getConversation(), async (code, message)=>{
      if(code == 0 && message != null){
        JuggleIm.instance.getConversationManager().clearDraft(this.getConversation())
        await this.appendMessage(message, false)
        return
      }
      this.showToast(`${fallbackName}发送失败: ${code}`)
    })
  }

  private async pickImageMessage():Promise<void>{
    this.showMediaPanel = false
    try{
      let options = new photoAccessHelper.PhotoSelectOptions()
      options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
      options.maxSelectNumber = 1
      options.isPhotoTakingSupported = true
      let result = await new photoAccessHelper.PhotoViewPicker().select(options)
      if(result.photoUris.length == 0){
        return
      }
      let msg = new ImageMessage()
      msg.localPath = result.photoUris[0]
      msg.size = this.getFileSizeFromUri(msg.localPath)
      await this.sendSelectedMediaMessage(msg, '图片')
    }catch(error){
      let err = error as BusinessError
      console.error(`jimsdk_pick_image_fail:${err.code}:${err.message}`)
      this.showToast('选择图片失败')
    }
  }

  private async pickFileMessage():Promise<void>{
    this.showMediaPanel = false
    let context = this.getAbilityContext()
    if(context == null){
      this.showToast('当前页面上下文不可用')
      return
    }
    try{
      let options = new picker.DocumentSelectOptions()
      options.maxSelectNumber = 1
      let uris = await new picker.DocumentViewPicker(context).select(options)
      if(uris.length == 0){
        return
      }
      let msg = new FileMessage()
      msg.localPath = uris[0]
      msg.name = this.getFileNameFromUri(msg.localPath)
      msg.type = this.inferFileMimeType(msg.name)
      msg.size = this.getFileSizeFromUri(msg.localPath)
      await this.sendSelectedMediaMessage(msg, '文件')
    }catch(error){
      let err = error as BusinessError
      console.error(`jimsdk_pick_file_fail:${err.code}:${err.message}`)
      this.showToast('选择文件失败')
    }
  }

  private async pickVideoMessage():Promise<void>{
    this.showMediaPanel = false
    try{
      let options = new photoAccessHelper.PhotoSelectOptions()
      options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE
      options.maxSelectNumber = 1
      let result = await new photoAccessHelper.PhotoViewPicker().select(options)
      if(result.photoUris.length == 0){
        return
      }
      let msg = new VideoMessage()
      msg.localPath = result.photoUris[0]
      msg.size = this.getFileSizeFromUri(msg.localPath)
      await this.sendSelectedMediaMessage(msg, '视频')
    }catch(error){
      let err = error as BusinessError
      console.error(`jimsdk_pick_video_fail:${err.code}:${err.message}`)
      this.showToast('选择视频失败')
    }
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
        this.markConversationRead()
        this.sendReadReceiptIfNeeded([message])
      }
    }
    this.msgModifiedListener = async (message)=>{
      let conver = message.conversation
      if(conver?.conversationId===param.conversationId && conver?.conversationType===param.converType){
        await this.appendMessage(message, false)
      }
    }
    this.readReceiptListener = async (conver, msgIds)=>{
      if(conver.conversationId===param.conversationId && conver.conversationType===param.converType){
        await this.refreshMessagesByIds(msgIds)
      }
    }
    this.groupReadReceiptListener = async (conver, messages)=>{
      if(conver.conversationId!==param.conversationId || conver.conversationType!==param.converType){
        return
      }
      let changedMessageIds:string[] = []
      let changedIds:Map<string, boolean> = new Map()
      messages.forEach((info, msgId)=>{
        changedIds.set(msgId, true)
        changedMessageIds.push(msgId)
      })
      await this.refreshMessagesByIds(changedMessageIds)
      this.refreshOpenedGroupReadDetail(changedIds)
    }

    JuggleIm.instance.getMessageManager().addMsgReceivedListener(this.msgReceiveListener)
    JuggleIm.instance.getMessageManager().addMsgModifiedListener(this.msgModifiedListener)
    JuggleIm.instance.getMessageManager().addReadReceiptListener(this.readReceiptListener)
    JuggleIm.instance.getMessageManager().addGroupReadReceiptListener(this.groupReadReceiptListener)
    this.resolveConversationTitle()
    this.loadMentionCandidates()
    this.restoreDraft()
    this.resetMessageList()
    this.loadInitialMsgs()
  }

  aboutToDisappear(): void {
    this.persistDraft()
    this.isVoicePressing = false
    this.disposeRecordingResources(true)
    JuggleIm.instance.getMessageManager().removeMsgReceivedListener(this.msgReceiveListener)
    JuggleIm.instance.getMessageManager().removeMsgModifiedListener(this.msgModifiedListener)
    JuggleIm.instance.getMessageManager().removeReadReceiptListener(this.readReceiptListener)
    JuggleIm.instance.getMessageManager().removeGroupReadReceiptListener(this.groupReadReceiptListener)
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
                  ConversationDetailItem({
                    senderName:item.senderName,
                    senderIcon:item.senderIcon,
                    selfName:item.selfName,
                    selfIcon:item.selfIcon,
                    msgContent:item.msgContent,
                    referenceText:item.referenceText,
                    previewText:item.previewText,
                    msgType:item.msgType,
                    isEdited:item.isEdited,
                    hasRead:item.hasRead,
                    readCount:item.readCount,
                    memberCount:item.memberCount,
                    sentState:item.sentState,
                    conversationType:item.conversationType,
                    downloadState:item.downloadState,
                    downloadProgress:item.downloadProgress,
                    reactionSummaries:item.reactionSummaries,
                    showDownloadAction:this.shouldShowDownloadAction(item),
                    onDownloadTap:()=>{
                      this.startMediaDownload(item)
                    },
                    onCancelDownloadTap:()=>{
                      this.cancelMediaDownload(item)
                    },
                    isReceived:item.isReceived,
                    msgTime:item.msgTime
                  })
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

            if(this.useVoiceInput){
              Row() {
                Text(this.getRecordStatusText())
                  .fontSize(12)
                  .fontColor(this.isRecordingVoice ? '#D9485C' : '#666666')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width('100%')
              .padding({ left: 18, right: 18, top: 6, bottom: 6 })
              .backgroundColor(Color.White)
            }

            Row(){
              Stack() {
                if(this.useVoiceInput){
                  Image($r('app.media.ic_public_keyboard'))
                    .width(22)
                    .height(22)
                }else{
                  StandardIcon({ icon: $r('app.media.ic_public_voice_filled') })
                }
              }
              .width(40)
              .height(40)
              .borderRadius(20)
              .backgroundColor('#F3F4F6')
              .onClick(()=>{
                this.toggleVoiceInputMode()
              })

              if(this.useVoiceInput){
                Row() {
                  Text(this.getRecordButtonText())
                    .fontSize(15)
                    .fontWeight(this.isRecordingVoice ? FontWeight.Medium : FontWeight.Normal)
                    .fontColor(this.isRecordingVoice ? '#D9485C' : '#222222')
                }
                .layoutWeight(1)
                .height(44)
                .justifyContent(FlexAlign.Center)
                .borderRadius(22)
                .backgroundColor(this.isRecordingVoice ? '#FFF1F3' : '#F7F8FA')
                .border({
                  width: 1,
                  color: this.isRecordingVoice ? '#F3A1AF' : '#E5E7EB'
                })
                .onTouch(async (event:TouchEvent)=>{
                  if(event.type == TouchType.Down){
                    this.isVoicePressing = true
                    await this.beginVoiceRecording()
                  }else if(event.type == TouchType.Up){
                    this.isVoicePressing = false
                    await this.completeVoiceRecording(true)
                  }else if(event.type == TouchType.Cancel){
                    this.isVoicePressing = false
                    await this.completeVoiceRecording(false)
                  }
                })
              }else{
                TextInput({text:this.text, placeholder:'输入消息'})
                  .layoutWeight(1)
                  .placeholderColor($r('app.color.text_input_default_color'))
                  .caretColor($r('app.color.text_input_default_care_color'))
                  .backgroundColor('#F7F8FA')
                  .borderRadius(HomeConstants.CONVERSATION_DETAIL_BOTTOM_TEXT_RADIUS)
                  .padding({ left: 16, right: 16 })
                  .height(44)
                  .margin({ left: 10 })
                  .onChange((v)=>{
                    this.text = v
                    this.showMediaPanel = false
                    if(this.isEditingMessage()){
                      this.showMentionPanel = false
                    }else{
                      this.updateMentionPanel()
                    }
                  })
                  .onClick(()=>{
                    this.showMediaPanel = false
                  })

                if(this.hasInputText()){
                  Stack() {
                    StandardIcon({ icon: $r('app.media.ic_public_email_send') })
                  }
                  .width(40)
                  .height(40)
                  .borderRadius(20)
                  .backgroundColor('#F3F4F6')
                  .margin({ left: 10 })
                  .onClick(async ()=>{
                    await this.sendTextMessage()
                  })
                }else{
                  Stack() {
                    StandardIcon({ icon: $r('app.media.ic_public_add_norm') })
                  }
                  .width(40)
                  .height(40)
                  .borderRadius(20)
                  .backgroundColor('#F3F4F6')
                  .margin({ left: 10 })
                  .onClick(()=>{
                    this.toggleMediaPanel()
                  })
                }
              }
            }
            .width(BaseConstants.FULL_WIDTH)
            .padding({ left: 12, right: 12, top: 10, bottom: 10 })
            .backgroundColor(Color.White)

            if(this.showMediaPanel && !this.useVoiceInput){
              Column() {
                Divider()
                  .strokeWidth(1)
                  .color('#EAECEF')
                Row() {
                  Column() {
                    Stack() {
                      Image($r('app.media.img'))
                        .width(28)
                        .height(28)
                    }
                    .width(56)
                    .height(56)
                    .borderRadius(16)
                    .backgroundColor('#FFFFFF')
                    .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                    Text('图片')
                      .fontSize(12)
                      .fontColor('#333333')
                      .margin({ top: 8 })
                  }
                  .width(84)
                  .onClick(async ()=>{
                    await this.pickImageMessage()
                  })

                  Column() {
                    Stack() {
                      StandardIcon({ icon: $r('app.media.ic_public_video_filled') })
                    }
                    .width(56)
                    .height(56)
                    .borderRadius(16)
                    .backgroundColor('#FFFFFF')
                    .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                    Text('视频')
                      .fontSize(12)
                      .fontColor('#333333')
                      .margin({ top: 8 })
                  }
                  .width(84)
                  .margin({ left: 20 })
                  .onClick(async ()=>{
                    await this.pickVideoMessage()
                  })

                  Column() {
                    Stack() {
                      Image($r('app.media.ic_file'))
                        .width(28)
                        .height(28)
                    }
                    .width(56)
                    .height(56)
                    .borderRadius(16)
                    .backgroundColor('#FFFFFF')
                    .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                    Text('文件')
                      .fontSize(12)
                      .fontColor('#333333')
                      .margin({ top: 8 })
                  }
                  .width(84)
                  .margin({ left: 20 })
                  .onClick(async ()=>{
                    await this.pickFileMessage()
                  })
                  Blank()
                }
                .width('100%')
                .alignItems(VerticalAlign.Top)
              }
              .width('100%')
              .height(188)
              .padding({ left: 20, right: 20, top: 18, bottom: 18 })
              .backgroundColor('#F7F8FA')
            }
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

        if(this.showMessageActionPanel || this.showForwardPanel || this.showGroupReadDetailPanel){
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
                if(this.canReactMessage(this.getSelectedMessage())){
                  Column() {
                    Row({ space: 12 }) {
                      ForEach(DEMO_REACTION_OPTIONS, (reactionId:string)=>{
                        Text(reactionId)
                          .fontSize(22)
                          .width(44)
                          .height(44)
                          .textAlign(TextAlign.Center)
                          .backgroundColor(this.hasSelectedReaction(this.getSelectedMessage(), reactionId) ? '#E8F0FE' : '#F5F6F8')
                          .borderRadius(22)
                          .onClick(()=>{
                            this.toggleSelectedReaction(reactionId)
                          })
                      }, (reactionId:string)=>reactionId)
                    }
                    .width('100%')
                    .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                  }
                  Divider()
                    .strokeWidth(1)
                    .color('#EAEAEA')
                }

                if(this.canShowGroupReadDetail(this.getSelectedMessage())){
                  Row() {
                    Text('已读详情')
                      .fontSize(16)
                      .fontColor('#111111')
                    Blank()
                  }
                  .width('100%')
                  .padding({ left: 20, right: 20, top: 18, bottom: 18 })
                  .onClick(()=>{
                    this.openSelectedGroupReadDetail()
                  })
                  Divider()
                    .strokeWidth(1)
                    .color('#EAEAEA')
                }

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

            if(this.showGroupReadDetailPanel){
              Column() {
                Row() {
                  Column() {
                    Text('已读详情')
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#111111')
                    Text(`已读 ${this.groupReadCount}/${this.groupMemberCount}`)
                      .fontSize(13)
                      .fontColor('#666666')
                      .margin({ top: 4 })
                  }
                  Blank()
                  Button('关闭')
                    .type(ButtonType.Normal)
                    .onClick(()=>{
                      this.showGroupReadDetailPanel = false
                    })
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 18, bottom: 14 })
                Divider()
                  .strokeWidth(1)
                  .color('#EAEAEA')

                List() {
                  if(this.groupReadMembers.length > 0){
                    ListItem() {
                      Text('已读成员')
                        .fontSize(13)
                        .fontColor('#666666')
                        .padding({ left: 20, right: 20, top: 16, bottom: 8 })
                    }
                    ForEach(this.groupReadMembers, (item:GroupReadMemberItem, index:number) => {
                      ListItem() {
                        Row() {
                          Text(item.name)
                            .fontSize(15)
                            .fontColor('#111111')
                          Blank()
                          Text(item.userId)
                            .fontSize(12)
                            .fontColor('#999999')
                        }
                        .width('100%')
                        .padding({ left: 20, right: 20, top: 14, bottom: 14 })
                      }
                    }, (item:GroupReadMemberItem, index:number)=>`${index}_${item.userId}`)
                  }

                  if(this.groupUnreadMembers.length > 0){
                    ListItem() {
                      Text('未读成员')
                        .fontSize(13)
                        .fontColor('#666666')
                        .padding({ left: 20, right: 20, top: 16, bottom: 8 })
                    }
                    ForEach(this.groupUnreadMembers, (item:GroupReadMemberItem, index:number) => {
                      ListItem() {
                        Row() {
                          Text(item.name)
                            .fontSize(15)
                            .fontColor('#111111')
                          Blank()
                          Text(item.userId)
                            .fontSize(12)
                            .fontColor('#999999')
                        }
                        .width('100%')
                        .padding({ left: 20, right: 20, top: 14, bottom: 14 })
                      }
                    }, (item:GroupReadMemberItem, index:number)=>`${index}_${item.userId}`)
                  }
                }
                .constraintSize({ maxHeight: 360 })
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
