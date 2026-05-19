import { promptAction, router } from '@kit.ArkUI'
import { CryptoJS } from '@ohos/crypto-js';
import { JimServer, PreferenceUtil } from 'home'

@Entry
@Component
struct Login{
  @State organization:string = ''
  @State username:string = ''
  @State password:string = ''

  aboutToAppear(): void {
    let cacheAuth = PreferenceUtil.getCacheAuth()
    if(cacheAuth!=undefined){
      router.replaceUrl({
        url:"pages/Home"
      })
      return
    }
    let serverConfig = PreferenceUtil.getServerConfig()
    if(serverConfig==undefined){
      router.replaceUrl({
        url:"pages/Index"
      })
      return
    }
    this.organization = serverConfig.organization
    let loginProfile = PreferenceUtil.getLoginProfile()
    if(loginProfile!=undefined){
      this.username = loginProfile.username
    }
  }

  private loginFailedMessage(code:number,msg?:string):string{
    if(code == 0){
      return '登录返回缺少授权信息'
    }
    if(msg!=undefined && msg!=''){
      return `登录失败: ${msg}`
    }
    return `登录失败，错误码: ${code}`
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

        Text('JuggleChat').fontSize(35).textAlign(TextAlign.Center).margin({bottom:40}).width('80%')
        Row() {
          Text(`组织id：${this.organization}`)
            .fontSize(14)
            .fontColor('#666')
            .layoutWeight(1)
          Button('切换组织')
            .type(ButtonType.Capsule)
            .onClick(()=>{
              router.replaceUrl({
                url:"pages/Index"
              })
            })
        }
        .width('80%')
        .alignItems(VerticalAlign.Center)
        .margin({bottom:30})

        TextInput({
          text:this.username,
          placeholder:'用户名'
        }).margin({
          bottom:20
        }).placeholderColor('#999')
          .fontColor('#000')
          .backgroundColor('#eee')
          .onChange((val)=>{
            this.username = val
          })
          .width('80%')
        TextInput({
          text:this.password,
          placeholder:'密码'
        }).margin({
          bottom:10
        }).placeholderColor('#999')
          .fontColor('#000')
          .backgroundColor('#eee')
          .type(InputType.Password)
          .onChange((val)=>{
            this.password = val
          })
          .width('80%')

        Button('登录').margin({top:30}).onClick(()=>{
          if(this.username == '' || this.password == ''){
            promptAction.showToast({
              message:"用户名和密码不能为空",
              duration:1000,
              bottom:100
            })
            return
          }
          let passwordMd5 = CryptoJS.MD5(this.password).toString()
          console.log("jim_login_md5_password:", passwordMd5)
          JimServer.instance.accountLogin(this.organization,this.username,passwordMd5,(code,resp,msg)=>{
            console.log("http_util_codex:",code,JSON.stringify(resp),msg)
            if(code==0&&resp.authorization!=''&&resp.im_token!=''){
              PreferenceUtil.setLoginProfile(this.organization,this.username)
              PreferenceUtil.setCacheAuth(resp.user_id,resp.authorization,resp.im_token)
              router.replaceUrl({
                url:"pages/Home"
              })
            }else{
              promptAction.showToast({
                message:this.loginFailedMessage(code,msg),
                duration:1500,
                bottom:100
              })
            }
          })
        }).width('80%')

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
