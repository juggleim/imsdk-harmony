# Harmony vs Android：IM / Call 能力差异与对齐分析

本文目标不是简单罗列“有/没有”，而是从 **能力面、实现深度、架构层级、应用接入程度、后续对齐优先级** 五个角度，帮助你判断 Harmony 端下一步应该补什么。

---

# 1. 总结先看

## 1.1 一句话结论

**Android 端是完整的 IM + Call + Push + UIKit + Demo 产品体系；Harmony 端当前只实现了 IM Core 的一部分，加上一个较轻量的聊天示例 UI，Call 基本未落地。**

## 1.2 如果把 Android 当对齐基线

### Harmony 已有基础
- IM 连接
- 消息同步
- 文本消息发送
- 会话同步
- 本地 DB
- 用户/群资料基础缓存
- 基础聊天示例页面

### Harmony 明显缺失
- 完整消息高级能力
- 媒体消息上传/发送闭环
- 聊天室
- Push
- Moment/朋友圈
- 完整群能力
- 完整已读体系
- Message Reaction
- 收藏 / 消息置顶 / 标签 / Mention 完整链路
- 独立 UIKit
- 完整 Call Core
- RTC 引擎接入
- 通话 UI

## 1.3 对齐建议排序
建议分 4 个阶段推进：

### P0：先把 Harmony IM 核心补成“可用 SDK”
1. 媒体消息上传 + 发送
2. 已读回执
3. 消息修改主动 API
4. 查询消息 by ids
5. 本地属性 / 搜索 / mention
6. 草稿
7. 群资料 / 群成员补齐

### P1：补 Android 已有的 IM 增强能力
1. reaction
2. 收藏
3. top message
4. 会话标签
5. 全局免打扰与时段免打扰
6. 广播消息
7. 合并消息完整链路

### P2：补生态能力
1. Chatroom
2. Push
3. Moment/朋友圈
4. 下载器 / 上传器完整能力

### P3：补 Call 体系
1. Call 信令抽象
2. Call 状态机
3. ICallSession
4. RTC 媒体引擎接口
5. 选一个引擎先落地
6. 通话 UI 与应用层接入

---

# 2. 项目层级差异

## 2.1 Harmony 当前结构

Harmony 当前主要是：
- `juggleim`：IM 核心
- `jugglechat/home`：聊天页面
- `jugglechat/base`：基础 UI
- `jugglechat/socialCircle`：静态社交圈示例
- `demo`：应用入口

核心问题：
- **没有独立 UIKit 抽象层**
- **没有 Push 能力模块**
- **没有 Call 模块**
- **没有独立业务扩展模块（如 Moment、Chatroom）**

## 2.2 Android 当前结构

Android 已分成：
- `JuggleIM`：IM Core + Chatroom + Moment + Call 信令 + Push 管理 + Upload/Download
- `JetIMKit`：UIKit + Call UI
- `JZegoCall / JAgoraCall / JLiveKitCall`：RTC 媒体引擎实现
- 多厂商 Push 插件
- `demo` / `app`

### 结论
Android 是 **产品级 SDK 家族**；Harmony 目前是 **SDK 雏形 + 示例工程**。

---

# 3. IM 能力差异总表

下面以 Android 为基线做能力对比。

## 3.1 连接与生命周期

### Android
已实现：
- connect / disconnect
- 自动重连状态机
- 心跳
- 网络变化感知
- 前后台切换 pushSwitch
- DB open / close 监听
- 语言设置与获取
- push token 注册

证据：
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IConnectionManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IConnectionManager.java)
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/connect/ConnectionManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/connect/ConnectionManager.java)

### Harmony
已实现：
- connect
- disconnect
- 心跳 ping/pong
- 基础连接状态回调

缺失：
- 前后台状态感知
- 网络变化感知
- reconnect 状态机
- push token 上报
- 语言设置
- DB open/close 生命周期回调

### 对齐判断
Harmony 连接层当前只是“可连接”，Android 已是“连接生命周期管理器”。

### 对齐优先级
**高**。尤其是重连、网络切换和前后台逻辑，后续所有能力都依赖它稳定。

---

## 3.2 会话基础能力

