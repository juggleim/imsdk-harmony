# IM 对齐补齐任务表

更新时间：2026-05-25  
依据：

- Harmony：`/Users/helena/Work/code/imsdk-harmony`
- Android：`/Users/helena/Work/code/im-android-sdk`

## 1. 对齐原则

本任务表按下面标准执行，不再接受“能跑主流程但实现层次不同”的状态：

1. **功能必须一致**
   - Android 有的 IM 能力，Harmony 必须具备。
   - 不能只补 UI，不补 SDK 能力。
2. **逻辑必须等价**
   - 允许语言差异、框架差异、实现方式差异。
   - 不允许出现远端/本地链路、状态机、回写时机、排序逻辑、回显逻辑不一致。
3. **本地存储必须补齐**
   - Android 已持久化的关键域，Harmony 不能只放内存。
   - 包括 sync、moment、reaction、friend、tag 元数据、消息状态相关能力。
4. **demo 必须真实走通**
   - 页面存在不算完成。
   - 必须能触发 SDK，且回显、状态、列表排序、重进页面后的结果一致。
5. **本次不补 Call**
   - `call` 相关能力本轮不进入补齐范围。
   - SDK 和 demo 任务都先排除音视频通话相关项。
6. **demo 只要求产品交互和 UI 样式对齐**
   - 不要求按照 Android `demo + JetIMKit` 的工程拆分方式实现。
   - Harmony 可以维持单 demo 工程结构，只要求用户可见功能、交互路径、页面表现对齐。

## 2. 执行顺序

建议严格按下面顺序推进：

1. SDK 数据模型与存储补齐
2. SDK public interface 补齐
3. SDK 内部逻辑补齐
4. demo 功能链路补齐
5. demo 产品交互与 UI 样式对齐
6. 联调验证与回归

原因很直接：demo 层的大部分问题，本质都来自 SDK 能力和本地状态域没有完全对齐。

## 3. SDK 对齐任务表

