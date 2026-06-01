import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { window } from '@kit.ArkUI'
import { JuggleIm } from 'juggleim'

const DOMAIN = 0x0001

export default class ApiDemoAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
    void want
    void launchParam
    hilog.info(DOMAIN, 'apiDemo', '%{public}s', 'Ability onCreate')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'apiDemo', '%{public}s', 'Ability onWindowStageCreate')
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'apiDemo', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err))
        return
      }
      hilog.info(DOMAIN, 'apiDemo', 'Succeeded in loading the content.')
    })
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'apiDemo', '%{public}s', 'Ability onForeground')
    JuggleIm.instance.config.isBackend = false
    JuggleIm.instance.getConnectionManager().pushSwitch(false)
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'apiDemo', '%{public}s', 'Ability onBackground')
    JuggleIm.instance.config.isBackend = true
    JuggleIm.instance.getConnectionManager().pushSwitch(true)
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'apiDemo', '%{public}s', 'Ability onWindowStageDestroy')
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'apiDemo', '%{public}s', 'Ability onDestroy')
  }
}
