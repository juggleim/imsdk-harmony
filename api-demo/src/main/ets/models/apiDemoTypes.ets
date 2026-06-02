export class ApiDemoCommonDefaults {
  address: string = ''
  appkey: string = ''
  token: string = ''
  userId: string = ''
  packageName: string = ''
  language: string = ''
  conversationType: string = '1'
  conversationId: string = ''
  subChannel: string = ''
  groupId: string = ''
  chatroomId: string = ''
  tagId: string = ''
  tagName: string = ''
  messageId: string = ''
  clientMsgNo: string = '0'
  count: string = '20'
  time: string = '0'
  direction: string = '0'
  isPositive: string = 'false'
  startTime: string = '0'
  prevMessageCount: string = '20'
  isAutoCreate: string = 'false'
  pushChannel: string = '2'
  pushToken: string = ''
  signKey: string = ''
  searchContent: string = ''
  filePath: string = ''
  contentKind: string = 'text'
  contentJson: string = '{"content":"Hello","extra":""}'
  msgIdsJson: string = '[]'
  conversationIdsJson: string = '[]'
  contentTypesJson: string = '[]'
  userIdsJson: string = '[]'
  periodsJson: string = '[]'
  mapJson: string = '{}'
  paramsJson: string = '{}'
  headersJson: string = '{}'
  reactionId: string = 'like'
  momentId: string = ''
  commentId: string = ''
  parentCommentId: string = ''
  cleanTime: string = '0'
  cleanScope: string = '0'
  limit: string = '20'
  offset: string = ''
  advancedJson: string = '{}'
}

export enum ApiFieldKind {
  Text = 'text',
  Number = 'number',
  Boolean = 'boolean',
  Json = 'json',
  Password = 'password',
  MediaMessage = 'mediaMessage'
}

export class ApiFieldConfig {
  key: string = ''
  label: string = ''
  kind: string = ApiFieldKind.Text
  defaultValue: string = ''
  sourceKey: string = ''
  placeholder: string = ''
  help: string = ''
}

export class ApiActionConfig {
  id: string = ''
  title: string = ''
  target: string = ''
  method: string = ''
  description: string = ''
  callbackKind: string = 'common'
  callbackKinds: string[] = []
  args: ApiFieldConfig[] = []
}

export class ApiCategoryConfig {
  id: string = ''
  title: string = ''
  description: string = ''
  actions: ApiActionConfig[] = []
}

export class ApiListenerConfig {
  id: string = ''
  title: string = ''
  target: string = ''
  method: string = ''
  description: string = ''
  listenerKind: string = ''
  key: string = ''
}

export class ApiDemoConfig {
  defaults: ApiDemoCommonDefaults = new ApiDemoCommonDefaults()
  categories: ApiCategoryConfig[] = []
  listeners: ApiListenerConfig[] = []
}

export class ApiDemoInvokeContext {
  address: string = ''
  appkey: string = ''
  token: string = ''
  userId: string = ''
  packageName: string = ''
  language: string = ''
  advancedJson: string = '{}'
}

export class ApiFieldViewState {
  key: string = ''
  label: string = ''
  kind: string = ApiFieldKind.Text
  value: string = ''
  placeholder: string = ''
  help: string = ''
}

export class ApiMediaMessageValue {
  contentKind: string = 'text'
  content: string = 'Hello'
  extra: string = ''
  localPath: string = ''
  url: string = ''
  thumbnail: string = ''
  poster: string = ''
  name: string = ''
  type: string = ''
  size: number = 0
  width: number = 0
  height: number = 0
  duration: number = 0
}

export class ApiLogItem {
  time: number = 0
  title: string = ''
  content: string = ''
}
