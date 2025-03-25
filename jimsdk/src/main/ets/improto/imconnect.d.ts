import * as $protobuf from "@ohos/protobufjs";
import Long = require("long");
/** Namespace imconnect. */
export namespace imconnect {

    /** Properties of a ConnectMsgBody. */
    interface IConnectMsgBody {

        /** ConnectMsgBody protoId */
        protoId?: (string|null);

        /** ConnectMsgBody sdkVersion */
        sdkVersion?: (string|null);

        /** ConnectMsgBody appkey */
        appkey?: (string|null);

        /** ConnectMsgBody token */
        token?: (string|null);

        /** ConnectMsgBody deviceId */
        deviceId?: (string|null);

        /** ConnectMsgBody platform */
        platform?: (string|null);

        /** ConnectMsgBody deviceCompany */
        deviceCompany?: (string|null);

        /** ConnectMsgBody deviceModel */
        deviceModel?: (string|null);

        /** ConnectMsgBody deviceOsVersion */
        deviceOsVersion?: (string|null);

        /** ConnectMsgBody pushToken */
        pushToken?: (string|null);

        /** ConnectMsgBody networkId */
        networkId?: (string|null);

        /** ConnectMsgBody ispNum */
        ispNum?: (string|null);

        /** ConnectMsgBody clientIp */
        clientIp?: (string|null);

        /** ConnectMsgBody packageName */
        packageName?: (string|null);

        /** ConnectMsgBody pushChannel */
        pushChannel?: (string|null);

        /** ConnectMsgBody ext */
        ext?: (string|null);

        /** ConnectMsgBody instanceId */
        instanceId?: (string|null);

        /** ConnectMsgBody language */
        language?: (string|null);

        /** ConnectMsgBody isBackend */
        isBackend?: (boolean|null);

        /** ConnectMsgBody voipToken */
        voipToken?: (string|null);
    }

    /** Represents a ConnectMsgBody. */
    class ConnectMsgBody implements IConnectMsgBody {

        /**
         * Constructs a new ConnectMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IConnectMsgBody);

        /** ConnectMsgBody protoId. */
        public protoId: string;

        /** ConnectMsgBody sdkVersion. */
        public sdkVersion: string;

        /** ConnectMsgBody appkey. */
        public appkey: string;

        /** ConnectMsgBody token. */
        public token: string;

        /** ConnectMsgBody deviceId. */
        public deviceId: string;

        /** ConnectMsgBody platform. */
        public platform: string;

        /** ConnectMsgBody deviceCompany. */
        public deviceCompany: string;

        /** ConnectMsgBody deviceModel. */
        public deviceModel: string;

        /** ConnectMsgBody deviceOsVersion. */
        public deviceOsVersion: string;

        /** ConnectMsgBody pushToken. */
        public pushToken: string;

        /** ConnectMsgBody networkId. */
        public networkId: string;

        /** ConnectMsgBody ispNum. */
        public ispNum: string;

        /** ConnectMsgBody clientIp. */
        public clientIp: string;

        /** ConnectMsgBody packageName. */
        public packageName: string;

        /** ConnectMsgBody pushChannel. */
        public pushChannel: string;

        /** ConnectMsgBody ext. */
        public ext: string;

        /** ConnectMsgBody instanceId. */
        public instanceId: string;

        /** ConnectMsgBody language. */
        public language: string;

        /** ConnectMsgBody isBackend. */
        public isBackend: boolean;

        /** ConnectMsgBody voipToken. */
        public voipToken: string;

        /**
         * Creates a new ConnectMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ConnectMsgBody instance
         */
        public static create(properties?: imconnect.IConnectMsgBody): imconnect.ConnectMsgBody;

        /**
         * Encodes the specified ConnectMsgBody message. Does not implicitly {@link imconnect.ConnectMsgBody.verify|verify} messages.
         * @param message ConnectMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IConnectMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ConnectMsgBody message, length delimited. Does not implicitly {@link imconnect.ConnectMsgBody.verify|verify} messages.
         * @param message ConnectMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IConnectMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ConnectMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ConnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.ConnectMsgBody;

        /**
         * Decodes a ConnectMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ConnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.ConnectMsgBody;

        /**
         * Verifies a ConnectMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ConnectMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ConnectMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.ConnectMsgBody;

        /**
         * Creates a plain object from a ConnectMsgBody message. Also converts values to other types if specified.
         * @param message ConnectMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.ConnectMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ConnectMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ConnectMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ConnectAckMsgBody. */
    interface IConnectAckMsgBody {

