import { promptAction, router } from '@kit.ArkUI'
import { JimServer, PreferenceUtil } from 'home'
import { JuggleIm } from 'juggleim'

@Entry
@Component
struct Index{
  @State phone:string = ''
  @State verCode:string = ''

  aboutToAppear(): void {
    let cacheAuth = PreferenceUtil.getCacheAuth()
    console.log("http_util:",JSON.stringify(cacheAuth))
    if(cacheAuth!=undefined){
      router.replaceUrl({
        url:"pages/Home"
      })
    }
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
          placeholder:'手机号'
        }).margin({
          bottom:20
        }).placeholderColor('#999')
          .fontColor('#000')
          .backgroundColor('#eee')
          .type(InputType.PhoneNumber)
          .onChange((val)=>{
            this.phone = val
          })
          .width('80%')
        Row(){
          TextInput({
            placeholder:'000000'
          }).placeholderColor('#999')
            .fontColor('#000')
            .backgroundColor('#eee')
            .type(InputType.Number)
            .onChange((val)=>{
              this.verCode = val
            }).width('75%')
          Button('发送').onClick(()=>{

          }).margin({
            left:15
          })
        }.align(Alignment.Center).width('80%')

        Button('登录').margin({top:30}).onClick(()=>{
          if(this.phone == '' || this.verCode == ''){
            promptAction.showToast({
              message:"手机号和验证码，不能为空",
              duration:1000,
              bottom:100
            })
            return
          }
          JimServer.instance.phoneLogin(this.phone,this.verCode,(code,resp)=>{
            console.log("http_util_codex:",code,JSON.stringify(resp))
            if(code==0&&resp.authorization!=''&&resp.im_token!=''){
              PreferenceUtil.setCacheAuth(resp.user_id,resp.authorization,resp.im_token)
              router.replaceUrl({
                url:"pages/Home"
              })
            }else{
              promptAction.showToast({
                message:"登录失败",
                duration:1000,
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