# imsdk-harmony 项目整体分析

## 1. 项目定位

这是一个 **HarmonyOS / ArkTS 多模块工程**，整体由一个可运行示例应用 `demo`、若干 UI/业务 HAR 模块，以及一个独立的 IM SDK HAR 模块组成。

从工程配置可以确认这是一个标准多模块应用：根目录 [oh-package.json5](../oh-package.json5) 注册了 `demo`、`jugglechat/base`、`jugglechat/home`、`jugglechat/socialCircle`、`juggleim` 五个模块；其中 `demo` 是 entry 模块，其余大多是 HAR 组件模块。

## 2. 技术栈与构建形态

### 2.1 技术栈
- UI：HarmonyOS ArkUI / ArkTS
- 构建：Hvigor
- 本地存储：`@kit.ArkData` 的关系型数据库 `relationalStore`
- 网络：
  - IM 长连接：`@ohos.net.webSocket`
  - 业务 HTTP：`@ohos.net.http`
- 协议：`@ohos/protobufjs`
- 其他：`long` 用于处理 64 位整数

### 2.2 模块形态
- `demo`：entry，可直接运行的示例 App，入口见 [demo/src/main/module.json5](../demo/src/main/module.json5)
- `jugglechat/base`：HAR，基础 UI、常量、适配能力，入口导出见 [jugglechat/base/Index.ets](../jugglechat/base/Index.ets)
- `jugglechat/home`：HAR，聊天主业务 UI，入口导出见 [jugglechat/home/Index.ets](../jugglechat/home/Index.ets)
- `jugglechat/socialCircle`：HAR，社交圈展示模块，入口导出见 [jugglechat/socialCircle/Index.ets](../jugglechat/socialCircle/Index.ets)
- `juggleim`：HAR，IM SDK 核心模块，入口导出见 [juggleim/Index.ets](../juggleim/Index.ets)

## 3. 顶层目录与职责

### 3.1 `demo/`
用于运行和展示整个聊天产品示例。

关键作用：
- 登录入口
- 引导进入聊天首页
- 组合 `home`、`base`、`juggleim` 模块
- 申请网络权限并承载 `UIAbility`

关键文件：
- 应用入口页：[demo/src/main/ets/pages/Index.ets](../demo/src/main/ets/pages/Index.ets)
- 登录后首页路由：[demo/src/main/ets/pages/Home.ets](../demo/src/main/ets/pages/Home.ets)
- Ability 入口：[demo/src/main/ets/demoability/DemoAbility.ets](../demo/src/main/ets/demoability/DemoAbility.ets)
- 模块声明：[demo/src/main/module.json5](../demo/src/main/module.json5)

### 3.2 `jugglechat/`
聊天应用层，主要承载 UI、页面结构和业务展示逻辑。

子模块：
- `base/`：公共 UI 基建
- `home/`：聊天首页、会话、消息、联系人、我的
- `socialCircle/`：社交圈/动态展示

### 3.3 `juggleim/`
IM SDK 核心实现，负责：
- WebSocket 连接
- Protobuf 协议编解码
- 消息发送与同步
- 会话同步与未读管理
- 用户/群组资料缓存
- 本地数据库持久化

这是仓库里最核心的业务逻辑模块。

### 3.4 `AppScope/`
HarmonyOS 应用级资源目录，属于系统工程结构的一部分，不承载 IM 核心业务逻辑。

### 3.5 `hvigor/`、`hvigorfile.ts`
构建相关目录和配置，不承载业务能力。

### 3.6 `oh_modules/`
依赖缓存目录，不是项目自研逻辑。

## 4. 模块级分析

## 4.1 `demo` 模块

### 作用
`demo` 是完整示例应用壳，负责把聊天产品跑起来。

### 已实现内容
1. **登录页**
   - 文件：[demo/src/main/ets/pages/Index.ets](../demo/src/main/ets/pages/Index.ets)
   - 提供手机号 + 验证码登录 UI
   - 调用 `JimServer.instance.phoneLogin(...)` 完成业务登录
   - 成功后缓存 `user_id / server_auth / im_token`
   - 再跳转到 `pages/Home`