| 编号 | 模块 | 当前差异 | 对齐目标 | 关键文件 | 验收标准 | 优先级 |
|---|---|---|---|---|---|---|
| SDK-01 | 会话/消息数据模型 | Harmony `Conversation` 无 `subchannel`，消息/会话/tag 主键维度少于 Android | 补齐 `subchannel` 维度，保证会话、消息、tag、搜索、未读统计逻辑等价 | `entries/conversation.ets`、`entries/message.ets`、`dbs/*`、`managers/*` | 同一 `conversationId` 不同 `subchannel` 能独立存储、查询、排序、统计 | P0 |
| SDK-02 | 本地存储 - profile/sync | Android `profile` 与 Harmony `confs` 当前都承担 KV 式 sync checkpoint 存储，现阶段未发现明确功能缺口 | 先做等价性核验，不单独重构表名/抽象；仅当发现 sync 语义、恢复时机、扩展字段支持不一致时再升级为改造任务 | `dbs/confdao.ets`、`msgsyncmanager.ets`、Android `ProfileSql/DBManager` | 现阶段验收标准是：会话/收件箱/发件箱 sync checkpoint 行为与 Android 一致；若一致，则本项关闭不改 | P2 |
| SDK-03 | 本地存储 - friend | Harmony 无 friend 表、无 friend SDK 能力 | 新增 friend 持久化与查询能力，对齐 Android `friend` 域 | 新增 SQL、DAO、`userinfomanager.ets` | 好友信息能缓存、查询、远端刷新、demo 资料页可正确回显好友关系 | P0 |
| SDK-04 | 本地存储 - reaction | Harmony 将 reaction 内嵌在 `messages.reactions`，缺少 Android 独立 reaction cache | 补齐独立 reaction 持久化模型或实现出与 Android 等价的缓存读取/回写逻辑 | SQL、DAO、`messagemanager.ets`、`msgsyncmanager.ets` | reaction 查询、同步、重启回显、增删更新行为与 Android 一致 | P0 |
| SDK-05 | 本地存储 - moment | Harmony `MomentManager` 只有内存缓存，无 SQLite 持久化 | 新增 moment 表与 DAO，对齐 Android `MomentSql/DBManager` 行为 | 新增 SQL、DAO、`momentmanager.ets` | 朋友圈列表/详情/评论/点赞重启后可回显，本地缓存命中逻辑与 Android 一致 | P0 |
| SDK-06 | 本地存储 - conversation tag 元数据 | Harmony 只有 `conversation_tags` 关系表，无 `conversation_tag_info` | 补齐 tag info 持久化与同步处理 | SQL、DAO、`conversationmanager.ets`、`msgsyncmanager.ets` | tag 创建/改名/删除/查询/会话绑定关系可持久化并回显 | P0 |
| SDK-07 | 消息字段域 | Harmony `messages` 缺 `clientMsgNo/life_time/life_time_after_read/destroy_time/read_time/subchannel` 等 | 补齐关键字段与 DAO 查询能力 | SQL、`messagedao.ets`、`entries/message.ets` | 可支持 resend、消息状态回写、销毁/已读时间等 Android 等价逻辑 | P0 |
| SDK-08 | 连接接口 | Harmony `IConnectionManager` 缺 `disconnect(receivePush)`、语言、连接参数、连接状态、DB 生命周期监听 | 补齐 public interface 和实现链路 | `interfaces/iconnectionmanager.ets`、`managers/connectionmanager.ets` | API 对齐 Android，推送语言/receivePush/headers/状态回调可用 | P0 |
| SDK-09 | 会话接口 - tag/full query | Harmony 缺完整 tag API、`getUnreadCountWithTypes`、`setTopConversationsOrderType`、sync/tag listener | 补齐 `IConversationManager` 到 Android 等价能力 | `interfaces/iconversationmanager.ets`、`managers/conversationmanager.ets` | tag 全链路、类型未读统计、top 排序策略、listener 全部可用 | P0 |
| SDK-10 | 消息接口 - resend/state | Harmony 缺 `resendMessage/resendMediaMessage/saveMessage/getMessagesByClientMsgNos/setMessageState` 等 | 补齐发送失败恢复和状态控制能力 | `interfaces/imessagemanager.ets`、`managers/messagemanager.ets`、`dbs/messagedao.ets` | 文本/媒体失败后可重发，状态迁移与 Android 一致，DB 正确回写 | P0 |
| SDK-11 | 消息接口 - query/search | Harmony 缺 `getFirstUnreadMessage/searchConversationsWithMessageContent/getLocalAndRemoteMessages/getMergedMessageList/getMessageReadTime` | 补齐高级查询与搜索能力 | `messagemanager.ets`、DAO、proto/network 层 | 查询结果、分页、时间锚点、远端回包处理与 Android 等价 | P1 |
| SDK-12 | 消息接口 - local attribute | Harmony 只有按 `msgId` 存取，本质弱于 Android 按 `clientMsgNo` 管理 | 补齐按 `clientMsgNo` 的本地属性能力 | `messagemanager.ets`、`messagedao.ets` | 本地消息 ID 未换远端 ID 前后都能稳定读写属性 | P1 |
| SDK-13 | 消息接口 - uploadImage | Harmony 无 Android 公共 `uploadImage(path)` 能力 | 增加等价 public API，并接入现有上传体系 | `interfaces/imessagemanager.ets`、`messagemanager.ets` | demo 资料编辑、图片上传等可直接调用 SDK 能力 | P1 |
| SDK-14 | User/Group/Friend facade | Harmony 拆成 `UserInfoManager + GroupInfoManager`，当前已补 batch / friend / group member 入口，但仍需继续对拍 Android 的统一门面行为 | 继续核对 public facade 的覆盖面与远端刷新语义，必要时再收敛统一入口 | `interfaces/*userinfo*.ets`、`managers/*` | API 能覆盖 Android 所有 user/group/friend 查询场景 | P1 |
| SDK-15 | 连接实现逻辑 | Harmony 连接实现较轻，缺 Android 状态机级别的状态收敛 | 对齐关键逻辑：状态流转、断线恢复、DB open/close 通知、参数注入时机 | `connectionmanager.ets`、`imclients/imclient.ets` | 日志链路与行为结果与 Android 一致 | P1 |
| SDK-16 | 会话排序/未读/置顶逻辑 | 现已修过一部分，但需要从 SDK 层彻底对齐 Android | 统一会话排序、topTime、未读标签、mute/top 回显与回写逻辑 | `conversationmanager.ets`、`msgsyncmanager.ets`、DAO | 列表排序、详情回显、重启后状态、同步后状态全部一致 | P1 |
| SDK-17 | reaction/favorite/top/mute 同步链路 | 有功能，但需核实本地/远端/回调/回显时机是否完全等价 | 按 Android 链路逐项收敛 | `messagemanager.ets`、`msgsyncmanager.ets`、DAO | 本地先行、远端成功、DB 回写、listener 派发顺序与 Android 对齐 | P1 |
| SDK-18 | 消息 sync/listener 体系 | Harmony 缺 Android 的 sync listener、destroy listener、preprocessor、stream listener | 视 Android 对外面向补齐 listener 体系 | `interfaces/imessagemanager.ets`、`messagemanager.ets` | 对外监听能力覆盖 Android | P2 |
## 4. Demo 对齐任务表

