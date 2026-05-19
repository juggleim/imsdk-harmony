# IM 功能实现集合与实现逻辑

本文只基于当前仓库代码确认“已经实现 / 部分实现 / 仅预留未实现”的 IM 功能，不做主观补全。

## 1. IM SDK 总体结构

对外统一入口是单例 [juggleim/src/main/ets/juggleim.ets](../juggleim/src/main/ets/juggleim.ets) 的 `JuggleIm.instance`。

它内部聚合了：
- `ConnectionManager`：连接管理
- `MessageManager`：消息能力
- `MsgSyncManager`：同步与通知分发
- `ConversationManager`：会话能力
- `UserInfoManager`：用户资料
- `GroupInfoManager`：群资料

整体思路是：
1. 先初始化服务器地址、appkey、deviceId
2. 连接成功后初始化用户本地数据库
3. 自动同步会话和消息
4. 通过本地数据库支撑列表、历史消息和资料缓存
5. 通过 listener 通知 UI 实时更新

---

## 2. 功能清单总览

### 已实现较完整
1. SDK 初始化
2. WebSocket 连接与连接状态监听
3. 连接成功后自动同步会话
4. 连接成功后自动同步消息
5. 文本消息发送
6. 本地消息落库与发送态管理
7. 实时下行消息接收
8. 会话列表本地查询
9. 会话增删改监听
10. 历史消息本地查询
11. 历史消息远端补拉
12. 消息撤回命令处理
13. 消息修改命令处理
14. 会话置顶
15. 会话免打扰设置
16. 标记会话未读
17. 清除单会话未读
18. 清除总未读
19. 查询总未读数
20. 删除会话
21. 新增会话
22. 用户资料本地缓存与远端查询
23. 群资料本地缓存
24. 本地 SQLite 持久化
25. 自定义消息类型注册机制
26. 多种消息内容类型建模

### 部分实现 / 能力存在但不完整
1. 群会话发送能力
2. 文件/图片/语音/视频消息内容模型
3. 群资料远端查询底层逻辑
4. 会话标签表结构
5. 聊天室消息通知预留
6. 已读通知消息结构
7. 清未读命令消息结构

### 明确未实现或空壳
1. 媒体消息上传/发送流程
2. 消息搜索
3. 查询指定消息 ID
4. 修改消息主动 API
5. 已读回执发送 API
6. 本地消息属性设置
7. 草稿设置/清除
8. mention 消息查询
9. 聊天室消息同步处理
10. 群成员管理能力
11. 群资料完整对外 API

---

## 3. 详细功能列表

## 3.1 SDK 初始化

### 功能描述
初始化 IM SDK 基础配置，包括服务器地址、健康检查地址、appkey、平台和设备标识。

### 核心文件
- [juggleim/src/main/ets/juggleim.ets](../juggleim/src/main/ets/juggleim.ets)
- [juggleim/src/main/ets/commons/preferenceutil.ets](../juggleim/src/main/ets/commons/preferenceutil.ets)

### 实现思路和逻辑
- `JuggleIm.init(address, appkey)` 写入配置
- 实际 WebSocket 地址被拼接为 `address + "/im"`
- `healthCheckAddress` 也被保存，但当前代码未看到实际使用
- `deviceId` 通过本地 preferences 生成并持久化，保证设备稳定标识

### 结论
**已实现。**

---

## 3.2 WebSocket 连接与连接状态监听

### 功能描述
用 IM token 建立长连接，并向上层暴露连接状态变化。

### 核心文件
- [juggleim/src/main/ets/managers/connectionmanager.ets](../juggleim/src/main/ets/managers/connectionmanager.ets)
- [juggleim/src/main/ets/imclients/imclient.ets](../juggleim/src/main/ets/imclients/imclient.ets)
- [juggleim/src/main/ets/improto/imconnect.proto](../juggleim/src/main/ets/improto/imconnect.proto)

### 实现思路和逻辑
- `ConnectionManager.connect(token)` 会先尝试根据 token 找到缓存 userId，用于提前初始化 DB
- 真实连接由 `ImClient.connect(token)` 完成
- 建链后发送 `ConnectMsgBody`，包含 `protoId/appkey/token/platform/deviceId`
- SDK 内部维护状态：`unknown / connecting / connected / fail / disconnected`
- 通过 listener 将连接状态回调给页面或业务层