        /** ConnectAckMsgBody code */
        code?: (number|null);

        /** ConnectAckMsgBody userId */
        userId?: (string|null);

        /** ConnectAckMsgBody session */
        session?: (string|null);

        /** ConnectAckMsgBody timestamp */
        timestamp?: (number|Long|null);

        /** ConnectAckMsgBody ext */
        ext?: (string|null);
    }

    /** Represents a ConnectAckMsgBody. */
    class ConnectAckMsgBody implements IConnectAckMsgBody {

        /**
         * Constructs a new ConnectAckMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IConnectAckMsgBody);

        /** ConnectAckMsgBody code. */
        public code: number;

        /** ConnectAckMsgBody userId. */
        public userId: string;

        /** ConnectAckMsgBody session. */
        public session: string;

        /** ConnectAckMsgBody timestamp. */
        public timestamp: (number|Long);

        /** ConnectAckMsgBody ext. */
        public ext: string;

        /**
         * Creates a new ConnectAckMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ConnectAckMsgBody instance
         */
        public static create(properties?: imconnect.IConnectAckMsgBody): imconnect.ConnectAckMsgBody;

        /**
         * Encodes the specified ConnectAckMsgBody message. Does not implicitly {@link imconnect.ConnectAckMsgBody.verify|verify} messages.
         * @param message ConnectAckMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IConnectAckMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ConnectAckMsgBody message, length delimited. Does not implicitly {@link imconnect.ConnectAckMsgBody.verify|verify} messages.
         * @param message ConnectAckMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IConnectAckMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ConnectAckMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ConnectAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.ConnectAckMsgBody;

        /**
         * Decodes a ConnectAckMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ConnectAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.ConnectAckMsgBody;

        /**
         * Verifies a ConnectAckMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ConnectAckMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ConnectAckMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.ConnectAckMsgBody;

        /**
         * Creates a plain object from a ConnectAckMsgBody message. Also converts values to other types if specified.
         * @param message ConnectAckMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.ConnectAckMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ConnectAckMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ConnectAckMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a DisconnectMsgBody. */
    interface IDisconnectMsgBody {

        /** DisconnectMsgBody code */
        code?: (number|null);

        /** DisconnectMsgBody timestamp */
        timestamp?: (number|Long|null);

        /** DisconnectMsgBody ext */
        ext?: (string|null);
    }

    /** Represents a DisconnectMsgBody. */
    class DisconnectMsgBody implements IDisconnectMsgBody {

        /**
         * Constructs a new DisconnectMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IDisconnectMsgBody);

        /** DisconnectMsgBody code. */
        public code: number;

        /** DisconnectMsgBody timestamp. */
        public timestamp: (number|Long);

        /** DisconnectMsgBody ext. */
        public ext: string;

        /**
         * Creates a new DisconnectMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns DisconnectMsgBody instance
         */
        public static create(properties?: imconnect.IDisconnectMsgBody): imconnect.DisconnectMsgBody;

        /**
         * Encodes the specified DisconnectMsgBody message. Does not implicitly {@link imconnect.DisconnectMsgBody.verify|verify} messages.
         * @param message DisconnectMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IDisconnectMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified DisconnectMsgBody message, length delimited. Does not implicitly {@link imconnect.DisconnectMsgBody.verify|verify} messages.
         * @param message DisconnectMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IDisconnectMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a DisconnectMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns DisconnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.DisconnectMsgBody;

        /**
         * Decodes a DisconnectMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns DisconnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.DisconnectMsgBody;

        /**
         * Verifies a DisconnectMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a DisconnectMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns DisconnectMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.DisconnectMsgBody;

        /**
         * Creates a plain object from a DisconnectMsgBody message. Also converts values to other types if specified.
         * @param message DisconnectMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.DisconnectMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this DisconnectMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for DisconnectMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a PublishMsgBody. */
    interface IPublishMsgBody {