### Android
已实现：
- 创建会话
- 删除会话
- 查询会话
- 草稿设置/清除
- 置顶
- 免打扰
- 单会话/总未读
- 按类型统计未读
- 按标签统计未读
- 置顶会话排序模式
- 会话标签增删
- 会话同步完成监听
- 会话标签监听

证据：
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IConversationManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IConversationManager.java)
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/ConversationManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/ConversationManager.java)

### Harmony
已实现：
- 查询会话
- 创建会话
- 删除会话
- 置顶
- 免打扰（较粗糙）
- 单会话/总未读
- 会话增删改监听

缺失：
- 草稿持久化
- 会话标签
- 按标签统计未读
- 同步完成监听
- 更细粒度查询条件
- 置顶排序策略配置

### 对齐判断
Harmony 的会话能力有基础，但 Android 明显更完整，特别是 **草稿、tag、mention、统计维度**。

### 对齐优先级
**中高**。建议先补草稿和 tag。

---

## 3.3 消息发送基础能力

### Android
已实现：
- 文本消息发送
- 消息选项 `MessageOptions`
- 引用消息
- mention 信息
- pushData
- 生命时长 `lifeTime`
- 已读后销毁 `lifeTimeAfterRead`
- 广播消息
- 自定义预处理（加密/解密）

证据：
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IMessageManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IMessageManager.java)
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/MessageManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/MessageManager.java)

### Harmony
已实现：
- 文本消息发送
- 基础发送状态
- 群/私聊 topic 区分

缺失：
- MessageOptions 体系
- 引用消息完整链路
- mention 信息
- pushData
- lifeTime / 阅后即焚
- 广播消息
- 消息加解密前处理器

### 对齐判断
Harmony 当前只支持“基础 sendMessage”，Android 已是“完整消息发送框架”。

### 对齐优先级
**高**。建议优先补 `MessageOptions` 体系，后续很多高级能力都挂在这里。

---

## 3.4 媒体消息上传与发送

### Android
已实现：
- 图片/视频/文件/语音上传
- 图片缩略图预上传
- 视频快照预上传
- OSS 凭证获取
- 多种上传器适配
- 可替换上传 provider
- 发送进度回调
- 失败/取消回调
- 独立 `uploadImage`

证据：
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/UploadManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/UploadManager.java)
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IMessageUploadProvider.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IMessageUploadProvider.java)

### Harmony
现状：
- 只有 `ImageMessage / FileMessage / VoiceMessage / VideoMessage` 内容模型
- `sendMediaMessage(...)` 空实现
- 没有 upload provider
- 没有进度/取消机制

### 对齐判断
这是 Harmony 与 Android IM 能力差距最大的模块之一。

### 对齐优先级
**最高**。如果要先把 Harmony 端补成“能真正用的 IM SDK”，媒体消息必须优先。

---

## 3.5 历史消息拉取

### Android
已实现：
- 本地拉取
- 远端拉取
- 本地 + 远端双阶段回调
- 拉取过滤 contentType
- MessageQueryOptions
- V2 / V3 回调形式
- 第一条未读消息定位
- 合并消息展开

### Harmony
已实现：
- 本地历史消息
- 本地不足或缺失时远端补拉

缺失：
- 更丰富的 query options
- 第一条未读消息定位
- 合并消息展开接口
- 多版本回调接口
- contentType 过滤查询

### 对齐判断
Harmony 的拉取能力够基础聊天页用，但不够 SDK 化。

### 对齐优先级
**中**。

---

## 3.6 消息搜索

### Android
已实现：
- 全局搜索消息
- 按会话搜索消息
- 按 contentType 过滤搜索
- 根据消息内容搜索会话

### Harmony
- `searchMessages(...)` 空实现
- 没有搜索会话能力

### 对齐判断
Harmony 还没有真正的消息搜索。

### 对齐优先级
**中**。

---

## 3.7 已读体系

### Android
已实现：
- `sendReadReceipt`
- 单聊消息阅读时间 `getMessageReadTime`
- 群消息阅读详情 `getGroupMessageReadInfoDetail`
- 已读回执监听
- 群消息阅读回执监听

### Harmony
- `ReadNtfMessage` / `ClearUnreadMessage` 结构存在
- `sendReadReceipt(...)` 空实现
- 没有群消息阅读详情 API

