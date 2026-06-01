import { loadApiDemoConfig } from '../models/apiDemoConfig'
import {
  ApiActionConfig,
  ApiCategoryConfig,
  ApiDemoConfig,
  ApiDemoInvokeContext,
  ApiFieldKind,
  ApiFieldViewState,
  ApiListenerConfig,
  ApiLogItem
} from '../models/apiDemoTypes'
import { ApiDemoRuntime } from '../runtime/apiDemoRuntime'

interface ApiDemoJsonRecord {
  [key: string]: string | number | boolean | null
}

@Entry
@Component
struct Index {
  @State private config: ApiDemoConfig = new ApiDemoConfig()
  @State private categories: ApiCategoryConfig[] = []
  @State private listeners: ApiListenerConfig[] = []
  @State private selectedCategoryIndex: number = 0
  @State private selectedActionIndex: number = -1
  @State private selectedFields: ApiFieldViewState[] = []
  @State private quickAddress: string = ''
  @State private quickAppkey: string = ''
  @State private quickToken: string = ''
  @State private quickUserId: string = ''
  @State private quickPackageName: string = ''
  @State private quickLanguage: string = ''
  @State private advancedJson: string = '{}'
  @State private logs: ApiLogItem[] = []
  @State private listenersRegistered: boolean = false
  @State private statusText: string = 'ready'
  private runtime!: ApiDemoRuntime

  aboutToAppear(): void {
    this.runtime = new ApiDemoRuntime((title: string, content: string) => {
      this.appendLog(title, content)
    })
    this.config = loadApiDemoConfig()
    this.categories = this.config.categories
    this.listeners = this.config.listeners
    this.applyDefaults()
    this.selectFirstAction()
  }

  private applyDefaults(): void {
    this.quickAddress = this.config.defaults.address
    this.quickAppkey = this.config.defaults.appkey
    this.quickToken = this.config.defaults.token
    this.quickUserId = this.config.defaults.userId
    this.quickPackageName = this.config.defaults.packageName
    this.quickLanguage = this.config.defaults.language
    this.advancedJson = this.config.defaults.advancedJson != '' ? this.config.defaults.advancedJson : '{}'
  }

  private selectFirstAction(): void {
    if (this.categories.length == 0 || this.categories[0].actions.length == 0) {
      this.selectedActionIndex = -1
      this.selectedFields = []
      return
    }
    this.selectedCategoryIndex = 0
    this.selectedActionIndex = 0
    this.selectedFields = this.buildFieldViews(this.categories[0].actions[0])
  }

  private appendLog(title: string, content: string): void {
    const item: ApiLogItem = new ApiLogItem()
    item.time = new Date().getTime()
    item.title = title
    item.content = content
    this.logs = [item, ...this.logs].slice(0, 300)
    this.statusText = `${title}: ${content}`
  }

  private buildContext(): ApiDemoInvokeContext {
    const context: ApiDemoInvokeContext = new ApiDemoInvokeContext()
    context.address = this.quickAddress.trim()
    context.appkey = this.quickAppkey.trim()
    context.token = this.quickToken.trim()
    context.userId = this.quickUserId.trim()
    context.packageName = this.quickPackageName.trim()
    context.language = this.quickLanguage.trim()
    context.advancedJson = this.advancedJson.trim() == '' ? '{}' : this.advancedJson
    return context
  }

  private buildFieldViews(action: ApiActionConfig): ApiFieldViewState[] {
    const fields: ApiFieldViewState[] = []
    action.args.forEach((field) => {
      const view: ApiFieldViewState = new ApiFieldViewState()
      view.key = field.key
      view.label = field.label
      view.kind = field.kind
      view.placeholder = field.placeholder
      view.help = field.help
      view.value = field.defaultValue
      if (field.sourceKey != '') {
        view.value = this.getCommonValue(field.sourceKey)
      }
      fields.push(view)
    })
    return fields
  }

  private getCommonValue(key: string): string {
    switch (key) {
      case 'address':
        return this.quickAddress
      case 'appkey':
        return this.quickAppkey
      case 'token':
        return this.quickToken
      case 'userId':
        return this.quickUserId
      case 'packageName':
        return this.quickPackageName
      case 'language':
        return this.quickLanguage
      default:
        break
    }
    const text: string = this.advancedJson.trim()
    if (text == '') {
      return ''
    }
    try {
      const advanced: ApiDemoJsonRecord = JSON.parse(text) as ApiDemoJsonRecord
      const value: string | number | boolean | null = advanced[key]
      if (value == undefined || value == null) {
        return ''
      }
      return `${value}`
    } catch (error) {
      return ''
    }
  }

  private updateSelectedField(key: string, value: string): void {
    const next: ApiFieldViewState[] = this.selectedFields.map((field) => {
      if (field.key == key) {
        field.value = value
      }
      return field
    })
    this.selectedFields = next
  }

