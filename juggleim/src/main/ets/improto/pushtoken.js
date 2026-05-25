/*eslint-disable block-scoped-var, id-length, no-control-regex, no-magic-numbers, no-prototype-builtins, no-redeclare, no-shadow, no-var, sort-vars*/
import { index } from "@ohos/protobufjs";
const $protobuf = index;
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

const Platform = {
  DefaultPlatform: 0,
  Android: 1,
  iOS: 2,
  Web: 3,
  PC: 4
};

const PushChannel = {
  DefaultChannel: 0,
  Apple: 1,
  Huawei: 2,
  Xiaomi: 3,
  Oppo: 4,
  Vivo: 5,
  FCM: 6,
  JPush: 7
};

class RegPushTokenReq {
  deviceId = "";
  platform = 0;
  pushChannel = 0;
  pushToken = "";
  packageName = "";

  constructor(properties) {
    assignProperties(this, properties);
  }

  static create(properties) {
    return new RegPushTokenReq(properties);
  }

  static encode(message, writer) {
    if (!writer) {
      writer = $Writer.create();
    }
    if (message.deviceId != null && message.deviceId !== "") {
      writer.uint32(10).string(message.deviceId);
    }
    if (message.platform != null && message.platform !== 0) {
      writer.uint32(16).int32(message.platform);
    }
    if (message.pushChannel != null && message.pushChannel !== 0) {
      writer.uint32(24).int32(message.pushChannel);
    }
    if (message.pushToken != null && message.pushToken !== "") {
      writer.uint32(34).string(message.pushToken);
    }
    if (message.packageName != null && message.packageName !== "") {
      writer.uint32(42).string(message.packageName);
    }
    return writer;
  }

  static decode(reader, length) {
    if (!(reader instanceof $Reader)) {
      reader = $Reader.create(reader);
    }
    let end = length === undefined ? reader.len : reader.pos + length;
    let message = new RegPushTokenReq();
    while (reader.pos < end) {
      let tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          message.deviceId = reader.string();
          break;
        case 2:
          message.platform = reader.int32();
          break;
        case 3:
          message.pushChannel = reader.int32();
          break;
        case 4:
          message.pushToken = reader.string();
          break;
        case 5:
          message.packageName = reader.string();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return message;
  }
}

export const pushtoken = {
  Platform,
  PushChannel,
  RegPushTokenReq
};
