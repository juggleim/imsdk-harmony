# Call 实现集合与实现逻辑

## 1. 先说结论

基于当前仓库代码，**没有发现已经落地的 Call SDK / 音视频通话业务实现**。

也就是说，当前项目里：
- 没有独立的 `call` 模块
- 没有通话 manager / session / invite / accept / reject / hangup 业务类
- 没有 RTC 引擎接入代码
- 没有音视频采集、渲染、设备切换、权限处理的实现
- 没有通话 UI 页面

**目前能确认的 Call 相关内容只有协议字段预留，尚未形成真正功能。**

---

## 2. 仓库中与 Call 最接近的代码证据

## 2.1 连接协议中有 `voipToken` 字段预留

### 代码位置
- [juggleim/src/main/ets/improto/imconnect.proto](../juggleim/src/main/ets/improto/imconnect.proto)

### 字段
- `voipToken = 20`

### 说明
这个字段说明协议层考虑过 VoIP / 通话推送场景，尤其像 iOS 的 VoIP token 这一类模型。但在当前 Harmony 版本代码中：
- `ImClient.connect(...)` 发连接包时并没有填这个字段
- 也没有 VoIP 推送注册或回传逻辑

### 结论
**只是协议预留，不是实际功能。**

---

## 2.2 消息协议里有 RTC 相关字段预留

### 代码位置
- [juggleim/src/main/ets/improto/immessage.proto](../juggleim/src/main/ets/improto/immessage.proto)

### 字段
在 `PushData` 结构附近可以搜到：
- `rtcRoomId`
- `rtcInviterId`
- `rtcRoomType`
- `rtcMediaType`

### 说明
这说明 IM 协议层曾预留过 RTC / 通话联动能力，比如：
- 房间 ID
- 邀请人 ID
- 房间类型
- 媒体类型（音频/视频）

但是当前仓库里没有看到：
- 这些字段的解析使用
- 相关 manager
- 相关事件监听
- 相关 UI 页面
- 相关 join/leave room 逻辑

### 结论
**协议字段预留，业务逻辑未落地。**

---

## 2.3 UI 资源里有个“切换摄像头”图标

### 代码位置
- `jugglechat/home/src/main/resources/base/media/ic_public_switch_camera.svg`

### 说明
资源文件中存在通话类常见图标，但整个源码没有对应的通话页面、按钮逻辑、设备切换逻辑。

### 结论
**只能说明资源层面可能做过设计准备，不能证明功能实现。**

---

## 3. 全仓库未发现的 Call 核心实现

以下这些如果真有 Call SDK，通常一定会存在；但当前仓库未发现对应实现。

## 3.1 通话入口 API

未发现类似以下能力：
- 发起单人音频通话
- 发起单人视频通话
- 发起多人通话
- 邀请成员加入通话
- 取消邀请

也未找到类似：
- `startCall`
- `inviteCall`
- `createCallSession`
- `joinRoom`
- `leaveRoom`

### 结论
**未实现。**

---

## 3.2 通话状态机

未发现类似状态管理：
- calling
- ringing
- accepted
- rejected
- connected
- reconnecting
- ended
- timeout
- busy

也没有找到：
- `CallSession`
- `CallState`
- `CallManager`
- `CallListener`

### 结论
**未实现。**

---

## 3.3 通话邀请信令

虽然 IM 协议预留了 RTC 字段，但当前仓库没有看到：
- 通话邀请消息类型
- 接受邀请消息类型
- 拒绝邀请消息类型
- 挂断消息类型
- 忙线消息类型
- 超时消息类型

在当前消息类型定义 [juggleim/src/main/ets/entries/msgtypes.ets](../juggleim/src/main/ets/entries/msgtypes.ets) 中，只看到了：
- 文本
- 合并消息
- 语音消息
- 图片
- 文件
- 视频消息
- 撤回/已读/清未读/修改等 IM 命令

并没有发现专门的 call message type。

### 结论
**通话信令层未落地。**

---

## 3.4 RTC 引擎集成

未发现以下任何一种形态：
- WebRTC SDK 集成
- 第三方 RTC 厂商 SDK 集成
- 原生媒体采集/播放会话封装
- 房间管理器
- 本地流/远端流视图绑定
- 麦克风/摄像头开关
- 前后摄切换
- 扬声器切换

### 代码层面表现
- 没有 `rtc` 或 `webrtc` 模块目录
- 没有媒体采集与渲染类
- 没有 room/session 维护类
- 没有 call 页面 UI

### 结论
**RTC 实现完全缺失。**

---

## 3.5 音视频权限处理

当前 `demo` 模块申请的权限只有：
- `ohos.permission.INTERNET`

见 [demo/src/main/module.json5](../demo/src/main/module.json5)

如果有 Call 功能，通常还需要至少关注：
- 麦克风权限
- 摄像头权限
- 可能的前台运行/音频焦点处理

当前都没有看到。

### 结论
**通话所需权限体系未实现。**

---

## 3.6 通话 UI

未发现任何明显的通话界面，例如：
- 来电弹窗
- 呼叫中页面
- 通话中页面
- 多人宫格页面
- 最小化悬浮窗
- 音频通话头像页

当前 `home` 模块页面主要是：
- 会话列表
- 会话详情
- 联系人
- 我的
- 社交圈

