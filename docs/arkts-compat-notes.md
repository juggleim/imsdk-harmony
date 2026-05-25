# ArkTS 兼容写法备忘

更新时间：2026-05-25

这份文档只记录本仓库里已经实际踩中的 ArkTS / Harmony 编译限制，以及后续修改时应直接采用的规避写法。

## 1. 不要传匿名对象字面量给严格类型参数

已踩中的报错：

- `arkts-no-untyped-obj-literals`
- `Type '{ ... }' is not assignable to type 'Xxx'`

禁止写法：

```ts
this.setMsgFlag({ isCmd: true })
MsgFlagTool.toFlag({ isBroadcast: true })
let req = immessage.QryFavoriteMsgsReq.create({ limit: count, offset: '' })
```

推荐写法：

```ts
let flag = MsgFlagTool.commandFlag()
this.setMsgFlag(flag)

let req = immessage.QryFavoriteMsgsReq.create({})
req.limit = count
req.offset = ''
```

规则：

- `MsgFlag` 一类结构，优先用显式 class + helper 构造。
- protobuf `create(...)` 默认统一写成 `create({})`，后续逐字段赋值。
- 不要为了省几行代码重新引入对象字面量。

## 2. 不要使用 index signature / 按索引访问字段 / for...in

已踩中的报错：

- `arkts-no-indexed-signatures`
- `arkts-no-props-by-index`
- `arkts-no-for-in`

禁止写法：

```ts
interface IStringMapObject {
  [key: string]: string
}

obj[key] = value

for (let key in obj) {
  ...
}
```

推荐写法：

```ts
export class StringMapItem {
  key: string = ''
  value: string = ''
}

let items: StringMapItem[] = []
items.forEach((item) => {
  map.set(item.key, item.value)
})
```

规则：

- 动态 key/value 结构，优先改成显式数组元素类型，例如 `StringMapItem[]`。
- 能用 `forEach` 就不用 `for...in`。
- 能用点访问就不用 `obj['field']`。

## 3. 避免 `string | undefined` 直接赋给 `string`

已踩中的报错：

- `Type 'string | undefined' is not assignable to type 'string'`

禁止写法：

```ts
ext.key = k
ext.value = v
```

推荐写法：

```ts
ext.key = k != undefined ? k : ''
ext.value = v != undefined ? v : ''
```

规则：

- `HashMap.forEach`、proto 可选字段、JSON 反序列化字段，一律先兜底再赋值。

## 4. 修改 proto 字段后，要同时补 d.ts 的实例字段声明

已踩中的报错：

- `Property 'lifeTime' does not exist on type 'UpMsg'`
- `Property 'subChannel' does not exist on type 'UpMsg'`

规则：

- 只补 `IUpMsg` 这种 interface 不够。
- 还要同步补 `class UpMsg` 上的实例字段声明。
- 检查点：
  - `IType` 里有没有字段
  - `class Type` 里有没有 `public field: ...`

## 5. 新增接口签名时，先检查 import 是否同步

已踩中的报错：

- `Cannot find name 'Message'`

规则：

- 给 `interface` 新增方法签名时，先检查引用类型是否已 import。
- 当前仓库里最容易漏的是：
  - `Message`
  - `MessageOptions`
  - callback type

## 6. 这次已经验证过的安全模式

后续直接复用：

- `MsgFlagTool.commandFlag()`
- `MsgFlagTool.storageCountFlag()`
- `MsgFlagTool.broadcastFlag()`
- protobuf 请求对象统一 `create({})` + 字段赋值
- `Map<string, string>` 持久化统一转 `StringMapItem[]`
- `clientMsgNo` 相关查询统一走 DAO 显式方法，不做动态字段拼接

## 7. 提交前自检清单

每次改 ArkTS 代码前后至少扫一遍：

```bash
rg -n "setMsgFlag\\(\\{|toFlag\\(\\{|create\\(\\{.*\\}|\\[['\\\"]" juggleim/src/main/ets
rg -n "\\[key: string\\]|for \\(let .* in " juggleim/src/main/ets
git diff --check --
```

如果改到了 proto / interface / DAO / SQL，额外检查：

- proto 字段
- `immessage.d.ts`
- message model
- DAO 读写
- SQL 初始建表
- SQL migration
