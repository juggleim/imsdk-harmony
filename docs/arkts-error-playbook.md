# ArkTS Error Playbook

## 常见处理规则

1. 新增接口方法时，先补齐对应类型的 `import`，再补实现。
2. `ArkTS` 的回调参数不要依赖隐式推断，必须显式标注参数类型。
3. `any` / `unknown` 报错优先查匿名函数参数、`catch` 变量、外部 API callback。
4. 改函数签名时，接口文件、实现文件、调用处要一起收口。

## 本次命中项

- `imessagemanager.ets` 漏导入 `IMessageUploadProvider`、`MediaUpload*Callback`
- `realmessageuploadprovider.ets` 的回调参数靠推断触发 `arkts-no-any-unknown`