  private isMultilineField(kind: string): boolean {
    switch (kind) {
      case ApiFieldKind.Json:
      case 'conversation':
      case 'conversationArray':
      case 'messageContent':
      case 'messageOptions':
      case 'getConversationOptions':
      case 'getMessageOptions':
      case 'messageQueryOptions':
      case 'searchParams':
      case 'clearMsgOptions':
      case 'getFavoriteOption':
      case 'timePeriods':
      case 'momentOption':
      case 'momentCommentOption':
      case 'momentMediaArray':
      case 'pushData':
      case 'messageMentionInfo':
      case 'userInfo':
      case 'groupInfo':
      case 'groupMember':
      case 'friendInfo':
      case 'map':
      case 'hashMap':
        return true
      default:
        return false
    }
  }

  private selectAction(categoryIndex: number, actionIndex: number): void {
    this.selectedCategoryIndex = categoryIndex
    this.selectedActionIndex = actionIndex
    const action: ApiActionConfig = this.categories[categoryIndex].actions[actionIndex]
    this.selectedFields = this.buildFieldViews(action)
  }

  private currentAction(): ApiActionConfig | null {
    if (this.selectedCategoryIndex < 0 || this.selectedCategoryIndex >= this.categories.length) {
      return null
    }
    const category: ApiCategoryConfig = this.categories[this.selectedCategoryIndex]
    if (this.selectedActionIndex < 0 || this.selectedActionIndex >= category.actions.length) {
      return null
    }
    return category.actions[this.selectedActionIndex]
  }

  private invokeSelectedAction(): void {
    const action: ApiActionConfig | null = this.currentAction()
    if (action == null) {
      this.appendLog('invoke', 'no action selected')
      return
    }
    this.runtime.invoke(action, this.selectedFields, this.buildContext())
  }

  private registerAllListeners(): void {
    this.runtime.registerListeners(this.listeners, this.buildContext())
    this.listenersRegistered = true
    this.appendLog('listeners', 'all listeners registered')
  }

  private unregisterAllListeners(): void {
    this.runtime.unregisterListeners(this.listeners)
    this.listenersRegistered = false
    this.appendLog('listeners', 'all listeners removed')
  }

