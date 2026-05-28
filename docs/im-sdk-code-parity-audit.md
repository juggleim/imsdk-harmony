# IM SDK 代码对齐审计

更新时间：2026-05-25  
审计范围：

- Harmony：`/Users/helena/Work/code/imsdk-harmony/juggleim`
- Android：`/Users/helena/Work/code/im-android-sdk/JuggleIM`

本审计只依据当前两个仓库的真实代码实现，不引用既有 `docs/*.md` 作为事实来源。

## 1. 审计方法

本次按下面三个层次逐项比对：

1. 对外入口和接口：从 `JIM.java` 与 `juggleim.ets` 开始，逐个 manager interface 对照。
2. 对内实现逻辑：看 manager、sync、network、upload/download、缓存回写链路。
3. 本地存储：直接比对数据库 schema、DAO/DBManager 能力与持久化域。

核心比对文件包括但不限于：

- Android
  - `JuggleIM/src/main/java/com/juggle/im/JIM.java`
  - `interfaces/*.java`
  - `internal/ConversationManager.java`
  - `internal/MessageManager.java`
  - `internal/connect/ConnectionManager.java`
  - `internal/UserInfoManager.java`
  - `internal/ChatroomManager.java`
  - `internal/MomentManager.java`
  - `internal/core/db/*.java`
- Harmony
  - `juggleim/src/main/ets/juggleim.ets`
  - `interfaces/*.ets`
  - `managers/*.ets`
  - `dbs/*.ets`
  - `resources/rawfile/*.sql`

## 2. 总体结论

结论先给：

- 聊天主链路并不是“空白实现”，Harmony 已经具备连接、收发消息、会话、聊天室、朋友圈、收藏、reaction、广播、免打扰、会话置顶等主干能力。
- 但从“与 Android SDK 代码完全对齐”的标准看，Harmony 目前仍是 **部分对齐**，尤其缺在：
  - 公开接口面不完整；
  - 部分 Android 能力没有对等 public API；
  - 本地存储域明显更少；
  - 若干实现链路仍偏轻量，缺少 Android 侧的状态机、专用缓存表、tag 元数据模型、friend 域、subchannel 域等。

按优先级分层：

- **基本对齐**：`ChatroomManager`、`MomentManager` 的主 API 形态。
- **部分对齐**：`ConversationManager`、`MessageManager`、`UserInfo/GroupInfo`。
- **明显未对齐**：`ConnectionManager`、`CallManager` 入口、friend/tag/subchannel/消息状态相关能力。

## 3. SDK 入口差异

### 3.1 Android 入口

`JIM.java` 当前公开：

- `getConnectionManager()`
- `getMessageManager()`
- `getConversationManager()`
- `getChatroomManager()`
- `getUserInfoManager()`
- `getCallManager()`
- `getMomentManager()`
- `getSDKVersion()`
- `setServerUrls(...)`
- `setCallbackHandler(...)`
- `getCurrentUserId()`
- `getDeviceId(...)`
- `getTimeDifference()`

### 3.2 Harmony 入口

`juggleim.ets` 当前公开：

- `getConnectionManager()`
- `getMessageManager()`
- `getMsgSyncManager()`
- `getConversationManager()`
- `getChatroomManager()`
- `getUserInfoManager()`
- `getGroupInfoManager()`
- `getMomentManager()`
- `getConnStatus()`
- `setAppServerUrl(...)`
- `setPackageName(...)`

### 3.3 入口层结论

1. Harmony 缺少 Android 的 `CallManager` 公开入口。
2. Harmony 将 Android 的统一 `IUserInfoManager` 拆成了 `IUserInfoManager + IGroupInfoManager`，但没有 friend 维度 manager。
3. Harmony 初始化配置更轻：
   - 无 `setServerUrls`
   - 无 `setCallbackHandler`
   - 无 `getSDKVersion`
   - 无 `getDeviceId`
   - 无 `getTimeDifference`
4. Harmony 额外暴露了 `getMsgSyncManager()`，这是 Android public SDK 没有直接暴露的内部能力。

## 4. 对外接口逐项对比

## 4.1 `IConnectionManager`

### Android 已有

