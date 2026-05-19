# Harmony IM / RTC 能力补齐状态表

## 兼容策略

本次工作是对已有 Harmony SDK 版本做能力升级，不是从零重构。

兼容规则：

- 已有公开接口不删除。
- 参数可以新增，但必须是可选参数或有默认值，保证旧调用点继续可用。
- 返回值可以扩展，但必须覆盖/包含原有返回类型语义，旧用法不能失效。
- 不默认另开平行接口；如果现有接口可以安全演进，就在原接口上演进。
- 如果为了 Android 对齐需要破坏兼容，或无法判断旧调用是否安全，先暂停并让用户决策。

状态说明：

- `待开始`：尚未实现。
- `进行中`：正在实现。
- `已实现`：代码已完成，等待验证。
- `已验证`：已经完成验证步骤。
- `阻塞`：存在依赖或决策阻塞。

---

## IM 能力补齐清单

| 序号 | 优先级 | 能力 / 接口 | 当前 Harmony 状态 | Android 对齐参考 | 计划实现内容 | 验证方式 | 状态 |
|---:|---|---|---|---|---|---|---|
| IM-00 | P0 | 公共 API 边界与接口目录 | manager 直接作为实现暴露，UI 有 deep import | `JIM` + interfaces | 新增 `interfaces/`，统一 `Index.ets` 导出，manager return type 对齐接口 | 编译通过，现有登录/会话/文本发送不回退 | 已实现 |
| IM-01 | P0 | `MessageOptions` | 缺失 | Android `MessageOptions` | 新增发送选项，支持引用消息、mention、pushData、生命周期预留 | 文本发送仍正常，带 options 调用不报错 | 已实现 |
| IM-02 | P0 | `GetMessageOptions` | 当前 `QueryMsgOptions` 简化 | Android `GetMessageOptions` | 统一消息查询参数：count、time、direction、contentTypes | 会话详情历史消息正常分页 | 待开始 |
| IM-03 | P0 | `GetConversationOptions` | 会话查询参数分散 | Android `GetConversationOptions` | 统一会话查询参数：count、time、direction、conversationTypes | 会话列表正常分页 | 待开始 |
| IM-04 | P0 | 草稿 `setDraft / clearDraft` | 空实现 | Android `setDraft/clearDraft` | DAO 补 update draft，manager 触发会话更新 | 输入草稿退出再进恢复，清空后消失 | 待开始 |
| IM-05 | P0 | 本地属性 `setLocalAttribute / getLocalAttribute` | `setLocalAttribue` 空实现且拼写错误 | Android local attribute | DB 增字段/兼容，DAO 补读写，修正接口名 | 设置后重新查询可读 | 待开始 |
| IM-06 | P0 | 按 ID 查消息 `getMessagesByMessageIds` | 空实现 | Android 同名能力 | DAO 按 messageId/clientId 查询，manager 对外回调 | 给定 messageId 能查到消息 | 待开始 |
| IM-07 | P0 | 主动修改消息 `updateMessage / modifyMessage` | 空实现；仅被动 cmd 处理 | Android `updateMessage` | 发起服务端修改请求，成功后更新本地内容并通知 | 文本消息修改后 DB/UI 更新 | 待开始 |
| IM-08 | P0 | 已读回执 `sendReadReceipt` | 空实现 | Android `sendReadReceipt` | 构造 read receipt 请求，更新本地已读状态预留 | 调用返回成功/失败，不影响会话 | 待开始 |
| IM-09 | P1 | 消息搜索 `searchMessages` | 空实现 | Android `searchMessage` | 基于本地 `search_content`/文本内容查询，后续可远端 | 搜关键词返回匹配消息 | 待开始 |
| IM-10 | P1 | Mention 消息查询 | 空实现 | Android `getMentionMessageList` | 利用 mention 字段/标记查询相关消息 | @ 消息可查询 | 待开始 |
| IM-11 | P1 | 群资料 `getGroupInfo` | 公开方法返回 null | Android `getGroupInfo` | 本地优先，远端补拉，落 DB | 群会话可拉到群名头像 | 待开始 |
| IM-12 | P1 | 群成员 `getGroupMember` | DAO 只有私有转换，无能力 | Android `getGroupMember` | 补 model/DAO/manager 查询与缓存 | 给定 groupId/userId 返回成员资料 | 待开始 |
| IM-13 | P1 | 媒体消息基类 `MediaMessageContent` | 媒体消息只是普通 `MessageContent` | Android `MediaMessageContent` | 抽象 localPath/url/upload 状态字段 | 图片/视频/文件/语音模型统一 | 待开始 |
| IM-14 | P1 | 上传接口 `IMessageUploadProvider` | 缺失 | Android `IMessageUploadProvider` | 定义 upload callback：progress/success/error/cancel | mock provider 可走通回调 | 待开始 |
| IM-15 | P1 | `sendMediaMessage` | 空实现 | Android `sendMediaMessage` | 上传 -> 回填 url -> 发送 -> 状态更新 | 至少图片消息端到端发送成功 | 待开始 |
| IM-16 | P2 | 媒体消息下载 | 缺失 | Android `downloadMediaMessage` | 下载接口和取消接口，先支持 url 下载到本地 | 下载图片/文件成功 | 待开始 |
| IM-17 | P2 | 会话标签 tag | 表存在，能力不完整 | Android conversation tag | add/remove tag，按 tag 未读统计 | 标签增删和未读统计可用 | 待开始 |
| IM-18 | P2 | Reaction | 缺失 | Android reaction | add/remove/get/cache reaction | 消息 reaction 可增删查 | 待开始 |
| IM-19 | P2 | 收藏 Favorite | 缺失 | Android favorite | add/remove/get favorite | 收藏消息列表可查询 | 待开始 |
| IM-20 | P2 | 消息置顶 Top Message | 缺失 | Android top message | set/get top message | 会话内置顶消息可查 | 待开始 |
| IM-21 | P2 | 全局免打扰 / 时段免打扰 | 缺失 | Android global mute | set/get 全局免打扰和时段 | 设置后可查询 | 待开始 |
| IM-22 | P2 | 广播消息 | 缺失 | Android broadcast | 多会话批量发送与进度回调 | 多个会话发送进度正确 | 待开始 |
| IM-23 | P3 | ChatroomManager | 协议预留，逻辑 TODO | Android ChatroomManager | join/quit/send/receive/attrs 最小闭环 | 加入聊天室收发消息 | 待开始 |
| IM-24 | P3 | PushManager | 缺失 | Android PushManager | 定义 push token 注册接口，Harmony 推送后续接入 | token 注册请求可发出 | 待开始 |
| IM-25 | P3 | MomentManager | Harmony socialCircle 是静态 UI | Android MomentManager | 动态发布/列表/评论/点赞接口 | 动态列表可拉取 | 待开始 |