### 对齐判断
Harmony 已读体系只有协议预留，没有功能闭环。

### 对齐优先级
**高**。已读是 IM 的关键用户体验能力。

---

## 3.8 消息撤回 / 修改 / 删除 / 清空

### Android
已实现：
- recall
- updateMessage
- delete by messageId / clientMsgNo
- forAllUsers 删除
- clear messages
- forAllUsers 清空
- 相应监听完整

### Harmony
已实现：
- recall
- 被动 modify 命令处理
- delete / clear 请求接口

缺失：
- 主动 updateMessage API
- 删除/清空监听触发链路不完整
- forAllUsers 语义不清晰

### 对齐判断
Harmony 在这一类能力上接近 Android 的“基础版”，但离完整产品版还有差距。

### 对齐优先级
**中高**。

---

## 3.9 Reaction / 收藏 / 置顶消息

### Android
已实现：
- reaction 添加 / 移除 / 批量获取 / 缓存
- 收藏消息 add/remove/getFavorite
- 单条消息置顶 `setTop(messageId, conversation, ...)`
- 获取会话置顶消息 `getTopMessage`

证据：
- `MessageManager.java` 中的 `addMessageReaction/removeMessageReaction/getMessagesReaction/addFavorite/removeFavorite/getFavorite/setTop/getTopMessage`
- DB 中独立 `reaction` 表

### Harmony
已补齐：
- reaction 添加 / 移除 / 批量获取 / 本地缓存与服务端同步
- 收藏消息 add/remove/getFavorite
- 单条消息置顶 `setTop`
- 获取会话置顶消息 `getTopMessage`
- 下行状态消息 `jg:topmsg` 触发本地 UI/监听刷新

### 对齐判断
Reaction、收藏、置顶消息已经进入可用状态。

### 对齐优先级
**中**。不是最先要补，但如果要“能力对齐”，这是明确 gap。

---

## 3.10 Mention / Local Attribute / 阅后即焚

### Android
已实现：
- message / conversation mention info
- mention message list
- local attribute set/get
- destroy_time / 消息销毁时间监听
- lifeTime / lifeTimeAfterRead

证据：
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/core/db/MessageSql.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/core/db/MessageSql.java)
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/core/db/ConversationSql.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/core/db/ConversationSql.java)

### Harmony
- mention query 空实现
- `setLocalAttribue(...)` 空实现
- 无 destroy_time 模型
- 无消息销毁监听

### 对齐判断
Harmony 缺了这组“高级但重要”的消息元数据能力。

### 对齐优先级
**中高**，尤其是 local attribute 和 mention，做 UIKit 时会很常用。

---

## 3.11 用户/群/群成员资料

### Android
已实现：
- `getUserInfo`
- `getGroupInfo`
- `getGroupMember`
- 本地缓存与 DB 支撑

### Harmony
已实现：
- `getUserInfo`：本地 + 远端补拉
- `getLocalGroupInfo`
- 群资料缓存

缺失：
- `getGroupInfo()` 对外不可用
- `GroupMember` 无完整 API

### 对齐判断
Harmony 用户资料还行，群/成员能力明显弱。

### 对齐优先级
**中高**。

---

## 3.12 Chatroom

### Android
已实现：
- join / quit
- 拉历史消息数量控制
- 自动创建选项
- 属性 set / remove / getAll
- 属性同步
- 重连后自动重进
- kick / destroy / quit / joinFail 等事件
- 聊天室消息与属性缓存清理

证据：
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IChatroomManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IChatroomManager.java)
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/ChatroomManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/ChatroomManager.java)

### Harmony
- 协议有 `Chatroom` 和 `NotifyType.ChatroomMsg`
- 实际逻辑只有 `//TODO`

### 对齐判断
Harmony Chatroom 是明显空缺模块。

### 对齐优先级
**中高**。如果产品场景里有直播/大群互动，这会升到高优先级。

---

## 3.13 Push

### Android
已实现：
- PushConfig
- PushManager
- 多厂商 token 获取
- token 自动上报 IM 服务端

