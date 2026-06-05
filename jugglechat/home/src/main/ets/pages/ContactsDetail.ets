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
import { HomeConstants } from '../constants/HomeConstants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { CommonUtil } from '../jim/common';
import { promptAction } from '@kit.ArkUI';
import { ConversationDetailParams } from '../viewmodel/ConversationViewModel';
import { GetMomentDirection, GetMomentOption, JuggleIm, Moment, MomentMedia } from 'juggleim';
import { FriendRequestStore } from '../jim/friendrequeststore';

@Component
export struct ContactsDetail {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Prop currentContactUserId: string
  @Prop currentContactUserName: string
  @Prop currentContactUserIcon: ResourceStr
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State private friendStatus: string = '加载中'
  @State private friendAlias: string = ''
  @State private friendUpdatedText: string = ''
  @State private friendRequestStatus: string = '未申请'
  @State private contactMoments: Moment[] = []
  @State private contactMomentsLoading: boolean = false
  @State private contactMomentsFinished: boolean = true

  aboutToAppear(): void {
    this.refreshFriendInfo()
    this.loadContactMoments()
  }

  onPageShow(): void {
    this.refreshFriendInfo()
    this.loadContactMoments()
  }

  private getDefaultBackgroundColor():string{
    return CommonUtil.getBackgroundColor(this.currentContactUserName as string)
  }

  private getNameFirstChar():string{
    let n = this.currentContactUserName as string
    if(n.length>0){
      return n.charAt(0)
    }else{
      return ''
    }
  }

  private showToast(message:string):void{
    promptAction.showToast({
      message,
      duration: 1500,
      bottom: 100
    })
  }