### 结论
**已实现。**

---

## 3.3 连接成功后的自动同步

### 功能描述
连接成功后自动把服务端会话和消息同步到本地。

### 核心文件
- [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)

### 实现思路和逻辑
- `MsgSyncManager` 在构造时注册连接状态监听
- 当状态变为 `connected`，执行 `syncAfterConnect`
- 同步分两段：
  1. 循环调用 `syncConvers`
  2. 循环调用 `syncMsgs`
- 直到服务端返回 `isFinished` 才结束首次同步
- 首次同步完成后，实时通知队列才开始顺序消费

### 结论
**已实现，且是 SDK 的核心机制。**

---

## 3.4 心跳保活

### 功能描述
连接成功后定时发送 ping 维持连接活性。

### 核心文件
- [juggleim/src/main/ets/imclients/imclient.ets](../juggleim/src/main/ets/imclients/imclient.ets)

### 实现思路和逻辑
- 连接 ack 成功后启动 30 秒定时器
- 周期发送 ping 消息
- 接收 pong 后更新 `latestPongTime`

### 结论
**已实现。**

---

## 3.5 文本消息发送

### 功能描述
支持发送文本消息到会话。

### 核心文件
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
- [juggleim/src/main/ets/entries/message.ets](../juggleim/src/main/ets/entries/message.ets)

### 实现思路和逻辑
- 目前 `MessageManager.sendMessage(...)` 是通用入口，UI 里实际使用的是 `TextMessage`
- 根据 `conversationType` 决定 topic：
  - 私聊：`p_msg`
  - 群聊：`g_msg`
- 先生成 `clientUid`
- 再把消息内容编码成二进制并 publish
- 发送前先插入本地 DB，状态记为 `sending`
- 收到 ack 后回填 `messageId / sentTime / msgSeqNo`，状态更新为 `success`
- 失败则更新为 `failed`

### 结论
**已实现。**

---

## 3.6 本地消息发送态管理

### 功能描述
管理消息 `sending / success / failed` 状态，并保持界面与数据库一致。

### 核心文件
- [juggleim/src/main/ets/entries/message.ets](../juggleim/src/main/ets/entries/message.ets)
- [juggleim/src/main/ets/dbs/messagedao.ets](../juggleim/src/main/ets/dbs/messagedao.ets)
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)

### 实现思路和逻辑
- 发送前本地落库，状态 `sending`
- ack 成功后调用 `updateMsgState`
- 并同步更新会话最后一条消息

### 结论
**已实现。**

---

## 3.7 实时消息接收

### 功能描述
接收服务端实时下行消息，并分发给本地存储和 UI 监听器。

### 核心文件
- [juggleim/src/main/ets/imclients/imclient.ets](../juggleim/src/main/ets/imclients/imclient.ets)
- [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)

### 实现思路和逻辑
- `ImClient` 将 publish topic 为 `msg` 的下行消息交给 `MsgSyncManager.onDirectMsgReceived`
- 收到后先 `pubAck`
- 再进入顺序任务队列处理
- 解析为业务 `Message`
- 如果需要存储则写 DB，并更新会话
- 最后触发消息监听器

### 结论
**已实现。**

---

## 3.8 消息同步（收件箱 + 发件箱）

### 功能描述
支持按时间增量同步消息，并区分收件箱、发件箱游标。

### 核心文件
- [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)
- [juggleim/src/main/ets/dbs/confdao.ets](../juggleim/src/main/ets/dbs/confdao.ets)

### 实现思路和逻辑
- SDK 分别维护：
  - `latestInboxMsgTime`
  - `latestSendboxMsgTime`
- 同步请求 `SyncMsgReq` 包含两个时间点
- 收到下行消息后根据 `senderId == 当前用户` 区分是发件箱还是收件箱消息
- 分别更新相应同步时间
- 游标持久化到 `confs` 表

### 结论
**已实现。**

---

