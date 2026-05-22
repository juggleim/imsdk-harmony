import { BusinessError } from '@kit.BasicServicesKit'
import { fileIo } from '@kit.CoreFileKit'
import { media } from '@kit.MediaKit'
import { VoiceMessage } from 'juggleim'

type VoicePlayingListener = (isPlaying:boolean) => void

let sharedVoicePlayer:media.AVPlayer | null = null
let sharedVoiceCurrentKey:string = ''
let sharedVoiceCurrentFile:fileIo.File | null = null
let sharedVoiceListeners:Map<string, VoicePlayingListener> = new Map()

function subscribeVoicePlayback(key:string, listener:VoicePlayingListener):void{
  sharedVoiceListeners.set(key, listener)
  listener(sharedVoiceCurrentKey == key)
}

function unsubscribeVoicePlayback(key:string):void{
  sharedVoiceListeners.delete(key)
}

function notifyVoicePlaybackState():void{
  sharedVoiceListeners.forEach((listener, key)=>{
    listener(sharedVoiceCurrentKey == key)
  })
}

function closeSharedVoiceFile():void{
  if(sharedVoiceCurrentFile == null){
    return
  }
  try{
    fileIo.closeSync(sharedVoiceCurrentFile)
  }catch (error) {
  }
  sharedVoiceCurrentFile = null
}

async function ensureSharedVoicePlayer():Promise<media.AVPlayer>{
  if(sharedVoicePlayer != null){
    return sharedVoicePlayer
  }
  let player = await media.createAVPlayer()
  player.on('stateChange', (state)=>{
    if(state == 'completed' || state == 'stopped' || state == 'released' || state == 'error'){
      sharedVoiceCurrentKey = ''
      closeSharedVoiceFile()
      notifyVoicePlaybackState()
    }
  })
  sharedVoicePlayer = player
  return player
}

async function resetSharedVoicePlayer(player:media.AVPlayer):Promise<void>{
  if(player.state != 'idle' && player.state != 'released'){
    try{
      await player.reset()
    }catch (error) {
    }
  }
  closeSharedVoiceFile()
}

async function stopSharedVoicePlayback():Promise<void>{
  if(sharedVoicePlayer == null){
    sharedVoiceCurrentKey = ''
    closeSharedVoiceFile()
    notifyVoicePlaybackState()
    return
  }
  try{
    if(sharedVoicePlayer.state == 'playing'){
      await sharedVoicePlayer.stop()
    }else if(sharedVoicePlayer.state != 'idle' && sharedVoicePlayer.state != 'released'){
      await sharedVoicePlayer.reset()
    }
  }catch (error) {
  }
  sharedVoiceCurrentKey = ''
  closeSharedVoiceFile()
  notifyVoicePlaybackState()
}

function isRemoteVoiceSource(source:string):boolean{
  return source.indexOf('http://') == 0 || source.indexOf('https://') == 0
}

async function prepareVoicePlayerSource(player:media.AVPlayer, source:string):Promise<void>{
  if(isRemoteVoiceSource(source)){
    player.url = source
    await player.prepare()
    return
  }
  let stat = fileIo.statSync(source)
  let file = fileIo.openSync(source)
  sharedVoiceCurrentFile = file
  let fdSrc:media.AVFileDescriptor = {
    fd: file.fd,
    offset: 0,
    length: stat.size
  }
  player.fdSrc = fdSrc
  await player.prepare()
}

async function toggleVoicePlayback(key:string, source:string):Promise<void>{
  if(source == ''){
    return
  }
  if(sharedVoiceCurrentKey == key){
    await stopSharedVoicePlayback()
    return
  }
  let player = await ensureSharedVoicePlayer()
  await resetSharedVoicePlayer(player)
  try{
    await prepareVoicePlayerSource(player, source)
    await player.play()
    sharedVoiceCurrentKey = key
    notifyVoicePlaybackState()
  }catch (error) {
    let err = error as BusinessError
    console.error(`jimsdk_voice_play_fail:${err.code}:${err.message}`)
    sharedVoiceCurrentKey = ''
    closeSharedVoiceFile()
    notifyVoicePlaybackState()
  }
}

@Component
export struct VoiceMsgBubble{
  private isReceived:boolean = true
  private voiceMsg?:VoiceMessage
  @State private isPlaying:boolean = false

  private getVoiceKey():string{
    if(this.voiceMsg == undefined){
      return 'voice_empty'
    }
    return `${this.voiceMsg.url}|${this.voiceMsg.localPath}|${this.voiceMsg.duration}`
  }

  private getVoiceSource():string{
    if(this.voiceMsg == undefined){
      return ''
    }
    if(this.voiceMsg.localPath != ''){
      try{
        fileIo.statSync(this.voiceMsg.localPath)
        return this.voiceMsg.localPath
      }catch (error) {
      }
    }
    return this.voiceMsg.url
  }

  private getTimeStr():string{
    if(this.voiceMsg instanceof VoiceMessage){
      let totalSeconds = Math.floor(this.voiceMsg.duration / 1000)
      let min = Math.floor(totalSeconds / 60)
      let sec = totalSeconds % 60
      let minText = min < 10 ? `0${min}` : `${min}`
      let secText = sec < 10 ? `0${sec}` : `${sec}`
      return `${minText}:${secText}`
    }
    return '00:00'
  }

  private getBubbleWidth():number{
    if(this.voiceMsg == undefined || this.voiceMsg.duration <= 0){
      return 150
    }
    let totalSeconds = Math.floor(this.voiceMsg.duration / 1000)
    let width = 132 + totalSeconds * 6
    if(width < 150){
      return 150
    }
    if(width > 230){
      return 230
    }
    return width
  }

  aboutToAppear(): void {
    subscribeVoicePlayback(this.getVoiceKey(), (isPlaying:boolean)=>{
      this.isPlaying = isPlaying
    })
  }

  aboutToDisappear(): void {
    unsubscribeVoicePlayback(this.getVoiceKey())
  }

  build() {
    Row() {
      if(this.isReceived){
        Image($r('app.media.ic_public_sound'))
          .width(22)
          .height(22)
      }else{
        Text(this.getTimeStr())
          .fontSize(13)
          .fontColor('#111111')
          .margin({ right: 12 })
      }
      Blank()
      Image(this.isPlaying ? $r('app.media.ic_public_sound') : $r('app.media.ic_public_play_norm'))
        .width(22)
        .height(22)
      if(this.isReceived){
        Text(this.getTimeStr())
          .fontSize(13)
          .fontColor('#111111')
          .margin({ left: 12 })
      }else{
        Blank()
        Image($r('app.media.ic_public_sound'))
          .width(22)
          .height(22)
          .margin({ left: 12 })
      }
    }
    .width(this.getBubbleWidth())
    .height(42)
    .padding({ left: 14, right: 14 })
    .alignItems(VerticalAlign.Center)
    .onClick(()=>{
      toggleVoicePlayback(this.getVoiceKey(), this.getVoiceSource())
    })
  }
}