### Harmony
已补最小可用 Push 链路：
- `IConnectionManager.registerPushToken(...)`
- Harmony PushKit `getToken()` + `tokenUpdate` 监听
- `reg_push_token` 远端上报
- connect 建链时携带 `pushToken/packageName/pushChannel`
- demo “推送设置”调试页

### 对齐判断
Harmony 已具备 token 获取与上报闭环，但离线消息接收扩展能力仍未完整展开。

### 对齐优先级
**高**，如果要进入实际可交付阶段，Push 必须补。

---

## 3.14 Moment / 朋友圈

### Android
已实现：
- 发布动态
- 删除动态
- 获取动态列表 / 详情
- 评论增删查
- 点赞增删查
- 本地缓存 moments
- moment DB 存储

证据：
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IMomentManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/interfaces/IMomentManager.java)
- [../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/MomentManager.java](../../im-android-sdk/JuggleIM/src/main/java/com/juggle/im/internal/MomentManager.java)

### Harmony
- `socialCircle` 只是静态展示页
- 没有 SDK 级 `MomentManager`
- 没有动态数据接口、评论、点赞

### 对齐判断
Harmony 的社交圈只是 UI 占位，不是功能模块。

### 对齐优先级
**中**，取决于产品范围；如果只做 IM，可暂后。

---

# 4. Call 能力差异总表

## 4.1 Android Call 总体结构

Android Call 已经是完整三层：

### 1）Call 信令 / 业务层
- `ICallManager`
- `ICallSession`
- `CallManager`
- `CallSessionImpl`
- `CallEvent`
- 通话状态机 `Call*State`

### 2）媒体抽象层
- `ICallMediaEngine`
- `CallMediaManager`
- `CallMediaRoom / User / Config`

### 3）引擎实现层
- Zego
- Agora
- LiveKit

### 4）UI 层
- `CallCenter`
- `SingleCallActivity`
- `MultiVoiceCallActivity`
- `MultiVideoCallActivity`

---

## 4.2 Android Call 已实现能力

### 信令与会话
- 单呼
- 多人通话
- join existing call
- 邀请新成员
- 获取会话当前 callInfo
- 会话级监听
- 收到来电监听
- 会话生命周期管理

### 状态管理
- idle
- incoming
- outgoing
- connecting
- connected
- join state
- finish reason
- error code

### 用户事件
- accept
- hangup
- quit
- invite others
- receive invite others
- user join
- user leave
- remote hangup
- room destroy

### 媒体控制
- enable camera
- start preview
- set video view
- mute microphone
- mute speaker
- set speaker route
- use front camera
- enable AEC
- video denoise params
- 音量级别回调
- 首帧回调

### 引擎可选
- Zego
- Agora
- LiveKit

### 应用层证据
- [../../im-android-sdk/demo/src/main/java/com/juggle/chat/settings/UserDetailFragment.java](../../im-android-sdk/demo/src/main/java/com/juggle/chat/settings/UserDetailFragment.java)
- [../../im-android-sdk/demo/src/main/java/com/juggle/chat/BaseApplication.kt](../../im-android-sdk/demo/src/main/java/com/juggle/chat/BaseApplication.kt)

---

## 4.3 Harmony Call 现状

### 真正已实现
**无。**

### 仅有预留
- 连接协议里的 `voipToken`
- 消息协议里的 `rtcRoomId / rtcInviterId / rtcRoomType / rtcMediaType`

### 缺失
- `ICallManager`
- `ICallSession`
- 通话状态机
- Call 信令消息类型
- join/accept/hangup/invite API
- RTC 引擎抽象层
- Zego/Agora/LiveKit 接入
- 通话 UI
- 权限流程
- 通话记录

### 对齐判断
Harmony 当前 **不是 Call SDK 未完善，而是 Call 体系尚未开始真正建设**。

### 对齐优先级
如果你下一步目标是“先对齐两端 IM”，Call 可以稍后；但如果目标是“产品能力对齐”，Call 需要单独立项。

---

# 5. UIKit / 应用层差异

## 5.1 Android
有独立 `JetIMKit`：
- 会话列表
- 会话详情
- 多类型消息渲染
- 语音消息
- reaction UI
- 通话 UI
- 可配置项
- Provider 扩展点