## 3.9 历史消息本地查询

### 功能描述
从本地数据库分页读取历史消息。

### 核心文件
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
- [juggleim/src/main/ets/dbs/messagedao.ets](../juggleim/src/main/ets/dbs/messagedao.ets)

### 实现思路和逻辑
- `queryLocalMessages` 根据会话 ID / 类型、起始时间、方向查询本地库
- 支持向前翻页和向后翻页
- 倒序查出来后会重新排序成时间正序，方便 UI 展示

### 结论
**已实现。**

---

## 3.10 历史消息远端补拉

### 功能描述
本地消息不足或发现序列缺口时，从服务端补拉历史消息。

### 核心文件
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)

### 实现思路和逻辑
- `queryMessages` 先查本地
- 如果数量不够，或 `msgSeqNo` 出现断档，就调用 `queryRemoteMessages`
- 远端接口为 `qry_hismsgs`
- 拉回的数据若本地不存在，则插入 DB

### 结论
**已实现。**

---

## 3.11 会话同步

### 功能描述
同步会话列表及会话状态变化。

### 核心文件
- [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)
- [juggleim/src/main/ets/dbs/conversationdao.ets](../juggleim/src/main/ets/dbs/conversationdao.ets)

### 实现思路和逻辑
- 首次连接后走 `sync_convers`
- 服务端返回会话集合
- 本地比较是否存在：
  - 不存在 -> add
  - 存在 -> update
  - 标记删除 -> del
- 全部写入或删除本地 DB
- 再触发增删改 listener 给 UI

### 结论
**已实现。**

---

## 3.12 会话列表本地查询

### 功能描述
从本地库按时间分页读取会话。

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)
- [juggleim/src/main/ets/dbs/conversationdao.ets](../juggleim/src/main/ets/dbs/conversationdao.ets)

### 实现思路和逻辑
- `queryConversations` 直接查本地库
- UI 层滚动到底后继续分页
- 依赖 `conver_time` 进行排序和游标翻页

### 结论
**已实现。**

---

## 3.13 会话新增

### 功能描述
主动向服务端创建/插入会话。

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)

### 实现思路和逻辑
- `insertConversation` 构造 `Conversation` protobuf
- 调用服务端 `add_conver`
- 成功后回调上层

### 结论
**已实现基础版。**

---

## 3.14 删除会话

### 功能描述
支持删除会话。

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)

### 实现思路和逻辑
- 通过 `del_convers` 接口向服务端删除
- 本地删除更多依赖后续同步回流触发

### 结论
**已实现。**

---

## 3.15 会话置顶

### 功能描述
支持设置/取消会话置顶。

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)

### 实现思路和逻辑
- 调用 `top_convers`
- 请求中带 `isTop`
- 本地状态通常由同步结果回写

### 结论
**已实现。**

---

## 3.16 查询置顶会话

### 功能描述
支持按置顶时间或排序时间查询置顶会话列表。

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)

### 实现思路和逻辑
- 使用 `qry_top_convers`
- 支持 `ByTopTime / BySortTime` 两种排序方式
- 将返回结果转换为 `ConversationInfo`

### 结论
**已实现。**

---

## 3.17 会话免打扰设置

### 功能描述
支持为单个会话设置免打扰。

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)

### 实现思路和逻辑
- 调用 `undisturb_convers`
- 当前请求里 `undisturbType` 写死为 `1`
- 方法签名有 `isMute`，但实际未把参数映射到不同值

### 结论
**已实现，但实现比较粗糙。**

---

## 3.18 未读数管理

### 功能描述
支持设置未读、清除单会话未读、查询总未读、清除总未读。

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)

### 实现思路和逻辑
- `setUnread` -> `mark_unread`
- `clearUnreadCount` -> `clear_unread`
- `getTotalUnreadCount` -> `qry_total_unread_count`
- `clearTotalUnreadCount` -> `clear_total_unread`

### 结论
**已实现。**

---

## 3.19 消息撤回

### 功能描述
支持发起消息撤回，也支持接收撤回命令后把原消息替换成撤回提示消息。