  private formatTime(timestamp:number):string{
    if(timestamp <= 0){
      return ''
    }
    let date = new Date(timestamp)
    let pad = (value:number):string => value < 10 ? `0${value}` : `${value}`
    return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`
  }

  private getMomentOwnerName(moment: Moment): string {
    if (moment.userInfo == null) {
      return this.currentContactUserName as string
    }
    if (moment.userInfo.nickname != '') {
      return moment.userInfo.nickname
    }
    if (moment.userInfo.userId != '') {
      return moment.userInfo.userId
    }
    return this.currentContactUserName as string
  }

  private getMomentAvatar(moment: Moment): string {
    if (moment.userInfo == null) {
      return ''
    }
    return moment.userInfo.userPortrait
  }

  private getAvatarColor(name: string): string {
    let colors: string[] = ['#D97706', '#2563EB', '#7C3AED', '#0F766E', '#DC2626', '#4F46E5']
    if (name == '') {
      return colors[0]
    }
    return colors[name.charCodeAt(0) % colors.length]
  }

  private getAvatarText(name: string): string {
    if (name == '') {
      return '友'
    }
    return name.charAt(0)
  }

  private loadContactMoments(): void {
    if (this.currentContactUserId == '') {
      this.contactMoments = []
      this.contactMomentsFinished = true
      return
    }
    this.contactMomentsLoading = true
    let option = new GetMomentOption()
    option.startTime = 0
    option.count = 20
    option.direction = GetMomentDirection.Backward
    option.userId = this.currentContactUserId
    JuggleIm.instance.getMomentManager().getMomentList(option, (code, moments, isFinished) => {
      this.contactMomentsLoading = false
      if (code != 0) {
        this.contactMoments = []
        this.contactMomentsFinished = true
        return
      }
      this.contactMomentsFinished = isFinished
      this.contactMoments = moments
        .filter((moment: Moment) => {
          let userInfo = moment.userInfo
          return userInfo == null ||
            userInfo.userId == '' ||
            userInfo.userId == this.currentContactUserId
        })
        .sort((left: Moment, right: Moment) => {
          return right.createTime - left.createTime
        })
    })
  }

  private getFriendStatusColor():string{
    if(this.friendStatus == '好友'){
      return '#047857'
    }
    if(this.friendStatus == '非好友'){
      return '#B91C1C'
    }
    return '#6B7280'
  }

  private getFriendStatusBackground():string{
    if(this.friendStatus == '好友'){
      return '#D1FAE5'
    }
    if(this.friendStatus == '非好友'){
      return '#FEE2E2'
    }
    return '#E5E7EB'
  }

  private refreshFriendInfo():void{
    this.friendStatus = '加载中'
    this.friendAlias = ''
    this.friendUpdatedText = ''
    this.refreshFriendRequestStatus()
    if(this.currentContactUserId == ''){
      this.friendStatus = '无好友数据'
      return
    }
    JuggleIm.instance.getUserInfoManager().queryFriendInfo(this.currentContactUserId, (code, friendInfo)=>{
      if(code != 0 || friendInfo == null){
        this.friendStatus = '好友状态加载失败'
        return
      }
      this.friendStatus = friendInfo.isFriend ? '好友' : '非好友'
      this.friendAlias = friendInfo.alias != '' ? friendInfo.alias : ''
      this.friendUpdatedText = this.formatTime(friendInfo.updTime)
      this.refreshFriendRequestStatus()
    })
  }

  private refreshFriendRequestStatus():void{
    if(this.currentContactUserId == ''){
      this.friendRequestStatus = '未申请'
      return
    }
    let request = FriendRequestStore.getRequestByUserId(this.currentContactUserId)
    if(request == null){
      this.friendRequestStatus = '未申请'
      return
    }
    if(request.status == 'pending'){
      this.friendRequestStatus = '申请中'
      return
    }
    if(request.status == 'accepted'){
      this.friendRequestStatus = '已通过'
      return
    }
    this.friendRequestStatus = '已拒绝'
  }

  private openFriendRequestList():void{
    this.pageInfo.pushPath({
      name: 'FriendRequestList'
    })
  }

  private sendFriendRequest():void{
    if(this.currentContactUserId == ''){
      this.showToast('联系人信息不完整')
      return
    }
    if(this.friendStatus == '好友'){
      this.showToast('当前已经是好友')
      return
    }
    let request = FriendRequestStore.submitRequest(
      this.currentContactUserId,
      this.currentContactUserName as string,
      '',
      '来自 Harmony demo 的好友申请'
    )
    if(request == null){
      this.showToast('发送失败')
      return
    }
    this.friendRequestStatus = '申请中'
    this.showToast('已发送好友申请')
  }

  private openConversation():void{
    if(this.currentContactUserId == ''){
      this.showToast('联系人信息不完整')
      return
    }
    this.pageInfo.pushPath({
      name: 'ConversationDetail',
      param: new ConversationDetailParams(
        this.currentContactUserId,
        this.currentContactUserId,
        1,
        this.currentContactUserName as string,
        ''
      )
    })
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
        }
        .width(BaseConstants.FULL_WIDTH)
        .height(BaseConstants.FULL_HEIGHT)
        .backgroundColor($r('app.color.background_color_pink'))
        .padding({
          top: deviceInfo.deviceType === BaseConstants.DEVICE_2IN1 ? $r('app.float.zero') : $r('app.float.device_padding_top')
        })

        if(this.currentContactUserIcon!='') {
          Image(this.currentContactUserIcon)
            .height($r('app.float.contacts_detail_avatar_height'))
            .margin({ top: $r('app.float.contacts_detail_avatar_top') })
            .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
            .border({
              width: $r('app.float.contacts_detail_avatar_border_width'),
              color: Color.White,
              radius: $r('app.float.contacts_detail_avatar_border_radius')
            })
        }else{
          Stack(){
            Text(this.getNameFirstChar()).fontColor(Color.White).fontSize(58)
          }.backgroundColor(this.getDefaultBackgroundColor())
          .height(124)
          .width(124)
          .margin({top:84})
          .zIndex(HomeConstants.CONTACTS_DETAIL_AVATAR_Z_INDEX)
          .border({
            width:5,
            color:Color.White,
            radius:100
          })
          .borderRadius(200)
        }

        Column() {
          Column() {
              Column() {
                Text(this.currentContactUserName || HomeConstants.CONTACTS_DEFAULT_SELECTED_NAME)
                  .fontSize(BaseConstants.FONT_SIZE_THIRTY_TWO)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor(Color.Black)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
            .width(BaseConstants.FULL_WIDTH)
            .alignItems(HorizontalAlign.Center)
            .padding({ top: $r('app.float.contacts_detail_user_top') })

            Row() {
              Column() {
                Text(HomeConstants.USER_PHONE)
                  .fontFamily(BaseConstants.FONT_FAMILY_MEDIUM)
                  .fontSize(BaseConstants.FONT_SIZE_SIXTEEN)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
              }
              .margin({ left: $r('app.float.phone_left') })

              Blank()
              StandardIcon({ icon: $r('app.media.ic_public_phone') })
                .margin({ right: $r('app.float.phone_icon_right') })
                .onClick(()=>{
                  this.openConversation()
                })
              StandardIcon({ icon: $r('app.media.ic_public_video') })
                .margin({ right: $r('app.float.phone_icon_right') })
                .onClick(()=>{
                  this.showToast('通话入口暂未接入')
                })
              StandardIcon({ icon: $r('app.media.ic_public_comments') })
                .margin({ right: $r('app.float.phone_icon_right') })
                .onClick(()=>{
                  this.openConversation()
                })
            }
            .width(BaseConstants.FULL_WIDTH)
            .padding({ top: $r('app.float.phone_column_top') })

            Column() {
              Divider()
                .color($r('app.color.line_color'))
                .width(BaseConstants.FULL_WIDTH)
                .margin({ left: $r('app.float.phone_divider_left'), right: $r('app.float.phone_divider_right') })
            }
            .width(BaseConstants.FULL_WIDTH)
            .padding({ top: $r('app.float.phone_divider_top') })

            Column() {
              Text(HomeConstants.LAST_POST)
                .fontSize(BaseConstants.FONT_SIZE_TWELVE)
                .fontColor(Color.Black)
                .fontWeight(BaseConstants.FONT_WEIGHT_FOUR)
                .fontFamily(BaseConstants.FONT_FAMILY_NORMAL)
            }
            .width(BaseConstants.FULL_WIDTH)
            .padding({ left: $r('app.float.last_post_left'), top: $r('app.float.last_post_top') })
            .alignItems(HorizontalAlign.Start)

            Scroll() {
              Column() {
                if (this.contactMomentsLoading && this.contactMoments.length == 0) {
                  Text('朋友圈加载中...')
                    .width(BaseConstants.FULL_WIDTH)
                    .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                    .fontColor('#6B7280')
                    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                } else if (this.contactMoments.length == 0) {
                  Text('暂无朋友圈内容')
                    .width(BaseConstants.FULL_WIDTH)
                    .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                    .fontColor('#9CA3AF')
                    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                } else {
                  ForEach(this.contactMoments, (moment: Moment) => {
                    Column() {
                      Row() {
                        if (this.getMomentAvatar(moment) != '') {
                          Image(this.getMomentAvatar(moment))
                            .width(40)
                            .height(40)
                            .borderRadius(20)
                        } else {
                          Stack() {
                            Text(this.getAvatarText(this.getMomentOwnerName(moment)))
                              .fontSize(18)
                              .fontColor(Color.White)
                              .fontWeight(FontWeight.Bold)
                          }
                          .width(40)
                          .height(40)
                          .borderRadius(20)
                          .backgroundColor(this.getAvatarColor(this.getMomentOwnerName(moment)))
                        }

                        Column() {
                          Text(this.getMomentOwnerName(moment))
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor('#111827')
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                          Text(this.formatTime(moment.createTime))
                            .fontSize(12)
                            .fontColor('#98A2B3')
                            .margin({ top: 4 })
                        }
                        .layoutWeight(1)
                        .margin({ left: 12 })
                        .alignItems(HorizontalAlign.Start)
                      }
                      .width('100%')
                      .alignItems(VerticalAlign.Top)

                      if (moment.content != '') {
                        Text(moment.content)
                          .width('100%')
                          .fontSize(14)
                          .fontColor('#1F2937')
                          .lineHeight(22)
                          .margin({ top: 12 })
                      }

                      if (moment.mediaList.length > 0) {
                        Column() {
                          ForEach(moment.mediaList, (media: MomentMedia, index: number) => {
                            if (media.url != '') {
                              Image(media.url)
                                .width('100%')
                                .height(180)
                                .objectFit(ImageFit.Cover)
                                .borderRadius(8)
                                .margin({ top: index == 0 ? 0 : 8 })
                            }
                          }, (_media: MomentMedia, index: number) => `${moment.momentId}_media_${index}`)
                        }
                        .width('100%')
                        .margin({ top: 12 })
                      }
                    }
                    .width('100%')
                    .padding(16)
                    .backgroundColor('#F8FAFC')
                    .borderRadius(12)
                    .margin({ left: 16, right: 16, top: 12 })
                  }, (moment: Moment) => moment.momentId)

                  if (this.contactMomentsFinished) {
                    Text('没有更多朋友圈内容')
                      .width(BaseConstants.FULL_WIDTH)
                      .fontSize(12)
                      .fontColor('#9CA3AF')
                      .textAlign(TextAlign.Center)
                      .padding({ top: 12, bottom: 12 })
                  }
                }
              }
              .width(BaseConstants.FULL_WIDTH)
            }
            .height(280)
            .scrollBar(BarState.Auto)
            .padding({ left: 0, right: 0, top: $r('app.float.images_top') })

            Column() {
              Row() {
                Text('好友状态')
                  .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                  .fontColor('#6B7280')
                Blank()
                Text(this.friendStatus)
                  .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                  .fontColor(this.getFriendStatusColor())
                  .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                  .backgroundColor(this.getFriendStatusBackground())
                  .borderRadius(999)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })

              if(this.friendAlias != ''){
                Divider()
                Row() {
                  Text('好友备注')
                    .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                    .fontColor('#6B7280')
                  Blank()
                  Text(this.friendAlias)
                    .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                    .fontColor('#111827')
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              }

              if(this.friendUpdatedText != ''){
                Divider()
                Row() {
                  Text('最近校验')
                    .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                    .fontColor('#6B7280')
                  Blank()
                  Text(this.friendUpdatedText)
                    .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                    .fontColor('#111827')
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              }

              Divider()
              Row() {
                Text('好友申请')
                  .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                  .fontColor('#6B7280')
                Blank()
                Text(this.friendRequestStatus)
                  .fontSize(BaseConstants.FONT_SIZE_FOURTEEN)
                  .fontColor(this.friendRequestStatus == '已通过' ? '#047857' : this.friendRequestStatus == '已拒绝' ? '#B91C1C' : '#B45309')
                  .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                  .backgroundColor(this.friendRequestStatus == '已通过' ? '#D1FAE5' : this.friendRequestStatus == '已拒绝' ? '#FEE2E2' : '#FEF3C7')
                  .borderRadius(999)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .onClick(()=>{
                this.openFriendRequestList()
              })

              Divider()
              Row() {
                Button('消息')
                  .layoutWeight(1)
                  .height(44)
                  .fontSize(BaseConstants.FONT_SIZE_SIXTEEN)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor(Color.White)
                  .backgroundColor('#4C8DFF')
                  .borderRadius(6)
                  .onClick(()=>{
                    this.openConversation()
                  })

                Button('刷新状态')
                  .layoutWeight(1)
                  .height(44)
                  .fontSize(BaseConstants.FONT_SIZE_SIXTEEN)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor('#111827')
                  .backgroundColor('#E5E7EB')
                  .borderRadius(6)
                  .margin({ left: 12 })
                  .onClick(()=>{
                    this.refreshFriendInfo()
                  })
              }
              .width('100%')
              .margin({ left: 16, right: 16, top: 14, bottom: 16 })

              if(this.friendStatus == '非好友'){
                Button(this.friendRequestStatus == '申请中' ? '已申请' : this.friendRequestStatus == '已拒绝' ? '重新申请' : '加好友')
                  .width('100%')
                  .height(44)
                  .fontSize(BaseConstants.FONT_SIZE_SIXTEEN)
                  .fontWeight(BaseConstants.FONT_WEIGHT_FIVE)
                  .fontColor(Color.White)
                  .backgroundColor('#10B981')
                  .borderRadius(6)
                  .margin({ left: 16, right: 16, bottom: 16 })
                  .onClick(()=>{
                    if(this.friendRequestStatus == '申请中'){
                      this.showToast('申请已在处理')
                      return
                    }
                    this.sendFriendRequest()
                  })
              }
            }
            .width(BaseConstants.FULL_WIDTH)
            .margin({ top: 12 })
          }
          .margin(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? {
            left: 0,
            right: 0
          } : {
            left: $r('app.float.images_column_left'),
            right: $r('app.float.images_column_right')
          })
          .height(Adaptive.ContactDetailHeight(this.currentBreakpoint))
          .borderRadius({
            topLeft: $r('app.float.contacts_detail_left'),
            topRight: $r('app.float.contacts_detail_right')
          })
          .backgroundColor(Color.White)
        }
        .margin({ top: $r('app.float.contacts_detail_column_top') })
        .width(BaseConstants.FULL_WIDTH)
        .alignItems(HorizontalAlign.Start)
      }
      }
      .title(this.currentContactUserName || HomeConstants.CONTACTS_DEFAULT_SELECTED_NAME)
    }
  }
