import * as $protobuf from "@ohos/protobufjs";
import Long from "long";

export namespace chatroom {
  interface ISyncChatroomReq {
    chatroomId?: string | null;
    syncTime?: number | Long | null;
    count?: number | null;
  }

  class SyncChatroomReq implements ISyncChatroomReq {
    constructor(properties?: ISyncChatroomReq);
    public chatroomId: string;
    public syncTime: number | Long;
    public count: number;
    public static create(properties?: ISyncChatroomReq): SyncChatroomReq;
    public static encode(message: ISyncChatroomReq, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): SyncChatroomReq;
  }

  interface ISyncChatroomMsgResp {
    msgs?: any[] | null;
  }

  class SyncChatroomMsgResp implements ISyncChatroomMsgResp {
    constructor(properties?: ISyncChatroomMsgResp);
    public msgs: any[];
    public static create(properties?: ISyncChatroomMsgResp): SyncChatroomMsgResp;
    public static encode(message: ISyncChatroomMsgResp, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): SyncChatroomMsgResp;
  }

  interface IChatroomReq {
    chatId?: string | null;
    chatName?: string | null;
    isAutoCreate?: boolean | null;
  }

  class ChatroomReq implements IChatroomReq {
    constructor(properties?: IChatroomReq);
    public chatId: string;
    public chatName: string;
    public isAutoCreate: boolean;
    public static create(properties?: IChatroomReq): ChatroomReq;
    public static encode(message: IChatroomReq, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): ChatroomReq;
  }

  interface IChatAttReq {
    key?: string | null;
    value?: string | null;
    isForce?: boolean | null;
    isAutoDel?: boolean | null;
    msg?: any | null;
  }

  class ChatAttReq implements IChatAttReq {
    constructor(properties?: IChatAttReq);
    public key: string;
    public value: string;
    public isForce: boolean;
    public isAutoDel: boolean;
    public msg: any | null;
    public static create(properties?: IChatAttReq): ChatAttReq;
    public static encode(message: IChatAttReq, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): ChatAttReq;
  }

  interface IChatAttResp {
    key?: string | null;
    code?: number | null;
    attTime?: number | Long | null;
    msgCode?: number | null;
    msgId?: string | null;
    msgTime?: number | Long | null;
    msgSeq?: number | Long | null;
  }

  class ChatAttResp implements IChatAttResp {
    constructor(properties?: IChatAttResp);
    public key: string;
    public code: number;
    public attTime: number | Long;
    public msgCode: number;
    public msgId: string;
    public msgTime: number | Long;
    public msgSeq: number | Long;
    public static create(properties?: IChatAttResp): ChatAttResp;
    public static encode(message: IChatAttResp, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): ChatAttResp;
  }

  interface IChatAttBatchReq {
    atts?: IChatAttReq[] | null;
  }

  class ChatAttBatchReq implements IChatAttBatchReq {
    constructor(properties?: IChatAttBatchReq);
    public atts: IChatAttReq[];
    public static create(properties?: IChatAttBatchReq): ChatAttBatchReq;
    public static encode(message: IChatAttBatchReq, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): ChatAttBatchReq;
  }

  interface IChatAttBatchResp {
    attResps?: IChatAttResp[] | null;
  }

  class ChatAttBatchResp implements IChatAttBatchResp {
    constructor(properties?: IChatAttBatchResp);
    public attResps: IChatAttResp[];
    public static create(properties?: IChatAttBatchResp): ChatAttBatchResp;
    public static encode(message: IChatAttBatchResp, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): ChatAttBatchResp;
  }

  enum ChatAttOptType {
    ChatAttOpt_Default = 0,
    ChatAttOpt_Add = 1,
    ChatAttOpt_Del = 2
  }

  interface IChatAttItem {
    key?: string | null;
    value?: string | null;
    attTime?: number | Long | null;
    userId?: string | null;
    optType?: ChatAttOptType | null;
  }

  class ChatAttItem implements IChatAttItem {
    constructor(properties?: IChatAttItem);
    public key: string;
    public value: string;
    public attTime: number | Long;
    public userId: string;
    public optType: ChatAttOptType;
    public static create(properties?: IChatAttItem): ChatAttItem;
    public static encode(message: IChatAttItem, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): ChatAttItem;
  }

  interface ISyncChatroomAttResp {
    atts?: IChatAttItem[] | null;
  }

  class SyncChatroomAttResp implements ISyncChatroomAttResp {
    constructor(properties?: ISyncChatroomAttResp);
    public atts: IChatAttItem[];
    public static create(properties?: ISyncChatroomAttResp): SyncChatroomAttResp;
    public static encode(message: ISyncChatroomAttResp, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): SyncChatroomAttResp;
  }

  enum ChrmEventType {
    Join = 0,
    Quit = 1,
    Kick = 2,
    Fallout = 3
  }

  interface IChrmEvent {
    eventType?: ChrmEventType | null;
    chatId?: string | null;
    userId?: string | null;
    eventTime?: number | Long | null;
  }

  class ChrmEvent implements IChrmEvent {
    constructor(properties?: IChrmEvent);
    public eventType: ChrmEventType;
    public chatId: string;
    public userId: string;
    public eventTime: number | Long;
    public static create(properties?: IChrmEvent): ChrmEvent;
    public static encode(message: IChrmEvent, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): ChrmEvent;
  }
}