        /** PublishMsgBody index */
        index?: (number|null);

        /** PublishMsgBody topic */
        topic?: (string|null);

        /** PublishMsgBody targetId */
        targetId?: (string|null);

        /** PublishMsgBody timestamp */
        timestamp?: (number|Long|null);

        /** PublishMsgBody data */
        data?: (Uint8Array|null);
    }

    /** Represents a PublishMsgBody. */
    class PublishMsgBody implements IPublishMsgBody {

        /**
         * Constructs a new PublishMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IPublishMsgBody);

        /** PublishMsgBody index. */
        public index: number;

        /** PublishMsgBody topic. */
        public topic: string;

        /** PublishMsgBody targetId. */
        public targetId: string;

        /** PublishMsgBody timestamp. */
        public timestamp: (number|Long);

        /** PublishMsgBody data. */
        public data: Uint8Array;

        /**
         * Creates a new PublishMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns PublishMsgBody instance
         */
        public static create(properties?: imconnect.IPublishMsgBody): imconnect.PublishMsgBody;

        /**
         * Encodes the specified PublishMsgBody message. Does not implicitly {@link imconnect.PublishMsgBody.verify|verify} messages.
         * @param message PublishMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IPublishMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified PublishMsgBody message, length delimited. Does not implicitly {@link imconnect.PublishMsgBody.verify|verify} messages.
         * @param message PublishMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IPublishMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a PublishMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns PublishMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.PublishMsgBody;

        /**
         * Decodes a PublishMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns PublishMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.PublishMsgBody;

        /**
         * Verifies a PublishMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a PublishMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns PublishMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.PublishMsgBody;

        /**
         * Creates a plain object from a PublishMsgBody message. Also converts values to other types if specified.
         * @param message PublishMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.PublishMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this PublishMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for PublishMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a PublishAckMsgBody. */
    interface IPublishAckMsgBody {

        /** PublishAckMsgBody index */
        index?: (number|null);

        /** PublishAckMsgBody code */
        code?: (number|null);

        /** PublishAckMsgBody msgId */
        msgId?: (string|null);

        /** PublishAckMsgBody timestamp */
        timestamp?: (number|Long|null);

        /** PublishAckMsgBody msgSeqNo */
        msgSeqNo?: (number|Long|null);

        /** PublishAckMsgBody memberCount */
        memberCount?: (number|null);

        /** PublishAckMsgBody clientMsgId */
        clientMsgId?: (string|null);

        /** PublishAckMsgBody modifiedMsg */
        modifiedMsg?: (imconnect.ISimplifiedDownMsg|null);
    }

    /** Represents a PublishAckMsgBody. */
    class PublishAckMsgBody implements IPublishAckMsgBody {

        /**
         * Constructs a new PublishAckMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IPublishAckMsgBody);

        /** PublishAckMsgBody index. */
        public index: number;

        /** PublishAckMsgBody code. */
        public code: number;

        /** PublishAckMsgBody msgId. */
        public msgId: string;

        /** PublishAckMsgBody timestamp. */
        public timestamp: (number|Long);

        /** PublishAckMsgBody msgSeqNo. */
        public msgSeqNo: (number|Long);

        /** PublishAckMsgBody memberCount. */
        public memberCount: number;

        /** PublishAckMsgBody clientMsgId. */
        public clientMsgId: string;

        /** PublishAckMsgBody modifiedMsg. */
        public modifiedMsg?: (imconnect.ISimplifiedDownMsg|null);

        /**
         * Creates a new PublishAckMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns PublishAckMsgBody instance
         */
        public static create(properties?: imconnect.IPublishAckMsgBody): imconnect.PublishAckMsgBody;

        /**
         * Encodes the specified PublishAckMsgBody message. Does not implicitly {@link imconnect.PublishAckMsgBody.verify|verify} messages.
         * @param message PublishAckMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IPublishAckMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified PublishAckMsgBody message, length delimited. Does not implicitly {@link imconnect.PublishAckMsgBody.verify|verify} messages.
         * @param message PublishAckMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IPublishAckMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a PublishAckMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns PublishAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.PublishAckMsgBody;

        /**
         * Decodes a PublishAckMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns PublishAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.PublishAckMsgBody;

        /**
         * Verifies a PublishAckMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a PublishAckMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns PublishAckMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.PublishAckMsgBody;

        /**
         * Creates a plain object from a PublishAckMsgBody message. Also converts values to other types if specified.
         * @param message PublishAckMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.PublishAckMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this PublishAckMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for PublishAckMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SimplifiedDownMsg. */
    interface ISimplifiedDownMsg {