- `connect`
- `disconnect(boolean receivePush)`
- `registerPushToken`
- `setLanguage`
- `getLanguage`
- `getConnectionStatus`
- `setConnectParams`
- keyed listener：`addConnectionStatusListener(String key, ...)`
- listener 包含 `onStatusChange/onDbOpen/onDbClose`

### Harmony 当前

- `connect`
- `disconnect()`
- `registerPushToken`
- `addConnectStatusListener(listener)`
- `removeConnectStatusListener(listener)`

### 差异结论

Harmony 在连接管理接口上缺口最大：

- 缺 `disconnect(receivePush)` 语义；
- 缺推送语言设置与查询；
- 缺连接参数注入；
- 缺 keyed listener；
- 缺 `onDbOpen/onDbClose` 生命周期回调；
- 缺 public `getConnectionStatus()`，虽然 `JuggleIm` 有 `getConnStatus()`，但不在 interface 上。

## 4.2 `IConversationManager`

### 已对齐部分

- 查询会话
- 获取单会话
- 草稿
- 删除会话
- 会话置顶
- 会话免打扰
- 清除未读 / 清除总未读 / 设未读
- conversation listener
- conversation tag 绑定关系的增删查

### Harmony 缺失或能力不等价

- `createConversationInfo`
- Android 风格 `getConversationInfoList(...)` 重载族
- `getUnreadCountWithTypes`
- 完整 tag 元数据 API：
  - `createConversationTag`
  - `destroyConversationTag`
  - `updateConversationTagName`
  - `getCachedConversationTagList`
  - `getConversationTagList`
  - `getTagsForConversation` 的 Android 版本返回 `ConversationTagInfo`
  - `addConversationsToTag`
  - `removeConversationsFromTag`
- `setTopConversationsOrderType`
- sync listener
- tag listener

### 关键实现差异

Harmony 本地只有 `conversation_tags(tag_id, conver_type, conver_id)` 绑定表，只有“会话 <-> tagId 关系”；  
Android 除 `conversation_tag` 外还有 `conversation_tag_info`，同时具备 tag 元数据和 tag 变更监听链路。

### 结论

Harmony 会话模块在“普通会话列表能力”上已可用，但 **标签体系只做到了关系层，没有做到 Android 的完整标签域模型**。

## 4.3 `IMessageManager`

### Harmony 已覆盖的主链路

- 文本/媒体消息发送
- 下载媒体
- 查询本地/远端/mention/history
- reaction
- 收藏
- 广播消息
- 全局免打扰
- 会话置顶消息
- 读回执 / 群已读详情
- 修改消息 / 更新消息
- 撤回
- 搜索消息
- `local_attribute`
- 自定义消息注册
- 上传 provider 注入

### Harmony 缺失或未等价公开的能力

- `resendMessage`
- `resendMediaMessage`
- `saveMessage`
- Android 风格同步返回 `getMessages(...)` 重载
- `getMessagesByClientMsgNos`
- `getFirstUnreadMessage`
- `searchConversationsWithMessageContent`
- `deleteMessagesByClientMsgNoList`
- `getLocalAndRemoteMessages`
- `getMessageReadTime`
- `getMergedMessageList`
- 基于 `clientMsgNo` 的 `local_attribute` 访问
- `getCachedMessagesReaction`
- `uploadImage`
- `setMessageState`
- sync listener / destroy listener / preprocessor / stream message listener

### 关键实现差异

1. Android 有完整的发送状态回写链路：
   - `saveMessageWithContent(...)`
   - `setMessageState(...)`
   - `resendMessage(...)`
   - `resendMediaMessage(...)`
   - `getMessagesByClientMsgNos(...)`
2. Harmony 目前 public message API 更偏“即时操作”，缺少围绕 `clientMsgNo` 的二次控制能力。
3. Android 提供 `uploadImage(path)` 作为 SDK 公共能力；Harmony 只有 provider 机制，没有等价快捷接口。

### 结论

Harmony 的消息模块已覆盖 demo 主流程，但 **发送失败恢复、消息状态控制、merge/first-unread/search-conversation 等高级能力仍未对齐**。

## 4.4 `IUserInfoManager` / `IGroupInfoManager`

### Android

Android `IUserInfoManager` 是统一门面，覆盖：

