import { JimUtil } from '@juggleim/imlib'
import { ApiDemoConfig } from './apiDemoTypes'

export function loadApiDemoConfig(): ApiDemoConfig {
  try {
    const raw: Uint8Array = getContext().resourceManager.getRawFileContentSync('api_demo_config.json')
    const text: string = JimUtil.uint8ArrayToString(raw)
    return JSON.parse(text) as ApiDemoConfig
  } catch {
    console.error('api_demo_load_config_fail')
    return new ApiDemoConfig()
  }
}