        /** SimplifiedDownMsg msgType */
        msgType?: (string|null);

        /** SimplifiedDownMsg msgContent */
        msgContent?: (Uint8Array|null);
    }

    /** Represents a SimplifiedDownMsg. */
    class SimplifiedDownMsg implements ISimplifiedDownMsg {

        /**
         * Constructs a new SimplifiedDownMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.ISimplifiedDownMsg);

        /** SimplifiedDownMsg msgType. */
        public msgType: string;

        /** SimplifiedDownMsg msgContent. */
        public msgContent: Uint8Array;

        /**
         * Creates a new SimplifiedDownMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SimplifiedDownMsg instance
         */
        public static create(properties?: imconnect.ISimplifiedDownMsg): imconnect.SimplifiedDownMsg;

        /**
         * Encodes the specified SimplifiedDownMsg message. Does not implicitly {@link imconnect.SimplifiedDownMsg.verify|verify} messages.
         * @param message SimplifiedDownMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.ISimplifiedDownMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SimplifiedDownMsg message, length delimited. Does not implicitly {@link imconnect.SimplifiedDownMsg.verify|verify} messages.
         * @param message SimplifiedDownMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.ISimplifiedDownMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SimplifiedDownMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SimplifiedDownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.SimplifiedDownMsg;

        /**
         * Decodes a SimplifiedDownMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SimplifiedDownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.SimplifiedDownMsg;

        /**
         * Verifies a SimplifiedDownMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SimplifiedDownMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SimplifiedDownMsg
         */
        public static fromObject(object: { [k: string]: any }): imconnect.SimplifiedDownMsg;

        /**
         * Creates a plain object from a SimplifiedDownMsg message. Also converts values to other types if specified.
         * @param message SimplifiedDownMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.SimplifiedDownMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SimplifiedDownMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SimplifiedDownMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QueryMsgBody. */
    interface IQueryMsgBody {

        /** QueryMsgBody index */
        index?: (number|null);

        /** QueryMsgBody topic */
        topic?: (string|null);

        /** QueryMsgBody targetId */
        targetId?: (string|null);

        /** QueryMsgBody timestamp */
        timestamp?: (number|Long|null);

        /** QueryMsgBody data */
        data?: (Uint8Array|null);
    }

    /** Represents a QueryMsgBody. */
    class QueryMsgBody implements IQueryMsgBody {

        /**
         * Constructs a new QueryMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IQueryMsgBody);

        /** QueryMsgBody index. */
        public index: number;

        /** QueryMsgBody topic. */
        public topic: string;

        /** QueryMsgBody targetId. */
        public targetId: string;

        /** QueryMsgBody timestamp. */
        public timestamp: (number|Long);

        /** QueryMsgBody data. */
        public data: Uint8Array;

        /**
         * Creates a new QueryMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QueryMsgBody instance
         */
        public static create(properties?: imconnect.IQueryMsgBody): imconnect.QueryMsgBody;

        /**
         * Encodes the specified QueryMsgBody message. Does not implicitly {@link imconnect.QueryMsgBody.verify|verify} messages.
         * @param message QueryMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IQueryMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QueryMsgBody message, length delimited. Does not implicitly {@link imconnect.QueryMsgBody.verify|verify} messages.
         * @param message QueryMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IQueryMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QueryMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QueryMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.QueryMsgBody;

        /**
         * Decodes a QueryMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QueryMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.QueryMsgBody;

        /**
         * Verifies a QueryMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QueryMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QueryMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.QueryMsgBody;

        /**
         * Creates a plain object from a QueryMsgBody message. Also converts values to other types if specified.
         * @param message QueryMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.QueryMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QueryMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QueryMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QueryAckMsgBody. */
    interface IQueryAckMsgBody {