- 用户
- 群组
- 群成员
- 好友
- 批量获取
- 强制远端刷新

### Harmony

Harmony 分成两套，但 `IUserInfoManager` 现在已经承接了 user/group/friend 的批量和群成员查询入口：

- `IUserInfoManager`
  - `saveUserInfo`
  - `getLocalUserInfo`
  - `getUserInfoList`
  - `getGroupInfoList`
  - `getFriendInfoList`
  - `getLocalGroupInfo`
  - `getGroupInfo`
  - `queryGroupInfo`
  - `getLocalGroupMember`
  - `getGroupMember`
  - `queryGroupMember`
  - `getLocalGroupMembers`
  - `queryGroupMembers`
  - `getUserInfo`
  - `queryUserInfo`
  - `getRemoteUserInfo`
  - `fetchUserInfo`
  - `fetchGroupInfo`
  - `saveFriendInfo`
  - `getLocalFriendInfo`
  - `getFriendInfo`
  - `queryFriendInfo`
  - `fetchFriendInfo`
  - `checkFriend`
- `IGroupInfoManager`
  - `saveGroupInfo`
  - `getLocalGroupInfo`
  - `getGroupInfoList`
  - `getGroupInfo`
  - `queryGroupInfo`
  - `getLocalGroupMember`
  - `getGroupMember`
  - `queryGroupMember`
  - `getLocalGroupMembers`
  - `queryGroupMembers`

### 缺口

- 仍需继续对拍 Android 的统一门面语义，确认远端刷新和返回值行为完全一致

### 结论

Harmony 的 user/group/friend 数据面已经覆盖了大部分查询场景，但 **统一门面的行为和 Android 仍需继续对拍**。

## 4.5 `IChatroomManager`

### 结论

这一项比旧文档里写得完整得多，当前代码看已经是 **基本对齐**：

- join/quit
- set/remove/get attributes
- keyed listener
- attributes listener

Harmony 还实现了：

- 聊天室消息同步处理
- 属性同步处理
- 被踢 / 销毁事件处理

对应实现见 `managers/chatroommanager.ets`，不是占位代码。

## 4.6 `IMomentManager`

### 接口层

Harmony 与 Android public API 基本一致：

- 发布 / 删除
- 取缓存列表 / 取远端列表 / 取详情
- 评论增删查
- 点赞增删查

### 实现层关键差异

- Android `MomentManager` 也是走 HTTP `/momentgateway/*`，但每次远端结果都会回写 SQLite：
  - `insertMoments(...)`
  - `removeMoment(...)`
- Harmony `MomentManager` 只维护内存 `momentCache: Moment[]`
  - 无 moment DAO
  - 无 moment 表
  - 进程重启后缓存丢失

### 结论

朋友圈接口已对齐，但 **持久化能力未对齐**。

## 5. 对内实现逻辑对比

## 5.1 连接与网络层

### Android

- `internal/connect/ConnectionManager.java` 基于状态机
- 依赖 `internal/connect/fsm/*`
- 统一管理网络变更、生命周期、DB 打开关闭、连接状态
- listener 体系更完整

### Harmony

- `managers/connectionmanager.ets` + `imclients/imclient.ets`
- 结构更直接，连接逻辑集中在 websocket client 与 manager
- 没有 Android 那套显式 FSM

### 影响

- Harmony 更轻，但连接态、DB 生命周期、语言/headers/receivePush 等能力没有被完整抽象出来。

## 5.2 同步链路

### Android

- `ConnectionManager + MessageManager + ConversationManager + DBManager`
- sync 状态持久化到 `profile` 表

### Harmony

- `MsgSyncManager` 是核心同步器
- sync 时间写在 `confs` 表：
  - `conver_sync_time`
  - `inbox_sync_time`
  - `sendbox_sync_time`

### 结论

Harmony 同步主链路是可工作的，但 profile 域抽象更弱，存储模型更轻量。

## 5.3 上传/下载

### Android

- `UploadManager`
- `internal/uploader/*`
- public `uploadImage(...)`
- 发送态、上传态、失败态管理更完整

### Harmony

- provider 驱动上传
- 下载主链路可用
- 缺 Android public `uploadImage(...)`
- 缺 resend / message state 管理

## 5.4 Reaction / Favorite / Top / Mute

