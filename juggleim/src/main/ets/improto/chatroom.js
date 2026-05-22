/*eslint-disable block-scoped-var, id-length, no-control-regex, no-magic-numbers, no-prototype-builtins, no-redeclare, no-shadow, no-var, sort-vars*/
import { index } from "@ohos/protobufjs";
const $protobuf = index;
import Long from 'long';
import { immessage } from './immessage.js';
$protobuf.util.Long = Long;
$protobuf.configure();

const $Reader = $protobuf.Reader;
const $Writer = $protobuf.Writer;

function assignProperties(target, properties) {
  if (!properties) {
    return;
  }
  let keys = Object.keys(properties);
  for (let i = 0; i < keys.length; i++) {
    let key = keys[i];
    if (properties[key] != null) {
      target[key] = properties[key];
    }
  }
}

class SyncChatroomReq {
  chatroomId = "";
  syncTime = 0;
  count = 0;

  constructor(properties) {
    assignProperties(this, properties);
  }

  static create(properties) {
    return new SyncChatroomReq(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.chatroomId != null && message.chatroomId !== "") {
      writer.uint32(10).string(message.chatroomId);
    }
    if (message.syncTime != null && message.syncTime !== 0) {
      writer.uint32(16).int64(message.syncTime);
    }
    if (message.count != null && message.count !== 0) {
      writer.uint32(24).int32(message.count);
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new SyncChatroomReq();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.chatroomId = reader.string();
          break;
        case 2:
          message.syncTime = reader.int64();
          break;
        case 3:
          message.count = reader.int32();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

class SyncChatroomMsgResp {
  msgs = [];

  constructor(properties) {
    this.msgs = [];
    assignProperties(this, properties);
  }

  static create(properties) {
    return new SyncChatroomMsgResp(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.msgs != null && message.msgs.length > 0) {
      for (let i = 0; i < message.msgs.length; i++) {
        immessage.DownMsg.encode(message.msgs[i], writer.uint32(10).fork()).ldelim();
      }
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new SyncChatroomMsgResp();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (!(message.msgs && message.msgs.length)) {
            message.msgs = [];
          }
          message.msgs.push(immessage.DownMsg.decode(reader, reader.uint32()));
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

class ChatroomReq {
  chatId = "";
  chatName = "";
  isAutoCreate = false;

  constructor(properties) {
    assignProperties(this, properties);
  }

  static create(properties) {
    return new ChatroomReq(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.chatId != null && message.chatId !== "") {
      writer.uint32(10).string(message.chatId);
    }
    if (message.chatName != null && message.chatName !== "") {
      writer.uint32(18).string(message.chatName);
    }
    if (message.isAutoCreate != null && message.isAutoCreate === true) {
      writer.uint32(24).bool(message.isAutoCreate);
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new ChatroomReq();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.chatId = reader.string();
          break;
        case 2:
          message.chatName = reader.string();
          break;
        case 3:
          message.isAutoCreate = reader.bool();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

class ChatAttReq {
  key = "";
  value = "";
  isForce = false;
  isAutoDel = false;
  msg = null;

  constructor(properties) {
    assignProperties(this, properties);
  }

  static create(properties) {
    return new ChatAttReq(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.key != null && message.key !== "") {
      writer.uint32(10).string(message.key);
    }
    if (message.value != null && message.value !== "") {
      writer.uint32(18).string(message.value);
    }
    if (message.isForce != null && message.isForce === true) {
      writer.uint32(24).bool(message.isForce);
    }
    if (message.isAutoDel != null && message.isAutoDel === true) {
      writer.uint32(32).bool(message.isAutoDel);
    }
    if (message.msg != null) {
      immessage.UpMsg.encode(message.msg, writer.uint32(42).fork()).ldelim();
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new ChatAttReq();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string();
          break;
        case 2:
          message.value = reader.string();
          break;
        case 3:
          message.isForce = reader.bool();
          break;
        case 4:
          message.isAutoDel = reader.bool();
          break;
        case 5:
          message.msg = immessage.UpMsg.decode(reader, reader.uint32());
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

class ChatAttResp {
  key = "";
  code = 0;
  attTime = 0;
  msgCode = 0;
  msgId = "";
  msgTime = 0;
  msgSeq = 0;

  constructor(properties) {
    assignProperties(this, properties);
  }

  static create(properties) {
    return new ChatAttResp(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.key != null && message.key !== "") {
      writer.uint32(10).string(message.key);
    }
    if (message.code != null && message.code !== 0) {
      writer.uint32(16).int32(message.code);
    }
    if (message.attTime != null && message.attTime !== 0) {
      writer.uint32(24).int64(message.attTime);
    }
    if (message.msgCode != null && message.msgCode !== 0) {
      writer.uint32(88).int32(message.msgCode);
    }
    if (message.msgId != null && message.msgId !== "") {
      writer.uint32(98).string(message.msgId);
    }
    if (message.msgTime != null && message.msgTime !== 0) {
      writer.uint32(104).int64(message.msgTime);
    }
    if (message.msgSeq != null && message.msgSeq !== 0) {
      writer.uint32(112).int64(message.msgSeq);
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new ChatAttResp();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string();
          break;
        case 2:
          message.code = reader.int32();
          break;
        case 3:
          message.attTime = reader.int64();
          break;
        case 11:
          message.msgCode = reader.int32();
          break;
        case 12:
          message.msgId = reader.string();
          break;
        case 13:
          message.msgTime = reader.int64();
          break;
        case 14:
          message.msgSeq = reader.int64();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

class ChatAttBatchReq {
  atts = [];

  constructor(properties) {
    this.atts = [];
    assignProperties(this, properties);
  }

  static create(properties) {
    return new ChatAttBatchReq(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.atts != null && message.atts.length > 0) {
      for (let i = 0; i < message.atts.length; i++) {
        ChatAttReq.encode(message.atts[i], writer.uint32(10).fork()).ldelim();
      }
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new ChatAttBatchReq();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (!(message.atts && message.atts.length)) {
            message.atts = [];
          }
          message.atts.push(ChatAttReq.decode(reader, reader.uint32()));
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

class ChatAttBatchResp {
  attResps = [];

  constructor(properties) {
    this.attResps = [];
    assignProperties(this, properties);
  }

  static create(properties) {
    return new ChatAttBatchResp(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.attResps != null && message.attResps.length > 0) {
      for (let i = 0; i < message.attResps.length; i++) {
        ChatAttResp.encode(message.attResps[i], writer.uint32(10).fork()).ldelim();
      }
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new ChatAttBatchResp();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (!(message.attResps && message.attResps.length)) {
            message.attResps = [];
          }
          message.attResps.push(ChatAttResp.decode(reader, reader.uint32()));
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

const ChatAttOptType = {
  ChatAttOpt_Default: 0,
  ChatAttOpt_Add: 1,
  ChatAttOpt_Del: 2
};

class ChatAttItem {
  key = "";
  value = "";
  attTime = 0;
  userId = "";
  optType = 0;

  constructor(properties) {
    assignProperties(this, properties);
  }

  static create(properties) {
    return new ChatAttItem(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.key != null && message.key !== "") {
      writer.uint32(10).string(message.key);
    }
    if (message.value != null && message.value !== "") {
      writer.uint32(18).string(message.value);
    }
    if (message.attTime != null && message.attTime !== 0) {
      writer.uint32(24).int64(message.attTime);
    }
    if (message.userId != null && message.userId !== "") {
      writer.uint32(34).string(message.userId);
    }
    if (message.optType != null && message.optType !== 0) {
      writer.uint32(40).int32(message.optType);
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new ChatAttItem();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.key = reader.string();
          break;
        case 2:
          message.value = reader.string();
          break;
        case 3:
          message.attTime = reader.int64();
          break;
        case 4:
          message.userId = reader.string();
          break;
        case 5:
          message.optType = reader.int32();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

class SyncChatroomAttResp {
  atts = [];

  constructor(properties) {
    this.atts = [];
    assignProperties(this, properties);
  }

  static create(properties) {
    return new SyncChatroomAttResp(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.atts != null && message.atts.length > 0) {
      for (let i = 0; i < message.atts.length; i++) {
        ChatAttItem.encode(message.atts[i], writer.uint32(10).fork()).ldelim();
      }
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new SyncChatroomAttResp();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (!(message.atts && message.atts.length)) {
            message.atts = [];
          }
          message.atts.push(ChatAttItem.decode(reader, reader.uint32()));
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

const ChrmEventType = {
  Join: 0,
  Quit: 1,
  Kick: 2,
  Fallout: 3
};

class ChrmEvent {
  eventType = 0;
  chatId = "";
  userId = "";
  eventTime = 0;

  constructor(properties) {
    assignProperties(this, properties);
  }

  static create(properties) {
    return new ChrmEvent(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.eventType != null && message.eventType !== 0) {
      writer.uint32(8).int32(message.eventType);
    }
    if (message.chatId != null && message.chatId !== "") {
      writer.uint32(18).string(message.chatId);
    }
    if (message.userId != null && message.userId !== "") {
      writer.uint32(26).string(message.userId);
    }
    if (message.eventTime != null && message.eventTime !== 0) {
      writer.uint32(32).int64(message.eventTime);
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new ChrmEvent();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.eventType = reader.int32();
          break;
        case 2:
          message.chatId = reader.string();
          break;
        case 3:
          message.userId = reader.string();
          break;
        case 4:
          message.eventTime = reader.int64();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

export const chatroom = {
  SyncChatroomReq,
  SyncChatroomMsgResp,
  SyncChatroomAttResp,
  ChatroomReq,
  ChatAttReq,
  ChatAttResp,
  ChatAttBatchReq,
  ChatAttBatchResp,
  ChatAttItem,
  ChatAttOptType,
  ChrmEventType,
  ChrmEvent
};