2. **首页承载**
   - 文件：[demo/src/main/ets/pages/Home.ets](../demo/src/main/ets/pages/Home.ets)
   - 内部直接挂载 `Home()`，也就是 `home` 模块导出的主界面

3. **应用启动与页面装载**
   - 文件：[demo/src/main/ets/demoability/DemoAbility.ets](../demo/src/main/ets/demoability/DemoAbility.ets)
   - `windowStage.loadContent('pages/Index')` 作为应用启动页面

### 设计思路
`demo` 自己不实现 IM 细节，而是负责：
- 先获取业务身份（HTTP 登录）
- 再把令牌交给下层 IM SDK 使用
- 用于演示完整登录 -> 进入聊天 UI 的链路

## 4.2 `jugglechat/base` 模块

### 作用
基础 UI 和跨页面公共能力模块。

### 主要内容
- 响应式断点常量：[jugglechat/base/src/main/ets/constants/BreakpointConstants.ets](../jugglechat/base/src/main/ets/constants/BreakpointConstants.ets)
- 基础常量：[jugglechat/base/src/main/ets/constants/BaseConstants.ets](../jugglechat/base/src/main/ets/constants/BaseConstants.ets)
- 自适应视图模型：[jugglechat/base/src/main/ets/viewmodel/AdaptiveViewModel.ets](../jugglechat/base/src/main/ets/viewmodel/AdaptiveViewModel.ets)
- 基础图标/文本组件：`views/image`、`views/text`
- 日志工具：[jugglechat/base/src/main/ets/utils/Logger/Logger.ets](../jugglechat/base/src/main/ets/utils/Logger/Logger.ets)

### 设计思路
该模块充当 UI 基础设施层，降低 `home`、`socialCircle` 的重复实现。

## 4.3 `jugglechat/home` 模块

### 作用
聊天应用主业务模块，是业务展示层，不是底层 IM SDK。

### 页面结构
- 主入口：[jugglechat/home/src/main/ets/pages/Index.ets](../jugglechat/home/src/main/ets/pages/Index.ets)
- 会话列表：[jugglechat/home/src/main/ets/pages/ConversationList.ets](../jugglechat/home/src/main/ets/pages/ConversationList.ets)
- 会话详情：[jugglechat/home/src/main/ets/pages/ConversationDetail.ets](../jugglechat/home/src/main/ets/pages/ConversationDetail.ets)
- 联系人列表：[jugglechat/home/src/main/ets/pages/ContactsList.ets](../jugglechat/home/src/main/ets/pages/ContactsList.ets)
- 联系人详情：[jugglechat/home/src/main/ets/pages/ContactsDetail.ets](../jugglechat/home/src/main/ets/pages/ContactsDetail.ets)
- 我的页面：[jugglechat/home/src/main/ets/pages/MeDetail.ets](../jugglechat/home/src/main/ets/pages/MeDetail.ets)

### 主要职责
1. **初始化 IM SDK**
   - 在首页 `aboutToAppear` 中调用 `initJuggleIm(...)`
   - 文件：[jugglechat/home/src/main/ets/pages/Index.ets](../jugglechat/home/src/main/ets/pages/Index.ets)
   - 初始化封装在 [jugglechat/home/src/main/ets/jim/jimsdk.ets](../jugglechat/home/src/main/ets/jim/jimsdk.ets)

2. **会话展示与监听**
   - 页面监听 SDK 的会话新增/更新/删除事件
   - 本地分页拉取会话列表
   - 文件：[jugglechat/home/src/main/ets/pages/ConversationList.ets](../jugglechat/home/src/main/ets/pages/ConversationList.ets)

3. **消息详情展示与发送**
   - 读取历史消息
   - 监听实时新消息
   - 发送文本消息
   - 文件：[jugglechat/home/src/main/ets/pages/ConversationDetail.ets](../jugglechat/home/src/main/ets/pages/ConversationDetail.ets)

4. **联系人能力**
   - 通过业务 HTTP 接口获取好友列表
   - 点击联系人直接进入私聊会话页
   - 文件：[jugglechat/home/src/main/ets/pages/ContactsList.ets](../jugglechat/home/src/main/ets/pages/ContactsList.ets)