        /** QueryAckMsgBody index */
        index?: (number|null);

        /** QueryAckMsgBody code */
        code?: (number|null);

        /** QueryAckMsgBody timestamp */
        timestamp?: (number|Long|null);

        /** QueryAckMsgBody data */
        data?: (Uint8Array|null);
    }

    /** Represents a QueryAckMsgBody. */
    class QueryAckMsgBody implements IQueryAckMsgBody {

        /**
         * Constructs a new QueryAckMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IQueryAckMsgBody);

        /** QueryAckMsgBody index. */
        public index: number;

        /** QueryAckMsgBody code. */
        public code: number;

        /** QueryAckMsgBody timestamp. */
        public timestamp: (number|Long);

        /** QueryAckMsgBody data. */
        public data: Uint8Array;

        /**
         * Creates a new QueryAckMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QueryAckMsgBody instance
         */
        public static create(properties?: imconnect.IQueryAckMsgBody): imconnect.QueryAckMsgBody;

        /**
         * Encodes the specified QueryAckMsgBody message. Does not implicitly {@link imconnect.QueryAckMsgBody.verify|verify} messages.
         * @param message QueryAckMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IQueryAckMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QueryAckMsgBody message, length delimited. Does not implicitly {@link imconnect.QueryAckMsgBody.verify|verify} messages.
         * @param message QueryAckMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IQueryAckMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QueryAckMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QueryAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.QueryAckMsgBody;

        /**
         * Decodes a QueryAckMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QueryAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.QueryAckMsgBody;

        /**
         * Verifies a QueryAckMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QueryAckMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QueryAckMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.QueryAckMsgBody;

        /**
         * Creates a plain object from a QueryAckMsgBody message. Also converts values to other types if specified.
         * @param message QueryAckMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.QueryAckMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QueryAckMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QueryAckMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QueryConfirmMsgBody. */
    interface IQueryConfirmMsgBody {

        /** QueryConfirmMsgBody index */
        index?: (number|null);
    }

    /** Represents a QueryConfirmMsgBody. */
    class QueryConfirmMsgBody implements IQueryConfirmMsgBody {

        /**
         * Constructs a new QueryConfirmMsgBody.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IQueryConfirmMsgBody);

        /** QueryConfirmMsgBody index. */
        public index: number;

        /**
         * Creates a new QueryConfirmMsgBody instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QueryConfirmMsgBody instance
         */
        public static create(properties?: imconnect.IQueryConfirmMsgBody): imconnect.QueryConfirmMsgBody;

        /**
         * Encodes the specified QueryConfirmMsgBody message. Does not implicitly {@link imconnect.QueryConfirmMsgBody.verify|verify} messages.
         * @param message QueryConfirmMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IQueryConfirmMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QueryConfirmMsgBody message, length delimited. Does not implicitly {@link imconnect.QueryConfirmMsgBody.verify|verify} messages.
         * @param message QueryConfirmMsgBody message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IQueryConfirmMsgBody, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QueryConfirmMsgBody message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QueryConfirmMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.QueryConfirmMsgBody;

        /**
         * Decodes a QueryConfirmMsgBody message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QueryConfirmMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.QueryConfirmMsgBody;

        /**
         * Verifies a QueryConfirmMsgBody message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QueryConfirmMsgBody message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QueryConfirmMsgBody
         */
        public static fromObject(object: { [k: string]: any }): imconnect.QueryConfirmMsgBody;

        /**
         * Creates a plain object from a QueryConfirmMsgBody message. Also converts values to other types if specified.
         * @param message QueryConfirmMsgBody
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.QueryConfirmMsgBody, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QueryConfirmMsgBody to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QueryConfirmMsgBody
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an ImWebsocketMsg. */
    interface IImWebsocketMsg {

        /** ImWebsocketMsg version */
        version?: (number|null);

        /** ImWebsocketMsg cmd */
        cmd?: (number|null);

        /** ImWebsocketMsg qos */
        qos?: (number|null);

        /** ImWebsocketMsg payload */
        payload?: (Uint8Array|null);

        /** ImWebsocketMsg connectMsgBody */
        connectMsgBody?: (imconnect.IConnectMsgBody|null);

