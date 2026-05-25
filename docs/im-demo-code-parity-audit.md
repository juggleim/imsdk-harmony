# IM Demo 代码对齐审计

更新时间：2026-05-25  
审计范围：

- Harmony demo：`/Users/helena/Work/code/imsdk-harmony/jugglechat`
- Android demo：`/Users/helena/Work/code/im-android-sdk/demo`
- Android 聊天 UI/交互基座：`/Users/helena/Work/code/im-android-sdk/JetIMKit`

本审计只依据当前仓库代码，不引用历史文档结论。

## 1. 总体结论

Demo 侧与 SDK 侧的情况不同：

- Harmony demo 这段时间已经补了不少功能页，主路径不再是空壳。
- 但与 Android demo + JetIMKit 相比，**差距仍然主要集中在 demo 层**，而且差的不只是页面数量，还包括：
  - 页面入口完整度；
  - UI 交互颗粒度；
  - 现成聊天组件能力；
  - 好友 / 扫码 / 建群 / 呼叫等外围能力；
  - 资料页和设置页的动作回路。

一句话概括：  
**Harmony demo 已经能演示“IM 主能力”，但还没有达到 Android demo 那种“完整产品化样例”的覆盖度。**

## 2. 主入口对比

## 2.1 Android demo 主入口

`GroupChannelMainActivity.kt` 当前包含 4 个主 tab：

- 会话：`ChannelListFragment`
- 好友：`FriendListFragment`
- Bots：`BotListFragment`
- 设置：`SampleSettingsFragment`

并且会话页 header 右上角扩展了：

- 建群
- 加好友
- 扫码

## 2.2 Harmony demo 主入口

`home/src/main/ets/pages/Index.ets` 当前主入口为：

- 会话
- 联系人
- 朋友圈
- 我的

可见结论：

- Harmony 没有 Android demo 的 `Bots` 页。
- Harmony 没有 Android 主入口级别的 “建群 / 加好友 / 扫码” 右上角动作组。
- Harmony 的“联系人”更偏自定义页面，不等同于 Android demo 的好友体系。

## 3. 功能与页面对照

下表按“真实页面/入口是否存在 + 是否形成完整交互链路”来看。

| 模块 | Android demo / JetIMKit | Harmony demo | 结论 |
|---|---|---|---|
| 会话列表 | `ChannelListFragment`，成体系列表组件 | `ConversationList.ets` | 部分对齐 |
| 会话详情 | `ChannelActivity/ChannelFragment` + `BaseMessageListViewModel` | `ConversationDetail.ets` | 部分对齐 |
| 会话资料 | Android header/profile 流程成熟 | `ConversationProfile.ets` | 部分对齐 |
| 会话历史搜索 | JetIMKit + demo 可组合支持 | `ConversationHistory.ets` | 已有入口，但交互深度较浅 |
| 全局消息搜索 | Android 依赖更成熟的列表/搜索基座 | `GlobalMessageSearch.ets` | 部分对齐 |
| @提及消息页 | Android 基座支持 mention suggestion / mention 发送 | `MentionMessages.ets` | 部分对齐 |
| reaction 展示/操作 | JetIMKit 有成熟 reaction 列表、更多按钮、长按、用户列表 | Harmony 有基础 toggle 与摘要展示 | Harmony 明显偏轻 |
| 收藏 | Android SDK 有，demo 侧可接入 | `MyFavorite.ets` | Harmony 已有页面 |
| 广播消息 | Android SDK 支持，demo 无明显同层专页 | `BroadcastMessage.ets` | Harmony 反而补得更显性 |
| 全局免打扰 | `GlobalDisturbSettingActivity` | `GlobalUndisturb.ets` | 基本对齐 |
| 推送设置 | `PushSettingActivity` -> `PushLanguageSettingActivity` | `PushSetting.ets` | 方向不同，未等价 |
| 推送语言 | Android 有独立语言设置页 | Harmony 只有 Push token/调试信息页，无语言设置落地 | 未对齐 |
| 聊天室列表/房间 | Android `ChatRoomListFragment` + `ChannelActivity` | `ChatroomList.ets` + `ChatroomRoom.ets` | 基本对齐 |
| 朋友圈 | Android SDK 有 moment，demo 侧产品化较弱 | `socialCircle/Index.ets` | Harmony 已有完整样例页 |
| 个人资料设置 | `ProfileSettingActivity` 支持头像/昵称编辑 | Harmony `MeDetail.ets` 只是入口聚合，不是完整 profile setting | 未对齐 |
| 用户资料页 | `UserDetailFragment` 支持发消息/音视频通话/加好友 | `ContactsDetail.ets` 目前以静态展示为主 | 明显未对齐 |
| 好友系统 | Android 有好友列表、好友申请、加好友链路 | Harmony demo 只有部分 server 侧 friend 页面/开关，SDK 内 friend 域不完整 | 明显未对齐 |
| 扫码/二维码 | Android 有 `ScanActivity`、`QRCodeDisplayActivity` | Harmony 未见对等页面 | 未对齐 |
| 群管理 | Android 有群公告、群管理、群昵称、选成员、加群等 | Harmony 未见同级别页面组 | 未对齐 |
| 通话入口 | Android 用户资料页直接发起语音/视频 | Harmony 无对等能力 | 未对齐 |

## 4. 会话列表与聊天页对比

## 4.1 Harmony 已补上的聊天能力

从 `ConversationDetail.ets` 看，Harmony 聊天页已经不是简单收发：

- 文本发送
- 图片 / 视频 / 文件 / 语音发送
- 语音录制
- 引用回复
- 编辑消息
- 转发
- reaction
- 收藏
- 群已读详情
- mention candidate 与 @ 输入
- 历史消息翻页
- 媒体下载