关键页面见：
- [jugglechat/home/src/main/ets/pages/ConversationList.ets](../jugglechat/home/src/main/ets/pages/ConversationList.ets)
- [jugglechat/home/src/main/ets/pages/ConversationDetail.ets](../jugglechat/home/src/main/ets/pages/ConversationDetail.ets)
- [jugglechat/home/src/main/ets/pages/ContactsList.ets](../jugglechat/home/src/main/ets/pages/ContactsList.ets)

### 结论
**Call UI 未实现。**

---

## 4. 目前与 Call 最接近的“已有能力”是什么

虽然没有 Call 实现，但现有 IM SDK 能提供未来做 Call 的基础设施。

## 4.1 已有长连接基础

### 已有内容
- WebSocket 长连接
- 连接状态监听
- 心跳 ping/pong
- query / publish 模型

### 代码位置
- [juggleim/src/main/ets/imclients/imclient.ets](../juggleim/src/main/ets/imclients/imclient.ets)

### 价值
如果未来要做 Call，可以复用这层做通话邀请和状态同步信令。

---

## 4.2 已有自定义消息注册机制

### 已有内容
- `registerMessage(msgType, constructor)`
- `MsgHandler` 可按类型反序列化业务消息

### 代码位置
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
- [juggleim/src/main/ets/entries/msghandler.ets](../juggleim/src/main/ets/entries/msghandler.ets)

### 价值
未来可以在 IM 消息体系里注册通话邀请、接听、挂断等自定义命令消息。

---

## 4.3 已有本地数据库模型扩展空间

### 已有内容
当前 `messages` 表已支持：
- `msg_type`
- `msg_content`
- `refer_msg_id`
- `search_content`
- `reactions`
- `ext`

见 [juggleim/src/main/resources/rawfile/202504011225.sql](../juggleim/src/main/resources/rawfile/202504011225.sql)

### 价值
未来通话邀请消息、通话记录消息可以作为一种特殊消息类型入库。

---

## 5. 如果按当前架构实现 Call，可能的实现思路

这一部分不是“现有功能”，而是根据现有架构推导出的合理实现方向。

## 5.1 信令层思路

可以基于现有 `juggleim` 做通话信令层：

1. 新增 call 相关消息类型，例如：
   - `jg:call_invite`
   - `jg:call_accept`
   - `jg:call_reject`
   - `jg:call_hangup`
   - `jg:call_cancel`
   - `jg:call_timeout`
   - `jg:call_member_update`

2. 通过 `MsgHandler.registerMessage(...)` 注册这些消息

3. 通过 `MessageManager.sendMessage(...)` 或新的 `CallManager` 发送信令

4. 在 `MsgSyncManager.handleMsg(...)` 中把 call 信令分发给专门监听器

## 5.2 SDK 结构思路

可新增：
- `CallManager`
- `CallSession`
- `CallListener`
- `CallState`
- `CallInviteMessage / CallAcceptMessage / CallHangupMessage`

并在 `JuggleIm` 或平级模块中暴露：
- `getCallManager()`

## 5.3 RTC 媒体层思路

需要额外接入真正的 RTC 引擎，负责：
- 创建房间
- 加入/离开房间
- 发布本地音视频流
- 订阅远端流
- 设备控制
- 网络重连与质量监听

这部分当前仓库完全没有现成代码，需要从零补。

## 5.4 UI 层思路

可在 `home` 模块增加：
- 联系人页发起音视频通话入口
- 会话页发起通话入口
- 来电页面
- 通话中页面
- 悬浮小窗

## 5.5 数据持久化思路

可选择：
- 通话记录作为消息落 `messages`
- 或新增 `call_logs` 表单独存

当前架构更偏向前者，因为消息体系已经成熟。

---

## 6. 当前 Call 文档化结论

### 6.1 已实现功能列表
严格按代码确认，**当前可算作已实现的 Call 功能：无。**

### 6.2 已预留但未实现的内容
1. 协议连接层预留了 `voipToken`
2. IM 消息协议里预留了 RTC 相关字段：
   - `rtcRoomId`
   - `rtcInviterId`
   - `rtcRoomType`
   - `rtcMediaType`
3. UI 资源层存在少量通话类图标素材

### 6.3 未实现的关键能力
1. 发起通话
2. 接听通话
3. 拒绝通话
4. 挂断通话
5. 呼叫超时
6. 忙线处理
7. 多人通话
8. RTC 房间管理
9. 音频采集播放
10. 视频采集渲染
11. 前后摄切换
12. 麦克风/扬声器控制
13. 通话状态同步
14. 通话记录
15. 来电 UI / 通话中 UI
16. 权限管理

---

## 7. 最终判断

当前仓库是一个 **以 IM 为核心的 HarmonyOS 示例工程**，并不是一个 IM + Call 双 SDK 完整工程。

如果只看当前代码：
- **IM：已经有较明显实现基础**
- **Call：只有协议层预留，没有真正业务落地**

所以对外描述时，比较准确的说法应该是：

> 当前项目已经实现了 IM SDK 及聊天示例应用；Call / RTC 相关能力在协议层有少量预留字段，但仓库中尚未实现实际通话功能、通话 UI 和 RTC 媒体链路。