### 核心文件
- 发起：[juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
- 命令模型：[juggleim/src/main/ets/entries/cmdmsg.ets](../juggleim/src/main/ets/entries/cmdmsg.ets)
- 命令处理：[juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)
- 撤回提示内容：[juggleim/src/main/ets/entries/message.ets](../juggleim/src/main/ets/entries/message.ets)

### 实现思路和逻辑
- 主动撤回通过 `recall_msg` 发送请求
- 下行接收到 `jg:recall` 命令后：
  - 根据被撤回消息 ID 查本地消息
  - 把原消息内容替换成 `RecallInfoMessage`
  - 更新数据库
  - 触发撤回监听器

### 结论
**已实现。**

---

## 3.20 消息修改

### 功能描述
支持处理服务端下发的“修改消息”命令，把旧消息内容替换为新内容。

### 核心文件
- [juggleim/src/main/ets/entries/cmdmsg.ets](../juggleim/src/main/ets/entries/cmdmsg.ets)
- [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)

### 实现思路和逻辑
- 下行命令 `jg:modify`
- 根据 `msgId` 找到旧消息
- 如果指定了 `newMsgType` 就按新类型重建消息内容
- 更新本地 DB
- 触发修改监听器

### 结论
**被动处理已实现；主动 `modifyMessage(...)` API 仍是空实现。**

---

## 3.21 消息删除与清空历史

### 功能描述
支持请求删除部分消息，或按条件清空历史消息。

### 核心文件
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)

### 实现思路和逻辑
- `delMessages` 调用 `del_hismsg`
- `clearMessages` 调用 `clean_hismsg`
- `ClearMsgOptions` 支持按时间、范围、发送者、时间偏移配置

### 结论
**接口已实现。**

---

## 3.22 消息内容类型

### 功能描述
当前 SDK 内建多种消息内容模型。

### 已建模类型
- `jg:text` 文本
- `jg:merge` 合并转发/聊天记录
- `jg:voice` 语音
- `jg:img` 图片
- `jg:file` 文件
- `jg:video` 视频
- `jg:recallinfo` 撤回提示
- `jg:recall` 撤回命令
- `jg:readntf` 已读通知命令
- `jg:clearunread` 清未读命令
- `jg:modify` 消息修改命令

### 核心文件
- [juggleim/src/main/ets/entries/message.ets](../juggleim/src/main/ets/entries/message.ets)
- [juggleim/src/main/ets/entries/msgtypes.ets](../juggleim/src/main/ets/entries/msgtypes.ets)
- [juggleim/src/main/ets/entries/msghandler.ets](../juggleim/src/main/ets/entries/msghandler.ets)

### 实现思路和逻辑
- 每种消息内容继承 `MessageContent`
- 自己负责 `encode / decode`
- `MsgHandler` 通过 `msgType -> constructor` 映射构造对象

### 结论
**模型已实现。**

---

## 3.23 自定义消息注册

### 功能描述
允许业务方注册新的消息类型。

### 核心文件
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
- [juggleim/src/main/ets/entries/msghandler.ets](../juggleim/src/main/ets/entries/msghandler.ets)

### 实现思路和逻辑
- `registerMessage(msgType, constructor)` 把类型与构造函数注册到全局 map
- 收到该类型消息时由 `MsgHandler.constructByMsgType(...)` 自动解码

### 结论
**已实现。**

---

## 3.24 用户资料缓存与查询

### 功能描述
支持本地缓存用户资料，未命中时远端补拉。

### 核心文件
- [juggleim/src/main/ets/managers/userinfomanager.ets](../juggleim/src/main/ets/managers/userinfomanager.ets)
- [juggleim/src/main/ets/dbs/userdao.ets](../juggleim/src/main/ets/dbs/userdao.ets)

### 实现思路和逻辑
- 同步会话或消息时，如果带有 `targetUserInfo`，就直接缓存到本地库
- `getUserInfo(userid)` 先查本地
- 本地没有则调用 `qry_user_info`
- 拉到后回写本地库
- `needUpdate` 用更新时间判断是否要覆盖旧数据

### 结论
**已实现。**

---

## 3.25 群资料缓存