5. **个人页能力**
   - 展示当前账号基本信息
   - 提供好友验证、免打扰设置、语言设置、收藏等入口
   - 当前这些页面更多是 UI 壳或静态页

### 业务服务层
`home` 模块里还有一层与业务后台通信的 HTTP 封装：
- 登录：[jugglechat/home/src/main/ets/jim/jimserver/jimserver.ets](../jugglechat/home/src/main/ets/jim/jimserver/jimserver.ets)
- 用户信息：[jugglechat/home/src/main/ets/jim/jimserver/usermanager.ets](../jugglechat/home/src/main/ets/jim/jimserver/usermanager.ets)
- 好友列表：[jugglechat/home/src/main/ets/jim/jimserver/friendmanager.ets](../jugglechat/home/src/main/ets/jim/jimserver/friendmanager.ets)
- 本地鉴权缓存：[jugglechat/home/src/main/ets/jim/preferenceutil.ets](../jugglechat/home/src/main/ets/jim/preferenceutil.ets)

### 设计思路
`home` 模块采用明显的“UI 层 + 业务 HTTP 层 + IM SDK 层”分层：
- UI 页面只关心展示和交互
- 用户、好友、登录等走业务 HTTP 服务
- 会话、消息实时链路走 `juggleim`

## 4.4 `jugglechat/socialCircle` 模块

### 作用
社交圈/动态流示例模块。

### 现状
- 文件少，核心页面为 [jugglechat/socialCircle/src/main/ets/pages/Index.ets](../jugglechat/socialCircle/src/main/ets/pages/Index.ets)
- 当前主要是静态图文列表展示
- 没有看到与 IM、Call 或动态后端服务联动的核心实现

### 设计思路
更像 UI 演示模块，用于补齐产品形态，而不是承载核心聊天逻辑。

## 4.5 `juggleim` 模块

### 作用
这是项目最关键的 SDK 层，实现了 IM 通信、消息同步、本地存储和资料缓存。

### 目录职责
- `entries/`：实体、消息内容、命令消息、错误码、消息类型注册
- `imclients/`：WebSocket 连接客户端
- `improto/`：Protobuf 协议与生成代码
- `managers/`：连接、消息、会话、同步、用户资料、群资料管理器
- `dbs/`：关系数据库与 DAO
- `commons/`：工具、偏好存储、队列
- `resources/rawfile/`：数据库初始化 SQL

### 设计思路
- 对外暴露单例 `JuggleIm.instance`
- 通过 `ConnectionManager / MessageManager / ConversationManager / UserInfoManager / GroupInfoManager` 划分能力边界
- 底层 `ImClient` 专注协议收发
- `MsgSyncManager` 统一处理消息同步和通知下发
- `DAO + 本地 DB` 负责离线能力和启动恢复

## 5. 模块依赖关系

从根依赖配置可确认：
- `demo` 依赖 `base`、`home`、`juggleim`，见 [demo/oh-package.json5](../demo/oh-package.json5)
- `home` 依赖 `base`、`socialcircle`、`juggleim`，见 [jugglechat/home/oh-package.json5](../jugglechat/home/oh-package.json5)
- `socialCircle` 依赖 `base`，见 [jugglechat/socialCircle/oh-package.json5](../jugglechat/socialCircle/oh-package.json5)
- `juggleim` 独立依赖 protobuf/long，见 [juggleim/oh-package.json5](../juggleim/oh-package.json5)

可以概括为：
- `base` 是基础 UI 层
- `socialCircle` 是业务展示子模块
- `home` 是聊天业务主模块
- `juggleim` 是底层 IM 能力层
- `demo` 是总装应用

## 6. 项目主流程

### 6.1 登录到进入聊天
1. 打开 `demo` 登录页
2. 调用业务 HTTP 登录接口 `/jim/sms_login`
3. 获取 `authorization` 和 `im_token`
4. 把认证信息写入本地偏好
5. 进入 `Home` 页
6. `home` 模块初始化 `JuggleIm`
7. 用 `im_token` 建立 WebSocket IM 连接
8. 连接成功后开始同步会话和消息