| 编号 | 模块 | 当前差异 | 对齐目标 | 关键文件 | 验收标准 | 优先级 |
|---|---|---|---|---|---|---|
| DEMO-01 | 会话列表 | 目前已补 top/mute 等，但仍需按 Android 逐项核实 UI 标识、选中态、返回态 | 对齐置顶背景色、静音图标、排序、选中态恢复 | `pages/ConversationList.ets`、`views/ConversationItem.ets` | UI 与状态回显稳定，与 Android 表现一致 | P0 |
| DEMO-02 | 会话详情 | 聊天功能不少，但 resend、失败态、reaction 更完整交互、资料联动不够 | 对齐 Android 聊天页主交互 | `pages/ConversationDetail.ets`、bubble views | 消息发送失败可重发，reaction/favorite/read detail 流程完整 | P0 |
| DEMO-03 | 会话资料页 | 现有页已支持部分置顶/免打扰，但要建立在 SDK 真实状态等价上 | 对齐 Android 会话设置的回显和操作链路 | `pages/ConversationProfile.ets` | 重进页面后置顶/免打扰/其他状态与真实 SDK 数据一致 | P0 |
| DEMO-04 | 个人资料设置 | Harmony 无 Android `ProfileSettingActivity` 等价页 | 新增头像/昵称编辑页，并接入 SDK 上传能力 | 新页面、`MeDetail.ets`、server 接口接入 | 头像上传、昵称修改、重进回显完整 | P0 |
| DEMO-05 | 用户资料页 | `ContactsDetail.ets` 仍偏静态展示 | 对齐 Android `UserDetailFragment` 的产品交互：发消息、加好友、好友态判断；`call` 入口本轮不补 | `pages/ContactsDetail.ets` | 资料页根据好友态展示不同按钮，发消息/加好友动作能走通 | P0 |
| DEMO-06 | 好友系统 | Android 有好友列表/申请/加好友链路，Harmony 不完整 | 补齐好友相关页面与 SDK 接口使用 | `pages/ContactsList.ets`、新增页面、server manager | 好友列表、好友申请、加好友、资料页状态形成闭环 | P0 |
| DEMO-07 | 推送语言设置 | Harmony 当前是 push 调试页，不是 Android 的语言设置 | 新增或改造出对等的推送语言设置页 | `views/MySettings/PushSetting.ets`、新增语言页 | 语言设置读写真实走 SDK，页面回显正确 | P1 |
| DEMO-08 | 扫码/二维码 | Android 有 `ScanActivity`、`QRCodeDisplayActivity`，Harmony 无对等页 | 补齐二维码展示与扫码入口 | 新页面、入口页 | 可展示本人二维码，可扫码进入对应流程 | P1 |
| DEMO-09 | 建群/选成员/群管理 | Android demo 覆盖较完整，Harmony 缺失 | 补齐建群、选成员、群管理、群公告、群昵称等入口与页面 | 新页面、联系人/群页面 | 群操作流程能闭环，至少覆盖 Android demo 当前页面集 | P1 |
| DEMO-10 | 主入口结构与样式 | Android 主 tab 与页面编排更完整，Harmony 入口结构不同 | 不要求复制 JetIMKit 工程拆分，但要求主入口的产品交互、tab 组织、页面风格与 Android demo 产品表现对齐 | `pages/Index.ets`、相关入口页 | 用户从主入口触达核心产品能力的路径与 Android demo 保持一致 | P1 |
| DEMO-11 | 聊天室页 | 当前已基本可用，但需校准 UI 与进入房间后的真实链路 | 对齐聊天室进入、历史、属性变化回显 | `ChatroomList.ets`、`ChatroomRoom.ets` | 聊天室功能与 Android demo 行为一致 | P1 |
| DEMO-12 | 朋友圈页 | Harmony 已有页面，但底层 moment 持久化未对齐 | 在 SDK `moment` 持久化补齐后，校准列表首屏缓存、重进回显、评论点赞时序 | `socialCircle/Index.ets` | 首屏缓存、刷新、删除、评论、点赞、重启后表现与 Android 等价 | P1 |