        /** ImWebsocketMsg ConnectAckMsgBody */
        ConnectAckMsgBody?: (imconnect.IConnectAckMsgBody|null);

        /** ImWebsocketMsg disconnectMsgBody */
        disconnectMsgBody?: (imconnect.IDisconnectMsgBody|null);

        /** ImWebsocketMsg publishMsgBody */
        publishMsgBody?: (imconnect.IPublishMsgBody|null);

        /** ImWebsocketMsg pubAckMsgBody */
        pubAckMsgBody?: (imconnect.IPublishAckMsgBody|null);

        /** ImWebsocketMsg qryMsgBody */
        qryMsgBody?: (imconnect.IQueryMsgBody|null);

        /** ImWebsocketMsg qryAckMsgBody */
        qryAckMsgBody?: (imconnect.IQueryAckMsgBody|null);

        /** ImWebsocketMsg qryConfirmMsgBody */
        qryConfirmMsgBody?: (imconnect.IQueryConfirmMsgBody|null);
    }

    /** Represents an ImWebsocketMsg. */
    class ImWebsocketMsg implements IImWebsocketMsg {

        /**
         * Constructs a new ImWebsocketMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: imconnect.IImWebsocketMsg);

        /** ImWebsocketMsg version. */
        public version: number;

        /** ImWebsocketMsg cmd. */
        public cmd: number;

        /** ImWebsocketMsg qos. */
        public qos: number;

        /** ImWebsocketMsg payload. */
        public payload: Uint8Array;

        /** ImWebsocketMsg connectMsgBody. */
        public connectMsgBody?: (imconnect.IConnectMsgBody|null);

        /** ImWebsocketMsg ConnectAckMsgBody. */
        public ConnectAckMsgBody?: (imconnect.IConnectAckMsgBody|null);

        /** ImWebsocketMsg disconnectMsgBody. */
        public disconnectMsgBody?: (imconnect.IDisconnectMsgBody|null);

        /** ImWebsocketMsg publishMsgBody. */
        public publishMsgBody?: (imconnect.IPublishMsgBody|null);

        /** ImWebsocketMsg pubAckMsgBody. */
        public pubAckMsgBody?: (imconnect.IPublishAckMsgBody|null);

        /** ImWebsocketMsg qryMsgBody. */
        public qryMsgBody?: (imconnect.IQueryMsgBody|null);

        /** ImWebsocketMsg qryAckMsgBody. */
        public qryAckMsgBody?: (imconnect.IQueryAckMsgBody|null);

        /** ImWebsocketMsg qryConfirmMsgBody. */
        public qryConfirmMsgBody?: (imconnect.IQueryConfirmMsgBody|null);

        /** ImWebsocketMsg testof. */
        public testof?: ("connectMsgBody"|"ConnectAckMsgBody"|"disconnectMsgBody"|"publishMsgBody"|"pubAckMsgBody"|"qryMsgBody"|"qryAckMsgBody"|"qryConfirmMsgBody");

        /**
         * Creates a new ImWebsocketMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ImWebsocketMsg instance
         */
        public static create(properties?: imconnect.IImWebsocketMsg): imconnect.ImWebsocketMsg;

        /**
         * Encodes the specified ImWebsocketMsg message. Does not implicitly {@link imconnect.ImWebsocketMsg.verify|verify} messages.
         * @param message ImWebsocketMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: imconnect.IImWebsocketMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ImWebsocketMsg message, length delimited. Does not implicitly {@link imconnect.ImWebsocketMsg.verify|verify} messages.
         * @param message ImWebsocketMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: imconnect.IImWebsocketMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an ImWebsocketMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ImWebsocketMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): imconnect.ImWebsocketMsg;

        /**
         * Decodes an ImWebsocketMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ImWebsocketMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): imconnect.ImWebsocketMsg;

        /**
         * Verifies an ImWebsocketMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an ImWebsocketMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ImWebsocketMsg
         */
        public static fromObject(object: { [k: string]: any }): imconnect.ImWebsocketMsg;

        /**
         * Creates a plain object from an ImWebsocketMsg message. Also converts values to other types if specified.
         * @param message ImWebsocketMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: imconnect.ImWebsocketMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ImWebsocketMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ImWebsocketMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }
}