## 5.2 Harmony
只有应用级页面：
- 会话列表
- 会话详情
- 联系人
- 我的
- 静态社交圈

没有看到：
- 可复用 UIKit 模块
- CallCenter
- 多消息类型成熟渲染体系
- 通话 Activity/Page 体系

### 对齐判断
Harmony 当前更像“业务 demo 页面”，Android 已经有“可复用 UI 产品层”。

### 对齐优先级
**中**。如果先做 SDK 对齐，可以晚于 Core；如果要给业务方复用，UIKit 迟早要独立出来。

---

# 6. Harmony 对齐 Android 的推荐路线

## 阶段 1：补齐 IM Core 的最小可用差距

目标：让 Harmony 先达到“基础可用 SDK”水平。

### 建议优先实现
1. `MessageOptions`
2. `sendMediaMessage`
3. 上传器接口 `IMessageUploadProvider` 对应能力
4. `sendReadReceipt`
5. `modifyMessage`
6. `getMessagesByIds`
7. `searchMessages`
8. `setLocalAttribute/getLocalAttribute`
9. `setDraft/clearDraft`
10. `getGroupInfo/getGroupMember`

### 原因
这些能力和当前 Harmony 架构最接近，改造成本相对低，而且是 UI 可用性的核心。

---

## 阶段 2：补齐 IM 高级能力

### 建议实现
1. mention message list
2. reaction
3. favorite
4. top message
5. conversation tags
6. broadcast message
7. global mute / mute periods
8. destroy time / 阅后即焚

### 原因
这些能力在 Android 已经稳定存在，是产品深度的主要差异来源。

---

## 阶段 3：补生态能力

### 建议实现
1. ChatroomManager
2. PushManager + 各厂商 push 适配思路
3. MomentManager
4. downloader / upload manager 完整化

### 原因
这阶段开始不只是“聊天 SDK”，而是产品能力生态扩展。

---

## 阶段 4：补 Call 体系

### 推荐建设顺序
1. 先在 Harmony 新建 `call` 核心层
2. 定义：
   - `ICallManager`
   - `ICallSession`
   - `CallConst`
   - `CallStateMachine`
3. 在 IM 协议上定义通话信令消息类型
4. 建 `ICallMediaEngine` 抽象
5. 先选一套 RTC 引擎接入
6. 补通话 UI

### 重要建议
**不要直接把 Android Call 代码平铺翻译到 Harmony。**
应该优先照着它的抽象边界重建：
- 信令层
- 会话状态机
- 媒体引擎接口
- UI 层分离

这样后续才能同时支持多引擎。

---

# 7. 建议你后续对齐时的比较基线

如果你准备真的做两端对齐，建议把能力拆成 4 张清单管理：

## 清单 A：必须先对齐的 IM 基础能力
- connect / reconnect
- text send/receive
- media send
- conversation sync
- history query
- read receipt
- group/user info

## 清单 B：产品增强 IM 能力
- draft
- mention
- search
- reaction
- favorite
- top message
- local attribute
- tag

## 清单 C：生态能力
- chatroom
- push
- moment

## 清单 D：Call 能力
- signaling
- session state
- rtc engine
- ui

这样做能避免一开始就被 Android 端的全部能力压垮，也更适合制定 Harmony 的迭代路线。

---

# 8. 最终结论

## 8.1 当前真实差距
Harmony 与 Android 之间不是“小补丁差距”，而是 **代际差距**：
- Android：完整 IM/Call 产品 SDK 体系
- Harmony：基础 IM 雏形 + 示例页面

## 8.2 但 Harmony 的好消息
Harmony 当前的 `juggleim` 架构方向并不差，已经有：
- 统一入口单例
- manager 分层
- 本地 DB
- protobuf 协议
- 消息内容注册机制
- 同步管理器

所以它不是推倒重来，而是 **可以沿着 Android 的能力面逐步扩展**。

## 8.3 最适合你的下一步
如果你的目标是“最终两端能力对齐”，建议先做下面这件事：

> 先把 Android 的 IM / Call 能力拆成一张标准能力矩阵，再把 Harmony 映射进去，标出：已实现 / 部分实现 / 未实现 / 架构未预留。

这样你后面做版本规划、排优先级、拆任务会非常顺。