## 5. 联调与验证任务表

| 编号 | 验证项 | 目标 | 依赖 | 验收标准 | 优先级 |
|---|---|---|---|---|---|
| QA-01 | SDK public API 对照检查 | 逐项对照 Android interface，确认 Harmony public 面无缺口 | SDK-08~SDK-14 | 生成最终 API 对齐清单，无缺项 | P0 |
| QA-02 | 本地存储对照检查 | 逐表、逐字段对照 Android 本地存储能力 | SDK-01~SDK-07 | 关键域全部可持久化，重启后行为一致 | P0 |
| QA-03 | 本地/远端链路日志回放 | 为 top/mute/reaction/favorite/moment 等能力打完整日志 | SDK-16~SDK-17 | 可用日志还原调用、回包、DB、listener 全链路 | P0 |
| QA-04 | demo 回归用例 | 逐页执行核心流程 | DEMO 全部 | 每个页面至少有一条主流程和一条状态回显用例 | P0 |
| QA-05 | Android 行为对拍 | 同一账号、同一数据集、同一操作路径对拍 Android 与 Harmony | 所有任务 | 列表、详情、回显、重启后状态一致 | P0 |

## 6. 建议分批次执行

### 第一批：先把 SDK 结构性缺口补平

- SDK-01 ~ SDK-10
- QA-01 ~ QA-03

这是最关键的一批。  
如果这批没做完，demo 再改也会反复返工。

### 第二批：补高级查询和外围 SDK 能力

- SDK-11 ~ SDK-17

### 第三批：补 demo 产品链路

- DEMO-01 ~ DEMO-12

### 第四批：收尾与对拍

- QA-04
- QA-05

## 7. 当前建议的实际开工顺序

如果按“最少返工”的顺序，我建议从这里开始：

1. `SDK-01`：`subchannel` 数据模型和 DB 维度补齐
2. `SDK-03` ~ `SDK-07`：friend/reaction/moment/tag info/消息字段持久化补齐
3. `SDK-08` ~ `SDK-10`：connection/conversation/message public API 补齐
4. `SDK-16` ~ `SDK-17`：置顶/免打扰/reaction/favorite 等现有能力按 Android 逻辑校准
5. `DEMO-04` ~ `DEMO-06`：资料页、好友链路补齐
6. `DEMO-07` ~ `DEMO-10`：推送语言、扫码、群管理、主入口交互/UI 对齐

## 8. 完成标准

只有满足下面条件，才能认为“IM 已对齐 Android”：

1. Android public API 在 Harmony 可找到等价能力。
2. Android 关键本地持久化域在 Harmony 全部落库。
3. 同一能力的远端调用、本地回写、listener 派发、页面回显逻辑一致。
4. demo 对应页面和操作路径存在且可走通。
5. 重启应用后，列表状态、详情状态、缓存状态仍与 Android 一致。

## 9. 备注

这份表是执行表，不是现状描述表。  
后续建议按这个文档逐项推进，每完成一个任务，就补：

- 代码文件
- 自测日志
- 对拍结果
- 剩余风险

## 10. 当前推进状态（2026-05-25）

说明：

- `待开始`：当前代码里还没有形成可用实现。
- `进行中`：已有部分实现，但还没达到本任务定义的完整目标。
- `已实现（待验证）`：代码已基本落地，但还缺编译 / 对拍 / 回归验证。
- `待核验`：当前判断为“可能无需改造或改动较少”，需要专门对照 Android 再决定是否关闭。

ArkTS 兼容约束已单独记录在 [docs/arkts-compat-notes.md](/Users/helena/Work/code/imsdk-harmony/docs/arkts-compat-notes.md:1)，后续同类修改默认先按这份清单规避。

