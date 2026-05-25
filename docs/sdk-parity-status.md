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

## 任务执行附加要求

从本条规则开始，后续每个 IM / RTC 任务除 SDK 主体实现外，还必须同步处理 demo 侧补充，不能只停留在底层能力。

统一要求：

- 需要补充 demo 逻辑入口，确保该能力在 demo 中可触发、可操作。
- 需要补充必要的 demo UI 或交互控件，避免“能力已实现但 demo 无法体现”。
- 需要补充最小可验证路径，优先参考 Android demo 的测试方式和交互位置。
- 每个任务完成后，都要在任务表和执行记录里补充对应的 demo / UI 落地点。

---

## IM 能力补齐清单

| 序号 | 优先级 | 能力 / 接口 | 当前 Harmony 状态 | Android 对齐参考 | 计划实现内容 | Demo / UI 补充要求 | 验证方式 | 状态 |
|---:|---|---|---|---|---|---|---|---|
| IM-00 | P0 | 公共 API 边界与接口目录 | manager 直接作为实现暴露，UI 有 deep import | `JIM` + interfaces | 新增 `interfaces/`，统一 `Index.ets` 导出，manager return type 对齐接口 | 清理 demo / home 对 SDK 的 deep import，用公共导出验证接入边界 | 编译通过，现有登录/会话/文本发送不回退 | 已实现 |
| IM-01 | P0 | `MessageOptions` | 缺失 | Android `MessageOptions` | 新增发送选项，支持引用消息、mention、pushData、生命周期预留 | demo 补引用消息、群 `@` 消息等可操作入口，便于直接验证 options 透传 | 文本发送仍正常，带 options 调用不报错 | 已实现 |
| IM-02 | P0 | `GetMessageOptions` | 当前 `QueryMsgOptions` 简化 | Android `GetMessageOptions` | 统一消息查询参数：count、time、direction、contentTypes | demo 改为“会话页右上角 -> 会话详情 -> 历史消息”路径；聊天页本身改走新接口，历史消息页补类型筛选、搜索和分页入口 | 会话详情历史消息正常分页 | 已实现 |
| IM-03 | P0 | `GetConversationOptions` | 已补统一查询参数，兼容旧签名 | Android `GetConversationOptions` | 统一会话查询参数：count、time、direction、conversationTypes；旧 `queryConversations(count,startTime,isPositive,callback)` 保留兼容 | demo 主会话列表已改走新 options 查询；不额外保留 Android 中不存在的筛选/刷新按钮，保持入口对齐 | 会话列表正常分页，现有列表加载路径可正常使用新查询参数 | 已实现 |
| IM-04 | P0 | 草稿 `setDraft / clearDraft` | 已支持本地草稿保存、恢复与清空 | Android `setDraft/clearDraft` | DAO 补 draft 读写，manager 触发会话更新；无消息会话允许用本地占位会话承载草稿，清空时自动移除 | demo 会话输入框支持离开页保存草稿、再次进入恢复；会话列表补 `[草稿]` 预览，清空后列表同步消失 | 输入草稿退出再进恢复，发送成功或清空输入后草稿消失 | 已实现 |
| IM-05 | P0 | 本地属性 `setLocalAttribute / getLocalAttribute` | 已支持本地属性存取，兼容旧错拼接口 | Android local attribute | 消息模型和 DB 补 `local_attribute` 字段；新增正确拼写接口 `setLocalAttribute/getLocalAttribute`，旧 `setLocalAttribue` 保留兼容 | Android demo 无对应入口，Harmony demo 不额外暴露；通过 SDK 接口或后续正式业务接入验证 | 设置后重新查询可读，本地属性状态可恢复 | 已实现 |
| IM-06 | P0 | 按 ID 查消息 `getMessagesByMessageIds` | 已支持本地优先 + 远端按 ID 补查，兼容旧 `getMessagesByIds` | Android 同名能力 | DAO 按 `messageId/clientId` 查询，manager 对外补 `getMessagesByMessageIds` 并保留旧名兼容；缺失消息走 `qry_hismsg_by_ids` | Android demo 无独立入口，Harmony demo 不额外暴露；按 Android 方式仅保留 SDK 能力供业务侧接入 | 给定 `messageId` 或本地 `clientId` 能查到消息 | 已实现 |
| IM-07 | P0 | 主动修改消息 `updateMessage / modifyMessage` | 已支持主动编辑消息，兼容旧 `modifyMessage` | Android `updateMessage` | 发起 `modify_msg` 请求，成功后更新本地内容、modified 标记和会话最后一条摘要；补 `updateMessage` 对齐 Android 命名，旧 `modifyMessage` 保留兼容 | demo 聊天页长按自己发送的文本消息补“编辑”入口；输入框进入编辑态，保存后当前会话 UI 刷新并展示已编辑标记 | 文本消息修改后 DB/UI 更新 | 已实现 |
| IM-08 | P0 | 已读回执 `sendReadReceipt` | 已支持私聊已读回执发送，群聊已补 `clearUnreadCount + jg:grpreadntf + 已读详情查询` | Android `sendReadReceipt` / 群已读相关链路 | 私聊构造 `mark_read` 请求并消费 `jg:readntf`；群聊补 `jg:grpreadntf`、`getGroupMessageReadInfoDetail(...)` 与本地读数更新 | demo 按 Android 方式在私聊消息加载/接收后自动发送已读回执；群聊进入会话自动清未读，自己发出的群消息展示 `已读 x/y`，长按可看已读详情 | 私聊双方互发消息后发送端状态更新为已读；群聊成员进入会话后，发送端消息读数变化并可查看已读/未读成员 | 已实现 |
| IM-09 | P1 | 消息搜索 `searchMessages` | 已支持单会话和全局本地关键字搜索 | Android `searchMessage` | 基于本地 `search_content`/文本内容查询，支持消息类型、时间范围和会话维度过滤；当前按 Android 现状仅对齐本地搜索能力 | demo 补“会话内历史搜索”与“会话列表顶部全局搜索入口”，结果页按会话聚合展示 | 本地搜关键词返回匹配消息 | 已实现 |
| IM-10 | P1 | Mention 消息查询 | 已支持单会话 mention 消息查询 | Android `getMentionMessageList` | 调用 `qry_mention_msgs`，带会话已读游标查询 mention 消息；返回后落本地并合并本地状态 | demo 在“会话详情 -> 提及我的消息”增加入口，直接展示当前会话中提及我的消息列表 | 群聊内收到 @ 消息后，可在入口页分页查看 | 已实现 |
| IM-11 | P1 | 群资料 `getGroupInfo` | 已支持本地读取与远端补拉，新增异步查询接口 | Android `getGroupInfo` | `getGroupInfo(...)` 本地优先，未命中时异步补拉；新增 `queryGroupInfo(...)` 明确暴露远端查询并回写 DB | demo 会话详情页已补群头像、群名展示，群聊标题和全局搜索结果也会在缺本地缓存时远端补齐 | 群会话可拉到群名头像，资料页与会话标题可刷新显示 | 已实现 |
| IM-12 | P1 | 群成员 `getGroupMember` | 已支持本地单成员查询与远端分页补拉缓存 | Android `getGroupMember` | DAO 补 `getGroupMember(...)`；manager 新增 `getLocalGroupMember/getGroupMember/queryGroupMember`，`queryGroupMembers(...)` 支持分页拉全成员并回写缓存 | demo 群资料页补成员预览区，群聊 `@` 面板继续复用群成员缓存；可直接看到成员昵称/头像预览 | 给定 groupId/userId 返回成员资料，群资料页可展示成员预览 | 已实现 |
| IM-13 | P1 | 媒体消息基类 `MediaMessageContent` | 已抽象媒体消息公共字段并统一 UI 状态识别 | Android `MediaMessageContent` | 抽象 `localPath/url/uploadState/uploadProgress` 公共字段，图片/视频/文件/语音统一继承 | demo 消息气泡已能识别媒体状态字段，当前重点先落首发媒体消息最终展示，后续可继续补完整上传中/失败交互 | 图片/视频/文件/语音模型统一 | 已实现 |
| IM-14 | P1 | 上传接口 `IMessageUploadProvider` | 已支持可替换上传 provider 抽象 | Android `IMessageUploadProvider` | 定义 upload callback：progress/success/error/cancel，并在 `MessageManager` 上暴露 provider 设置入口 | demo 已注册 mock provider，媒体发送会走统一上传回调链路；当前 UI 先用于首发媒体消息闭环演示 | mock provider 可走通回调 | 已实现 |
| IM-15 | P1 | `sendMediaMessage` | 已支持通过 upload provider 发送媒体消息 | Android `sendMediaMessage` | 上传 -> 回填 url/封面/缩略图/元数据 -> 发送 -> 状态更新；无 provider 时返回失败 | demo 聊天页左下角 `+` 已补图片/文件/视频/语音首发入口，首发媒体消息可直接展示在消息列表 | 至少图片消息端到端发送成功 | 已实现 |
| IM-16 | P2 | 媒体消息下载 | 已支持基础下载与取消下载链路 | Android `downloadMediaMessage` | 下载接口和取消接口，先支持 url 下载到本地 | demo 会话页媒体消息补下载按钮、进度和取消交互 | 下载图片/文件成功 | 已实现 |
| IM-17 | P2 | 会话标签 tag | 已支持本地标签增删查、按 tag 过滤和未读统计 | Android conversation tag | add/remove tag，按 tag 未读统计 | Android demo 无现成入口，Harmony demo 不额外暴露；保留 SDK 能力供业务侧接入 | 标签增删和未读统计可用 | 已实现 |
| IM-18 | P2 | Reaction | 已支持 Android 同步指令与本地缓存闭环 | Android reaction | add/remove/get/cache reaction | demo 消息气泡补 reaction 面板和结果展示 | 消息 reaction 可增删查并同步服务端 | 已实现 |
| IM-19 | P2 | 收藏 Favorite | 已支持 Android 指令与分页查询 | Android favorite | add/remove/get favorite | demo 会话消息长按补收藏入口，设置页“我的收藏”支持查询与取消收藏 | 收藏消息可分页查询并取消收藏 | 已实现 |
| IM-20 | P2 | 消息置顶 Top Message | 已支持 Android 指令、查询与状态消息 | Android top message | set/get top message | demo 会话页补置顶消息展示区域和长按操作入口，支持取消置顶 | 会话内置顶消息可查、可置顶/取消并实时刷新 | 已实现 |
| IM-21 | P2 | 全局免打扰 / 时段免打扰 | 缺失 | Android global mute | set/get 全局免打扰和时段 | demo 设置页补免打扰开关和查询展示 | 设置后可查询 | 待开始 |
| IM-22 | P2 | 广播消息 | 缺失 | Android broadcast | 多会话批量发送与进度回调 | demo 补多会话选择和广播进度反馈 | 多个会话发送进度正确 | 待开始 |
| IM-23 | P3 | ChatroomManager | 协议预留，逻辑 TODO | Android ChatroomManager | join/quit/send/receive/attrs 最小闭环 | demo 补聊天室入口和最小收发页 | 加入聊天室收发消息 | 待开始 |
| IM-24 | P3 | PushManager | 已支持 Harmony PushKit token 获取、tokenUpdate 监听与 `reg_push_token` 上报 | Android PushManager | `IConnectionManager.registerPushToken(...)`、connect 携带 `pushToken/packageName/pushChannel`、Harmony PushKit 自动取 token 并在连接成功后补注册 | demo 新增“推送设置”页，展示 token/AAID/最近一次上报结果，并保留推送语言设置入口 | ArkTS 编译通过；token 注册请求可发出；打包阶段受本机 Java 运行时缺失影响未完成 | 已实现 |
| IM-25 | P3 | MomentManager | Harmony socialCircle 是静态 UI | Android MomentManager | 动态发布/列表/评论/点赞接口 | demo socialCircle 改成真实可操作列表与发布入口 | 动态列表可拉取 | 待开始 |

