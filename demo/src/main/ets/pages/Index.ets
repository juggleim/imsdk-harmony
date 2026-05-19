import { promptAction, router } from '@kit.ArkUI'
import { JimServer, PreferenceUtil } from 'home'

@Entry
@Component
struct Index{
  @State organization:string = ''
  @State orgLoading:boolean = false

  aboutToAppear(): void {
    let cacheAuth = PreferenceUtil.getCacheAuth()
    if(cacheAuth!=undefined){
      router.replaceUrl({
        url:"pages/Home"
      })
      return
    }
    let loginProfile = PreferenceUtil.getLoginProfile()
    let serverConfig = PreferenceUtil.getServerConfig()
    if(loginProfile!=undefined){
      this.organization = loginProfile.organization
    }else if(serverConfig!=undefined){
      this.organization = serverConfig.organization
    }
  }

  private showError(message:string){
    promptAction.showToast({
      message: message,
      duration: 1500,
      bottom: 100
    })
  }

  build() {
    Row(){
      Column(){
        Image($r('app.media.jim_logo'))
          .margin({
            top:30,
            bottom:30
          })
          .width(80)
          .height(80)
          .align(Alignment.Center)

        Text('JuggleChat').fontSize(35).textAlign(TextAlign.Center).margin({bottom:100}).width('80%')

        TextInput({
          text:this.organization,
          placeholder:'组织'
        }).margin({
          bottom:20
        }).placeholderColor('#999')
          .fontColor('#000')
          .backgroundColor('#eee')
          .onChange((val)=>{
            this.organization = val
          })
          .width('80%')

        Button(this.orgLoading ? '确认中...' : '确认组织')
          .enabled(!this.orgLoading)
          .width('80%')
          .onClick(()=>{
            if(this.organization == ''){
              this.showError("组织不能为空")
              return
            }
            this.orgLoading = true
            JimServer.instance.clearAuth()
            JimServer.instance.queryServerConfig(this.organization,(code,serverInfo,msg)=>{
              this.orgLoading = false
              if(code==0 && serverInfo!=undefined && serverInfo.app_key!=''
                && serverInfo.app_servers.length>0 && serverInfo.im_servers.length>0){
                PreferenceUtil.setServerConfig(
                  this.organization,
                  serverInfo.app_servers[0],
                  serverInfo.im_servers[0],
                  serverInfo.app_key
                )
                router.replaceUrl({
                  url:"pages/Login"
                })
              }else{
                this.showError(msg!=undefined && msg!='' ? `组织确认失败: ${msg}` : "组织无效或配置获取失败")
              }
            })
          })

        Image($r('app.media.jim_logo_full'))
          .margin({
            top:280
          })
          .width(120)
          .height(15)
          .align(Alignment.Bottom)
      }.width('100%')
    }
  }
}