### SDK 状态总览

| 编号 | 当前状态 | 现状判断 | 下一步 |
|---|---|---|---|
| SDK-01 | 进行中 | `subchannel` 已进入 `Conversation/Message`、DB、SQL 迁移、DAO、proto、manager 主链路；当前主要卡在 Harmony 编译收口与整链路验证 | 重新编译；补齐剩余 ArkTS 错误；做多 `subchannel` 会话的增删改查和未读隔离验证 |
| SDK-02 | 待核验 | 现有 `conf/profile` sync checkpoint 逻辑暂未发现明确缺口，但还没做 Android 对照验证 | 专门对照 Android 的 checkpoint 写入、恢复、连接后同步时机 |
| SDK-03 | 进行中 | 已有 `frienddao.ets` 和 DB 接入，但 friend SDK facade、远端刷新和 demo 好友态闭环还没完成 | 补 `getFriendInfo/fetchFriendInfo/checkFriend` 一类接口，接入 `UserInfoManager` 和 demo 资料页 |
| SDK-04 | 已实现（待验证） | 独立 `reactiondao.ets`、消息 reaction 接口、同步与本地回写链路已落地 | 做重启回显、远端同步顺序、失败重试和 Android 对拍 |
| SDK-05 | 已实现（待验证） | `momentdao.ets` 与 `momentmanager.ets` 已形成持久化读写闭环 | 验证列表缓存命中、详情回显、评论点赞后重启恢复 |
| SDK-06 | 已实现（待验证） | `conversation_tag_infos` DAO、tag 元数据缓存、查询和同步写回已落地 | 验证 tag 创建/改名/删除/会话绑定关系的回显与重启恢复 |
| SDK-07 | 进行中 | `subchannel/lifeTime/lifeTimeAfterRead/destroyTime/readTime` 已进入消息模型、DAO、proto 和部分 sync 逻辑；`clientMsgNo` 字段、SQL、DAO 查询、状态回写和 resend 入口已补，但还缺编译与升级验证 | 重新编译验证 `clientMsgNo` 改造；检查 resend 后发送成功、失败、会话回显三条状态流转 |
| SDK-08 | 进行中 | 已有 `connect/disconnect/registerPushToken/status listener`，Push token 注册链路也已补；但 `disconnect(receivePush)`、语言、headers、DB 生命周期监听仍缺 | 收口连接 public API，对齐 Android 的参数面和状态通知 |
| SDK-09 | 进行中 | tag API、tag 元数据、会话 listener、按 tag 未读统计已补；但 `getUnreadCountWithTypes`、`setTopConversationsOrderType` 等还缺 | 继续补会话 public API 缺口，并核对排序/回显行为 |
| SDK-10 | 已实现（待验证） | 已补媒体发送、编辑消息、按 ID 查消息、已读回执、reaction/favorite/top，本轮补齐了 `saveMessage/getMessagesByClientMsgNos/setMessageState/resendMessage/resendMediaMessage` | 重新编译并重点验证文本/媒体失败后重发、上传后重发、状态回写、listener 时序 |
| SDK-11 | 进行中 | 已有本地搜索、mention 查询、部分历史消息查询；但 `getFirstUnreadMessage/searchConversationsWithMessageContent/getLocalAndRemoteMessages/getMergedMessageList/getMessageReadTime` 未补齐 | 按接口缺口逐个补，优先 `getFirstUnreadMessage` 和 `getLocalAndRemoteMessages` |
| SDK-12 | 进行中 | 已为消息表、SQL migration、DAO 和 manager 补 `clientMsgNo` 存储与查询 / 状态更新入口；但按 `clientMsgNo` 的本地属性接口和兼容迁移还没做完 | 补 `clientMsgNo` 维度的本地属性读写接口，并验证旧库升级后的兼容性 |
| SDK-13 | 进行中 | 已有上传 provider 和 `sendMediaMessage`，但 Android 对外 `uploadImage(path)` 公共 API 还没单独补出 | 增加 `uploadImage(path)` 并复用现有上传 provider 返回值 |
| SDK-14 | 进行中 | 已补 batch user/group/friend 查询、group/member 统一入口，以及 user/friend 的远端查询回调入口，但仍需继续对拍 Android 的统一门面语义 | 继续核对 public facade 覆盖面与远端刷新语义，必要时再收敛统一入口 |
| SDK-15 | 待开始 | 当前连接实现仍偏轻量，尚未形成 Android 那种状态机级收敛逻辑 | 在 SDK-08 完成后再做状态机、断线恢复、DB open/close 通知收口 |
| SDK-16 | 进行中 | 置顶、免打扰、清未读、tag 关系和部分本地回写已补；但排序、topTime、重启后状态与 Android 还没完整对拍 | 做会话列表排序、置顶/免打扰回显、同步后状态回归 |
| SDK-17 | 进行中 | reaction/favorite/top/mute 功能链已具备，但本地先行、远端成功、DB 回写、listener 时序还没系统对拍 | 以日志方式跑完整链路，对照 Android 的事件顺序收口 |
| SDK-18 | 进行中 | 当前已有多类消息 listener 和 destroy time listener；但 sync listener、preprocessor、stream listener 仍不完整 | 先梳理 Android 对外监听面，再补缺的 listener 类型 |