---

## RTC / Call 能力补齐清单

RTC 在 IM 基础能力补齐后开始。前期先做 SDK 架构和 mock media，不直接上复杂 UI。

| 序号 | 优先级 | 能力 / 接口 | 当前 Harmony 状态 | Android 对齐参考 | 计划实现内容 | Demo / UI 补充要求 | 验证方式 | 状态 |
|---:|---|---|---|---|---|---|---|---|
| RTC-00 | P0 | Call 公共目录与 facade | 缺失 | `getCallManager()` | 新增 `call/` 目录和 `getCallManager()` | demo 补 call 调试入口，能直接拿到 manager 并触发基础调用 | 编译通过，SDK 可获取 CallManager | 待开始 |
| RTC-01 | P0 | `CallConst` | 缺失 | Android `CallConst` | 定义媒体类型、状态、错误码、结束原因 | demo 通话页 / 调试页补状态和错误码展示 | 类型可被 UI/SDK 引用 | 待开始 |
| RTC-02 | P0 | `ICallManager` | 缺失 | Android `ICallManager` | startSingleCall/startMultiCall/joinCall/listener | demo 补单呼 / 群呼发起入口 | 方法可调用，mock 返回 session | 待开始 |
| RTC-03 | P0 | `ICallSession` | 缺失 | Android `ICallSession` | accept/hangup/media controls/getters/listeners | demo 补接听 / 挂断 / 静音等控制条 | session 状态可观察 | 待开始 |
| RTC-04 | P0 | Call 状态机 | 缺失 | Android `CallSessionImpl + fsm` | idle/outgoing/incoming/connecting/connected/finished | demo 补状态流转可视化或日志面板 | mock 信令状态流正确 | 待开始 |
| RTC-05 | P0 | Call 信令消息 | 只有 RTC 字段预留 | Android call signaling | 定义 invite/accept/hangup/join/quit 信令 | demo 补双端调试路径，能看见信令行为 | 双端收发信令可见 | 待开始 |
| RTC-06 | P1 | `ICallMediaEngine` | 缺失 | Android `ICallMediaEngine` | joinRoom/leaveRoom/camera/mic/speaker/view | demo 补媒体控制按钮和渲染占位区域 | mock engine 可验证调用顺序 | 待开始 |
| RTC-07 | P1 | MockCallMediaEngine | 缺失 | Android media abstraction | 无真实 RTC，先验证状态和接口 | demo 补 mock 通话完整流程页 | start/accept/hangup 全流程无媒体 | 待开始 |
| RTC-08 | P1 | 1v1 音频真实 RTC | 缺失 | Android Zego/Agora/LiveKit | 接入一个 Harmony RTC SDK | demo 补 1v1 音频通话页和音频状态展示 | 双端语音通话成功 | 待开始 |
| RTC-09 | P1 | 1v1 视频真实 RTC | 缺失 | Android video call | 预览、远端渲染、开关摄像头 | demo 补视频预览 / 远端画面 / 摄像头切换 UI | 双端视频通话成功 | 待开始 |
| RTC-10 | P2 | 多人通话 | 缺失 | Android multi call | 邀请多人、加入、退出、成员状态 | demo 补多人通话成员面板和状态 UI | 3 人通话基本流程 | 待开始 |
| RTC-11 | P2 | Call UI | 缺失 | Android `SingleCallActivity/Multi*` | Harmony 通话页/来电页/通话中页 | demo 直接消费完整通话页，而非只保留 SDK 调试接口 | 从联系人发起通话完整跑通 | 待开始 |
| RTC-12 | P2 | CallKit 抽离 | 缺失 | JetIMKit call UI | 通话 UI 组件化 | demo 改为消费组件化 CallKit，验证可复用性 | demo 消费组件，不依赖内部 | 待开始 |

