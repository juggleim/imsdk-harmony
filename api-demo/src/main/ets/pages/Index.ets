import { promptAction } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { fileIo, fileUri, picker } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { loadApiDemoConfig } from '../models/apiDemoConfig'
import {
  ApiActionConfig,
  ApiCategoryConfig,
  ApiDemoConfig,
  ApiDemoInvokeContext,
  ApiFieldKind,
  ApiFieldViewState,
  ApiListenerConfig,
  ApiLogItem,
  ApiMediaMessageValue
} from '../models/apiDemoTypes'
import { ApiDemoRuntime } from '../runtime/apiDemoRuntime'

@Entry
@Component
struct Index {
  @State private config: ApiDemoConfig = new ApiDemoConfig()
  @State private categories: ApiCategoryConfig[] = []
  @State private listeners: ApiListenerConfig[] = []
  @State private selectedCategoryIndex: number = 0
  @State private selectedActionIndex: number = -1
  @State private selectedFields: ApiFieldViewState[] = []
  @State private quickSetupCollapsed: boolean = true
  @State private quickAddress: string = ''
  @State private quickAppkey: string = ''
  @State private quickToken: string = ''
  @State private quickUserId: string = ''
  @State private quickPackageName: string = ''
  @State private quickLanguage: string = ''
  @State private advancedJson: string = '{}'
  @State private currentActionId: string = ''
  @State private currentActionResult: string = ''
  @State private listenerDrawerVisible: boolean = false
  @State private listenerLogs: ApiLogItem[] = []
  @State private logs: ApiLogItem[] = []
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
      this.selectedCategoryIndex = -1
      this.selectedActionIndex = -1
      this.selectedFields = []
      this.currentActionId = ''
      this.currentActionResult = ''
      return
    }
    this.selectedCategoryIndex = 0
    this.selectedActionIndex = -1
    this.selectedFields = []
    this.currentActionId = ''
    this.currentActionResult = ''
  }

  private appendLog(title: string, content: string): void {
    if (this.isListenerLog(title)) {
      this.appendListenerLog(title, content)
      return
    }
    const item: ApiLogItem = new ApiLogItem()
    item.time = new Date().getTime()
    item.title = title
    item.content = content
    this.logs = [item, ...this.logs].slice(0, 300)
    this.statusText = `${title}: ${content}`
    if (this.currentActionId != '' && title == this.currentActionId) {
      this.currentActionResult = content
    }
  }

  private appendListenerLog(title: string, content: string): void {
    const item: ApiLogItem = new ApiLogItem()
    item.time = new Date().getTime()
    item.title = title
    item.content = content
    this.listenerLogs = [item, ...this.listenerLogs].slice(0, 300)
    this.showToast(`收到监听: ${title}`)
  }

  private showToast(message: string): void {
    promptAction.showToast({
      message: message,
      duration: 1200,
      bottom: 120
    })
  }

  private getAbilityContext(): common.UIAbilityContext | null {
    const hostContext: common.UIAbilityContext | undefined = getContext(this) as common.UIAbilityContext | undefined
    if (hostContext == undefined) {
      return null
    }
    return hostContext
  }

  private buildTextMessageJson(): string {
    const value: ApiMediaMessageValue = new ApiMediaMessageValue()
    value.contentKind = 'text'
    value.content = 'Hello'
    value.extra = ''
    return JSON.stringify(value)
  }

  private buildImageMessageJson(uri: string): string {
    const value: ApiMediaMessageValue = new ApiMediaMessageValue()
    value.contentKind = 'image'
    value.content = ''
    value.localPath = uri
    value.size = this.getFileSizeFromUri(uri)
    value.extra = ''
    console.info('------------------buildImageMessageJson', value)
    return JSON.stringify(value)
  }

  private buildFileMessageJson(uri: string): string {
    const fileName: string = this.getFileNameFromUri(uri)
    const value: ApiMediaMessageValue = new ApiMediaMessageValue()
    value.contentKind = 'file'
    value.content = ''
    value.localPath = uri
    value.name = fileName
    value.type = this.inferFileMimeType(fileName)
    value.size = this.getFileSizeFromUri(uri)
    value.extra = ''
    return JSON.stringify(value)
  }

  private getFileNameFromUri(uri: string): string {
    try {
      return new fileUri.FileUri(uri).name
    } catch {
      const uriWithoutQuery: string = uri.split('?')[0]
      const index: number = uriWithoutQuery.lastIndexOf('/')
      if (index >= 0 && index < uriWithoutQuery.length - 1) {
        return uriWithoutQuery.substring(index + 1)
      }
      return 'unknown'
    }
  }

  private getFileSizeFromUri(uri: string): number {
    try {
      const stat = fileIo.statSync(uri)
      return stat.size
    } catch {
      return 0
    }
  }

  private inferFileMimeType(fileName: string): string {
    const lowerName: string = fileName.toLowerCase()
    if (lowerName.endsWith('.pdf')) {
      return 'application/pdf'
    }
    if (lowerName.endsWith('.doc')) {
      return 'application/msword'
    }
    if (lowerName.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    }
    if (lowerName.endsWith('.xls')) {
      return 'application/vnd.ms-excel'
    }
    if (lowerName.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    }
    if (lowerName.endsWith('.ppt')) {
      return 'application/vnd.ms-powerpoint'
    }
    if (lowerName.endsWith('.pptx')) {
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    }
    if (lowerName.endsWith('.zip')) {
      return 'application/zip'
    }
    if (lowerName.endsWith('.txt')) {
      return 'text/plain'
    }
    return 'application/octet-stream'
  }

  private setMediaFieldValue(fieldKey: string, value: string): void {
    this.updateSelectedField(fieldKey, value)
  }

  private async pickImageForField(fieldKey: string): Promise<void> {
    const options = new photoAccessHelper.PhotoSelectOptions()
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    options.maxSelectNumber = 1
    options.isPhotoTakingSupported = true
    try {
      const result = await new photoAccessHelper.PhotoViewPicker().select(options)
      if (result.photoUris.length == 0) {
        return
      }
      this.setMediaFieldValue(fieldKey, this.buildImageMessageJson(result.photoUris[0]))
    } catch {
      this.showToast('选择图片失败')
    }
  }

  private async pickFileForField(fieldKey: string): Promise<void> {
    const context: common.UIAbilityContext | null = this.getAbilityContext()
    if (context == null) {
      this.showToast('当前页面上下文不可用')
      return
    }
    const options = new picker.DocumentSelectOptions()
    options.maxSelectNumber = 1
    try {
      const uris: string[] = await new picker.DocumentViewPicker(context).select(options)
      if (uris.length == 0) {
        return
      }
      this.setMediaFieldValue(fieldKey, this.buildFileMessageJson(uris[0]))
    } catch {
      this.showToast('选择文件失败')
    }
  }

  private describeMediaValue(raw: string): string {
    const text: string = raw.trim()
    if (text == '') {
      return '未选择'
    }
    try {
      const parsed: Object = JSON.parse(text) as Object
      const kindValue: string = this.pickMediaString(parsed, 'contentKind', 'text')
      if (kindValue == 'image' || kindValue == 'file' || kindValue == 'video' || kindValue == 'voice') {
        const pathValue: string = this.pickMediaString(parsed, 'localPath', '')
        if (pathValue != '') {
          return `${kindValue}:${pathValue}`
        }
        return kindValue
      }
      const contentValue: string = this.pickMediaString(parsed, 'content', '')
      if (contentValue != '') {
        return `${kindValue}:${contentValue}`
      }
      return kindValue
    } catch {
      return '未选择'
    }
  }

  private pickMediaString(source: Object, key: string, defaultValue: string): string {
    const value: string | number | boolean | undefined = Reflect.get(source, key) as string | number | boolean | undefined
    if (value == undefined || value == null) {
      return defaultValue
    }
    return `${value}`
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
      view.value = field.kind == ApiFieldKind.MediaMessage ? '' : field.defaultValue
      if (field.sourceKey != '' && field.kind != ApiFieldKind.MediaMessage) {
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
      const advanced: Object = JSON.parse(text) as Object
      const value: string | number | boolean | undefined = Reflect.get(advanced, key) as string | number | boolean | undefined
      if (value == undefined || value == null) {
        return ''
      }
      return `${value}`
    } catch {
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

  private toggleQuickSetup(): void {
    this.quickSetupCollapsed = !this.quickSetupCollapsed
  }

  private openListenerDrawer(): void {
    this.listenerDrawerVisible = true
  }

  private closeListenerDrawer(): void {
    this.listenerDrawerVisible = false
  }

  private isListenerLog(title: string): boolean {
    return this.listeners.some((listener: ApiListenerConfig) => listener.id == title)
  }

  private selectCategory(categoryIndex: number): void {
    if (categoryIndex < 0 || categoryIndex >= this.categories.length) {
      return
    }
    this.selectedCategoryIndex = categoryIndex
    this.selectedActionIndex = -1
    this.selectedFields = []
    this.currentActionId = ''
    this.currentActionResult = ''
  }

  private isCategorySelected(categoryIndex: number): boolean {
    return this.selectedCategoryIndex == categoryIndex
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
    if (categoryIndex < 0 || categoryIndex >= this.categories.length) {
      return
    }
    const category: ApiCategoryConfig = this.categories[categoryIndex]
    if (actionIndex < 0 || actionIndex >= category.actions.length) {
      return
    }
    if (this.selectedCategoryIndex == categoryIndex && this.selectedActionIndex == actionIndex) {
      this.selectedActionIndex = -1
      this.selectedFields = []
      this.currentActionId = ''
      this.currentActionResult = ''
      return
    }
    this.selectedCategoryIndex = categoryIndex
    this.selectedActionIndex = actionIndex
    const action: ApiActionConfig = category.actions[actionIndex]
    this.selectedFields = this.buildFieldViews(action)
    this.currentActionId = action.id
    this.currentActionResult = ''
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
    if (action.method == 'sendMediaMessage') {
      const mediaField: ApiFieldViewState | undefined = this.selectedFields.find((field: ApiFieldViewState) => field.kind == ApiFieldKind.MediaMessage)
      if (mediaField != undefined && mediaField.value.trim() == '') {
        this.currentActionId = action.id
        this.currentActionResult = '请先选择图片或文件'
        return
      }
      this.appendLog(
        action.id,
        `prepare sendMediaMessage, uploadProvider=${this.runtime.hasMessageUploadProvider() ? 'set' : 'null'}, media=${mediaField == undefined ? '' : mediaField.value}`
      )
    }
    const context: ApiDemoInvokeContext = this.buildContext()
    this.currentActionId = action.id
    this.currentActionResult = '调用中...'
    if (action.target == 'sdk' && action.method == 'init') {
      this.runtime.initSdk(context, this.listeners, action.id)
    } else {
      this.runtime.invoke(action, this.selectedFields, context)
    }
    setTimeout(() => {
      if (this.currentActionId == action.id && this.currentActionResult == '调用中...') {
        this.currentActionResult = '未返回结果'
      }
    }, 5000)
  }

  @Builder
  renderField(field: ApiFieldViewState) {
    if (field.kind == ApiFieldKind.MediaMessage) {
      Column() {
        Row() {
          Text(field.label)
            .fontSize(13)
            .width(88)
            .maxLines(2)
          Blank()
          Text(this.describeMediaValue(field.value))
            .fontSize(11)
            .fontColor('#6b7280')
            .maxLines(1)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .margin({ bottom: 4 })

        Row() {
          Button('文本')
            .fontSize(12)
            .margin({ right: 6 })
            .onClick(() => {
              this.setMediaFieldValue(field.key, this.buildTextMessageJson())
            })
          Button('图片')
            .fontSize(12)
            .margin({ right: 6 })
            .onClick(() => {
              void this.pickImageForField(field.key)
            })
          Button('文件')
            .fontSize(12)
            .onClick(() => {
              void this.pickFileForField(field.key)
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .margin({ bottom: 6 })

        TextArea({ placeholder: field.placeholder, text: field.value })
          .width('100%')
          .minFontSize(12)
          .maxLines(6)
          .onChange((value: string) => {
            this.updateSelectedField(field.key, value)
          })
      }
      .width('100%')
      .padding({ top: 4, bottom: 4 })
    } else if (field.kind == ApiFieldKind.Boolean) {
      Row() {
        Text(field.label)
          .fontSize(13)
          .width(88)
          .maxLines(2)
        Toggle({ type: ToggleType.Switch, isOn: field.value == 'true' || field.value == '1' })
          .selectedColor('#4C8DFF')
          .onChange((value: boolean) => {
            this.updateSelectedField(field.key, value ? 'true' : 'false')
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .padding({ top: 4, bottom: 4 })
    } else if (this.isMultilineField(field.kind)) {
      Column() {
        Text(field.label)
          .fontSize(13)
          .fontColor('#374151')
          .margin({ bottom: 4 })
        TextArea({ placeholder: field.placeholder, text: field.value })
          .width('100%')
          .minFontSize(12)
          .maxLines(5)
          .onChange((value: string) => {
            this.updateSelectedField(field.key, value)
          })
      }
      .width('100%')
      .padding({ top: 4, bottom: 4 })
    } else {
      Row() {
        Text(field.label)
          .fontSize(13)
          .width(88)
          .maxLines(2)
        TextInput({ text: field.value, placeholder: field.placeholder })
          .layoutWeight(1)
          .type(field.kind == ApiFieldKind.Password ? InputType.Password : InputType.Normal)
          .onChange((value: string) => {
            this.updateSelectedField(field.key, value)
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .padding({ top: 4, bottom: 4 })
    }
    if (field.help != '') {
      Text(field.help)
        .fontSize(11)
        .fontColor('#6b7280')
      .margin({ left: 92, bottom: 4 })
    }
  }

  @Builder
  renderAction(action: ApiActionConfig, categoryIndex: number, actionIndex: number) {
    Column() {
      Row() {
        Column() {
          Text(action.title)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
          if (action.description != '') {
            Text(action.description)
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ top: 2 })
          }
        }
        .layoutWeight(1)
        Text(this.selectedCategoryIndex == categoryIndex && this.selectedActionIndex == actionIndex ? '收起' : '展开')
          .fontSize(12)
          .fontColor('#2563eb')
      }
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .onClick(() => {
        this.selectAction(categoryIndex, actionIndex)
      })

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
          if (this.currentActionResult != '') {
            Column() {
              Text('调用结果')
                .fontSize(12)
                .fontColor('#6b7280')
              Text(this.currentActionResult)
                .fontSize(12)
                .fontColor('#111827')
                .margin({ top: 6 })
            }
            .width('100%')
            .margin({ top: 10 })
          }
        }
        .width('100%')
        .margin({ top: 10 })
      }
    }
    .padding(10)
    .borderWidth(1)
    .borderColor(this.selectedCategoryIndex == categoryIndex && this.selectedActionIndex == actionIndex ? '#93c5fd' : '#dbe4f0')
    .borderRadius(6)
    .backgroundColor(this.selectedCategoryIndex == categoryIndex && this.selectedActionIndex == actionIndex ? '#f8fbff' : '#ffffff')
    .margin({ bottom: 8 })
    .onClick(() => {
      this.selectAction(categoryIndex, actionIndex)
    })
  }

  @Builder
  renderCategoryItem(category: ApiCategoryConfig, categoryIndex: number) {
    Row() {
      Text(category.title)
        .fontSize(11)
        .fontWeight(this.isCategorySelected(categoryIndex) ? FontWeight.Medium : FontWeight.Regular)
        .fontColor(this.isCategorySelected(categoryIndex) ? '#1d4ed8' : '#111827')
      .layoutWeight(1)
    }
    .width('100%')
    .padding(4)
    .borderRadius(4)
    .backgroundColor(this.isCategorySelected(categoryIndex) ? '#dbeafe' : '#ffffff')
    .margin({ bottom: 2 })
    .onClick(() => {
      this.selectCategory(categoryIndex)
    })
  }

  @Builder
  renderQuickSetup() {
    Column() {
      Row() {
        Text('Quick Setup')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(this.quickSetupCollapsed ? '展开' : '收起')
          .fontSize(12)
          .fontColor('#2563eb')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.toggleQuickSetup()
      })

      if (!this.quickSetupCollapsed) {
        Column() {
          Column() {
            Text('address')
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ bottom: 2 })
            TextInput({ text: this.quickAddress, placeholder: 'address' })
              .width('100%')
              .onChange((value: string) => this.quickAddress = value)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
          Divider().strokeWidth(1).color('#E5E7EB')

          Column() {
            Text('appkey')
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ bottom: 2 })
            TextInput({ text: this.quickAppkey, placeholder: 'appkey' })
              .width('100%')
              .onChange((value: string) => this.quickAppkey = value)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
          Divider().strokeWidth(1).color('#E5E7EB')

          Column() {
            Text('token')
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ bottom: 2 })
            TextInput({ text: this.quickToken, placeholder: 'token' })
              .width('100%')
              .onChange((value: string) => this.quickToken = value)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
          Divider().strokeWidth(1).color('#E5E7EB')

          Column() {
            Text('userId')
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ bottom: 2 })
            TextInput({ text: this.quickUserId, placeholder: 'userId' })
              .width('100%')
              .onChange((value: string) => this.quickUserId = value)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
          Divider().strokeWidth(1).color('#E5E7EB')

          Column() {
            Text('packageName')
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ bottom: 2 })
            TextInput({ text: this.quickPackageName, placeholder: 'packageName' })
              .width('100%')
              .onChange((value: string) => this.quickPackageName = value)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
          Divider().strokeWidth(1).color('#E5E7EB')

          Column() {
            Text('language')
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ bottom: 2 })
            TextInput({ text: this.quickLanguage, placeholder: 'language' })
              .width('100%')
              .onChange((value: string) => this.quickLanguage = value)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
          Divider().strokeWidth(1).color('#E5E7EB')

          Column() {
            Text('advancedJson')
              .fontSize(12)
              .fontColor('#6b7280')
              .margin({ bottom: 2 })
            TextArea({ text: this.advancedJson, placeholder: 'advancedJson' })
              .width('100%')
              .minFontSize(12)
              .maxLines(5)
              .onChange((value: string) => this.advancedJson = value)
          }
          .width('100%')
          .padding({ top: 6, bottom: 6 })
        }
        .width('100%')
        .margin({ top: 8 })
      }
    }
    .width('100%')
    .padding({ left: 8, right: 8, top: 6, bottom: 6 })
    .borderRadius(4)
    .backgroundColor('#ffffff')
    .margin({ bottom: 8 })
  }

  @Builder
  renderLogsSection() {
    Column() {
      Text('Logs')
        .fontSize(13)
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
        .borderRadius(6)
        .backgroundColor('#ffffff')
        .margin({ bottom: 6 })
      }, (item: ApiLogItem) => `${item.time}_${item.title}`)
    }
    .padding(8)
    .borderRadius(4)
    .backgroundColor('#f9fafb')
    .margin({ bottom: 24 })
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text('API Demo')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          Blank()
          Text('查看监听列表')
            .fontSize(12)
            .fontColor('#2563eb')
            .onClick(() => {
              this.openListenerDrawer()
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .margin({ bottom: 8 })

        this.renderQuickSetup()

        Row() {
          Scroll() {
            Column() {
              Text('分类')
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 6 })
              ForEach(this.categories, (category: ApiCategoryConfig, categoryIndex: number) => {
                this.renderCategoryItem(category, categoryIndex)
              }, (category: ApiCategoryConfig) => category.id)
            }
            .width('100%')
            .padding(0)
          }
          .width(80)
          .height('100%')
          .scrollBar(BarState.Off)
          .backgroundColor('#f8fafc')

          Scroll() {
            Column() {
              Column() {
                Row() {
                  Text('接口列表')
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                  Blank()
                  Text(this.selectedCategoryIndex >= 0 && this.selectedCategoryIndex < this.categories.length ? this.categories[this.selectedCategoryIndex].title : '未选择分类')
                    .fontSize(12)
                    .fontColor('#6b7280')
                }
                .width('100%')
                .alignItems(VerticalAlign.Center)
                .margin({ bottom: 6 })

                if (this.selectedCategoryIndex >= 0 && this.selectedCategoryIndex < this.categories.length && this.categories[this.selectedCategoryIndex].actions.length > 0) {
                  ForEach(this.categories[this.selectedCategoryIndex].actions, (action: ApiActionConfig, actionIndex: number) => {
                    this.renderAction(action, this.selectedCategoryIndex, actionIndex)
                  }, (action: ApiActionConfig) => action.id)
                } else {
                  Text('请选择左侧分类')
                    .fontSize(12)
                    .fontColor('#6b7280')
                    .padding({ top: 6, bottom: 6 })
                }
              }
              .padding(6)
              .borderRadius(4)
              .backgroundColor('#ffffff')
              .margin({ bottom: 8 })

              this.renderLogsSection()
            }
            .width('100%')
            .padding(6)
          }
          .layoutWeight(1)
          .height('100%')
          .scrollBar(BarState.Off)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#eef2f7')

      if (this.listenerDrawerVisible) {
        Row() {
          Blank()
            .layoutWeight(1)
            .height('100%')
            .onClick(() => {
              this.closeListenerDrawer()
            })
          Column() {
            Row() {
              Text('监听列表')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
              Blank()
              Text(`${this.listenerLogs.length}`)
                .fontSize(12)
                .fontColor('#6b7280')
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .margin({ bottom: 8 })

            Scroll() {
              Column() {
                if (this.listenerLogs.length > 0) {
                  ForEach(this.listenerLogs, (item: ApiLogItem) => {
                    Column() {
                      Text(item.title)
                        .fontSize(12)
                        .fontWeight(FontWeight.Medium)
                      Text(`${item.time}`)
                        .fontSize(10)
                        .fontColor('#6b7280')
                        .margin({ top: 2 })
                      Text(item.content)
                        .fontSize(12)
                        .fontColor('#374151')
                        .margin({ top: 4 })
                    }
                    .width('100%')
                    .padding(8)
                    .borderRadius(4)
                    .backgroundColor('#f8fafc')
                    .margin({ bottom: 6 })
                  }, (item: ApiLogItem) => `${item.time}_${item.title}`)
                } else {
                  Text('暂无监听记录')
                    .fontSize(12)
                    .fontColor('#6b7280')
                }
              }
              .width('100%')
            }
            .layoutWeight(1)
            .width('100%')
            .scrollBar(BarState.Off)
          }
        .width(320)
        .height('100%')
        .padding(12)
        .backgroundColor('#ffffff')
      }
        .width('100%')
        .height('100%')
        .backgroundColor('#66000000')
      }
    }
    .width('100%')
    .height('100%')
  }
}