### 6.2 查看会话
1. 首页初始化后，`ConversationList` 从本地 DB 分页拉取会话
2. 首次连接后 `MsgSyncManager` 执行 `sync_convers` 和 `sync_msgs`
3. 同步结果写入本地 DB
4. 通过 listener 反向通知 UI 更新

### 6.3 进入会话与发消息
1. 从会话列表或联系人页进入 `ConversationDetail`
2. 拉取本地历史消息，不足时回源远端历史
3. 输入文本后调用 `sendMessage`
4. 先写入本地数据库并更新会话
5. 走 WebSocket publish 发送
6. 收到 ack 后更新本地消息状态和服务端消息 ID

## 7. 其他不能漏掉的核心逻辑

### 7.1 协议层
- 长连接协议：[juggleim/src/main/ets/improto/imconnect.proto](../juggleim/src/main/ets/improto/imconnect.proto)
- 消息业务协议：[juggleim/src/main/ets/improto/immessage.proto](../juggleim/src/main/ets/improto/immessage.proto)

这两部分决定了 IM 的命令字、消息体和服务端交互方式，是核心逻辑而不是附属代码。

### 7.2 本地数据库初始化
- 管理器：[juggleim/src/main/ets/dbs/dbmanager.ets](../juggleim/src/main/ets/dbs/dbmanager.ets)
- 建表 SQL：[juggleim/src/main/resources/rawfile/202504011225.sql](../juggleim/src/main/resources/rawfile/202504011225.sql)

本地库中有：
- `messages`
- `conversations`
- `conversation_tags`
- `users`
- `groups`
- `group_members`
- `confs`

说明该 SDK 从设计上支持较完整的离线消息和资料缓存模型。

### 7.3 业务后台服务封装
虽然 IM 核心在 `juggleim`，但用户登录、好友关系、用户卡片信息在 `home/jim/jimserver` 中实现，这也是产品闭环必不可少的一部分。

## 8. 当前项目结论

### 8.1 已经比较明确的部分
- 是一个 HarmonyOS 多模块 IM 示例工程
- `juggleim` 是核心 IM SDK
- `home` 是聊天业务 UI 层
- `demo` 是整合运行入口
- `socialCircle` 是附属展示模块

### 8.2 当前工程成熟度判断
- **IM 基础能力已具备雏形且可运行**：连接、收发消息、会话同步、本地持久化、资料缓存都已落地
- **应用层功能以单聊展示为主**：联系人、会话、消息详情、个人页已接通基础流程
- **还有不少预留接口未完成**：例如草稿、搜索、已读回执、媒体消息发送等
- **Call 没有真正实现**：仓库没有独立音视频通话 SDK / manager / UI / RTC 引擎接入，只在协议字段中看到少量 RTC 预留字段

## 9. 推荐阅读顺序

如果要快速理解项目，建议按下面顺序读：
1. [oh-package.json5](../oh-package.json5)
2. [demo/src/main/ets/pages/Index.ets](../demo/src/main/ets/pages/Index.ets)
3. [jugglechat/home/src/main/ets/pages/Index.ets](../jugglechat/home/src/main/ets/pages/Index.ets)
4. [jugglechat/home/src/main/ets/jim/jimsdk.ets](../jugglechat/home/src/main/ets/jim/jimsdk.ets)
5. [juggleim/src/main/ets/juggleim.ets](../juggleim/src/main/ets/juggleim.ets)
6. [juggleim/src/main/ets/imclients/imclient.ets](../juggleim/src/main/ets/imclients/imclient.ets)
7. [juggleim/src/main/ets/managers/msgsyncmanager.ets](../juggleim/src/main/ets/managers/msgsyncmanager.ets)
8. [juggleim/src/main/ets/managers/messagemanager.ets](../juggleim/src/main/ets/managers/messagemanager.ets)
9. [juggleim/src/main/ets/managers/conversationmanager.ets](../juggleim/src/main/ets/managers/conversationmanager.ets)
10. [juggleim/src/main/resources/rawfile/202504011225.sql](../juggleim/src/main/resources/rawfile/202504011225.sql)