---

## 本轮执行记录

| 序号 | 状态 | 修改前对照点 | 修改后实现点 | Demo / UI 补充 | 涉及文件 | 测试/验证 |
|---|---|---|---|---|---|---|
| IM-00 | 已实现 | `JuggleIm` 直接返回 concrete manager；`juggleim/Index.ets` 只导出 `JuggleIm` | 已补 `interfaces/` 公共类型目录、统一 `Index.ets` 导出，`get*Manager()` 返回接口类型，`home` 侧剩余 deep import 已清理 | 已同步清理 home 侧 deep import，确保 demo / 业务侧通过公共导出接 SDK | `juggleim/Index.ets`、`juggleim/src/main/ets/interfaces/*`、`juggleim/src/main/ets/juggleim.ets`、`jugglechat/home/src/main/ets/pages/ConversationList.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets` | 待验证 |
| IM-01 | 已实现 | Harmony `sendMessage` 只有基础消息体，协议里已有 `pushData / mentionInfo / referMsg` 但公共类型和透传缺失 | 已新增 `MessageOptions / MessageMentionInfo / PushData` 公共类型；`sendMessage` 支持兼容旧签名和带 options 的新签名；引用消息、mention、pushData 已透传到 websocket，上行前本地消息也会保留相关字段，生命周期先做本地字段预留 | demo 已补引用消息、群 `@` 消息和消息操作面板，便于直接验证 `MessageOptions` 是否生效 | `juggleim/src/main/ets/entries/messageoptions.ets`、`juggleim/src/main/ets/commons/messageoptionutil.ets`、`juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/entries/msghandler.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`juggleim/Index.ets` | 待验证 |
| IM-02 | 已实现 | 仅有 `QueryMsgOptions(count/startTime/isPositive)`，无法表达统一时间方向和按类型过滤 | 已新增 `GetMessageOptions` 与 `GetMessageDirection`；`QueryMsgOptions` 兼容保留；本地/远端查询统一走 `count/time/direction/contentTypes`，远端 `qry_hismsgs` 已透传 `msgTypes`，本地 DB 查询已支持 `msg_type in (...)` | demo 已改成“会话页右上角 -> 会话详情 -> 历史消息”；聊天页移除临时调试按钮，历史消息页补类型筛选、消息搜索和分页入口 | `juggleim/src/main/ets/interfaces/messagetypes.ets`、`juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets`、`jugglechat/home/src/main/ets/pages/ConversationProfile.ets`、`jugglechat/home/src/main/ets/pages/ConversationHistory.ets` | 待验证 |
| IM-09 | 已实现 | `searchMessages` 为空实现；历史消息页只有输入框，没有明确触发动作，也只对已加载数据做临时过滤；会话列表顶部搜索未接全局消息搜索 | 已补本地 `searchMessages` 查询，支持按关键字、消息类型、时间范围搜索；会话参数改为可选，不传时支持全局本地搜索；本地发送消息已写入 `searchContent`，旧数据可回退匹配 `msg_content` | demo 已补“会话内历史搜索”和“会话列表顶部全局搜索入口 -> 全局搜索结果页”；按 Android 当前实现仅对齐本地搜索能力 | `juggleim/src/main/ets/interfaces/messagetypes.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`jugglechat/home/src/main/ets/pages/ConversationHistory.ets`、`jugglechat/home/src/main/ets/pages/GlobalMessageSearch.ets`、`jugglechat/home/src/main/ets/views/common/HomeTopSearch.ets`、`jugglechat/home/src/main/ets/pages/ConversationList.ets` | 待验证 |
| IM-03 | 已实现 | 会话查询只有 `count/startTime/isPositive`，会话类型过滤能力缺失 | 已新增 `GetConversationOptions` 与 `GetConversationDirection`，`queryConversations(options, callback)` 支持 count/time/direction/conversationTypes；旧签名保留兼容，DAO 已支持按类型过滤和统一排序 | demo 主会话列表查询已切到新 options；对齐 Android，去掉临时增加的类型筛选和“拉取较新”按钮，不额外扩展入口 | `juggleim/src/main/ets/interfaces/conversationtypes.ets`、`juggleim/src/main/ets/interfaces/iconversationmanager.ets`、`juggleim/src/main/ets/managers/conversationmanager.ets`、`juggleim/src/main/ets/dbs/conversationdao.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/pages/ConversationList.ets` | 待验证 |
| IM-04 | 已实现 | 草稿接口为空实现；会话列表与消息页都无法体现草稿状态 | 已补本地 `setDraft / clearDraft`，支持已有会话草稿更新，也支持无消息会话创建本地占位草稿并在清空时自动移除；`upsert` 已保留草稿字段避免同步覆盖 | demo 会话页在离开时保存草稿、进入时恢复；会话列表预览草稿内容并高亮 `[草稿]`，发送成功或清空输入后同步清除 | `juggleim/src/main/ets/dbs/conversationdao.ets`、`juggleim/src/main/ets/managers/conversationmanager.ets`、`juggleim/src/main/ets/managers/msgsyncmanager.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets`、`jugglechat/home/src/main/ets/viewmodel/ConversationViewModel.ets`、`jugglechat/home/src/main/ets/views/Conversation/ConversationItem.ets` | 待验证 |
| IM-05 | 已实现 | `setLocalAttribue` 空实现且拼写错误，消息模型和 DB 都没有本地属性字段 | 已新增消息 `localAttribute` 字段、DB `local_attribute` 列和迁移脚本；DAO 支持按消息 ID 更新/读取；公共接口新增正确拼写 `setLocalAttribute/getLocalAttribute`，旧错拼接口保留兼容 | Android demo 无现成入口，Harmony demo 不再额外暴露；保留 SDK 能力供正式业务或后续页面接入 | `juggleim/src/main/ets/entries/message.ets`、`juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`juggleim/src/main/resources/rawfile/sqllist.txt`、`juggleim/src/main/resources/rawfile/202605201430.sql` | 待验证 |
| IM-06 | 已实现 | `getMessagesByIds(...)` 空实现，DAO 也没有按一组消息 ID 查询能力 | 已补本地 `messageId/clientId` 查询，新增 Android 对齐接口 `getMessagesByMessageIds(...)`，旧 `getMessagesByIds(...)` 保留兼容；本地缺失时按会话走 `qry_hismsg_by_ids` 远端补查，并按请求 ID 顺序返回结果 | Android demo 无独立查询页，Harmony demo 已移除额外调试入口，仅保留 SDK 能力 | `juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/dbs/messagedao.ets` | 待验证 |
| IM-07 | 已实现 | 只有被动 `ModifyMsg` 命令处理，主动 `modifyMessage(...)` 为空实现 | 已补 Android 对齐 `updateMessage(...)`，旧 `modifyMessage(...)` 保留兼容；主动编辑成功后更新本地消息内容、modified 标记和会话最后一条摘要，并触发消息修改监听 | demo 已补“长按自己发送的文本消息 -> 编辑”，输入框进入编辑态，保存后当前消息刷新并展示“已编辑” | `juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/managers/msgsyncmanager.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`juggleim/src/main/ets/entries/message.ets`、`juggleim/src/main/ets/entries/msghandler.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets`、`jugglechat/home/src/main/ets/viewmodel/MessageViewModel.ets`、`jugglechat/home/src/main/ets/views/Conversation/ConversationDetailItem.ets`、`jugglechat/home/src/main/ets/views/MessageBubble.ets` | 待验证 |
| IM-08 | 已实现 | `sendReadReceipt(...)` 为空实现，`ReadNtfMessage` 只有建模没有消费链路；群聊未补 Android 的已读统计路径 | 已补私聊 `mark_read` 上行和 `jg:readntf` 消费；同时补群聊 `jg:grpreadntf`、`getGroupMessageReadInfoDetail(...)`、本地 `readCount/memberCount` 更新，以及消息方向字段修正，保证读回执触发条件正确 | demo 已按 Android 方式在私聊加载历史消息和收到新消息后自动发送已读回执；群聊进入会话自动清未读，自己发送的群消息底部展示 `已读 x/y`，长按消息可查看已读详情面板 | `juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/managers/msgsyncmanager.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`juggleim/src/main/ets/entries/msghandler.ets`、`juggleim/src/main/ets/entries/cmdmsg.ets`、`juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/interfaces/messagetypes.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets`、`jugglechat/home/src/main/ets/viewmodel/MessageViewModel.ets`、`jugglechat/home/src/main/ets/views/Conversation/ConversationDetailItem.ets`、`jugglechat/home/src/main/ets/views/MessageBubble.ets` | 待验证 |
| IM-10 | 已实现 | `queryMentionMessages(...)` 空实现，demo 无 mention 消息查看入口 | 已补 `qry_mention_msgs` 远端查询，带 `latestReadIndex` 请求 mention 消息；返回消息写入本地并合并本地状态，保持和普通历史消息一致 | demo 已补“会话详情 -> 提及我的消息”入口，当前会话可直接查看提及我的消息列表并下拉继续加载 | `juggleim/src/main/ets/managers/messagemanager.ets`、`jugglechat/home/src/main/ets/pages/MentionMessages.ets`、`jugglechat/home/src/main/ets/pages/ConversationProfile.ets`、`jugglechat/home/src/main/ets/pages/Index.ets`、`jugglechat/home/src/main/ets/viewmodel/ConversationViewModel.ets` | 待验证 |
| IM-11 | 已实现 | `getGroupInfo(groupId)` 公开方法直接返回 `null`，私有 `qryGroupInfo(...)` 未暴露给上层 | 已补 `queryGroupInfo(...)` 异步接口，对外支持远端查询并自动落本地；同步 `getGroupInfo(...)` 改为本地优先，未命中时后台补拉；公共导出已补 `GroupInfoCallback` | demo 已补群资料页头像/群名区，群聊标题和全局搜索结果在本地缺缓存时也会触发远端补齐 | `juggleim/src/main/ets/interfaces/igroupinfomanager.ets`、`juggleim/src/main/ets/managers/groupinfomanager.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets`、`jugglechat/home/src/main/ets/pages/ConversationProfile.ets`、`jugglechat/home/src/main/ets/pages/GlobalMessageSearch.ets`、`jugglechat/home/src/main/ets/viewmodel/ConversationViewModel.ets` | 待验证 |
| IM-12 | 已实现 | `GroupMemberDao` 只有列表转换能力，没有单成员查询；manager 只有 `queryGroupMembers(...)` 且只拉第一页 | 已补 DAO `getGroupMember(...)`，manager 新增 `getLocalGroupMember/getGroupMember/queryGroupMember`；`queryGroupMembers(...)` 改为按 offset 分页拉全量成员并写回缓存；公共导出已补 `GroupMemberCallback` | demo 群资料页已补成员预览区，直接展示成员昵称/头像；群聊 `@` 面板继续复用同一份群成员缓存 | `juggleim/src/main/ets/dbs/groupmemberdao.ets`、`juggleim/src/main/ets/interfaces/igroupinfomanager.ets`、`juggleim/src/main/ets/managers/groupinfomanager.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/pages/ConversationProfile.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets` | 待验证 |
| IM-13 | 已实现 | 图片/文件/视频/语音消息各自直接继承 `MessageContent`，公共媒体字段分散；demo 气泡状态只识别普通发送态 | 已新增 `MediaMessageContent` 与 `MediaMessageUploadState`，统一 `localPath/url/extra/uploadState/uploadProgress`；`ImageMessage/FileMessage/VideoMessage/VoiceMessage` 全部改为继承媒体基类，序列化和反序列化兼容旧数据；`cloneMessageContent(...)` 已统一复制媒体公共字段 | demo 气泡层已能识别媒体状态字段，并为后续更完整的上传态展示预留统一承载 | `juggleim/src/main/ets/entries/message.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/viewmodel/MessageViewModel.ets`、`jugglechat/home/src/main/ets/views/MessageBubble.ets` | 待验证 |
| IM-14 | 已实现 | Harmony 没有 `IMessageUploadProvider` 抽象，也没有统一上传回调链路 | 已新增 `IMessageUploadProvider`、`MediaUploadResult` 和 progress/success/error/cancel 回调类型；`MessageManager` 已补 `setMessageUploadProvider/getMessageUploadProvider` | demo 初始化时已注册 `MockMessageUploadProvider`，用于演示媒体消息首发链路 | `juggleim/src/main/ets/interfaces/imessageuploadprovider.ets`、`juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/jim/mockmessageuploadprovider.ets`、`jugglechat/home/src/main/ets/jim/jimsdk.ets` | 待验证 |
| IM-15 | 已实现 | `sendMediaMessage(...)` 为空实现，demo 左下角 `+` 只是图标没有任何媒体首发入口 | 已补 `sendMediaMessage(...)`：媒体消息无 url 时先走 upload provider，上传成功后回填 url/封面/缩略图/元数据，再复用现有 `sendMessage(...)` 发送；provider 缺失或上传失败时返回错误 | demo 聊天页左下角 `+` 已补图片/文件/视频/语音首发入口；首发媒体消息发送成功后会直接进入当前消息列表，沿用现有媒体气泡展示 | `juggleim/src/main/ets/managers/messagemanager.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets`、`jugglechat/home/src/main/ets/jim/mockmessageuploadprovider.ets` | 待验证 |
| IM-16 | 已实现 | Harmony 缺少媒体消息下载接口，demo 也没有下载入口和状态反馈 | 已补 `downloadMediaMessage(...) / cancelDownloadMediaMessage(...)`，使用系统下载任务将媒体文件保存到本地缓存目录；下载成功后回写消息 `localPath` 并通知消息刷新 | demo 会话页媒体消息补下载按钮、下载进度和取消交互；图片下载后优先展示本地文件 | `juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/interfaces/messagetypes.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets`、`jugglechat/home/src/main/ets/viewmodel/MessageViewModel.ets`、`jugglechat/home/src/main/ets/views/Conversation/ConversationDetailItem.ets`、`jugglechat/home/src/main/ets/views/MessageBubble.ets`、`jugglechat/home/src/main/ets/views/MsgBubbles/ImageMsgBubble.ets` | 待验证 |
| IM-17 | 已实现 | `conversation_tags` 表已存在，但 DAO 只有 insert；公开接口没有 tag 增删查、按 tag 查询或按 tag 未读统计 | 已补 `addConversationTag/removeConversationTag/getConversationTags/getTotalUnreadCountByTag`；`GetConversationOptions` 新增 `tagId` 过滤；会话同步和单会话查询返回的 `converTags` 会落本地表，删除会话时会一并清理 tag | Android demo 无现成 tag UI，Harmony demo 已移除额外打标入口，仅保留 SDK 能力 | `juggleim/src/main/ets/interfaces/conversationtypes.ets`、`juggleim/src/main/ets/interfaces/iconversationmanager.ets`、`juggleim/src/main/ets/managers/conversationmanager.ets`、`juggleim/src/main/ets/managers/msgsyncmanager.ets`、`juggleim/src/main/ets/dbs/convertagdao.ets`、`juggleim/src/main/ets/dbs/conversationdao.ets`、`juggleim/src/main/ets/entries/conversation.ets`、`juggleim/Index.ets` | 待验证 |
| IM-18 | 已实现 | Harmony 之前没有 reaction 公共类型、接口、DB 落库和消息 UI 展示 | 已补 `MessageReaction/MessageReactionResult` 公共类型、`addMessageReaction/removeMessageReaction/getMessagesReaction` 接口；对齐 Android `msg_exset/del_msg_exset/qry_msg_exset` 指令与 `jg:msgexset` 下行状态消息；消息表 `reactions` 字段已接入序列化，reaction 变更后复用 `notifyMessageModified(...)` 刷新当前消息和会话摘要 | demo 聊天页长按消息已补 reaction 按钮行，消息气泡会展示 reaction 聚合结果；历史消息加载后也会批量补拉 reaction | `juggleim/src/main/ets/entries/message.ets`、`juggleim/src/main/ets/entries/cmdmsg.ets`、`juggleim/src/main/ets/entries/msghandler.ets`、`juggleim/src/main/ets/interfaces/messagetypes.ets`、`juggleim/src/main/ets/interfaces/imessagemanager.ets`、`juggleim/src/main/ets/managers/messagemanager.ets`、`juggleim/src/main/ets/managers/msgsyncmanager.ets`、`juggleim/src/main/ets/dbs/messagedao.ets`、`juggleim/Index.ets`、`jugglechat/home/src/main/ets/viewmodel/MessageViewModel.ets`、`jugglechat/home/src/main/ets/views/MessageBubble.ets`、`jugglechat/home/src/main/ets/views/Conversation/ConversationDetailItem.ets`、`jugglechat/home/src/main/ets/pages/ConversationDetail.ets` | 已验证 |