  @Builder
  renderField(field: ApiFieldViewState) {
    if (field.kind == ApiFieldKind.Boolean) {
      Row() {
        Text(field.label)
          .fontSize(13)
          .width(140)
        Switch({
          isOn: field.value == 'true' || field.value == '1'
        })
          .onChange((value: boolean) => {
            this.updateSelectedField(field.key, value ? 'true' : 'false')
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 6, bottom: 6 })
    } else if (this.isMultilineField(field.kind)) {
      Column() {
        Text(field.label)
          .fontSize(13)
          .margin({ bottom: 6 })
        TextArea({ placeholder: field.placeholder, text: field.value })
          .width('100%')
          .minFontSize(12)
          .maxLines(5)
          .onChange((value: string) => {
            this.updateSelectedField(field.key, value)
          })
      }
      .width('100%')
      .padding({ top: 6, bottom: 6 })
    } else {
      Row() {
        Text(field.label)
          .fontSize(13)
          .width(140)
        TextInput({ text: field.value, placeholder: field.placeholder })
          .layoutWeight(1)
          .type(field.kind == ApiFieldKind.Password ? InputType.Password : InputType.Normal)
          .onChange((value: string) => {
            this.updateSelectedField(field.key, value)
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ top: 6, bottom: 6 })
    }
    if (field.help != '') {
      Text(field.help)
        .fontSize(11)
        .fontColor('#6b7280')
        .margin({ left: 144, bottom: 4 })
    }
  }

  @Builder
  renderAction(action: ApiActionConfig, categoryIndex: number, actionIndex: number) {
    Column() {
      Row() {
        Column() {
          Text(action.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          if (action.description != '') {
            Text(action.description)
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ top: 2 })
          }
        }
        .layoutWeight(1)
        Button('选中')
          .onClick(() => {
            this.selectAction(categoryIndex, actionIndex)
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width('100%')

      if (this.selectedCategoryIndex == categoryIndex && this.selectedActionIndex == actionIndex) {
        Column() {
          ForEach(this.selectedFields, (field: ApiFieldViewState) => {
            this.renderField(field)
          }, (field: ApiFieldViewState) => field.key)
          Button('调用接口')
            .width('100%')
            .margin({ top: 12 })
            .onClick(() => {
              this.invokeSelectedAction()
            })
        }
        .width('100%')
        .margin({ top: 10 })
      }
    }
    .padding(12)
    .borderRadius(8)
    .backgroundColor('#ffffff')
    .margin({ bottom: 8 })
  }

  build() {
    Scroll() {
      Column() {
        Text('API Demo')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })

        Column() {
          Text('Quick Setup')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })
          Row() {
            TextInput({ text: this.quickAddress, placeholder: 'address' })
              .layoutWeight(1)
              .margin({ right: 8 })
              .onChange((value: string) => this.quickAddress = value)
            TextInput({ text: this.quickAppkey, placeholder: 'appkey' })
              .layoutWeight(1)
              .margin({ right: 8 })
              .onChange((value: string) => this.quickAppkey = value)
          }
          .margin({ bottom: 8 })
          Row() {
            TextInput({ text: this.quickToken, placeholder: 'token' })
              .layoutWeight(1)
              .margin({ right: 8 })
              .onChange((value: string) => this.quickToken = value)
            TextInput({ text: this.quickUserId, placeholder: 'userId' })
              .layoutWeight(1)
              .margin({ right: 8 })
              .onChange((value: string) => this.quickUserId = value)
          }
          .margin({ bottom: 8 })
          Row() {
            TextInput({ text: this.quickPackageName, placeholder: 'packageName' })
              .layoutWeight(1)
              .margin({ right: 8 })
              .onChange((value: string) => this.quickPackageName = value)
            TextInput({ text: this.quickLanguage, placeholder: 'language' })
              .layoutWeight(1)
              .onChange((value: string) => this.quickLanguage = value)
          }
          .margin({ bottom: 8 })
          TextArea({ text: this.advancedJson, placeholder: 'advanced JSON defaults' })
            .width('100%')
            .minFontSize(12)
            .maxLines(6)
            .onChange((value: string) => this.advancedJson = value)
          Column() {
            Row() {
              Button('Init SDK')
                .margin({ right: 8 })
                .onClick(() => {
                  this.runtime.initSdk(this.buildContext())
                })
              Button('Mock Upload')
                .margin({ right: 8 })
                .onClick(() => {
                  this.runtime.useMockUploadProvider()
                })
              Button('Clear Upload')
                .onClick(() => {
                  this.runtime.useRealUploadProvider()
                })
            }
            .margin({ bottom: 8 })
            Row() {
              Button('Register Listeners')
                .margin({ right: 8 })
                .onClick(() => {
                  this.registerAllListeners()
                })
              Button('Remove Listeners')
                .margin({ right: 8 })
                .onClick(() => {
                  this.unregisterAllListeners()
                })
              Button('Clear Logs')
                .onClick(() => {
                  this.logs = []
                })
            }
          }
          .margin({ top: 10 })
        }
        .padding(12)
        .borderRadius(8)
        .backgroundColor('#f9fafb')
        .margin({ bottom: 12 })

        Text(`Listener State: ${this.listenersRegistered ? 'registered' : 'idle'}`)
          .fontSize(14)
          .margin({ bottom: 8 })

        Tabs({ barPosition: BarPosition.Start }) {
          ForEach(this.categories, (category: ApiCategoryConfig, categoryIndex: number) => {
            TabContent() {
              Column() {
                ForEach(category.actions, (action: ApiActionConfig, actionIndex: number) => {
                  this.renderAction(action, categoryIndex, actionIndex)
                }, (action: ApiActionConfig) => action.id)
              }
              .padding({ top: 12, bottom: 12 })
            }
            .tabBar(category.title)
          }, (category: ApiCategoryConfig) => category.id)
        }
        .height(520)
        .margin({ bottom: 12 })

        Column() {
          Text('Listeners')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })
          ForEach(this.listeners, (listener: ApiListenerConfig) => {
            Column() {
              Text(listener.title)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
              if (listener.key != '') {
                Text(`key: ${listener.key}`)
                  .fontSize(11)
                  .fontColor('#6b7280')
                  .margin({ top: 2 })
              }
              if (listener.description != '') {
                Text(listener.description)
                  .fontSize(12)
                  .fontColor('#6b7280')
                  .margin({ top: 2 })
              }
            }
            .padding(10)
            .borderRadius(8)
            .backgroundColor('#ffffff')
            .margin({ bottom: 6 })
          }, (listener: ApiListenerConfig) => listener.id)
        }
        .padding(12)
        .borderRadius(8)
        .backgroundColor('#f9fafb')
        .margin({ bottom: 12 })

        Column() {
          Text('Logs')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })
          Text(this.statusText)
            .fontSize(12)
            .fontColor('#6b7280')
            .margin({ bottom: 8 })
          ForEach(this.logs, (item: ApiLogItem) => {
            Column() {
              Text(`${item.time}  ${item.title}`)
                .fontSize(12)
                .fontColor('#111827')
              Text(item.content)
                .fontSize(12)
                .fontColor('#374151')
                .margin({ top: 4 })
            }
            .padding(10)
            .borderRadius(8)
            .backgroundColor('#ffffff')
            .margin({ bottom: 6 })
          }, (item: ApiLogItem) => `${item.time}_${item.title}`)
        }
        .padding(12)
        .borderRadius(8)
        .backgroundColor('#f9fafb')
        .margin({ bottom: 24 })
      }
      .padding(12)
      .width('100%')
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .backgroundColor('#eef2f7')
  }
}