### 当前编译收口状态（针对 2026-05-25 这轮 ArkTS 报错）

| 状态 | 项目 | 当前判断 |
|---|---|---|
| 已处理 | `conversationmanager.ets` 中 `subChannel` 相关 proto 构造 | 已改成 `create({}) + 字段赋值`，并补了 `UndisturbConverItem` / 相关请求类型的 `subChannel` 声明 |
| 已处理 | `messagemanager.ets` 中多处 proto 请求对象字面量 | 已把 `MsgExtItem`、`FavoriteMsgIds`、`SimpleMsg`、`KvItem` 等高风险点改为显式实例化 |
| 已处理 | `messageoptionutil.ets` / `message.ets` / `cmdmsg.ets` 中 ArkTS 对对象字面量敏感的点 | `MsgFlag` 已改成显式 class；命令消息和普通消息的 flag 构造已切到 helper；部分 proto `create({...})` 已收口 |
| 已处理 | `jimutil.ets` 的 Map JSON 序列化 | 已从对象索引签名改成键值对数组序列化，避开 `index signature` / `for...in` / 按索引访问字段限制 |
| 已处理 | `clientMsgNo` 基础能力 | 已补 `Message.clientMsgNo`、messages 表字段与 migration、DAO 查询/状态更新，以及 `saveMessage/getMessagesByClientMsgNos/setMessageState/resend*` 入口 |
| 待重新编译确认 | 用户给出的 35 个报错列表 | 其中一部分行号已和当前源码不再对应，说明旧报错里已有一部分被吃掉；需要新一轮编译结果确认剩余真实阻塞 |
| 仍未完成 | `SDK-10` 验证收口 | resend / save / state 接口已落代码，但现有 `clientMsgNo` 链路还缺编译、旧库升级和时序验证 |

### 当前建议的下一步

1. 先完成 `SDK-01 + SDK-07` 的编译闭环
   也就是先把当前 ArkTS 编译重新跑通，确认 `subchannel`、`MsgFlag` 和 proto 请求构造改造不再引入新错误。
2. 紧接着做 `QA-02 + QA-03`
   这两项最能判断现在这批底层改动到底稳不稳，尤其是：
   - 多 `subchannel` 会话隔离
   - reaction / favorite / top / mute 本地与远端时序
   - destroy/read time 回写
3. 然后做 `SDK-10` 验证收口
   优先顺序建议是：
   - 验证 `clientMsgNo` migration
   - 验证 `resendMessage / resendMediaMessage`
   - 验证 `setMessageState`
   - 验证 `getMessagesByClientMsgNos`
   - 验证 `saveMessage`
4. 再补 `SDK-11` 缺失接口
   优先 `getFirstUnreadMessage` 和 `getLocalAndRemoteMessages`，因为这两项最容易影响聊天页和历史消息页体验。

### 当前不建议马上切到的方向

- 不建议现在先做 demo 样式收尾。SDK 侧状态域还在变化，demo 容易反复返工。
- 不建议先做 `SDK-15` 连接状态机。当前更紧的是消息 / 会话数据面先收稳。
- 不建议先开 `DEMO-08 ~ DEMO-10` 这类外围页面，收益不如把 IM 主链路补全。
