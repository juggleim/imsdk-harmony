import * as $protobuf from "@ohos/protobufjs";

export namespace pushtoken {
  enum Platform {
    DefaultPlatform = 0,
    Android = 1,
    iOS = 2,
    Web = 3,
    PC = 4
  }

  enum PushChannel {
    DefaultChannel = 0,
    Apple = 1,
    Huawei = 2,
    Xiaomi = 3,
    Oppo = 4,
    Vivo = 5,
    FCM = 6,
    JPush = 7
  }

  interface IRegPushTokenReq {
    deviceId?: string | null;
    platform?: Platform | null;
    pushChannel?: PushChannel | null;
    pushToken?: string | null;
    packageName?: string | null;
  }

  class RegPushTokenReq implements IRegPushTokenReq {
    constructor(properties?: IRegPushTokenReq);
    public deviceId: string;
    public platform: Platform;
    public pushChannel: PushChannel;
    public pushToken: string;
    public packageName: string;
    public static create(properties?: IRegPushTokenReq): RegPushTokenReq;
    public static encode(message: IRegPushTokenReq, writer?: $protobuf.Writer): $protobuf.Writer;
    public static decode(reader: $protobuf.Reader | Uint8Array, length?: number): RegPushTokenReq;
  }
}