---

## RTC / Call 能力补齐清单

RTC 在 IM 基础能力补齐后开始。前期先做 SDK 架构和 mock media，不直接上复杂 UI。

| 序号 | 优先级 | 能力 / 接口 | 当前 Harmony 状态 | Android 对齐参考 | 计划实现内容 | 验证方式 | 状态 |
|---:|---|---|---|---|---|---|---|
| RTC-00 | P0 | Call 公共目录与 facade | 缺失 | `getCallManager()` | 新增 `call/` 目录和 `getCallManager()` | 编译通过，SDK 可获取 CallManager | 待开始 |
| RTC-01 | P0 | `CallConst` | 缺失 | Android `CallConst` | 定义媒体类型、状态、错误码、结束原因 | 类型可被 UI/SDK 引用 | 待开始 |
| RTC-02 | P0 | `ICallManager` | 缺失 | Android `ICallManager` | startSingleCall/startMultiCall/joinCall/listener | 方法可调用，mock 返回 session | 待开始 |
| RTC-03 | P0 | `ICallSession` | 缺失 | Android `ICallSession` | accept/hangup/media controls/getters/listeners | session 状态可观察 | 待开始 |
| RTC-04 | P0 | Call 状态机 | 缺失 | Android `CallSessionImpl + fsm` | idle/outgoing/incoming/connecting/connected/finished | mock 信令状态流正确 | 待开始 |
| RTC-05 | P0 | Call 信令消息 | 只有 RTC 字段预留 | Android call signaling | 定义 invite/accept/hangup/join/quit 信令 | 双端收发信令可见 | 待开始 |
| RTC-06 | P1 | `ICallMediaEngine` | 缺失 | Android `ICallMediaEngine` | joinRoom/leaveRoom/camera/mic/speaker/view | mock engine 可验证调用顺序 | 待开始 |
| RTC-07 | P1 | MockCallMediaEngine | 缺失 | Android media abstraction | 无真实 RTC，先验证状态和接口 | start/accept/hangup 全流程无媒体 | 待开始 |
| RTC-08 | P1 | 1v1 音频真实 RTC | 缺失 | Android Zego/Agora/LiveKit | 接入一个 Harmony RTC SDK | 双端语音通话成功 | 待开始 |
| RTC-09 | P1 | 1v1 视频真实 RTC | 缺失 | Android video call | 预览、远端渲染、开关摄像头 | 双端视频通话成功 | 待开始 |
| RTC-10 | P2 | 多人通话 | 缺失 | Android multi call | 邀请多人、加入、退出、成员状态 | 3 人通话基本流程 | 待开始 |
| RTC-11 | P2 | Call UI | 缺失 | Android `SingleCallActivity/Multi*` | Harmony 通话页/来电页/通话中页 | 从联系人发起通话完整跑通 | 待开始 |
| RTC-12 | P2 | CallKit 抽离 | 缺失 | JetIMKit call UI | 通话 UI 组件化 | demo 消费组件，不依赖内部 | 待开始 |

---

## 本轮执行记录

| 序号 | 状态 | 修改前对照点 | 修改后实现点 | 涉及文件 | 测试/验证 |
|---|---|---|---|---|---|
| IM-00 | 已实现 | `JuggleIm` 直接返回 concrete manager；`juggleim/Index.ets` 只导出 `JuggleIm` | 已补 `interfaces/` 公共类型目录、统一 `Index.ets` 导出，`get*Manager()` 返回接口类型，`home` 侧剩余 deep import 已清理 | `juggleim/Index.ets`、`juggleim/src/main/ets/interfaces/*`、`juggleim/src/main/ets/juggleim.ets`、`jugglechat/home/src/main/ets/pages/ConversationList.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets` | 待验证 |
| IM-01 | 已实现 | Harmony `sendMessage` 只有基础消息体，协议里已有 `pushData / mentionInfo / referMsg` 但公共类型和透传缺失 | 已新增 `MessageOptions / MessageMentionInfo / PushData` 公共类型；`sendMessage` 支持兼容旧签名和带 options 的新签名；引用消息、mention、pushData 已透传到 websocket，上行前本地消息也会保留相关字段，生命周期先做本地字段预留 | `juggleim/src/main/ets/entries/messageoptions.ets`、`juggleim/src/main/ets/commons/messageoptionutil.ets`、`juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/entries/msghandler.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`juggleim/Index.ets` | 待验证 |