### 功能描述
支持把消息或会话里携带的群资料缓存到本地。

### 核心文件
- [juggleim/src/main/ets/managers/groupinfomanager.ets](../juggleim/src/main/ets/managers/groupinfomanager.ets)
- [juggleim/src/main/ets/dbs/groupdao.ets](../juggleim/src/main/ets/dbs/groupdao.ets)

### 实现思路和逻辑
- 如果下行消息 / 会话里带 `groupInfo`
- 就调用 `saveGroupInfo` 落库
- 本地可通过 `getLocalGroupInfo` 读取

### 结论
**本地缓存已实现。**

### 限制
- 对外 `getGroupInfo(groupId)` 直接返回 `null`
- 私有 `qryGroupInfo(...)` 虽然写了远端查询逻辑，但没有暴露使用

所以这是 **部分实现**。

---

## 3.26 本地数据库持久化

### 功能描述
支持以用户维度建立独立数据库，保存消息、会话、资料和同步游标。

### 核心文件
- [juggleim/src/main/ets/dbs/dbmanager.ets](../juggleim/src/main/ets/dbs/dbmanager.ets)
- [juggleim/src/main/resources/rawfile/202504011225.sql](../juggleim/src/main/resources/rawfile/202504011225.sql)

### 实现思路和逻辑
- DB 名为 `${appkey}_${userId}.db`
- 首次连接后初始化数据库
- 根据 `sqllist.txt` 和 SQL 文件做版本升级
- 用 `confs` 记录 SQL 版本和同步时间

### 表结构能力
- `messages`：消息体、状态、引用、搜索文本等
- `conversations`：会话摘要、置顶、免打扰、未读等
- `users`：用户资料
- `groups`：群资料
- `group_members`：群成员
- `conversation_tags`：会话标签
- `confs`：配置与游标

### 结论
**已实现。**

---

## 3.27 会话与消息事件监听

### 功能描述
SDK 支持监听会话和消息变化，供 UI 实时响应。

### 会话监听
- 新增
- 更新
- 删除
- 总未读变化

### 消息监听
- 收到消息
- 撤回消息
- 修改消息
- 删除消息
- 清空消息