### 已实现

Harmony 这几项都不是空白：

- reaction：消息维度可发起、查询、展示
- favorite：可添加/删除/列表
- top message：可设置/查询
- global mute：可设置/查询
- conversation mute/top：已打通

### 与 Android 的差异

- Android 对 reaction 还有独立缓存表与缓存读取接口；
- Harmony reaction 直接嵌到 `messages.reactions` 字段；
- Harmony 缺 `getCachedMessagesReaction` 之类的显式缓存 API。

## 5.5 Chatroom

Harmony 聊天室链路当前已经包含：

- 入会/退会
- 属性增删查
- 属性同步
- 被踢 / 房间销毁事件
- demo 页面打通

这一项已不属于主要缺口。

## 5.6 Moment

两边都通过 moment gateway 访问远端，但差异在缓存层：

- Android：HTTP + SQLite
- Harmony：HTTP + 进程内数组

这意味着 Harmony 朋友圈列表首屏、离线回显、重启后回显，与 Android 仍不在同一层级。

## 6. 本地存储对比

## 6.1 Harmony 当前表

来自 `202504011225.sql` 和 `202605201430.sql`：

- `confs`
- `messages`
- `conversations`
- `conversation_tags`
- `users`
- `groups`
- `group_members`
- 迁移字段：`messages.local_attribute`

## 6.2 Android 当前表

来自 `DBHelper.java` / `DBManager.java` / `*Sql.java`：

- `profile`
- `conversation_info`
- `conversation_tag`
- `conversation_tag_info`
- `message`
- `user`
- `group_info`
- `group_member`
- `friend`
- `reaction`
- `moment`

## 6.3 Harmony 缺失的持久化域

### 明确缺失

- `friend` 表
- `reaction` 独立表
- `moment` 表
- `conversation_tag_info` 表
- `profile` 表

### 字段级差异

Android `message` 额外有：

- `clientMsgNo`
- `life_time`
- `life_time_after_read`
- `destroy_time`
- `read_time`
- `subchannel`

Harmony `messages` 当前没有这些域，只有较轻量的消息记录。

### 模型级差异

- Android `Conversation` 支持 `subChannel`
- Harmony `Conversation` 只有 `conversationId + conversationType + msgIndex`
- Harmony 会话表、消息表、tag 表都没有 `subchannel`

这不是一个小差异，它会影响：

- 会话唯一键
- tag 绑定粒度
- 消息查询维度
- 合并消息 / 子频道会话场景

## 7. 对齐状态汇总

## 7.1 基本对齐

- `IChatroomManager`
- `IMomentManager` 的 public API 形态
- 会话置顶 / 会话免打扰 / 广播 / 收藏 / reaction / mention / 历史搜索等主功能

## 7.2 部分对齐

- `IConversationManager`
- `IMessageManager`
- `IUserInfoManager` / `IGroupInfoManager`
- 同步链路
- 上传下载链路

## 7.3 明显未对齐

- `IConnectionManager`
- `CallManager` public entry
- friend 域
- conversation tag 元数据域
- subchannel 能力
- moment 本地持久化
- message resend / state / clientMsgNo 扩展能力

## 8. 建议的补齐顺序

建议按“先补 SDK 面，再补存储，再补实现链路”的顺序做：

1. **接口先补齐**
   - `IConnectionManager`
   - `IConversationManager` tag/full query 能力
   - `IMessageManager` resend/state/clientMsgNo/uploadImage
   - friend API
2. **存储补齐**
   - `friend`
   - `conversation_tag_info`
   - `reaction`
   - `moment`
   - `profile`
   - `subchannel`
3. **实现链路补齐**
   - resend / message state
   - connection params / language / receivePush
   - moment SQLite cache
   - tag 同步监听

## 9. 最终判断

如果标准是“主流程能跑”，Harmony SDK 已经不算缺失严重。  
如果标准是“与 Android SDK 当前代码等价”，结论是：

- **聊天主干已具备**
- **接口面仍不完整**
- **本地存储域明显少于 Android**
- **高级实现能力尚未完全对齐**

所以当前更准确的判定应当是：**Harmony IM SDK 已完成主链路建设，但距离 Android 代码级完全对齐仍有一批结构性缺口。**