这说明 Harmony demo 在聊天主场景上已经做了较多补齐。

## 4.2 与 Android JetIMKit 的主要差距

Android `ChannelFragment + BaseMessageListViewModel` 仍然更完整，主要体现在：

1. **组件化程度更高**
   - header / message list / input / status 分层明确；
   - 页面行为更多由通用组件驱动。
2. **消息状态控制更完整**
   - resend 文本
   - resend 媒体
   - 更成熟的消息状态回写
3. **reaction 交互更完整**
   - click
   - long click
   - more button
   - 用户列表视图
4. **资料页跳转更完整**
   - `PersonInfoActivity`
   - 资料、通话、会话管理联动更成熟
5. **外设链路更成熟**
   - 相册/相机权限
   - 语音/视频通话
   - 统一的 permission/loader/status 处理

### 结论

Harmony 聊天页已经覆盖“可演示能力”，但离 Android 那种组件化、产品化、可复用的聊天 UI 仍有差距。

## 5. 设置页对比

## 5.1 已基本对齐

- 免打扰：
  - Android：`GlobalDisturbSettingActivity`
  - Harmony：`GlobalUndisturb.ets`
  - 预设时段也已补齐

- 聊天室：
  - Android：`ChatRoomListFragment`
  - Harmony：`ChatroomList.ets` + `ChatroomRoom.ets`

## 5.2 未等价对齐

### Push 设置

Android：

- `PushSettingActivity` 只做入口
- `PushLanguageSettingActivity` 真正落语言设置
- 直接调用 SDK `setLanguage/getLanguage`

Harmony：

- `PushSetting.ets` 主要是：
  - AAID
  - Push Token
  - 手动注册
  - 调试快照
- 目前更像“推送调试工具页”，不是 Android 那个“推送语言设置页”。

所以这两者不是同一类页面，不能算已对齐。

### Profile 设置

Android `ProfileSettingActivity` 提供：

- 头像编辑
- 昵称编辑
- 相机/相册权限
- 上传图片
- 更新用户资料

Harmony `MeDetail.ets` 当前更像“我的功能导航页”：

- 好友验证
- 免打扰
- 推送设置
- 收藏
- 广播
- 聊天室

但缺少真正的个人资料编辑页。

## 6. 用户资料与联系人对比

这是 demo 目前很明显的缺口。

### Android `UserDetailFragment`

根据用户身份和好友状态动态展示：

- 发消息
- 发起语音通话
- 发起视频通话
- 加好友

### Harmony `ContactsDetail.ets`

当前更偏静态展示：

- 头像
- 名称
- 几个 icon
- 最近动态图片

但没有看到与下面能力对齐的完整业务动作链：

- 真正进入聊天
- 语音/视频呼叫
- 好友状态判断
- 加好友动作

### 结论

联系人 / 用户资料页是 Harmony demo 目前最明显的体验缺口之一。

## 7. Android demo 有而 Harmony demo 缺失较多的模块

以下模块在 Android demo 中已形成可见页面或完整入口，但 Harmony 当前没有对等级别的实现：

- 扫码：`ScanActivity`
- 我的二维码：`QRCodeDisplayActivity`
- 加好友列表 / 好友申请列表
- 群管理
- 群公告
- 群昵称设置
- 选择群成员 / 建群
- Bots 页
- 用户资料页里的音视频通话入口
- 个人资料编辑页
- 推送语言设置页

## 8. UI/展示层差异

除了功能入口，UI 表现也有明显差异。

## 8.1 Android demo/JetIMKit 的特点

- 统一组件库驱动
- header、status、message cell、reaction view 都是成熟组件
- 页面状态一致性更高
- 会话、聊天、资料页之间跳转更自然

## 8.2 Harmony demo 当前特点

- 自定义 ArkUI 页面较多
- 单页功能实现已经不少
- 但页面之间的视觉与交互统一度不如 Android
- 某些页面仍带“功能演示页”气质，产品化程度略弱

最典型的几处：

- `PushSetting.ets` 更像调试页；
- `ContactsDetail.ets` 更像静态资料卡；
- `MeDetail.ets` 是聚合页，但不是 Android 那种完整 settings/profile 体系；
- 聊天页单点功能不少，但缺 JetIMKit 那种成熟 message cell/reaction/资料联动生态。

## 9. Demo 对齐优先级建议

如果目标是尽快让 Harmony demo 接近 Android demo，建议按下面顺序补：

1. **资料与联系人链路**
   - 用户详情页动作补齐：发消息 / 加好友 / 语音 / 视频
   - 个人资料编辑页：头像 / 昵称
2. **入口型能力**
   - 扫码
   - 我的二维码
   - 建群 / 选择成员 / 群管理
3. **推送设置对齐**
   - 新增“推送语言设置”页
   - 不是继续堆调试能力
4. **聊天组件体验**
   - reaction 更多面板 / 用户列表
   - resend 能力接入 UI
   - 更完整的消息状态与失败恢复
5. **外围功能**
   - 好友申请 / 好友列表 / 群公告 / bots（如果 Android 仍保留）

## 10. 最终判断

如果只看“能不能演示 IM SDK 新能力”，Harmony demo 已经有明显进展。  
如果看“是否与 Android demo 当前代码实现对齐”，结论是：

- **聊天主页面能力：部分对齐**
- **设置页能力：部分对齐**
- **资料、好友、扫码、群管理、通话入口：明显未对齐**
- **UI 组件成熟度：低于 Android JetIMKit**

因此 demo 侧当前更准确的判断应当是：  
**Harmony demo 已完成 IM 主能力展示，但与 Android demo 的完整度和产品化程度仍有较大差距，且差距主要集中在资料/好友/扫码/群管理/推送语言/通话入口这些外围产品链路。**