### 核心文件
- [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)
- [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
- [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)

### 实现思路和逻辑
- 对外 manager 只暴露 add/remove listener
- 真正的触发在 `MsgSyncManager`
- 同步、实时消息、命令消息处理后统一分发

### 结论
**大部分已实现。**

### 限制
`MsgDeletedListener` / `MsgCleanedListener` 目前对外接口有，但当前仓库里没有看到对应触发逻辑。

---

## 3.28 群聊能力

### 功能描述
SDK 从协议和数据结构层面支持群会话与群消息。

### 证据
- `conversationType == 2` 时发送 topic 用 `g_msg`，见 [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
- `ChannelType.Group = 2`，见 [juggleim/src/main/ets/improto/immessage.proto](../juggleim/src/main/ets/improto/immessage.proto)
- 同步与消息解析时都有 `groupInfo` 处理

### 实现思路和逻辑
- 群消息发送、群会话解析、群资料缓存都已考虑
- 但 UI 示例主要走私聊链路，联系人页进入会话时写死的是私聊类型 `1`

### 结论
**SDK 层部分具备，示例 UI 未完整体现。**

---

## 3.29 已读回执相关

### 功能描述
代码中有已读通知相关模型，但主动发送和完整消费链路还不完整。

### 证据
- `ReadNtfMessage` 已建模，见 [juggleim/src/main/ets/entries/cmdmsg.ets](../juggleim/src/main/ets/entries/cmdmsg.ets)
- `sendReadReceipt(...)` 为空实现，见 [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)

### 实现思路和逻辑
目前只看到了协议层和命令结构层面的准备，没有完整 API 流程。

### 结论
**仅部分预留，未真正实现。**

---

## 3.30 草稿能力

### 功能描述
接口存在，但没有实现。

### 证据
- `setDraft(...)` 空实现
- `clearDraft(...)` 空实现
- 文件：[juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)

### 结论
**未实现。**

---

## 3.31 搜索能力

### 功能描述
结构上支持消息搜索参数，但 API 为空。

### 证据
- `SearchParams` 已定义，包含关键词、消息类型、时间范围、会话
- `searchMessages(...)` 空实现
- 文件：[juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)

### 结论
**未实现。**

---

## 3.32 媒体消息发送

### 功能描述
虽然已有图片/语音/视频/文件消息内容模型，但真正的上传与发送流程没有落地。

### 证据
- `sendMediaMessage(...) {}` 空实现，见 [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)

### 结论
**未实现。**

---

## 3.33 查询指定消息、主动修改消息、本地属性

### 功能描述
这些接口在 SDK 里有占位，但未实现。

### 证据
位于 [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)：
- `getMessagesByIds(...) {}`
- `modifyMessage(...) {}`
- `setLocalAttribue(...) {}`

### 结论
**未实现。**

---

## 3.34 聊天室能力

### 功能描述
协议枚举中存在 `Chatroom` 与聊天室通知类型，但业务逻辑没有实现完成。

### 证据
- `ChannelType.Chatroom = 3`
- `NotifyType.ChatroomMsg / ChatroomAtt / ChatroomEvent / ChatroomDestroy`
- 在 [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets) 中，`NotifyType.ChatroomMsg` 分支只有 `//TODO`

### 结论
**协议预留，业务未实现。**

---

## 3.35 会话标签 / mention / 群成员

### 功能描述
数据库或实体有预留，但 SDK 层未形成完整产品能力。

### 证据
- `conversation_tags` 表存在，见 [juggleim/src/main/resources/rawfile/202504011225.sql](../juggleim/src/main/resources/rawfile/202504011225.sql)
- `ConverTagDao` 只有 insert，没有完整查询/删除封装，见 [juggleim/src/main/ets/dbs/convertagdao.ets](../juggleim/src/main/ets/dbs/convertagdao.ets)
- `queryMentionMessages(...)` 空实现
- `group_members` 表存在，但 `GroupMemberDao` 只有对象转换和 valuesBucket，没有对外能力

### 结论
**属于设计预留，尚未形成完整功能。**

---

## 4. IM 在示例应用中的实际接入功能

从 `home` 模块实际使用情况看，目前真正跑通的用户可见功能主要有：

1. 自动初始化 IM 并连接
2. 会话列表展示
3. 实时会话刷新
4. 私聊历史消息展示
5. 私聊文本消息发送
6. 实时新消息展示
7. 联系人列表进入私聊页
8. 用户信息按需加载并展示头像昵称

关键页面：
- [jugglechat/home/src/main/ets/pages/Index.ets](../jugglechat/home/src/main/ets/pages/Index.ets)
- [jugglechat/home/src/main/ets/pages/ConversationList.ets](../jugglechat/home/src/main/ets/pages/ConversationList.ets)
- [jugglechat/home/src/main/ets/pages/ConversationDetail.ets](../jugglechat/home/src/main/ets/pages/ConversationDetail.ets)
- [jugglechat/home/src/main/ets/pages/ContactsList.ets](../jugglechat/home/src/main/ets/pages/ContactsList.ets)

这意味着：
- **SDK 层能力 > 示例 UI 实际展示能力**
- 仓库更像“IM SDK + 聊天样例 app”，而不是完整商业聊天产品

---

## 5. 当前 IM 实现的整体判断

### 优点
- 分层比较清楚：连接、同步、消息、会话、资料、DB 分离明确
- 具备本地持久化能力
- 支持首次同步 + 实时消息混合模式
- 具备一定可扩展性，自定义消息机制已预留

### 目前缺口
- 媒体消息只是模型，没有上传和真正发送
- 已读、搜索、草稿、聊天室、mention 等能力未完成
- 群资料、群成员能力未做完整闭环
- 示例 UI 主要验证文本单聊流程

### 最终结论
当前仓库中的 IM SDK 已经实现了 **“连接、同步、单聊文本收发、会话管理、本地存储、资料缓存”** 这一套核心闭环；但距离完整 IM 商业 SDK 还差 **媒体消息、已读体系、搜索体系、聊天室、完整群能力** 等多个部分。
