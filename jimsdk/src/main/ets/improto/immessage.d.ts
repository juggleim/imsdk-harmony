import * as $protobuf from "@ohos/protobufjs";
import Long = require("long");
/** Namespace immessage. */
export namespace immessage {

    /** Properties of a Nil. */
    interface INil {
    }

    /** Represents a Nil. */
    class Nil implements INil {

        /**
         * Constructs a new Nil.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.INil);

        /**
         * Creates a new Nil instance using the specified properties.
         * @param [properties] Properties to set
         * @returns Nil instance
         */
        public static create(properties?: immessage.INil): immessage.Nil;

        /**
         * Encodes the specified Nil message. Does not implicitly {@link immessage.Nil.verify|verify} messages.
         * @param message Nil message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.INil, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified Nil message, length delimited. Does not implicitly {@link immessage.Nil.verify|verify} messages.
         * @param message Nil message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.INil, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a Nil message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns Nil
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.Nil;

        /**
         * Decodes a Nil message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns Nil
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.Nil;

        /**
         * Verifies a Nil message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a Nil message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns Nil
         */
        public static fromObject(object: { [k: string]: any }): immessage.Nil;

        /**
         * Creates a plain object from a Nil message. Also converts values to other types if specified.
         * @param message Nil
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.Nil, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this Nil to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for Nil
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an UpMsg. */
    interface IUpMsg {

        /** UpMsg msgType */
        msgType?: (string|null);

        /** UpMsg msgContent */
        msgContent?: (Uint8Array|null);

        /** UpMsg flags */
        flags?: (number|null);

        /** UpMsg clientUid */
        clientUid?: (string|null);

        /** UpMsg pushData */
        pushData?: (immessage.IPushData|null);

        /** UpMsg mentionInfo */
        mentionInfo?: (immessage.IMentionInfo|null);

        /** UpMsg referMsg */
        referMsg?: (immessage.IDownMsg|null);

        /** UpMsg toUserIds */
        toUserIds?: (string[]|null);

        /** UpMsg mergedMsgs */
        mergedMsgs?: (immessage.IMergedMsgs|null);

        /** UpMsg SearchText */
        SearchText?: (string|null);

        /** UpMsg msgTime */
        msgTime?: (number|Long|null);
    }

    /** Represents an UpMsg. */
    class UpMsg implements IUpMsg {

        /**
         * Constructs a new UpMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUpMsg);

        /** UpMsg msgType. */
        public msgType: string;

        /** UpMsg msgContent. */
        public msgContent: Uint8Array;

        /** UpMsg flags. */
        public flags: number;

        /** UpMsg clientUid. */
        public clientUid: string;

        /** UpMsg pushData. */
        public pushData?: (immessage.IPushData|null);

        /** UpMsg mentionInfo. */
        public mentionInfo?: (immessage.IMentionInfo|null);

        /** UpMsg referMsg. */
        public referMsg?: (immessage.IDownMsg|null);

        /** UpMsg toUserIds. */
        public toUserIds: string[];

        /** UpMsg mergedMsgs. */
        public mergedMsgs?: (immessage.IMergedMsgs|null);

        /** UpMsg SearchText. */
        public SearchText: string;

        /** UpMsg msgTime. */
        public msgTime: (number|Long);

        /**
         * Creates a new UpMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UpMsg instance
         */
        public static create(properties?: immessage.IUpMsg): immessage.UpMsg;

        /**
         * Encodes the specified UpMsg message. Does not implicitly {@link immessage.UpMsg.verify|verify} messages.
         * @param message UpMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUpMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UpMsg message, length delimited. Does not implicitly {@link immessage.UpMsg.verify|verify} messages.
         * @param message UpMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUpMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an UpMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UpMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UpMsg;

        /**
         * Decodes an UpMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UpMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UpMsg;

        /**
         * Verifies an UpMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an UpMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UpMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.UpMsg;

        /**
         * Creates a plain object from an UpMsg message. Also converts values to other types if specified.
         * @param message UpMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UpMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UpMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UpMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MergedMsgs. */
    interface IMergedMsgs {

        /** MergedMsgs channelType */
        channelType?: (immessage.ChannelType|null);

        /** MergedMsgs userId */
        userId?: (string|null);

        /** MergedMsgs targetId */
        targetId?: (string|null);

        /** MergedMsgs msgs */
        msgs?: (immessage.ISimpleMsg[]|null);
    }

    /** Represents a MergedMsgs. */
    class MergedMsgs implements IMergedMsgs {

        /**
         * Constructs a new MergedMsgs.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMergedMsgs);

        /** MergedMsgs channelType. */
        public channelType: immessage.ChannelType;

        /** MergedMsgs userId. */
        public userId: string;

        /** MergedMsgs targetId. */
        public targetId: string;

        /** MergedMsgs msgs. */
        public msgs: immessage.ISimpleMsg[];

        /**
         * Creates a new MergedMsgs instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MergedMsgs instance
         */
        public static create(properties?: immessage.IMergedMsgs): immessage.MergedMsgs;

        /**
         * Encodes the specified MergedMsgs message. Does not implicitly {@link immessage.MergedMsgs.verify|verify} messages.
         * @param message MergedMsgs message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMergedMsgs, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MergedMsgs message, length delimited. Does not implicitly {@link immessage.MergedMsgs.verify|verify} messages.
         * @param message MergedMsgs message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMergedMsgs, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MergedMsgs message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MergedMsgs
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MergedMsgs;

        /**
         * Decodes a MergedMsgs message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MergedMsgs
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MergedMsgs;

        /**
         * Verifies a MergedMsgs message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MergedMsgs message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MergedMsgs
         */
        public static fromObject(object: { [k: string]: any }): immessage.MergedMsgs;

        /**
         * Creates a plain object from a MergedMsgs message. Also converts values to other types if specified.
         * @param message MergedMsgs
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MergedMsgs, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MergedMsgs to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MergedMsgs
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MentionInfo. */
    interface IMentionInfo {

        /** MentionInfo mentionType */
        mentionType?: (immessage.MentionType|null);

        /** MentionInfo targetUsers */
        targetUsers?: (immessage.IUserInfo[]|null);
    }

    /** Represents a MentionInfo. */
    class MentionInfo implements IMentionInfo {

        /**
         * Constructs a new MentionInfo.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMentionInfo);

        /** MentionInfo mentionType. */
        public mentionType: immessage.MentionType;

        /** MentionInfo targetUsers. */
        public targetUsers: immessage.IUserInfo[];

        /**
         * Creates a new MentionInfo instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MentionInfo instance
         */
        public static create(properties?: immessage.IMentionInfo): immessage.MentionInfo;

        /**
         * Encodes the specified MentionInfo message. Does not implicitly {@link immessage.MentionInfo.verify|verify} messages.
         * @param message MentionInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMentionInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MentionInfo message, length delimited. Does not implicitly {@link immessage.MentionInfo.verify|verify} messages.
         * @param message MentionInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMentionInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MentionInfo message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MentionInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MentionInfo;

        /**
         * Decodes a MentionInfo message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MentionInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MentionInfo;

        /**
         * Verifies a MentionInfo message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MentionInfo message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MentionInfo
         */
        public static fromObject(object: { [k: string]: any }): immessage.MentionInfo;

        /**
         * Creates a plain object from a MentionInfo message. Also converts values to other types if specified.
         * @param message MentionInfo
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MentionInfo, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MentionInfo to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MentionInfo
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** MentionType enum. */
    enum MentionType {
        MentionDefault = 0,
        All = 1,
        Someone = 2,
        AllAndSomeone = 3
    }

    /** Properties of a PushData. */
    interface IPushData {

        /** PushData title */
        title?: (string|null);

        /** PushData pushId */
        pushId?: (string|null);

        /** PushData pushText */
        pushText?: (string|null);

        /** PushData pushExtraData */
        pushExtraData?: (string|null);

        /** PushData pushLevel */
        pushLevel?: (immessage.PushLevel|null);

        /** PushData isVoip */
        isVoip?: (boolean|null);

        /** PushData badge */
        badge?: (number|null);

        /** PushData msgId */
        msgId?: (string|null);

        /** PushData senderId */
        senderId?: (string|null);

        /** PushData ConverId */
        ConverId?: (string|null);

        /** PushData channelType */
        channelType?: (immessage.ChannelType|null);

        /** PushData rtcRoomId */
        rtcRoomId?: (string|null);

        /** PushData rtcInviterId */
        rtcInviterId?: (string|null);

        /** PushData rtcRoomType */
        rtcRoomType?: (number|null);

        /** PushData rtcMediaType */
        rtcMediaType?: (number|null);
    }

    /** Represents a PushData. */
    class PushData implements IPushData {

        /**
         * Constructs a new PushData.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IPushData);

        /** PushData title. */
        public title: string;

        /** PushData pushId. */
        public pushId: string;

        /** PushData pushText. */
        public pushText: string;

        /** PushData pushExtraData. */
        public pushExtraData: string;

        /** PushData pushLevel. */
        public pushLevel: immessage.PushLevel;

        /** PushData isVoip. */
        public isVoip: boolean;

        /** PushData badge. */
        public badge: number;

        /** PushData msgId. */
        public msgId: string;

        /** PushData senderId. */
        public senderId: string;

        /** PushData ConverId. */
        public ConverId: string;

        /** PushData channelType. */
        public channelType: immessage.ChannelType;

        /** PushData rtcRoomId. */
        public rtcRoomId: string;

        /** PushData rtcInviterId. */
        public rtcInviterId: string;

        /** PushData rtcRoomType. */
        public rtcRoomType: number;

        /** PushData rtcMediaType. */
        public rtcMediaType: number;

        /**
         * Creates a new PushData instance using the specified properties.
         * @param [properties] Properties to set
         * @returns PushData instance
         */
        public static create(properties?: immessage.IPushData): immessage.PushData;

        /**
         * Encodes the specified PushData message. Does not implicitly {@link immessage.PushData.verify|verify} messages.
         * @param message PushData message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IPushData, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified PushData message, length delimited. Does not implicitly {@link immessage.PushData.verify|verify} messages.
         * @param message PushData message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IPushData, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a PushData message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns PushData
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.PushData;

        /**
         * Decodes a PushData message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns PushData
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.PushData;

        /**
         * Verifies a PushData message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a PushData message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns PushData
         */
        public static fromObject(object: { [k: string]: any }): immessage.PushData;

        /**
         * Creates a plain object from a PushData message. Also converts values to other types if specified.
         * @param message PushData
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.PushData, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this PushData to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for PushData
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** PushLevel enum. */
    enum PushLevel {
        DefaultPuhsLevel = 0,
        IgnoreSpeedControl = 1,
        IgnoreUndisturb = 2
    }

    /** Properties of a DownMsg. */
    interface IDownMsg {

        /** DownMsg targetId */
        targetId?: (string|null);

        /** DownMsg channelType */
        channelType?: (immessage.ChannelType|null);

        /** DownMsg msgType */
        msgType?: (string|null);

        /** DownMsg senderId */
        senderId?: (string|null);

        /** DownMsg msgId */
        msgId?: (string|null);

        /** DownMsg msgSeqNo */
        msgSeqNo?: (number|Long|null);

        /** DownMsg msgContent */
        msgContent?: (Uint8Array|null);

        /** DownMsg msgTime */
        msgTime?: (number|Long|null);

        /** DownMsg flags */
        flags?: (number|null);

        /** DownMsg isSend */
        isSend?: (boolean|null);

        /** DownMsg platform */
        platform?: (string|null);

        /** DownMsg clientUid */
        clientUid?: (string|null);

        /** DownMsg pushData */
        pushData?: (immessage.IPushData|null);

        /** DownMsg mentionInfo */
        mentionInfo?: (immessage.IMentionInfo|null);

        /** DownMsg isRead */
        isRead?: (boolean|null);

        /** DownMsg referMsg */
        referMsg?: (immessage.IDownMsg|null);

        /** DownMsg targetUserInfo */
        targetUserInfo?: (immessage.IUserInfo|null);

        /** DownMsg groupInfo */
        groupInfo?: (immessage.IGroupInfo|null);

        /** DownMsg mergedMsgs */
        mergedMsgs?: (immessage.IMergedMsgs|null);

        /** DownMsg undisturbType */
        undisturbType?: (number|null);

        /** DownMsg memberCount */
        memberCount?: (number|null);

        /** DownMsg readCount */
        readCount?: (number|null);

        /** DownMsg unreadIndex */
        unreadIndex?: (number|Long|null);

        /** DownMsg streamMsgParts */
        streamMsgParts?: (immessage.IStreamMsgItem[]|null);

        /** DownMsg msgExSet */
        msgExSet?: (immessage.IMsgExtItem[]|null);

        /** DownMsg msgExts */
        msgExts?: (immessage.IMsgExtItem[]|null);

        /** DownMsg converTags */
        converTags?: (immessage.IConverTag[]|null);

        /** DownMsg transMsgMap */
        transMsgMap?: ({ [k: string]: immessage.ITransMsgContent }|null);

        /** DownMsg SearchText */
        SearchText?: (string|null);

        /** DownMsg grpMemberInfo */
        grpMemberInfo?: (immessage.IGrpMemberInfo|null);
    }

    /** Represents a DownMsg. */
    class DownMsg implements IDownMsg {

        /**
         * Constructs a new DownMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IDownMsg);

        /** DownMsg targetId. */
        public targetId: string;

        /** DownMsg channelType. */
        public channelType: immessage.ChannelType;

        /** DownMsg msgType. */
        public msgType: string;

        /** DownMsg senderId. */
        public senderId: string;

        /** DownMsg msgId. */
        public msgId: string;

        /** DownMsg msgSeqNo. */
        public msgSeqNo: (number|Long);

        /** DownMsg msgContent. */
        public msgContent: Uint8Array;

        /** DownMsg msgTime. */
        public msgTime: (number|Long);

        /** DownMsg flags. */
        public flags: number;

        /** DownMsg isSend. */
        public isSend: boolean;

        /** DownMsg platform. */
        public platform: string;

        /** DownMsg clientUid. */
        public clientUid: string;

        /** DownMsg pushData. */
        public pushData?: (immessage.IPushData|null);

        /** DownMsg mentionInfo. */
        public mentionInfo?: (immessage.IMentionInfo|null);

        /** DownMsg isRead. */
        public isRead: boolean;

        /** DownMsg referMsg. */
        public referMsg?: (immessage.IDownMsg|null);

        /** DownMsg targetUserInfo. */
        public targetUserInfo?: (immessage.IUserInfo|null);

        /** DownMsg groupInfo. */
        public groupInfo?: (immessage.IGroupInfo|null);

        /** DownMsg mergedMsgs. */
        public mergedMsgs?: (immessage.IMergedMsgs|null);

        /** DownMsg undisturbType. */
        public undisturbType: number;

        /** DownMsg memberCount. */
        public memberCount: number;

        /** DownMsg readCount. */
        public readCount: number;

        /** DownMsg unreadIndex. */
        public unreadIndex: (number|Long);

        /** DownMsg streamMsgParts. */
        public streamMsgParts: immessage.IStreamMsgItem[];

        /** DownMsg msgExSet. */
        public msgExSet: immessage.IMsgExtItem[];

        /** DownMsg msgExts. */
        public msgExts: immessage.IMsgExtItem[];

        /** DownMsg converTags. */
        public converTags: immessage.IConverTag[];

        /** DownMsg transMsgMap. */
        public transMsgMap: { [k: string]: immessage.ITransMsgContent };

        /** DownMsg SearchText. */
        public SearchText: string;

        /** DownMsg grpMemberInfo. */
        public grpMemberInfo?: (immessage.IGrpMemberInfo|null);

        /**
         * Creates a new DownMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns DownMsg instance
         */
        public static create(properties?: immessage.IDownMsg): immessage.DownMsg;

        /**
         * Encodes the specified DownMsg message. Does not implicitly {@link immessage.DownMsg.verify|verify} messages.
         * @param message DownMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IDownMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified DownMsg message, length delimited. Does not implicitly {@link immessage.DownMsg.verify|verify} messages.
         * @param message DownMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IDownMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a DownMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns DownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.DownMsg;

        /**
         * Decodes a DownMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns DownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.DownMsg;

        /**
         * Verifies a DownMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a DownMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns DownMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.DownMsg;

        /**
         * Creates a plain object from a DownMsg message. Also converts values to other types if specified.
         * @param message DownMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.DownMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this DownMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for DownMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a TransMsgContent. */
    interface ITransMsgContent {

        /** TransMsgContent lang */
        lang?: (string|null);

        /** TransMsgContent msgContent */
        msgContent?: (Uint8Array|null);

        /** TransMsgContent pushData */
        pushData?: (immessage.IPushData|null);
    }

    /** Represents a TransMsgContent. */
    class TransMsgContent implements ITransMsgContent {

        /**
         * Constructs a new TransMsgContent.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ITransMsgContent);

        /** TransMsgContent lang. */
        public lang: string;

        /** TransMsgContent msgContent. */
        public msgContent: Uint8Array;

        /** TransMsgContent pushData. */
        public pushData?: (immessage.IPushData|null);

        /**
         * Creates a new TransMsgContent instance using the specified properties.
         * @param [properties] Properties to set
         * @returns TransMsgContent instance
         */
        public static create(properties?: immessage.ITransMsgContent): immessage.TransMsgContent;

        /**
         * Encodes the specified TransMsgContent message. Does not implicitly {@link immessage.TransMsgContent.verify|verify} messages.
         * @param message TransMsgContent message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ITransMsgContent, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified TransMsgContent message, length delimited. Does not implicitly {@link immessage.TransMsgContent.verify|verify} messages.
         * @param message TransMsgContent message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ITransMsgContent, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a TransMsgContent message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns TransMsgContent
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.TransMsgContent;

        /**
         * Decodes a TransMsgContent message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns TransMsgContent
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.TransMsgContent;

        /**
         * Verifies a TransMsgContent message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a TransMsgContent message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns TransMsgContent
         */
        public static fromObject(object: { [k: string]: any }): immessage.TransMsgContent;

        /**
         * Creates a plain object from a TransMsgContent message. Also converts values to other types if specified.
         * @param message TransMsgContent
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.TransMsgContent, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this TransMsgContent to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for TransMsgContent
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MsgAck. */
    interface IMsgAck {

        /** MsgAck msgId */
        msgId?: (string|null);

        /** MsgAck msgTime */
        msgTime?: (number|Long|null);
    }

    /** Represents a MsgAck. */
    class MsgAck implements IMsgAck {

        /**
         * Constructs a new MsgAck.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMsgAck);

        /** MsgAck msgId. */
        public msgId: string;

        /** MsgAck msgTime. */
        public msgTime: (number|Long);

        /**
         * Creates a new MsgAck instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MsgAck instance
         */
        public static create(properties?: immessage.IMsgAck): immessage.MsgAck;

        /**
         * Encodes the specified MsgAck message. Does not implicitly {@link immessage.MsgAck.verify|verify} messages.
         * @param message MsgAck message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMsgAck, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MsgAck message, length delimited. Does not implicitly {@link immessage.MsgAck.verify|verify} messages.
         * @param message MsgAck message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMsgAck, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MsgAck message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MsgAck
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MsgAck;

        /**
         * Decodes a MsgAck message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MsgAck
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MsgAck;

        /**
         * Verifies a MsgAck message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MsgAck message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MsgAck
         */
        public static fromObject(object: { [k: string]: any }): immessage.MsgAck;

        /**
         * Creates a plain object from a MsgAck message. Also converts values to other types if specified.
         * @param message MsgAck
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MsgAck, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MsgAck to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MsgAck
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a StreamMsgItem. */
    interface IStreamMsgItem {

        /** StreamMsgItem event */
        event?: (immessage.StreamEvent|null);

        /** StreamMsgItem subSeq */
        subSeq?: (number|Long|null);

        /** StreamMsgItem partialContent */
        partialContent?: (Uint8Array|null);
    }

    /** Represents a StreamMsgItem. */
    class StreamMsgItem implements IStreamMsgItem {

        /**
         * Constructs a new StreamMsgItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IStreamMsgItem);

        /** StreamMsgItem event. */
        public event: immessage.StreamEvent;

        /** StreamMsgItem subSeq. */
        public subSeq: (number|Long);

        /** StreamMsgItem partialContent. */
        public partialContent: Uint8Array;

        /**
         * Creates a new StreamMsgItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns StreamMsgItem instance
         */
        public static create(properties?: immessage.IStreamMsgItem): immessage.StreamMsgItem;

        /**
         * Encodes the specified StreamMsgItem message. Does not implicitly {@link immessage.StreamMsgItem.verify|verify} messages.
         * @param message StreamMsgItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IStreamMsgItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified StreamMsgItem message, length delimited. Does not implicitly {@link immessage.StreamMsgItem.verify|verify} messages.
         * @param message StreamMsgItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IStreamMsgItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a StreamMsgItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns StreamMsgItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.StreamMsgItem;

        /**
         * Decodes a StreamMsgItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns StreamMsgItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.StreamMsgItem;

        /**
         * Verifies a StreamMsgItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a StreamMsgItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns StreamMsgItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.StreamMsgItem;

        /**
         * Creates a plain object from a StreamMsgItem message. Also converts values to other types if specified.
         * @param message StreamMsgItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.StreamMsgItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this StreamMsgItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for StreamMsgItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a StreamDownMsg. */
    interface IStreamDownMsg {

        /** StreamDownMsg targetId */
        targetId?: (string|null);

        /** StreamDownMsg channelType */
        channelType?: (immessage.ChannelType|null);

        /** StreamDownMsg msgId */
        msgId?: (string|null);

        /** StreamDownMsg msgItems */
        msgItems?: (immessage.IStreamMsgItem[]|null);

        /** StreamDownMsg msgType */
        msgType?: (string|null);
    }

    /** Represents a StreamDownMsg. */
    class StreamDownMsg implements IStreamDownMsg {

        /**
         * Constructs a new StreamDownMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IStreamDownMsg);

        /** StreamDownMsg targetId. */
        public targetId: string;

        /** StreamDownMsg channelType. */
        public channelType: immessage.ChannelType;

        /** StreamDownMsg msgId. */
        public msgId: string;

        /** StreamDownMsg msgItems. */
        public msgItems: immessage.IStreamMsgItem[];

        /** StreamDownMsg msgType. */
        public msgType: string;

        /**
         * Creates a new StreamDownMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns StreamDownMsg instance
         */
        public static create(properties?: immessage.IStreamDownMsg): immessage.StreamDownMsg;

        /**
         * Encodes the specified StreamDownMsg message. Does not implicitly {@link immessage.StreamDownMsg.verify|verify} messages.
         * @param message StreamDownMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IStreamDownMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified StreamDownMsg message, length delimited. Does not implicitly {@link immessage.StreamDownMsg.verify|verify} messages.
         * @param message StreamDownMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IStreamDownMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a StreamDownMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns StreamDownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.StreamDownMsg;

        /**
         * Decodes a StreamDownMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns StreamDownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.StreamDownMsg;

        /**
         * Verifies a StreamDownMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a StreamDownMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns StreamDownMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.StreamDownMsg;

        /**
         * Creates a plain object from a StreamDownMsg message. Also converts values to other types if specified.
         * @param message StreamDownMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.StreamDownMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this StreamDownMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for StreamDownMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** StreamEvent enum. */
    enum StreamEvent {
        DefaultStreamEvent = 0,
        StreamMessage = 1,
        StreamComplete = 2
    }

    /** ChannelType enum. */
    enum ChannelType {
        Unknown = 0,
        Private = 1,
        Group = 2,
        Chatroom = 3,
        System = 4,
        GroupCast = 5,
        BroadCast = 6
    }

    /** Properties of a Notify. */
    interface INotify {

        /** Notify type */
        type?: (immessage.NotifyType|null);

        /** Notify syncTime */
        syncTime?: (number|Long|null);

        /** Notify chatroomId */
        chatroomId?: (string|null);
    }

    /** Represents a Notify. */
    class Notify implements INotify {

        /**
         * Constructs a new Notify.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.INotify);

        /** Notify type. */
        public type: immessage.NotifyType;

        /** Notify syncTime. */
        public syncTime: (number|Long);

        /** Notify chatroomId. */
        public chatroomId: string;

        /**
         * Creates a new Notify instance using the specified properties.
         * @param [properties] Properties to set
         * @returns Notify instance
         */
        public static create(properties?: immessage.INotify): immessage.Notify;

        /**
         * Encodes the specified Notify message. Does not implicitly {@link immessage.Notify.verify|verify} messages.
         * @param message Notify message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.INotify, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified Notify message, length delimited. Does not implicitly {@link immessage.Notify.verify|verify} messages.
         * @param message Notify message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.INotify, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a Notify message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns Notify
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.Notify;

        /**
         * Decodes a Notify message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns Notify
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.Notify;

        /**
         * Verifies a Notify message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a Notify message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns Notify
         */
        public static fromObject(object: { [k: string]: any }): immessage.Notify;

        /**
         * Creates a plain object from a Notify message. Also converts values to other types if specified.
         * @param message Notify
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.Notify, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this Notify to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for Notify
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** NotifyType enum. */
    enum NotifyType {
        Default = 0,
        Msg = 1,
        ChatroomMsg = 2,
        ChatroomAtt = 3,
        ChatroomEvent = 4,
        ChatroomDestroy = 5
    }

    /** Properties of a SyncMsgReq. */
    interface ISyncMsgReq {

        /** SyncMsgReq syncTime */
        syncTime?: (number|Long|null);

        /** SyncMsgReq containsSendBox */
        containsSendBox?: (boolean|null);

        /** SyncMsgReq sendBoxSyncTime */
        sendBoxSyncTime?: (number|Long|null);

        /** SyncMsgReq permitConvers */
        permitConvers?: (immessage.IPermitConver[]|null);
    }

    /** Represents a SyncMsgReq. */
    class SyncMsgReq implements ISyncMsgReq {

        /**
         * Constructs a new SyncMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISyncMsgReq);

        /** SyncMsgReq syncTime. */
        public syncTime: (number|Long);

        /** SyncMsgReq containsSendBox. */
        public containsSendBox: boolean;

        /** SyncMsgReq sendBoxSyncTime. */
        public sendBoxSyncTime: (number|Long);

        /** SyncMsgReq permitConvers. */
        public permitConvers: immessage.IPermitConver[];

        /**
         * Creates a new SyncMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SyncMsgReq instance
         */
        public static create(properties?: immessage.ISyncMsgReq): immessage.SyncMsgReq;

        /**
         * Encodes the specified SyncMsgReq message. Does not implicitly {@link immessage.SyncMsgReq.verify|verify} messages.
         * @param message SyncMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISyncMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SyncMsgReq message, length delimited. Does not implicitly {@link immessage.SyncMsgReq.verify|verify} messages.
         * @param message SyncMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISyncMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SyncMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SyncMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SyncMsgReq;

        /**
         * Decodes a SyncMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SyncMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SyncMsgReq;

        /**
         * Verifies a SyncMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SyncMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SyncMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.SyncMsgReq;

        /**
         * Creates a plain object from a SyncMsgReq message. Also converts values to other types if specified.
         * @param message SyncMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SyncMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SyncMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SyncMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a DownMsgSet. */
    interface IDownMsgSet {

        /** DownMsgSet msgs */
        msgs?: (immessage.IDownMsg[]|null);

        /** DownMsgSet syncTime */
        syncTime?: (number|Long|null);

        /** DownMsgSet isFinished */
        isFinished?: (boolean|null);

        /** DownMsgSet targetUserInfo */
        targetUserInfo?: (immessage.IUserInfo|null);

        /** DownMsgSet groupInfo */
        groupInfo?: (immessage.IGroupInfo|null);
    }

    /** Represents a DownMsgSet. */
    class DownMsgSet implements IDownMsgSet {

        /**
         * Constructs a new DownMsgSet.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IDownMsgSet);

        /** DownMsgSet msgs. */
        public msgs: immessage.IDownMsg[];

        /** DownMsgSet syncTime. */
        public syncTime: (number|Long);

        /** DownMsgSet isFinished. */
        public isFinished: boolean;

        /** DownMsgSet targetUserInfo. */
        public targetUserInfo?: (immessage.IUserInfo|null);

        /** DownMsgSet groupInfo. */
        public groupInfo?: (immessage.IGroupInfo|null);

        /**
         * Creates a new DownMsgSet instance using the specified properties.
         * @param [properties] Properties to set
         * @returns DownMsgSet instance
         */
        public static create(properties?: immessage.IDownMsgSet): immessage.DownMsgSet;

        /**
         * Encodes the specified DownMsgSet message. Does not implicitly {@link immessage.DownMsgSet.verify|verify} messages.
         * @param message DownMsgSet message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IDownMsgSet, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified DownMsgSet message, length delimited. Does not implicitly {@link immessage.DownMsgSet.verify|verify} messages.
         * @param message DownMsgSet message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IDownMsgSet, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a DownMsgSet message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns DownMsgSet
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.DownMsgSet;

        /**
         * Decodes a DownMsgSet message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns DownMsgSet
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.DownMsgSet;

        /**
         * Verifies a DownMsgSet message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a DownMsgSet message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns DownMsgSet
         */
        public static fromObject(object: { [k: string]: any }): immessage.DownMsgSet;

        /**
         * Creates a plain object from a DownMsgSet message. Also converts values to other types if specified.
         * @param message DownMsgSet
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.DownMsgSet, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this DownMsgSet to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for DownMsgSet
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a KvItem. */
    interface IKvItem {

        /** KvItem key */
        key?: (string|null);

        /** KvItem value */
        value?: (string|null);

        /** KvItem updTime */
        updTime?: (number|Long|null);
    }

    /** Represents a KvItem. */
    class KvItem implements IKvItem {

        /**
         * Constructs a new KvItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IKvItem);

        /** KvItem key. */
        public key: string;

        /** KvItem value. */
        public value: string;

        /** KvItem updTime. */
        public updTime: (number|Long);

        /**
         * Creates a new KvItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns KvItem instance
         */
        public static create(properties?: immessage.IKvItem): immessage.KvItem;

        /**
         * Encodes the specified KvItem message. Does not implicitly {@link immessage.KvItem.verify|verify} messages.
         * @param message KvItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IKvItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified KvItem message, length delimited. Does not implicitly {@link immessage.KvItem.verify|verify} messages.
         * @param message KvItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IKvItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a KvItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns KvItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.KvItem;

        /**
         * Decodes a KvItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns KvItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.KvItem;

        /**
         * Verifies a KvItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a KvItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns KvItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.KvItem;

        /**
         * Creates a plain object from a KvItem message. Also converts values to other types if specified.
         * @param message KvItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.KvItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this KvItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for KvItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a PushSwitch. */
    interface IPushSwitch {

        /** PushSwitch switch */
        "switch"?: (number|null);
    }

    /** Represents a PushSwitch. */
    class PushSwitch implements IPushSwitch {

        /**
         * Constructs a new PushSwitch.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IPushSwitch);

        /** PushSwitch switch. */
        public switch: number;

        /**
         * Creates a new PushSwitch instance using the specified properties.
         * @param [properties] Properties to set
         * @returns PushSwitch instance
         */
        public static create(properties?: immessage.IPushSwitch): immessage.PushSwitch;

        /**
         * Encodes the specified PushSwitch message. Does not implicitly {@link immessage.PushSwitch.verify|verify} messages.
         * @param message PushSwitch message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IPushSwitch, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified PushSwitch message, length delimited. Does not implicitly {@link immessage.PushSwitch.verify|verify} messages.
         * @param message PushSwitch message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IPushSwitch, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a PushSwitch message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns PushSwitch
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.PushSwitch;

        /**
         * Decodes a PushSwitch message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns PushSwitch
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.PushSwitch;

        /**
         * Verifies a PushSwitch message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a PushSwitch message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns PushSwitch
         */
        public static fromObject(object: { [k: string]: any }): immessage.PushSwitch;

        /**
         * Creates a plain object from a PushSwitch message. Also converts values to other types if specified.
         * @param message PushSwitch
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.PushSwitch, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this PushSwitch to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for PushSwitch
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an AddGrpAssistantReq. */
    interface IAddGrpAssistantReq {

        /** AddGrpAssistantReq assistantId */
        assistantId?: (string|null);

        /** AddGrpAssistantReq targets */
        targets?: (immessage.ISimpleConversation[]|null);
    }

    /** Represents an AddGrpAssistantReq. */
    class AddGrpAssistantReq implements IAddGrpAssistantReq {

        /**
         * Constructs a new AddGrpAssistantReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IAddGrpAssistantReq);

        /** AddGrpAssistantReq assistantId. */
        public assistantId: string;

        /** AddGrpAssistantReq targets. */
        public targets: immessage.ISimpleConversation[];

        /**
         * Creates a new AddGrpAssistantReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns AddGrpAssistantReq instance
         */
        public static create(properties?: immessage.IAddGrpAssistantReq): immessage.AddGrpAssistantReq;

        /**
         * Encodes the specified AddGrpAssistantReq message. Does not implicitly {@link immessage.AddGrpAssistantReq.verify|verify} messages.
         * @param message AddGrpAssistantReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IAddGrpAssistantReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified AddGrpAssistantReq message, length delimited. Does not implicitly {@link immessage.AddGrpAssistantReq.verify|verify} messages.
         * @param message AddGrpAssistantReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IAddGrpAssistantReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an AddGrpAssistantReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns AddGrpAssistantReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.AddGrpAssistantReq;

        /**
         * Decodes an AddGrpAssistantReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns AddGrpAssistantReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.AddGrpAssistantReq;

        /**
         * Verifies an AddGrpAssistantReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an AddGrpAssistantReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns AddGrpAssistantReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.AddGrpAssistantReq;

        /**
         * Creates a plain object from an AddGrpAssistantReq message. Also converts values to other types if specified.
         * @param message AddGrpAssistantReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.AddGrpAssistantReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this AddGrpAssistantReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for AddGrpAssistantReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SimpleConversation. */
    interface ISimpleConversation {

        /** SimpleConversation targetId */
        targetId?: (string|null);

        /** SimpleConversation channelType */
        channelType?: (immessage.ChannelType|null);

        /** SimpleConversation msgTime */
        msgTime?: (number|Long|null);

        /** SimpleConversation msgSeq */
        msgSeq?: (number|Long|null);
    }

    /** Represents a SimpleConversation. */
    class SimpleConversation implements ISimpleConversation {

        /**
         * Constructs a new SimpleConversation.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISimpleConversation);

        /** SimpleConversation targetId. */
        public targetId: string;

        /** SimpleConversation channelType. */
        public channelType: immessage.ChannelType;

        /** SimpleConversation msgTime. */
        public msgTime: (number|Long);

        /** SimpleConversation msgSeq. */
        public msgSeq: (number|Long);

        /**
         * Creates a new SimpleConversation instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SimpleConversation instance
         */
        public static create(properties?: immessage.ISimpleConversation): immessage.SimpleConversation;

        /**
         * Encodes the specified SimpleConversation message. Does not implicitly {@link immessage.SimpleConversation.verify|verify} messages.
         * @param message SimpleConversation message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISimpleConversation, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SimpleConversation message, length delimited. Does not implicitly {@link immessage.SimpleConversation.verify|verify} messages.
         * @param message SimpleConversation message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISimpleConversation, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SimpleConversation message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SimpleConversation
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SimpleConversation;

        /**
         * Decodes a SimpleConversation message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SimpleConversation
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SimpleConversation;

        /**
         * Verifies a SimpleConversation message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SimpleConversation message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SimpleConversation
         */
        public static fromObject(object: { [k: string]: any }): immessage.SimpleConversation;

        /**
         * Creates a plain object from a SimpleConversation message. Also converts values to other types if specified.
         * @param message SimpleConversation
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SimpleConversation, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SimpleConversation to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SimpleConversation
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an AssistantMsgResp. */
    interface IAssistantMsgResp {

        /** AssistantMsgResp msgId */
        msgId?: (string|null);

        /** AssistantMsgResp msgTime */
        msgTime?: (number|Long|null);

        /** AssistantMsgResp msgSeq */
        msgSeq?: (number|Long|null);

        /** AssistantMsgResp convers */
        convers?: (immessage.ISimpleConversation[]|null);
    }

    /** Represents an AssistantMsgResp. */
    class AssistantMsgResp implements IAssistantMsgResp {

        /**
         * Constructs a new AssistantMsgResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IAssistantMsgResp);

        /** AssistantMsgResp msgId. */
        public msgId: string;

        /** AssistantMsgResp msgTime. */
        public msgTime: (number|Long);

        /** AssistantMsgResp msgSeq. */
        public msgSeq: (number|Long);

        /** AssistantMsgResp convers. */
        public convers: immessage.ISimpleConversation[];

        /**
         * Creates a new AssistantMsgResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns AssistantMsgResp instance
         */
        public static create(properties?: immessage.IAssistantMsgResp): immessage.AssistantMsgResp;

        /**
         * Encodes the specified AssistantMsgResp message. Does not implicitly {@link immessage.AssistantMsgResp.verify|verify} messages.
         * @param message AssistantMsgResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IAssistantMsgResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified AssistantMsgResp message, length delimited. Does not implicitly {@link immessage.AssistantMsgResp.verify|verify} messages.
         * @param message AssistantMsgResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IAssistantMsgResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an AssistantMsgResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns AssistantMsgResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.AssistantMsgResp;

        /**
         * Decodes an AssistantMsgResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns AssistantMsgResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.AssistantMsgResp;

        /**
         * Verifies an AssistantMsgResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an AssistantMsgResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns AssistantMsgResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.AssistantMsgResp;

        /**
         * Creates a plain object from an AssistantMsgResp message. Also converts values to other types if specified.
         * @param message AssistantMsgResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.AssistantMsgResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this AssistantMsgResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for AssistantMsgResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an AddHisMsgReq. */
    interface IAddHisMsgReq {

        /** AddHisMsgReq senderId */
        senderId?: (string|null);

        /** AddHisMsgReq targetId */
        targetId?: (string|null);

        /** AddHisMsgReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** AddHisMsgReq sendTime */
        sendTime?: (number|Long|null);

        /** AddHisMsgReq msg */
        msg?: (immessage.IDownMsg|null);

        /** AddHisMsgReq GroupMemberCount */
        GroupMemberCount?: (number|null);
    }

    /** Represents an AddHisMsgReq. */
    class AddHisMsgReq implements IAddHisMsgReq {

        /**
         * Constructs a new AddHisMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IAddHisMsgReq);

        /** AddHisMsgReq senderId. */
        public senderId: string;

        /** AddHisMsgReq targetId. */
        public targetId: string;

        /** AddHisMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /** AddHisMsgReq sendTime. */
        public sendTime: (number|Long);

        /** AddHisMsgReq msg. */
        public msg?: (immessage.IDownMsg|null);

        /** AddHisMsgReq GroupMemberCount. */
        public GroupMemberCount: number;

        /**
         * Creates a new AddHisMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns AddHisMsgReq instance
         */
        public static create(properties?: immessage.IAddHisMsgReq): immessage.AddHisMsgReq;

        /**
         * Encodes the specified AddHisMsgReq message. Does not implicitly {@link immessage.AddHisMsgReq.verify|verify} messages.
         * @param message AddHisMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IAddHisMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified AddHisMsgReq message, length delimited. Does not implicitly {@link immessage.AddHisMsgReq.verify|verify} messages.
         * @param message AddHisMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IAddHisMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an AddHisMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns AddHisMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.AddHisMsgReq;

        /**
         * Decodes an AddHisMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns AddHisMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.AddHisMsgReq;

        /**
         * Verifies an AddHisMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an AddHisMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns AddHisMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.AddHisMsgReq;

        /**
         * Creates a plain object from an AddHisMsgReq message. Also converts values to other types if specified.
         * @param message AddHisMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.AddHisMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this AddHisMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for AddHisMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a DelHisMsgsReq. */
    interface IDelHisMsgsReq {

        /** DelHisMsgsReq targetId */
        targetId?: (string|null);

        /** DelHisMsgsReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** DelHisMsgsReq msgs */
        msgs?: (immessage.ISimpleMsg[]|null);

        /** DelHisMsgsReq delScope */
        delScope?: (number|null);
    }

    /** Represents a DelHisMsgsReq. */
    class DelHisMsgsReq implements IDelHisMsgsReq {

        /**
         * Constructs a new DelHisMsgsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IDelHisMsgsReq);

        /** DelHisMsgsReq targetId. */
        public targetId: string;

        /** DelHisMsgsReq channelType. */
        public channelType: immessage.ChannelType;

        /** DelHisMsgsReq msgs. */
        public msgs: immessage.ISimpleMsg[];

        /** DelHisMsgsReq delScope. */
        public delScope: number;

        /**
         * Creates a new DelHisMsgsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns DelHisMsgsReq instance
         */
        public static create(properties?: immessage.IDelHisMsgsReq): immessage.DelHisMsgsReq;

        /**
         * Encodes the specified DelHisMsgsReq message. Does not implicitly {@link immessage.DelHisMsgsReq.verify|verify} messages.
         * @param message DelHisMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IDelHisMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified DelHisMsgsReq message, length delimited. Does not implicitly {@link immessage.DelHisMsgsReq.verify|verify} messages.
         * @param message DelHisMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IDelHisMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a DelHisMsgsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns DelHisMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.DelHisMsgsReq;

        /**
         * Decodes a DelHisMsgsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns DelHisMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.DelHisMsgsReq;

        /**
         * Verifies a DelHisMsgsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a DelHisMsgsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns DelHisMsgsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.DelHisMsgsReq;

        /**
         * Creates a plain object from a DelHisMsgsReq message. Also converts values to other types if specified.
         * @param message DelHisMsgsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.DelHisMsgsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this DelHisMsgsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for DelHisMsgsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryLatestMsgReq. */
    interface IQryLatestMsgReq {

        /** QryLatestMsgReq converId */
        converId?: (string|null);

        /** QryLatestMsgReq channelType */
        channelType?: (immessage.ChannelType|null);
    }

    /** Represents a QryLatestMsgReq. */
    class QryLatestMsgReq implements IQryLatestMsgReq {

        /**
         * Constructs a new QryLatestMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryLatestMsgReq);

        /** QryLatestMsgReq converId. */
        public converId: string;

        /** QryLatestMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /**
         * Creates a new QryLatestMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryLatestMsgReq instance
         */
        public static create(properties?: immessage.IQryLatestMsgReq): immessage.QryLatestMsgReq;

        /**
         * Encodes the specified QryLatestMsgReq message. Does not implicitly {@link immessage.QryLatestMsgReq.verify|verify} messages.
         * @param message QryLatestMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryLatestMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryLatestMsgReq message, length delimited. Does not implicitly {@link immessage.QryLatestMsgReq.verify|verify} messages.
         * @param message QryLatestMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryLatestMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryLatestMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryLatestMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryLatestMsgReq;

        /**
         * Decodes a QryLatestMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryLatestMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryLatestMsgReq;

        /**
         * Verifies a QryLatestMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryLatestMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryLatestMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryLatestMsgReq;

        /**
         * Creates a plain object from a QryLatestMsgReq message. Also converts values to other types if specified.
         * @param message QryLatestMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryLatestMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryLatestMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryLatestMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryLatestMsgResp. */
    interface IQryLatestMsgResp {

        /** QryLatestMsgResp converId */
        converId?: (string|null);

        /** QryLatestMsgResp ChannelType */
        ChannelType?: (immessage.ChannelType|null);

        /** QryLatestMsgResp msgSeqNo */
        msgSeqNo?: (number|Long|null);

        /** QryLatestMsgResp msgTime */
        msgTime?: (number|Long|null);

        /** QryLatestMsgResp msgId */
        msgId?: (string|null);
    }

    /** Represents a QryLatestMsgResp. */
    class QryLatestMsgResp implements IQryLatestMsgResp {

        /**
         * Constructs a new QryLatestMsgResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryLatestMsgResp);

        /** QryLatestMsgResp converId. */
        public converId: string;

        /** QryLatestMsgResp ChannelType. */
        public ChannelType: immessage.ChannelType;

        /** QryLatestMsgResp msgSeqNo. */
        public msgSeqNo: (number|Long);

        /** QryLatestMsgResp msgTime. */
        public msgTime: (number|Long);

        /** QryLatestMsgResp msgId. */
        public msgId: string;

        /**
         * Creates a new QryLatestMsgResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryLatestMsgResp instance
         */
        public static create(properties?: immessage.IQryLatestMsgResp): immessage.QryLatestMsgResp;

        /**
         * Encodes the specified QryLatestMsgResp message. Does not implicitly {@link immessage.QryLatestMsgResp.verify|verify} messages.
         * @param message QryLatestMsgResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryLatestMsgResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryLatestMsgResp message, length delimited. Does not implicitly {@link immessage.QryLatestMsgResp.verify|verify} messages.
         * @param message QryLatestMsgResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryLatestMsgResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryLatestMsgResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryLatestMsgResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryLatestMsgResp;

        /**
         * Decodes a QryLatestMsgResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryLatestMsgResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryLatestMsgResp;

        /**
         * Verifies a QryLatestMsgResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryLatestMsgResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryLatestMsgResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryLatestMsgResp;

        /**
         * Creates a plain object from a QryLatestMsgResp message. Also converts values to other types if specified.
         * @param message QryLatestMsgResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryLatestMsgResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryLatestMsgResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryLatestMsgResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryHisMsgsReq. */
    interface IQryHisMsgsReq {

        /** QryHisMsgsReq targetId */
        targetId?: (string|null);

        /** QryHisMsgsReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryHisMsgsReq startTime */
        startTime?: (number|Long|null);

        /** QryHisMsgsReq count */
        count?: (number|null);

        /** QryHisMsgsReq order */
        order?: (number|null);

        /** QryHisMsgsReq msgTypes */
        msgTypes?: (string[]|null);

        /** QryHisMsgsReq maxHisMsgCount */
        maxHisMsgCount?: (number|null);

        /** QryHisMsgsReq targetIdAlias */
        targetIdAlias?: (string|null);
    }

    /** Represents a QryHisMsgsReq. */
    class QryHisMsgsReq implements IQryHisMsgsReq {

        /**
         * Constructs a new QryHisMsgsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryHisMsgsReq);

        /** QryHisMsgsReq targetId. */
        public targetId: string;

        /** QryHisMsgsReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryHisMsgsReq startTime. */
        public startTime: (number|Long);

        /** QryHisMsgsReq count. */
        public count: number;

        /** QryHisMsgsReq order. */
        public order: number;

        /** QryHisMsgsReq msgTypes. */
        public msgTypes: string[];

        /** QryHisMsgsReq maxHisMsgCount. */
        public maxHisMsgCount: number;

        /** QryHisMsgsReq targetIdAlias. */
        public targetIdAlias: string;

        /**
         * Creates a new QryHisMsgsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryHisMsgsReq instance
         */
        public static create(properties?: immessage.IQryHisMsgsReq): immessage.QryHisMsgsReq;

        /**
         * Encodes the specified QryHisMsgsReq message. Does not implicitly {@link immessage.QryHisMsgsReq.verify|verify} messages.
         * @param message QryHisMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryHisMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryHisMsgsReq message, length delimited. Does not implicitly {@link immessage.QryHisMsgsReq.verify|verify} messages.
         * @param message QryHisMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryHisMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryHisMsgsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryHisMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryHisMsgsReq;

        /**
         * Decodes a QryHisMsgsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryHisMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryHisMsgsReq;

        /**
         * Verifies a QryHisMsgsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryHisMsgsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryHisMsgsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryHisMsgsReq;

        /**
         * Creates a plain object from a QryHisMsgsReq message. Also converts values to other types if specified.
         * @param message QryHisMsgsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryHisMsgsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryHisMsgsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryHisMsgsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryFirstUnreadMsgReq. */
    interface IQryFirstUnreadMsgReq {

        /** QryFirstUnreadMsgReq targetId */
        targetId?: (string|null);

        /** QryFirstUnreadMsgReq channelType */
        channelType?: (immessage.ChannelType|null);
    }

    /** Represents a QryFirstUnreadMsgReq. */
    class QryFirstUnreadMsgReq implements IQryFirstUnreadMsgReq {

        /**
         * Constructs a new QryFirstUnreadMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryFirstUnreadMsgReq);

        /** QryFirstUnreadMsgReq targetId. */
        public targetId: string;

        /** QryFirstUnreadMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /**
         * Creates a new QryFirstUnreadMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryFirstUnreadMsgReq instance
         */
        public static create(properties?: immessage.IQryFirstUnreadMsgReq): immessage.QryFirstUnreadMsgReq;

        /**
         * Encodes the specified QryFirstUnreadMsgReq message. Does not implicitly {@link immessage.QryFirstUnreadMsgReq.verify|verify} messages.
         * @param message QryFirstUnreadMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryFirstUnreadMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryFirstUnreadMsgReq message, length delimited. Does not implicitly {@link immessage.QryFirstUnreadMsgReq.verify|verify} messages.
         * @param message QryFirstUnreadMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryFirstUnreadMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryFirstUnreadMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryFirstUnreadMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryFirstUnreadMsgReq;

        /**
         * Decodes a QryFirstUnreadMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryFirstUnreadMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryFirstUnreadMsgReq;

        /**
         * Verifies a QryFirstUnreadMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryFirstUnreadMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryFirstUnreadMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryFirstUnreadMsgReq;

        /**
         * Creates a plain object from a QryFirstUnreadMsgReq message. Also converts values to other types if specified.
         * @param message QryFirstUnreadMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryFirstUnreadMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryFirstUnreadMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryFirstUnreadMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryHisMsgByIdsReq. */
    interface IQryHisMsgByIdsReq {

        /** QryHisMsgByIdsReq targetId */
        targetId?: (string|null);

        /** QryHisMsgByIdsReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryHisMsgByIdsReq msgIds */
        msgIds?: (string[]|null);
    }

    /** Represents a QryHisMsgByIdsReq. */
    class QryHisMsgByIdsReq implements IQryHisMsgByIdsReq {

        /**
         * Constructs a new QryHisMsgByIdsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryHisMsgByIdsReq);

        /** QryHisMsgByIdsReq targetId. */
        public targetId: string;

        /** QryHisMsgByIdsReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryHisMsgByIdsReq msgIds. */
        public msgIds: string[];

        /**
         * Creates a new QryHisMsgByIdsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryHisMsgByIdsReq instance
         */
        public static create(properties?: immessage.IQryHisMsgByIdsReq): immessage.QryHisMsgByIdsReq;

        /**
         * Encodes the specified QryHisMsgByIdsReq message. Does not implicitly {@link immessage.QryHisMsgByIdsReq.verify|verify} messages.
         * @param message QryHisMsgByIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryHisMsgByIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryHisMsgByIdsReq message, length delimited. Does not implicitly {@link immessage.QryHisMsgByIdsReq.verify|verify} messages.
         * @param message QryHisMsgByIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryHisMsgByIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryHisMsgByIdsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryHisMsgByIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryHisMsgByIdsReq;

        /**
         * Decodes a QryHisMsgByIdsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryHisMsgByIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryHisMsgByIdsReq;

        /**
         * Verifies a QryHisMsgByIdsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryHisMsgByIdsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryHisMsgByIdsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryHisMsgByIdsReq;

        /**
         * Creates a plain object from a QryHisMsgByIdsReq message. Also converts values to other types if specified.
         * @param message QryHisMsgByIdsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryHisMsgByIdsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryHisMsgByIdsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryHisMsgByIdsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a RecallMsgReq. */
    interface IRecallMsgReq {

        /** RecallMsgReq targetId */
        targetId?: (string|null);

        /** RecallMsgReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** RecallMsgReq msgId */
        msgId?: (string|null);

        /** RecallMsgReq msgTime */
        msgTime?: (number|Long|null);

        /** RecallMsgReq exts */
        exts?: (immessage.IKvItem[]|null);
    }

    /** Represents a RecallMsgReq. */
    class RecallMsgReq implements IRecallMsgReq {

        /**
         * Constructs a new RecallMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IRecallMsgReq);

        /** RecallMsgReq targetId. */
        public targetId: string;

        /** RecallMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /** RecallMsgReq msgId. */
        public msgId: string;

        /** RecallMsgReq msgTime. */
        public msgTime: (number|Long);

        /** RecallMsgReq exts. */
        public exts: immessage.IKvItem[];

        /**
         * Creates a new RecallMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns RecallMsgReq instance
         */
        public static create(properties?: immessage.IRecallMsgReq): immessage.RecallMsgReq;

        /**
         * Encodes the specified RecallMsgReq message. Does not implicitly {@link immessage.RecallMsgReq.verify|verify} messages.
         * @param message RecallMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IRecallMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified RecallMsgReq message, length delimited. Does not implicitly {@link immessage.RecallMsgReq.verify|verify} messages.
         * @param message RecallMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IRecallMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a RecallMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns RecallMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.RecallMsgReq;

        /**
         * Decodes a RecallMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns RecallMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.RecallMsgReq;

        /**
         * Verifies a RecallMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a RecallMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns RecallMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.RecallMsgReq;

        /**
         * Creates a plain object from a RecallMsgReq message. Also converts values to other types if specified.
         * @param message RecallMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.RecallMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this RecallMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for RecallMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MarkReadReq. */
    interface IMarkReadReq {

        /** MarkReadReq targetId */
        targetId?: (string|null);

        /** MarkReadReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** MarkReadReq msgs */
        msgs?: (immessage.ISimpleMsg[]|null);

        /** MarkReadReq indexScopes */
        indexScopes?: (immessage.IIndexScope[]|null);
    }

    /** Represents a MarkReadReq. */
    class MarkReadReq implements IMarkReadReq {

        /**
         * Constructs a new MarkReadReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMarkReadReq);

        /** MarkReadReq targetId. */
        public targetId: string;

        /** MarkReadReq channelType. */
        public channelType: immessage.ChannelType;

        /** MarkReadReq msgs. */
        public msgs: immessage.ISimpleMsg[];

        /** MarkReadReq indexScopes. */
        public indexScopes: immessage.IIndexScope[];

        /**
         * Creates a new MarkReadReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MarkReadReq instance
         */
        public static create(properties?: immessage.IMarkReadReq): immessage.MarkReadReq;

        /**
         * Encodes the specified MarkReadReq message. Does not implicitly {@link immessage.MarkReadReq.verify|verify} messages.
         * @param message MarkReadReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMarkReadReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MarkReadReq message, length delimited. Does not implicitly {@link immessage.MarkReadReq.verify|verify} messages.
         * @param message MarkReadReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMarkReadReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MarkReadReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MarkReadReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MarkReadReq;

        /**
         * Decodes a MarkReadReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MarkReadReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MarkReadReq;

        /**
         * Verifies a MarkReadReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MarkReadReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MarkReadReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.MarkReadReq;

        /**
         * Creates a plain object from a MarkReadReq message. Also converts values to other types if specified.
         * @param message MarkReadReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MarkReadReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MarkReadReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MarkReadReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MarkGrpMsgReadReq. */
    interface IMarkGrpMsgReadReq {

        /** MarkGrpMsgReadReq groupId */
        groupId?: (string|null);

        /** MarkGrpMsgReadReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** MarkGrpMsgReadReq msgIds */
        msgIds?: (string[]|null);
    }

    /** Represents a MarkGrpMsgReadReq. */
    class MarkGrpMsgReadReq implements IMarkGrpMsgReadReq {

        /**
         * Constructs a new MarkGrpMsgReadReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMarkGrpMsgReadReq);

        /** MarkGrpMsgReadReq groupId. */
        public groupId: string;

        /** MarkGrpMsgReadReq channelType. */
        public channelType: immessage.ChannelType;

        /** MarkGrpMsgReadReq msgIds. */
        public msgIds: string[];

        /**
         * Creates a new MarkGrpMsgReadReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MarkGrpMsgReadReq instance
         */
        public static create(properties?: immessage.IMarkGrpMsgReadReq): immessage.MarkGrpMsgReadReq;

        /**
         * Encodes the specified MarkGrpMsgReadReq message. Does not implicitly {@link immessage.MarkGrpMsgReadReq.verify|verify} messages.
         * @param message MarkGrpMsgReadReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMarkGrpMsgReadReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MarkGrpMsgReadReq message, length delimited. Does not implicitly {@link immessage.MarkGrpMsgReadReq.verify|verify} messages.
         * @param message MarkGrpMsgReadReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMarkGrpMsgReadReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MarkGrpMsgReadReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MarkGrpMsgReadReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MarkGrpMsgReadReq;

        /**
         * Decodes a MarkGrpMsgReadReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MarkGrpMsgReadReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MarkGrpMsgReadReq;

        /**
         * Verifies a MarkGrpMsgReadReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MarkGrpMsgReadReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MarkGrpMsgReadReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.MarkGrpMsgReadReq;

        /**
         * Creates a plain object from a MarkGrpMsgReadReq message. Also converts values to other types if specified.
         * @param message MarkGrpMsgReadReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MarkGrpMsgReadReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MarkGrpMsgReadReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MarkGrpMsgReadReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CleanHisMsgReq. */
    interface ICleanHisMsgReq {

        /** CleanHisMsgReq targetId */
        targetId?: (string|null);

        /** CleanHisMsgReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** CleanHisMsgReq cleanMsgTime */
        cleanMsgTime?: (number|Long|null);

        /** CleanHisMsgReq cleanScope */
        cleanScope?: (number|null);

        /** CleanHisMsgReq senderId */
        senderId?: (string|null);

        /** CleanHisMsgReq cleanTimeOffset */
        cleanTimeOffset?: (number|Long|null);
    }

    /** Represents a CleanHisMsgReq. */
    class CleanHisMsgReq implements ICleanHisMsgReq {

        /**
         * Constructs a new CleanHisMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ICleanHisMsgReq);

        /** CleanHisMsgReq targetId. */
        public targetId: string;

        /** CleanHisMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /** CleanHisMsgReq cleanMsgTime. */
        public cleanMsgTime: (number|Long);

        /** CleanHisMsgReq cleanScope. */
        public cleanScope: number;

        /** CleanHisMsgReq senderId. */
        public senderId: string;

        /** CleanHisMsgReq cleanTimeOffset. */
        public cleanTimeOffset: (number|Long);

        /**
         * Creates a new CleanHisMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CleanHisMsgReq instance
         */
        public static create(properties?: immessage.ICleanHisMsgReq): immessage.CleanHisMsgReq;

        /**
         * Encodes the specified CleanHisMsgReq message. Does not implicitly {@link immessage.CleanHisMsgReq.verify|verify} messages.
         * @param message CleanHisMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ICleanHisMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CleanHisMsgReq message, length delimited. Does not implicitly {@link immessage.CleanHisMsgReq.verify|verify} messages.
         * @param message CleanHisMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ICleanHisMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CleanHisMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CleanHisMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.CleanHisMsgReq;

        /**
         * Decodes a CleanHisMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CleanHisMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.CleanHisMsgReq;

        /**
         * Verifies a CleanHisMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CleanHisMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CleanHisMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.CleanHisMsgReq;

        /**
         * Creates a plain object from a CleanHisMsgReq message. Also converts values to other types if specified.
         * @param message CleanHisMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.CleanHisMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CleanHisMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CleanHisMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SimpleMsg. */
    interface ISimpleMsg {

        /** SimpleMsg msgId */
        msgId?: (string|null);

        /** SimpleMsg msgTime */
        msgTime?: (number|Long|null);

        /** SimpleMsg msgReadIndex */
        msgReadIndex?: (number|Long|null);
    }

    /** Represents a SimpleMsg. */
    class SimpleMsg implements ISimpleMsg {

        /**
         * Constructs a new SimpleMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISimpleMsg);

        /** SimpleMsg msgId. */
        public msgId: string;

        /** SimpleMsg msgTime. */
        public msgTime: (number|Long);

        /** SimpleMsg msgReadIndex. */
        public msgReadIndex: (number|Long);

        /**
         * Creates a new SimpleMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SimpleMsg instance
         */
        public static create(properties?: immessage.ISimpleMsg): immessage.SimpleMsg;

        /**
         * Encodes the specified SimpleMsg message. Does not implicitly {@link immessage.SimpleMsg.verify|verify} messages.
         * @param message SimpleMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISimpleMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SimpleMsg message, length delimited. Does not implicitly {@link immessage.SimpleMsg.verify|verify} messages.
         * @param message SimpleMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISimpleMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SimpleMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SimpleMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SimpleMsg;

        /**
         * Decodes a SimpleMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SimpleMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SimpleMsg;

        /**
         * Verifies a SimpleMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SimpleMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SimpleMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.SimpleMsg;

        /**
         * Creates a plain object from a SimpleMsg message. Also converts values to other types if specified.
         * @param message SimpleMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SimpleMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SimpleMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SimpleMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an IndexScope. */
    interface IIndexScope {

        /** IndexScope startIndex */
        startIndex?: (number|Long|null);

        /** IndexScope endIndex */
        endIndex?: (number|Long|null);
    }

    /** Represents an IndexScope. */
    class IndexScope implements IIndexScope {

        /**
         * Constructs a new IndexScope.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IIndexScope);

        /** IndexScope startIndex. */
        public startIndex: (number|Long);

        /** IndexScope endIndex. */
        public endIndex: (number|Long);

        /**
         * Creates a new IndexScope instance using the specified properties.
         * @param [properties] Properties to set
         * @returns IndexScope instance
         */
        public static create(properties?: immessage.IIndexScope): immessage.IndexScope;

        /**
         * Encodes the specified IndexScope message. Does not implicitly {@link immessage.IndexScope.verify|verify} messages.
         * @param message IndexScope message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IIndexScope, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified IndexScope message, length delimited. Does not implicitly {@link immessage.IndexScope.verify|verify} messages.
         * @param message IndexScope message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IIndexScope, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an IndexScope message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns IndexScope
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.IndexScope;

        /**
         * Decodes an IndexScope message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns IndexScope
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.IndexScope;

        /**
         * Verifies an IndexScope message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an IndexScope message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns IndexScope
         */
        public static fromObject(object: { [k: string]: any }): immessage.IndexScope;

        /**
         * Creates a plain object from an IndexScope message. Also converts values to other types if specified.
         * @param message IndexScope
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.IndexScope, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this IndexScope to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for IndexScope
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ModifyMsgReq. */
    interface IModifyMsgReq {

        /** ModifyMsgReq targetId */
        targetId?: (string|null);

        /** ModifyMsgReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** ModifyMsgReq msgId */
        msgId?: (string|null);

        /** ModifyMsgReq msgTime */
        msgTime?: (number|Long|null);

        /** ModifyMsgReq msgSeqNo */
        msgSeqNo?: (number|Long|null);

        /** ModifyMsgReq msgContent */
        msgContent?: (Uint8Array|null);

        /** ModifyMsgReq msgType */
        msgType?: (string|null);
    }

    /** Represents a ModifyMsgReq. */
    class ModifyMsgReq implements IModifyMsgReq {

        /**
         * Constructs a new ModifyMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IModifyMsgReq);

        /** ModifyMsgReq targetId. */
        public targetId: string;

        /** ModifyMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /** ModifyMsgReq msgId. */
        public msgId: string;

        /** ModifyMsgReq msgTime. */
        public msgTime: (number|Long);

        /** ModifyMsgReq msgSeqNo. */
        public msgSeqNo: (number|Long);

        /** ModifyMsgReq msgContent. */
        public msgContent: Uint8Array;

        /** ModifyMsgReq msgType. */
        public msgType: string;

        /**
         * Creates a new ModifyMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ModifyMsgReq instance
         */
        public static create(properties?: immessage.IModifyMsgReq): immessage.ModifyMsgReq;

        /**
         * Encodes the specified ModifyMsgReq message. Does not implicitly {@link immessage.ModifyMsgReq.verify|verify} messages.
         * @param message ModifyMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IModifyMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ModifyMsgReq message, length delimited. Does not implicitly {@link immessage.ModifyMsgReq.verify|verify} messages.
         * @param message ModifyMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IModifyMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ModifyMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ModifyMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.ModifyMsgReq;

        /**
         * Decodes a ModifyMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ModifyMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.ModifyMsgReq;

        /**
         * Verifies a ModifyMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ModifyMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ModifyMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.ModifyMsgReq;

        /**
         * Creates a plain object from a ModifyMsgReq message. Also converts values to other types if specified.
         * @param message ModifyMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.ModifyMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ModifyMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ModifyMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MergeMsgReq. */
    interface IMergeMsgReq {

        /** MergeMsgReq parentMsgId */
        parentMsgId?: (string|null);

        /** MergeMsgReq mergedMsgs */
        mergedMsgs?: (immessage.IMergedMsgs|null);
    }

    /** Represents a MergeMsgReq. */
    class MergeMsgReq implements IMergeMsgReq {

        /**
         * Constructs a new MergeMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMergeMsgReq);

        /** MergeMsgReq parentMsgId. */
        public parentMsgId: string;

        /** MergeMsgReq mergedMsgs. */
        public mergedMsgs?: (immessage.IMergedMsgs|null);

        /**
         * Creates a new MergeMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MergeMsgReq instance
         */
        public static create(properties?: immessage.IMergeMsgReq): immessage.MergeMsgReq;

        /**
         * Encodes the specified MergeMsgReq message. Does not implicitly {@link immessage.MergeMsgReq.verify|verify} messages.
         * @param message MergeMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMergeMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MergeMsgReq message, length delimited. Does not implicitly {@link immessage.MergeMsgReq.verify|verify} messages.
         * @param message MergeMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMergeMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MergeMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MergeMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MergeMsgReq;

        /**
         * Decodes a MergeMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MergeMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MergeMsgReq;

        /**
         * Verifies a MergeMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MergeMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MergeMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.MergeMsgReq;

        /**
         * Creates a plain object from a MergeMsgReq message. Also converts values to other types if specified.
         * @param message MergeMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MergeMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MergeMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MergeMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryMergedMsgsReq. */
    interface IQryMergedMsgsReq {

        /** QryMergedMsgsReq startTime */
        startTime?: (number|Long|null);

        /** QryMergedMsgsReq count */
        count?: (number|null);

        /** QryMergedMsgsReq order */
        order?: (number|null);
    }

    /** Represents a QryMergedMsgsReq. */
    class QryMergedMsgsReq implements IQryMergedMsgsReq {

        /**
         * Constructs a new QryMergedMsgsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryMergedMsgsReq);

        /** QryMergedMsgsReq startTime. */
        public startTime: (number|Long);

        /** QryMergedMsgsReq count. */
        public count: number;

        /** QryMergedMsgsReq order. */
        public order: number;

        /**
         * Creates a new QryMergedMsgsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryMergedMsgsReq instance
         */
        public static create(properties?: immessage.IQryMergedMsgsReq): immessage.QryMergedMsgsReq;

        /**
         * Encodes the specified QryMergedMsgsReq message. Does not implicitly {@link immessage.QryMergedMsgsReq.verify|verify} messages.
         * @param message QryMergedMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryMergedMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryMergedMsgsReq message, length delimited. Does not implicitly {@link immessage.QryMergedMsgsReq.verify|verify} messages.
         * @param message QryMergedMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryMergedMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryMergedMsgsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryMergedMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryMergedMsgsReq;

        /**
         * Decodes a QryMergedMsgsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryMergedMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryMergedMsgsReq;

        /**
         * Verifies a QryMergedMsgsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryMergedMsgsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryMergedMsgsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryMergedMsgsReq;

        /**
         * Creates a plain object from a QryMergedMsgsReq message. Also converts values to other types if specified.
         * @param message QryMergedMsgsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryMergedMsgsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryMergedMsgsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryMergedMsgsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MsgExt. */
    interface IMsgExt {

        /** MsgExt targetId */
        targetId?: (string|null);

        /** MsgExt channelType */
        channelType?: (immessage.ChannelType|null);

        /** MsgExt msgId */
        msgId?: (string|null);

        /** MsgExt ext */
        ext?: (immessage.IMsgExtItem|null);
    }

    /** Represents a MsgExt. */
    class MsgExt implements IMsgExt {

        /**
         * Constructs a new MsgExt.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMsgExt);

        /** MsgExt targetId. */
        public targetId: string;

        /** MsgExt channelType. */
        public channelType: immessage.ChannelType;

        /** MsgExt msgId. */
        public msgId: string;

        /** MsgExt ext. */
        public ext?: (immessage.IMsgExtItem|null);

        /**
         * Creates a new MsgExt instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MsgExt instance
         */
        public static create(properties?: immessage.IMsgExt): immessage.MsgExt;

        /**
         * Encodes the specified MsgExt message. Does not implicitly {@link immessage.MsgExt.verify|verify} messages.
         * @param message MsgExt message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMsgExt, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MsgExt message, length delimited. Does not implicitly {@link immessage.MsgExt.verify|verify} messages.
         * @param message MsgExt message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMsgExt, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MsgExt message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MsgExt
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MsgExt;

        /**
         * Decodes a MsgExt message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MsgExt
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MsgExt;

        /**
         * Verifies a MsgExt message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MsgExt message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MsgExt
         */
        public static fromObject(object: { [k: string]: any }): immessage.MsgExt;

        /**
         * Creates a plain object from a MsgExt message. Also converts values to other types if specified.
         * @param message MsgExt
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MsgExt, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MsgExt to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MsgExt
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MsgExtItem. */
    interface IMsgExtItem {

        /** MsgExtItem key */
        key?: (string|null);

        /** MsgExtItem value */
        value?: (string|null);

        /** MsgExtItem timestamp */
        timestamp?: (number|Long|null);

        /** MsgExtItem userInfo */
        userInfo?: (immessage.IUserInfo|null);
    }

    /** Represents a MsgExtItem. */
    class MsgExtItem implements IMsgExtItem {

        /**
         * Constructs a new MsgExtItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMsgExtItem);

        /** MsgExtItem key. */
        public key: string;

        /** MsgExtItem value. */
        public value: string;

        /** MsgExtItem timestamp. */
        public timestamp: (number|Long);

        /** MsgExtItem userInfo. */
        public userInfo?: (immessage.IUserInfo|null);

        /**
         * Creates a new MsgExtItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MsgExtItem instance
         */
        public static create(properties?: immessage.IMsgExtItem): immessage.MsgExtItem;

        /**
         * Encodes the specified MsgExtItem message. Does not implicitly {@link immessage.MsgExtItem.verify|verify} messages.
         * @param message MsgExtItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMsgExtItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MsgExtItem message, length delimited. Does not implicitly {@link immessage.MsgExtItem.verify|verify} messages.
         * @param message MsgExtItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMsgExtItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MsgExtItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MsgExtItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MsgExtItem;

        /**
         * Decodes a MsgExtItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MsgExtItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MsgExtItem;

        /**
         * Verifies a MsgExtItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MsgExtItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MsgExtItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.MsgExtItem;

        /**
         * Creates a plain object from a MsgExtItem message. Also converts values to other types if specified.
         * @param message MsgExtItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MsgExtItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MsgExtItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MsgExtItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryMsgExtReq. */
    interface IQryMsgExtReq {

        /** QryMsgExtReq targetId */
        targetId?: (string|null);

        /** QryMsgExtReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryMsgExtReq msgIds */
        msgIds?: (string[]|null);
    }

    /** Represents a QryMsgExtReq. */
    class QryMsgExtReq implements IQryMsgExtReq {

        /**
         * Constructs a new QryMsgExtReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryMsgExtReq);

        /** QryMsgExtReq targetId. */
        public targetId: string;

        /** QryMsgExtReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryMsgExtReq msgIds. */
        public msgIds: string[];

        /**
         * Creates a new QryMsgExtReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryMsgExtReq instance
         */
        public static create(properties?: immessage.IQryMsgExtReq): immessage.QryMsgExtReq;

        /**
         * Encodes the specified QryMsgExtReq message. Does not implicitly {@link immessage.QryMsgExtReq.verify|verify} messages.
         * @param message QryMsgExtReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryMsgExtReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryMsgExtReq message, length delimited. Does not implicitly {@link immessage.QryMsgExtReq.verify|verify} messages.
         * @param message QryMsgExtReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryMsgExtReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryMsgExtReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryMsgExtReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryMsgExtReq;

        /**
         * Decodes a QryMsgExtReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryMsgExtReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryMsgExtReq;

        /**
         * Verifies a QryMsgExtReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryMsgExtReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryMsgExtReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryMsgExtReq;

        /**
         * Creates a plain object from a QryMsgExtReq message. Also converts values to other types if specified.
         * @param message QryMsgExtReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryMsgExtReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryMsgExtReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryMsgExtReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MsgExtItemsList. */
    interface IMsgExtItemsList {

        /** MsgExtItemsList items */
        items?: (immessage.IMsgExtItems[]|null);
    }

    /** Represents a MsgExtItemsList. */
    class MsgExtItemsList implements IMsgExtItemsList {

        /**
         * Constructs a new MsgExtItemsList.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMsgExtItemsList);

        /** MsgExtItemsList items. */
        public items: immessage.IMsgExtItems[];

        /**
         * Creates a new MsgExtItemsList instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MsgExtItemsList instance
         */
        public static create(properties?: immessage.IMsgExtItemsList): immessage.MsgExtItemsList;

        /**
         * Encodes the specified MsgExtItemsList message. Does not implicitly {@link immessage.MsgExtItemsList.verify|verify} messages.
         * @param message MsgExtItemsList message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMsgExtItemsList, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MsgExtItemsList message, length delimited. Does not implicitly {@link immessage.MsgExtItemsList.verify|verify} messages.
         * @param message MsgExtItemsList message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMsgExtItemsList, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MsgExtItemsList message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MsgExtItemsList
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MsgExtItemsList;

        /**
         * Decodes a MsgExtItemsList message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MsgExtItemsList
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MsgExtItemsList;

        /**
         * Verifies a MsgExtItemsList message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MsgExtItemsList message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MsgExtItemsList
         */
        public static fromObject(object: { [k: string]: any }): immessage.MsgExtItemsList;

        /**
         * Creates a plain object from a MsgExtItemsList message. Also converts values to other types if specified.
         * @param message MsgExtItemsList
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MsgExtItemsList, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MsgExtItemsList to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MsgExtItemsList
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MsgExtItems. */
    interface IMsgExtItems {

        /** MsgExtItems msgId */
        msgId?: (string|null);

        /** MsgExtItems exts */
        exts?: (immessage.IMsgExtItem[]|null);
    }

    /** Represents a MsgExtItems. */
    class MsgExtItems implements IMsgExtItems {

        /**
         * Constructs a new MsgExtItems.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMsgExtItems);

        /** MsgExtItems msgId. */
        public msgId: string;

        /** MsgExtItems exts. */
        public exts: immessage.IMsgExtItem[];

        /**
         * Creates a new MsgExtItems instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MsgExtItems instance
         */
        public static create(properties?: immessage.IMsgExtItems): immessage.MsgExtItems;

        /**
         * Encodes the specified MsgExtItems message. Does not implicitly {@link immessage.MsgExtItems.verify|verify} messages.
         * @param message MsgExtItems message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMsgExtItems, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MsgExtItems message, length delimited. Does not implicitly {@link immessage.MsgExtItems.verify|verify} messages.
         * @param message MsgExtItems message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMsgExtItems, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MsgExtItems message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MsgExtItems
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MsgExtItems;

        /**
         * Decodes a MsgExtItems message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MsgExtItems
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MsgExtItems;

        /**
         * Verifies a MsgExtItems message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MsgExtItems message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MsgExtItems
         */
        public static fromObject(object: { [k: string]: any }): immessage.MsgExtItems;

        /**
         * Creates a plain object from a MsgExtItems message. Also converts values to other types if specified.
         * @param message MsgExtItems
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MsgExtItems, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MsgExtItems to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MsgExtItems
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a FavoriteMsgIds. */
    interface IFavoriteMsgIds {

        /** FavoriteMsgIds items */
        items?: (immessage.IFavoriteMsgIdItem[]|null);
    }

    /** Represents a FavoriteMsgIds. */
    class FavoriteMsgIds implements IFavoriteMsgIds {

        /**
         * Constructs a new FavoriteMsgIds.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IFavoriteMsgIds);

        /** FavoriteMsgIds items. */
        public items: immessage.IFavoriteMsgIdItem[];

        /**
         * Creates a new FavoriteMsgIds instance using the specified properties.
         * @param [properties] Properties to set
         * @returns FavoriteMsgIds instance
         */
        public static create(properties?: immessage.IFavoriteMsgIds): immessage.FavoriteMsgIds;

        /**
         * Encodes the specified FavoriteMsgIds message. Does not implicitly {@link immessage.FavoriteMsgIds.verify|verify} messages.
         * @param message FavoriteMsgIds message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IFavoriteMsgIds, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified FavoriteMsgIds message, length delimited. Does not implicitly {@link immessage.FavoriteMsgIds.verify|verify} messages.
         * @param message FavoriteMsgIds message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IFavoriteMsgIds, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a FavoriteMsgIds message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns FavoriteMsgIds
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.FavoriteMsgIds;

        /**
         * Decodes a FavoriteMsgIds message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns FavoriteMsgIds
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.FavoriteMsgIds;

        /**
         * Verifies a FavoriteMsgIds message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a FavoriteMsgIds message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns FavoriteMsgIds
         */
        public static fromObject(object: { [k: string]: any }): immessage.FavoriteMsgIds;

        /**
         * Creates a plain object from a FavoriteMsgIds message. Also converts values to other types if specified.
         * @param message FavoriteMsgIds
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.FavoriteMsgIds, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this FavoriteMsgIds to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for FavoriteMsgIds
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a FavoriteMsgIdItem. */
    interface IFavoriteMsgIdItem {

        /** FavoriteMsgIdItem senderId */
        senderId?: (string|null);

        /** FavoriteMsgIdItem receiverId */
        receiverId?: (string|null);

        /** FavoriteMsgIdItem channelType */
        channelType?: (immessage.ChannelType|null);

        /** FavoriteMsgIdItem msgId */
        msgId?: (string|null);
    }

    /** Represents a FavoriteMsgIdItem. */
    class FavoriteMsgIdItem implements IFavoriteMsgIdItem {

        /**
         * Constructs a new FavoriteMsgIdItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IFavoriteMsgIdItem);

        /** FavoriteMsgIdItem senderId. */
        public senderId: string;

        /** FavoriteMsgIdItem receiverId. */
        public receiverId: string;

        /** FavoriteMsgIdItem channelType. */
        public channelType: immessage.ChannelType;

        /** FavoriteMsgIdItem msgId. */
        public msgId: string;

        /**
         * Creates a new FavoriteMsgIdItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns FavoriteMsgIdItem instance
         */
        public static create(properties?: immessage.IFavoriteMsgIdItem): immessage.FavoriteMsgIdItem;

        /**
         * Encodes the specified FavoriteMsgIdItem message. Does not implicitly {@link immessage.FavoriteMsgIdItem.verify|verify} messages.
         * @param message FavoriteMsgIdItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IFavoriteMsgIdItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified FavoriteMsgIdItem message, length delimited. Does not implicitly {@link immessage.FavoriteMsgIdItem.verify|verify} messages.
         * @param message FavoriteMsgIdItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IFavoriteMsgIdItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a FavoriteMsgIdItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns FavoriteMsgIdItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.FavoriteMsgIdItem;

        /**
         * Decodes a FavoriteMsgIdItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns FavoriteMsgIdItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.FavoriteMsgIdItem;

        /**
         * Verifies a FavoriteMsgIdItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a FavoriteMsgIdItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns FavoriteMsgIdItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.FavoriteMsgIdItem;

        /**
         * Creates a plain object from a FavoriteMsgIdItem message. Also converts values to other types if specified.
         * @param message FavoriteMsgIdItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.FavoriteMsgIdItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this FavoriteMsgIdItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for FavoriteMsgIdItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryFavoriteMsgsReq. */
    interface IQryFavoriteMsgsReq {

        /** QryFavoriteMsgsReq limit */
        limit?: (number|Long|null);

        /** QryFavoriteMsgsReq offset */
        offset?: (string|null);
    }

    /** Represents a QryFavoriteMsgsReq. */
    class QryFavoriteMsgsReq implements IQryFavoriteMsgsReq {

        /**
         * Constructs a new QryFavoriteMsgsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryFavoriteMsgsReq);

        /** QryFavoriteMsgsReq limit. */
        public limit: (number|Long);

        /** QryFavoriteMsgsReq offset. */
        public offset: string;

        /**
         * Creates a new QryFavoriteMsgsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryFavoriteMsgsReq instance
         */
        public static create(properties?: immessage.IQryFavoriteMsgsReq): immessage.QryFavoriteMsgsReq;

        /**
         * Encodes the specified QryFavoriteMsgsReq message. Does not implicitly {@link immessage.QryFavoriteMsgsReq.verify|verify} messages.
         * @param message QryFavoriteMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryFavoriteMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryFavoriteMsgsReq message, length delimited. Does not implicitly {@link immessage.QryFavoriteMsgsReq.verify|verify} messages.
         * @param message QryFavoriteMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryFavoriteMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryFavoriteMsgsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryFavoriteMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryFavoriteMsgsReq;

        /**
         * Decodes a QryFavoriteMsgsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryFavoriteMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryFavoriteMsgsReq;

        /**
         * Verifies a QryFavoriteMsgsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryFavoriteMsgsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryFavoriteMsgsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryFavoriteMsgsReq;

        /**
         * Creates a plain object from a QryFavoriteMsgsReq message. Also converts values to other types if specified.
         * @param message QryFavoriteMsgsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryFavoriteMsgsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryFavoriteMsgsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryFavoriteMsgsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a FavoriteMsg. */
    interface IFavoriteMsg {

        /** FavoriteMsg msg */
        msg?: (immessage.IDownMsg|null);

        /** FavoriteMsg createdTime */
        createdTime?: (number|Long|null);
    }

    /** Represents a FavoriteMsg. */
    class FavoriteMsg implements IFavoriteMsg {

        /**
         * Constructs a new FavoriteMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IFavoriteMsg);

        /** FavoriteMsg msg. */
        public msg?: (immessage.IDownMsg|null);

        /** FavoriteMsg createdTime. */
        public createdTime: (number|Long);

        /**
         * Creates a new FavoriteMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns FavoriteMsg instance
         */
        public static create(properties?: immessage.IFavoriteMsg): immessage.FavoriteMsg;

        /**
         * Encodes the specified FavoriteMsg message. Does not implicitly {@link immessage.FavoriteMsg.verify|verify} messages.
         * @param message FavoriteMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IFavoriteMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified FavoriteMsg message, length delimited. Does not implicitly {@link immessage.FavoriteMsg.verify|verify} messages.
         * @param message FavoriteMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IFavoriteMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a FavoriteMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns FavoriteMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.FavoriteMsg;

        /**
         * Decodes a FavoriteMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns FavoriteMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.FavoriteMsg;

        /**
         * Verifies a FavoriteMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a FavoriteMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns FavoriteMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.FavoriteMsg;

        /**
         * Creates a plain object from a FavoriteMsg message. Also converts values to other types if specified.
         * @param message FavoriteMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.FavoriteMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this FavoriteMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for FavoriteMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a FavoriteMsgs. */
    interface IFavoriteMsgs {

        /** FavoriteMsgs items */
        items?: (immessage.IFavoriteMsg[]|null);

        /** FavoriteMsgs offset */
        offset?: (string|null);
    }

    /** Represents a FavoriteMsgs. */
    class FavoriteMsgs implements IFavoriteMsgs {

        /**
         * Constructs a new FavoriteMsgs.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IFavoriteMsgs);

        /** FavoriteMsgs items. */
        public items: immessage.IFavoriteMsg[];

        /** FavoriteMsgs offset. */
        public offset: string;

        /**
         * Creates a new FavoriteMsgs instance using the specified properties.
         * @param [properties] Properties to set
         * @returns FavoriteMsgs instance
         */
        public static create(properties?: immessage.IFavoriteMsgs): immessage.FavoriteMsgs;

        /**
         * Encodes the specified FavoriteMsgs message. Does not implicitly {@link immessage.FavoriteMsgs.verify|verify} messages.
         * @param message FavoriteMsgs message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IFavoriteMsgs, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified FavoriteMsgs message, length delimited. Does not implicitly {@link immessage.FavoriteMsgs.verify|verify} messages.
         * @param message FavoriteMsgs message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IFavoriteMsgs, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a FavoriteMsgs message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns FavoriteMsgs
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.FavoriteMsgs;

        /**
         * Decodes a FavoriteMsgs message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns FavoriteMsgs
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.FavoriteMsgs;

        /**
         * Verifies a FavoriteMsgs message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a FavoriteMsgs message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns FavoriteMsgs
         */
        public static fromObject(object: { [k: string]: any }): immessage.FavoriteMsgs;

        /**
         * Creates a plain object from a FavoriteMsgs message. Also converts values to other types if specified.
         * @param message FavoriteMsgs
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.FavoriteMsgs, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this FavoriteMsgs to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for FavoriteMsgs
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a TopMsgReq. */
    interface ITopMsgReq {

        /** TopMsgReq targetId */
        targetId?: (string|null);

        /** TopMsgReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** TopMsgReq msgId */
        msgId?: (string|null);
    }

    /** Represents a TopMsgReq. */
    class TopMsgReq implements ITopMsgReq {

        /**
         * Constructs a new TopMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ITopMsgReq);

        /** TopMsgReq targetId. */
        public targetId: string;

        /** TopMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /** TopMsgReq msgId. */
        public msgId: string;

        /**
         * Creates a new TopMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns TopMsgReq instance
         */
        public static create(properties?: immessage.ITopMsgReq): immessage.TopMsgReq;

        /**
         * Encodes the specified TopMsgReq message. Does not implicitly {@link immessage.TopMsgReq.verify|verify} messages.
         * @param message TopMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ITopMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified TopMsgReq message, length delimited. Does not implicitly {@link immessage.TopMsgReq.verify|verify} messages.
         * @param message TopMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ITopMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a TopMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns TopMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.TopMsgReq;

        /**
         * Decodes a TopMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns TopMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.TopMsgReq;

        /**
         * Verifies a TopMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a TopMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns TopMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.TopMsgReq;

        /**
         * Creates a plain object from a TopMsgReq message. Also converts values to other types if specified.
         * @param message TopMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.TopMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this TopMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for TopMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GetTopMsgReq. */
    interface IGetTopMsgReq {

        /** GetTopMsgReq targetId */
        targetId?: (string|null);

        /** GetTopMsgReq channelType */
        channelType?: (immessage.ChannelType|null);
    }

    /** Represents a GetTopMsgReq. */
    class GetTopMsgReq implements IGetTopMsgReq {

        /**
         * Constructs a new GetTopMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGetTopMsgReq);

        /** GetTopMsgReq targetId. */
        public targetId: string;

        /** GetTopMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /**
         * Creates a new GetTopMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GetTopMsgReq instance
         */
        public static create(properties?: immessage.IGetTopMsgReq): immessage.GetTopMsgReq;

        /**
         * Encodes the specified GetTopMsgReq message. Does not implicitly {@link immessage.GetTopMsgReq.verify|verify} messages.
         * @param message GetTopMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGetTopMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GetTopMsgReq message, length delimited. Does not implicitly {@link immessage.GetTopMsgReq.verify|verify} messages.
         * @param message GetTopMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGetTopMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GetTopMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GetTopMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GetTopMsgReq;

        /**
         * Decodes a GetTopMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GetTopMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GetTopMsgReq;

        /**
         * Verifies a GetTopMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GetTopMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GetTopMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.GetTopMsgReq;

        /**
         * Creates a plain object from a GetTopMsgReq message. Also converts values to other types if specified.
         * @param message GetTopMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GetTopMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GetTopMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GetTopMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a TopMsg. */
    interface ITopMsg {

        /** TopMsg msg */
        msg?: (immessage.IDownMsg|null);

        /** TopMsg operator */
        operator?: (immessage.IUserInfo|null);

        /** TopMsg createdTime */
        createdTime?: (number|Long|null);
    }

    /** Represents a TopMsg. */
    class TopMsg implements ITopMsg {

        /**
         * Constructs a new TopMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ITopMsg);

        /** TopMsg msg. */
        public msg?: (immessage.IDownMsg|null);

        /** TopMsg operator. */
        public operator?: (immessage.IUserInfo|null);

        /** TopMsg createdTime. */
        public createdTime: (number|Long);

        /**
         * Creates a new TopMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns TopMsg instance
         */
        public static create(properties?: immessage.ITopMsg): immessage.TopMsg;

        /**
         * Encodes the specified TopMsg message. Does not implicitly {@link immessage.TopMsg.verify|verify} messages.
         * @param message TopMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ITopMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified TopMsg message, length delimited. Does not implicitly {@link immessage.TopMsg.verify|verify} messages.
         * @param message TopMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ITopMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a TopMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns TopMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.TopMsg;

        /**
         * Decodes a TopMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns TopMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.TopMsg;

        /**
         * Verifies a TopMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a TopMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns TopMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.TopMsg;

        /**
         * Creates a plain object from a TopMsg message. Also converts values to other types if specified.
         * @param message TopMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.TopMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this TopMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for TopMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SearchMsgsReq. */
    interface ISearchMsgsReq {

        /** SearchMsgsReq targetId */
        targetId?: (string|null);

        /** SearchMsgsReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** SearchMsgsReq keyword */
        keyword?: (string|null);

        /** SearchMsgsReq count */
        count?: (number|null);
    }

    /** Represents a SearchMsgsReq. */
    class SearchMsgsReq implements ISearchMsgsReq {

        /**
         * Constructs a new SearchMsgsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISearchMsgsReq);

        /** SearchMsgsReq targetId. */
        public targetId: string;

        /** SearchMsgsReq channelType. */
        public channelType: immessage.ChannelType;

        /** SearchMsgsReq keyword. */
        public keyword: string;

        /** SearchMsgsReq count. */
        public count: number;

        /**
         * Creates a new SearchMsgsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SearchMsgsReq instance
         */
        public static create(properties?: immessage.ISearchMsgsReq): immessage.SearchMsgsReq;

        /**
         * Encodes the specified SearchMsgsReq message. Does not implicitly {@link immessage.SearchMsgsReq.verify|verify} messages.
         * @param message SearchMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISearchMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SearchMsgsReq message, length delimited. Does not implicitly {@link immessage.SearchMsgsReq.verify|verify} messages.
         * @param message SearchMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISearchMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SearchMsgsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SearchMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SearchMsgsReq;

        /**
         * Decodes a SearchMsgsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SearchMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SearchMsgsReq;

        /**
         * Verifies a SearchMsgsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SearchMsgsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SearchMsgsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.SearchMsgsReq;

        /**
         * Creates a plain object from a SearchMsgsReq message. Also converts values to other types if specified.
         * @param message SearchMsgsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SearchMsgsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SearchMsgsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SearchMsgsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BatchSearchMsgsReq. */
    interface IBatchSearchMsgsReq {

        /** BatchSearchMsgsReq convers */
        convers?: (immessage.ISimpleConversation[]|null);

        /** BatchSearchMsgsReq keyword */
        keyword?: (string|null);

        /** BatchSearchMsgsReq count */
        count?: (number|null);
    }

    /** Represents a BatchSearchMsgsReq. */
    class BatchSearchMsgsReq implements IBatchSearchMsgsReq {

        /**
         * Constructs a new BatchSearchMsgsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBatchSearchMsgsReq);

        /** BatchSearchMsgsReq convers. */
        public convers: immessage.ISimpleConversation[];

        /** BatchSearchMsgsReq keyword. */
        public keyword: string;

        /** BatchSearchMsgsReq count. */
        public count: number;

        /**
         * Creates a new BatchSearchMsgsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BatchSearchMsgsReq instance
         */
        public static create(properties?: immessage.IBatchSearchMsgsReq): immessage.BatchSearchMsgsReq;

        /**
         * Encodes the specified BatchSearchMsgsReq message. Does not implicitly {@link immessage.BatchSearchMsgsReq.verify|verify} messages.
         * @param message BatchSearchMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBatchSearchMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BatchSearchMsgsReq message, length delimited. Does not implicitly {@link immessage.BatchSearchMsgsReq.verify|verify} messages.
         * @param message BatchSearchMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBatchSearchMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BatchSearchMsgsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BatchSearchMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BatchSearchMsgsReq;

        /**
         * Decodes a BatchSearchMsgsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BatchSearchMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BatchSearchMsgsReq;

        /**
         * Verifies a BatchSearchMsgsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BatchSearchMsgsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BatchSearchMsgsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.BatchSearchMsgsReq;

        /**
         * Creates a plain object from a BatchSearchMsgsReq message. Also converts values to other types if specified.
         * @param message BatchSearchMsgsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BatchSearchMsgsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BatchSearchMsgsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BatchSearchMsgsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SearchMsgsResp. */
    interface ISearchMsgsResp {

        /** SearchMsgsResp targetId */
        targetId?: (string|null);

        /** SearchMsgsResp channelType */
        channelType?: (immessage.ChannelType|null);

        /** SearchMsgsResp items */
        items?: (immessage.ISearchMsgItem[]|null);

        /** SearchMsgsResp maxScore */
        maxScore?: (number|null);
    }

    /** Represents a SearchMsgsResp. */
    class SearchMsgsResp implements ISearchMsgsResp {

        /**
         * Constructs a new SearchMsgsResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISearchMsgsResp);

        /** SearchMsgsResp targetId. */
        public targetId: string;

        /** SearchMsgsResp channelType. */
        public channelType: immessage.ChannelType;

        /** SearchMsgsResp items. */
        public items: immessage.ISearchMsgItem[];

        /** SearchMsgsResp maxScore. */
        public maxScore: number;

        /**
         * Creates a new SearchMsgsResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SearchMsgsResp instance
         */
        public static create(properties?: immessage.ISearchMsgsResp): immessage.SearchMsgsResp;

        /**
         * Encodes the specified SearchMsgsResp message. Does not implicitly {@link immessage.SearchMsgsResp.verify|verify} messages.
         * @param message SearchMsgsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISearchMsgsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SearchMsgsResp message, length delimited. Does not implicitly {@link immessage.SearchMsgsResp.verify|verify} messages.
         * @param message SearchMsgsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISearchMsgsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SearchMsgsResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SearchMsgsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SearchMsgsResp;

        /**
         * Decodes a SearchMsgsResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SearchMsgsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SearchMsgsResp;

        /**
         * Verifies a SearchMsgsResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SearchMsgsResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SearchMsgsResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.SearchMsgsResp;

        /**
         * Creates a plain object from a SearchMsgsResp message. Also converts values to other types if specified.
         * @param message SearchMsgsResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SearchMsgsResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SearchMsgsResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SearchMsgsResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SearchMsgItem. */
    interface ISearchMsgItem {

        /** SearchMsgItem highlightText */
        highlightText?: (string|null);

        /** SearchMsgItem msg */
        msg?: (immessage.IDownMsg|null);

        /** SearchMsgItem score */
        score?: (number|null);
    }

    /** Represents a SearchMsgItem. */
    class SearchMsgItem implements ISearchMsgItem {

        /**
         * Constructs a new SearchMsgItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISearchMsgItem);

        /** SearchMsgItem highlightText. */
        public highlightText: string;

        /** SearchMsgItem msg. */
        public msg?: (immessage.IDownMsg|null);

        /** SearchMsgItem score. */
        public score: number;

        /**
         * Creates a new SearchMsgItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SearchMsgItem instance
         */
        public static create(properties?: immessage.ISearchMsgItem): immessage.SearchMsgItem;

        /**
         * Encodes the specified SearchMsgItem message. Does not implicitly {@link immessage.SearchMsgItem.verify|verify} messages.
         * @param message SearchMsgItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISearchMsgItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SearchMsgItem message, length delimited. Does not implicitly {@link immessage.SearchMsgItem.verify|verify} messages.
         * @param message SearchMsgItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISearchMsgItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SearchMsgItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SearchMsgItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SearchMsgItem;

        /**
         * Decodes a SearchMsgItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SearchMsgItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SearchMsgItem;

        /**
         * Verifies a SearchMsgItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SearchMsgItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SearchMsgItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.SearchMsgItem;

        /**
         * Creates a plain object from a SearchMsgItem message. Also converts values to other types if specified.
         * @param message SearchMsgItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SearchMsgItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SearchMsgItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SearchMsgItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BatchSearchMsgsResp. */
    interface IBatchSearchMsgsResp {

        /** BatchSearchMsgsResp items */
        items?: (immessage.ISearchMsgsResp[]|null);

        /** BatchSearchMsgsResp maxScore */
        maxScore?: (number|null);
    }

    /** Represents a BatchSearchMsgsResp. */
    class BatchSearchMsgsResp implements IBatchSearchMsgsResp {

        /**
         * Constructs a new BatchSearchMsgsResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBatchSearchMsgsResp);

        /** BatchSearchMsgsResp items. */
        public items: immessage.ISearchMsgsResp[];

        /** BatchSearchMsgsResp maxScore. */
        public maxScore: number;

        /**
         * Creates a new BatchSearchMsgsResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BatchSearchMsgsResp instance
         */
        public static create(properties?: immessage.IBatchSearchMsgsResp): immessage.BatchSearchMsgsResp;

        /**
         * Encodes the specified BatchSearchMsgsResp message. Does not implicitly {@link immessage.BatchSearchMsgsResp.verify|verify} messages.
         * @param message BatchSearchMsgsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBatchSearchMsgsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BatchSearchMsgsResp message, length delimited. Does not implicitly {@link immessage.BatchSearchMsgsResp.verify|verify} messages.
         * @param message BatchSearchMsgsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBatchSearchMsgsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BatchSearchMsgsResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BatchSearchMsgsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BatchSearchMsgsResp;

        /**
         * Decodes a BatchSearchMsgsResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BatchSearchMsgsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BatchSearchMsgsResp;

        /**
         * Verifies a BatchSearchMsgsResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BatchSearchMsgsResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BatchSearchMsgsResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.BatchSearchMsgsResp;

        /**
         * Creates a plain object from a BatchSearchMsgsResp message. Also converts values to other types if specified.
         * @param message BatchSearchMsgsResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BatchSearchMsgsResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BatchSearchMsgsResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BatchSearchMsgsResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryGlobalConversReq. */
    interface IQryGlobalConversReq {

        /** QryGlobalConversReq start */
        start?: (number|Long|null);

        /** QryGlobalConversReq count */
        count?: (number|null);

        /** QryGlobalConversReq order */
        order?: (number|null);

        /** QryGlobalConversReq targetId */
        targetId?: (string|null);

        /** QryGlobalConversReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryGlobalConversReq excludeUserIds */
        excludeUserIds?: (string[]|null);
    }

    /** Represents a QryGlobalConversReq. */
    class QryGlobalConversReq implements IQryGlobalConversReq {

        /**
         * Constructs a new QryGlobalConversReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryGlobalConversReq);

        /** QryGlobalConversReq start. */
        public start: (number|Long);

        /** QryGlobalConversReq count. */
        public count: number;

        /** QryGlobalConversReq order. */
        public order: number;

        /** QryGlobalConversReq targetId. */
        public targetId: string;

        /** QryGlobalConversReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryGlobalConversReq excludeUserIds. */
        public excludeUserIds: string[];

        /**
         * Creates a new QryGlobalConversReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryGlobalConversReq instance
         */
        public static create(properties?: immessage.IQryGlobalConversReq): immessage.QryGlobalConversReq;

        /**
         * Encodes the specified QryGlobalConversReq message. Does not implicitly {@link immessage.QryGlobalConversReq.verify|verify} messages.
         * @param message QryGlobalConversReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryGlobalConversReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryGlobalConversReq message, length delimited. Does not implicitly {@link immessage.QryGlobalConversReq.verify|verify} messages.
         * @param message QryGlobalConversReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryGlobalConversReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryGlobalConversReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryGlobalConversReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryGlobalConversReq;

        /**
         * Decodes a QryGlobalConversReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryGlobalConversReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryGlobalConversReq;

        /**
         * Verifies a QryGlobalConversReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryGlobalConversReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryGlobalConversReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryGlobalConversReq;

        /**
         * Creates a plain object from a QryGlobalConversReq message. Also converts values to other types if specified.
         * @param message QryGlobalConversReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryGlobalConversReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryGlobalConversReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryGlobalConversReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryGlobalConversResp. */
    interface IQryGlobalConversResp {

        /** QryGlobalConversResp convers */
        convers?: (immessage.IGlobalConver[]|null);

        /** QryGlobalConversResp isFinished */
        isFinished?: (boolean|null);
    }

    /** Represents a QryGlobalConversResp. */
    class QryGlobalConversResp implements IQryGlobalConversResp {

        /**
         * Constructs a new QryGlobalConversResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryGlobalConversResp);

        /** QryGlobalConversResp convers. */
        public convers: immessage.IGlobalConver[];

        /** QryGlobalConversResp isFinished. */
        public isFinished: boolean;

        /**
         * Creates a new QryGlobalConversResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryGlobalConversResp instance
         */
        public static create(properties?: immessage.IQryGlobalConversResp): immessage.QryGlobalConversResp;

        /**
         * Encodes the specified QryGlobalConversResp message. Does not implicitly {@link immessage.QryGlobalConversResp.verify|verify} messages.
         * @param message QryGlobalConversResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryGlobalConversResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryGlobalConversResp message, length delimited. Does not implicitly {@link immessage.QryGlobalConversResp.verify|verify} messages.
         * @param message QryGlobalConversResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryGlobalConversResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryGlobalConversResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryGlobalConversResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryGlobalConversResp;

        /**
         * Decodes a QryGlobalConversResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryGlobalConversResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryGlobalConversResp;

        /**
         * Verifies a QryGlobalConversResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryGlobalConversResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryGlobalConversResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryGlobalConversResp;

        /**
         * Creates a plain object from a QryGlobalConversResp message. Also converts values to other types if specified.
         * @param message QryGlobalConversResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryGlobalConversResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryGlobalConversResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryGlobalConversResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GlobalConver. */
    interface IGlobalConver {

        /** GlobalConver Id */
        Id?: (string|null);

        /** GlobalConver converId */
        converId?: (string|null);

        /** GlobalConver senderId */
        senderId?: (string|null);

        /** GlobalConver targetId */
        targetId?: (string|null);

        /** GlobalConver channelType */
        channelType?: (immessage.ChannelType|null);

        /** GlobalConver updatedTime */
        updatedTime?: (number|Long|null);
    }

    /** Represents a GlobalConver. */
    class GlobalConver implements IGlobalConver {

        /**
         * Constructs a new GlobalConver.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGlobalConver);

        /** GlobalConver Id. */
        public Id: string;

        /** GlobalConver converId. */
        public converId: string;

        /** GlobalConver senderId. */
        public senderId: string;

        /** GlobalConver targetId. */
        public targetId: string;

        /** GlobalConver channelType. */
        public channelType: immessage.ChannelType;

        /** GlobalConver updatedTime. */
        public updatedTime: (number|Long);

        /**
         * Creates a new GlobalConver instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GlobalConver instance
         */
        public static create(properties?: immessage.IGlobalConver): immessage.GlobalConver;

        /**
         * Encodes the specified GlobalConver message. Does not implicitly {@link immessage.GlobalConver.verify|verify} messages.
         * @param message GlobalConver message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGlobalConver, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GlobalConver message, length delimited. Does not implicitly {@link immessage.GlobalConver.verify|verify} messages.
         * @param message GlobalConver message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGlobalConver, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GlobalConver message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GlobalConver
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GlobalConver;

        /**
         * Decodes a GlobalConver message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GlobalConver
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GlobalConver;

        /**
         * Verifies a GlobalConver message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GlobalConver message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GlobalConver
         */
        public static fromObject(object: { [k: string]: any }): immessage.GlobalConver;

        /**
         * Creates a plain object from a GlobalConver message. Also converts values to other types if specified.
         * @param message GlobalConver
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GlobalConver, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GlobalConver to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GlobalConver
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryConversationsReq. */
    interface IQryConversationsReq {

        /** QryConversationsReq startTime */
        startTime?: (number|Long|null);

        /** QryConversationsReq count */
        count?: (number|null);

        /** QryConversationsReq order */
        order?: (number|null);

        /** QryConversationsReq targetId */
        targetId?: (string|null);

        /** QryConversationsReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryConversationsReq tag */
        tag?: (string|null);

        /** QryConversationsReq permitConvers */
        permitConvers?: (immessage.IPermitConver[]|null);

        /** QryConversationsReq onlyConver */
        onlyConver?: (boolean|null);
    }

    /** Represents a QryConversationsReq. */
    class QryConversationsReq implements IQryConversationsReq {

        /**
         * Constructs a new QryConversationsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryConversationsReq);

        /** QryConversationsReq startTime. */
        public startTime: (number|Long);

        /** QryConversationsReq count. */
        public count: number;

        /** QryConversationsReq order. */
        public order: number;

        /** QryConversationsReq targetId. */
        public targetId: string;

        /** QryConversationsReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryConversationsReq tag. */
        public tag: string;

        /** QryConversationsReq permitConvers. */
        public permitConvers: immessage.IPermitConver[];

        /** QryConversationsReq onlyConver. */
        public onlyConver: boolean;

        /**
         * Creates a new QryConversationsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryConversationsReq instance
         */
        public static create(properties?: immessage.IQryConversationsReq): immessage.QryConversationsReq;

        /**
         * Encodes the specified QryConversationsReq message. Does not implicitly {@link immessage.QryConversationsReq.verify|verify} messages.
         * @param message QryConversationsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryConversationsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryConversationsReq message, length delimited. Does not implicitly {@link immessage.QryConversationsReq.verify|verify} messages.
         * @param message QryConversationsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryConversationsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryConversationsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryConversationsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryConversationsReq;

        /**
         * Decodes a QryConversationsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryConversationsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryConversationsReq;

        /**
         * Verifies a QryConversationsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryConversationsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryConversationsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryConversationsReq;

        /**
         * Creates a plain object from a QryConversationsReq message. Also converts values to other types if specified.
         * @param message QryConversationsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryConversationsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryConversationsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryConversationsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryConversationsResp. */
    interface IQryConversationsResp {

        /** QryConversationsResp conversations */
        conversations?: (immessage.IConversation[]|null);

        /** QryConversationsResp isFinished */
        isFinished?: (boolean|null);
    }

    /** Represents a QryConversationsResp. */
    class QryConversationsResp implements IQryConversationsResp {

        /**
         * Constructs a new QryConversationsResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryConversationsResp);

        /** QryConversationsResp conversations. */
        public conversations: immessage.IConversation[];

        /** QryConversationsResp isFinished. */
        public isFinished: boolean;

        /**
         * Creates a new QryConversationsResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryConversationsResp instance
         */
        public static create(properties?: immessage.IQryConversationsResp): immessage.QryConversationsResp;

        /**
         * Encodes the specified QryConversationsResp message. Does not implicitly {@link immessage.QryConversationsResp.verify|verify} messages.
         * @param message QryConversationsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryConversationsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryConversationsResp message, length delimited. Does not implicitly {@link immessage.QryConversationsResp.verify|verify} messages.
         * @param message QryConversationsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryConversationsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryConversationsResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryConversationsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryConversationsResp;

        /**
         * Decodes a QryConversationsResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryConversationsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryConversationsResp;

        /**
         * Verifies a QryConversationsResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryConversationsResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryConversationsResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryConversationsResp;

        /**
         * Creates a plain object from a QryConversationsResp message. Also converts values to other types if specified.
         * @param message QryConversationsResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryConversationsResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryConversationsResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryConversationsResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a Conversation. */
    interface IConversation {

        /** Conversation userId */
        userId?: (string|null);

        /** Conversation targetId */
        targetId?: (string|null);

        /** Conversation channelType */
        channelType?: (immessage.ChannelType|null);

        /** Conversation sortTime */
        sortTime?: (number|Long|null);

        /** Conversation unreadCount */
        unreadCount?: (number|Long|null);

        /** Conversation msg */
        msg?: (immessage.IDownMsg|null);

        /** Conversation latestReadIndex */
        latestReadIndex?: (number|Long|null);

        /** Conversation mentions */
        mentions?: (immessage.IMentions|null);

        /** Conversation isTop */
        isTop?: (number|null);

        /** Conversation topUpdatedTime */
        topUpdatedTime?: (number|Long|null);

        /** Conversation undisturbType */
        undisturbType?: (number|null);

        /** Conversation targetUserInfo */
        targetUserInfo?: (immessage.IUserInfo|null);

        /** Conversation groupInfo */
        groupInfo?: (immessage.IGroupInfo|null);

        /** Conversation syncTime */
        syncTime?: (number|Long|null);

        /** Conversation isDelete */
        isDelete?: (number|null);

        /** Conversation latestUnreadIndex */
        latestUnreadIndex?: (number|Long|null);

        /** Conversation unreadTag */
        unreadTag?: (number|null);

        /** Conversation latestReadMsgId */
        latestReadMsgId?: (string|null);

        /** Conversation latestReadMsgTime */
        latestReadMsgTime?: (number|Long|null);

        /** Conversation converTags */
        converTags?: (immessage.IConverTag[]|null);
    }

    /** Represents a Conversation. */
    class Conversation implements IConversation {

        /**
         * Constructs a new Conversation.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IConversation);

        /** Conversation userId. */
        public userId: string;

        /** Conversation targetId. */
        public targetId: string;

        /** Conversation channelType. */
        public channelType: immessage.ChannelType;

        /** Conversation sortTime. */
        public sortTime: (number|Long);

        /** Conversation unreadCount. */
        public unreadCount: (number|Long);

        /** Conversation msg. */
        public msg?: (immessage.IDownMsg|null);

        /** Conversation latestReadIndex. */
        public latestReadIndex: (number|Long);

        /** Conversation mentions. */
        public mentions?: (immessage.IMentions|null);

        /** Conversation isTop. */
        public isTop: number;

        /** Conversation topUpdatedTime. */
        public topUpdatedTime: (number|Long);

        /** Conversation undisturbType. */
        public undisturbType: number;

        /** Conversation targetUserInfo. */
        public targetUserInfo?: (immessage.IUserInfo|null);

        /** Conversation groupInfo. */
        public groupInfo?: (immessage.IGroupInfo|null);

        /** Conversation syncTime. */
        public syncTime: (number|Long);

        /** Conversation isDelete. */
        public isDelete: number;

        /** Conversation latestUnreadIndex. */
        public latestUnreadIndex: (number|Long);

        /** Conversation unreadTag. */
        public unreadTag: number;

        /** Conversation latestReadMsgId. */
        public latestReadMsgId: string;

        /** Conversation latestReadMsgTime. */
        public latestReadMsgTime: (number|Long);

        /** Conversation converTags. */
        public converTags: immessage.IConverTag[];

        /**
         * Creates a new Conversation instance using the specified properties.
         * @param [properties] Properties to set
         * @returns Conversation instance
         */
        public static create(properties?: immessage.IConversation): immessage.Conversation;

        /**
         * Encodes the specified Conversation message. Does not implicitly {@link immessage.Conversation.verify|verify} messages.
         * @param message Conversation message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IConversation, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified Conversation message, length delimited. Does not implicitly {@link immessage.Conversation.verify|verify} messages.
         * @param message Conversation message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IConversation, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a Conversation message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns Conversation
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.Conversation;

        /**
         * Decodes a Conversation message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns Conversation
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.Conversation;

        /**
         * Verifies a Conversation message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a Conversation message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns Conversation
         */
        public static fromObject(object: { [k: string]: any }): immessage.Conversation;

        /**
         * Creates a plain object from a Conversation message. Also converts values to other types if specified.
         * @param message Conversation
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.Conversation, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this Conversation to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for Conversation
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BatchAddConvers. */
    interface IBatchAddConvers {

        /** BatchAddConvers convers */
        convers?: (immessage.IConversation[]|null);
    }

    /** Represents a BatchAddConvers. */
    class BatchAddConvers implements IBatchAddConvers {

        /**
         * Constructs a new BatchAddConvers.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBatchAddConvers);

        /** BatchAddConvers convers. */
        public convers: immessage.IConversation[];

        /**
         * Creates a new BatchAddConvers instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BatchAddConvers instance
         */
        public static create(properties?: immessage.IBatchAddConvers): immessage.BatchAddConvers;

        /**
         * Encodes the specified BatchAddConvers message. Does not implicitly {@link immessage.BatchAddConvers.verify|verify} messages.
         * @param message BatchAddConvers message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBatchAddConvers, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BatchAddConvers message, length delimited. Does not implicitly {@link immessage.BatchAddConvers.verify|verify} messages.
         * @param message BatchAddConvers message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBatchAddConvers, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BatchAddConvers message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BatchAddConvers
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BatchAddConvers;

        /**
         * Decodes a BatchAddConvers message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BatchAddConvers
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BatchAddConvers;

        /**
         * Verifies a BatchAddConvers message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BatchAddConvers message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BatchAddConvers
         */
        public static fromObject(object: { [k: string]: any }): immessage.BatchAddConvers;

        /**
         * Creates a plain object from a BatchAddConvers message. Also converts values to other types if specified.
         * @param message BatchAddConvers
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BatchAddConvers, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BatchAddConvers to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BatchAddConvers
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserMsgTimeItem. */
    interface IUserMsgTimeItem {

        /** UserMsgTimeItem userId */
        userId?: (string|null);

        /** UserMsgTimeItem msgTime */
        msgTime?: (number|Long|null);
    }

    /** Represents a UserMsgTimeItem. */
    class UserMsgTimeItem implements IUserMsgTimeItem {

        /**
         * Constructs a new UserMsgTimeItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserMsgTimeItem);

        /** UserMsgTimeItem userId. */
        public userId: string;

        /** UserMsgTimeItem msgTime. */
        public msgTime: (number|Long);

        /**
         * Creates a new UserMsgTimeItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserMsgTimeItem instance
         */
        public static create(properties?: immessage.IUserMsgTimeItem): immessage.UserMsgTimeItem;

        /**
         * Encodes the specified UserMsgTimeItem message. Does not implicitly {@link immessage.UserMsgTimeItem.verify|verify} messages.
         * @param message UserMsgTimeItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserMsgTimeItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserMsgTimeItem message, length delimited. Does not implicitly {@link immessage.UserMsgTimeItem.verify|verify} messages.
         * @param message UserMsgTimeItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserMsgTimeItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserMsgTimeItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserMsgTimeItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserMsgTimeItem;

        /**
         * Decodes a UserMsgTimeItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserMsgTimeItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserMsgTimeItem;

        /**
         * Verifies a UserMsgTimeItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserMsgTimeItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserMsgTimeItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserMsgTimeItem;

        /**
         * Creates a plain object from a UserMsgTimeItem message. Also converts values to other types if specified.
         * @param message UserMsgTimeItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserMsgTimeItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserMsgTimeItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserMsgTimeItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** UpdLatestMsgAction enum. */
    enum UpdLatestMsgAction {
        UpdMsg = 0,
        UpdRead = 1
    }

    /** Properties of an UpdLatestMsgReq. */
    interface IUpdLatestMsgReq {

        /** UpdLatestMsgReq targetId */
        targetId?: (string|null);

        /** UpdLatestMsgReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** UpdLatestMsgReq latestMsgId */
        latestMsgId?: (string|null);

        /** UpdLatestMsgReq action */
        action?: (immessage.UpdLatestMsgAction|null);

        /** UpdLatestMsgReq msg */
        msg?: (immessage.IDownMsg|null);

        /** UpdLatestMsgReq isRead */
        isRead?: (boolean|null);
    }

    /** Represents an UpdLatestMsgReq. */
    class UpdLatestMsgReq implements IUpdLatestMsgReq {

        /**
         * Constructs a new UpdLatestMsgReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUpdLatestMsgReq);

        /** UpdLatestMsgReq targetId. */
        public targetId: string;

        /** UpdLatestMsgReq channelType. */
        public channelType: immessage.ChannelType;

        /** UpdLatestMsgReq latestMsgId. */
        public latestMsgId: string;

        /** UpdLatestMsgReq action. */
        public action: immessage.UpdLatestMsgAction;

        /** UpdLatestMsgReq msg. */
        public msg?: (immessage.IDownMsg|null);

        /** UpdLatestMsgReq isRead. */
        public isRead: boolean;

        /**
         * Creates a new UpdLatestMsgReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UpdLatestMsgReq instance
         */
        public static create(properties?: immessage.IUpdLatestMsgReq): immessage.UpdLatestMsgReq;

        /**
         * Encodes the specified UpdLatestMsgReq message. Does not implicitly {@link immessage.UpdLatestMsgReq.verify|verify} messages.
         * @param message UpdLatestMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUpdLatestMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UpdLatestMsgReq message, length delimited. Does not implicitly {@link immessage.UpdLatestMsgReq.verify|verify} messages.
         * @param message UpdLatestMsgReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUpdLatestMsgReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an UpdLatestMsgReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UpdLatestMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UpdLatestMsgReq;

        /**
         * Decodes an UpdLatestMsgReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UpdLatestMsgReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UpdLatestMsgReq;

        /**
         * Verifies an UpdLatestMsgReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an UpdLatestMsgReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UpdLatestMsgReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.UpdLatestMsgReq;

        /**
         * Creates a plain object from an UpdLatestMsgReq message. Also converts values to other types if specified.
         * @param message UpdLatestMsgReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UpdLatestMsgReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UpdLatestMsgReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UpdLatestMsgReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a Mentions. */
    interface IMentions {

        /** Mentions isMentioned */
        isMentioned?: (boolean|null);

        /** Mentions mentionMsgCount */
        mentionMsgCount?: (number|null);

        /** Mentions senders */
        senders?: (immessage.IUserInfo[]|null);

        /** Mentions mentionMsgs */
        mentionMsgs?: (immessage.IMentionMsg[]|null);
    }

    /** Represents a Mentions. */
    class Mentions implements IMentions {

        /**
         * Constructs a new Mentions.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMentions);

        /** Mentions isMentioned. */
        public isMentioned: boolean;

        /** Mentions mentionMsgCount. */
        public mentionMsgCount: number;

        /** Mentions senders. */
        public senders: immessage.IUserInfo[];

        /** Mentions mentionMsgs. */
        public mentionMsgs: immessage.IMentionMsg[];

        /**
         * Creates a new Mentions instance using the specified properties.
         * @param [properties] Properties to set
         * @returns Mentions instance
         */
        public static create(properties?: immessage.IMentions): immessage.Mentions;

        /**
         * Encodes the specified Mentions message. Does not implicitly {@link immessage.Mentions.verify|verify} messages.
         * @param message Mentions message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMentions, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified Mentions message, length delimited. Does not implicitly {@link immessage.Mentions.verify|verify} messages.
         * @param message Mentions message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMentions, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a Mentions message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns Mentions
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.Mentions;

        /**
         * Decodes a Mentions message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns Mentions
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.Mentions;

        /**
         * Verifies a Mentions message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a Mentions message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns Mentions
         */
        public static fromObject(object: { [k: string]: any }): immessage.Mentions;

        /**
         * Creates a plain object from a Mentions message. Also converts values to other types if specified.
         * @param message Mentions
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.Mentions, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this Mentions to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for Mentions
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MentionMsg. */
    interface IMentionMsg {

        /** MentionMsg senderId */
        senderId?: (string|null);

        /** MentionMsg msgId */
        msgId?: (string|null);

        /** MentionMsg msgTime */
        msgTime?: (number|Long|null);

        /** MentionMsg mentionType */
        mentionType?: (immessage.MentionType|null);
    }

    /** Represents a MentionMsg. */
    class MentionMsg implements IMentionMsg {

        /**
         * Constructs a new MentionMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMentionMsg);

        /** MentionMsg senderId. */
        public senderId: string;

        /** MentionMsg msgId. */
        public msgId: string;

        /** MentionMsg msgTime. */
        public msgTime: (number|Long);

        /** MentionMsg mentionType. */
        public mentionType: immessage.MentionType;

        /**
         * Creates a new MentionMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MentionMsg instance
         */
        public static create(properties?: immessage.IMentionMsg): immessage.MentionMsg;

        /**
         * Encodes the specified MentionMsg message. Does not implicitly {@link immessage.MentionMsg.verify|verify} messages.
         * @param message MentionMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMentionMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MentionMsg message, length delimited. Does not implicitly {@link immessage.MentionMsg.verify|verify} messages.
         * @param message MentionMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMentionMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MentionMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MentionMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MentionMsg;

        /**
         * Decodes a MentionMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MentionMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MentionMsg;

        /**
         * Verifies a MentionMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MentionMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MentionMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.MentionMsg;

        /**
         * Creates a plain object from a MentionMsg message. Also converts values to other types if specified.
         * @param message MentionMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MentionMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MentionMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MentionMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryMentionMsgsReq. */
    interface IQryMentionMsgsReq {

        /** QryMentionMsgsReq targetId */
        targetId?: (string|null);

        /** QryMentionMsgsReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryMentionMsgsReq startTime */
        startTime?: (number|Long|null);

        /** QryMentionMsgsReq count */
        count?: (number|null);

        /** QryMentionMsgsReq order */
        order?: (number|null);

        /** QryMentionMsgsReq latestReadIndex */
        latestReadIndex?: (number|Long|null);

        /** QryMentionMsgsReq maxHisMsgCount */
        maxHisMsgCount?: (number|null);

        /** QryMentionMsgsReq targetIdAlias */
        targetIdAlias?: (string|null);
    }

    /** Represents a QryMentionMsgsReq. */
    class QryMentionMsgsReq implements IQryMentionMsgsReq {

        /**
         * Constructs a new QryMentionMsgsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryMentionMsgsReq);

        /** QryMentionMsgsReq targetId. */
        public targetId: string;

        /** QryMentionMsgsReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryMentionMsgsReq startTime. */
        public startTime: (number|Long);

        /** QryMentionMsgsReq count. */
        public count: number;

        /** QryMentionMsgsReq order. */
        public order: number;

        /** QryMentionMsgsReq latestReadIndex. */
        public latestReadIndex: (number|Long);

        /** QryMentionMsgsReq maxHisMsgCount. */
        public maxHisMsgCount: number;

        /** QryMentionMsgsReq targetIdAlias. */
        public targetIdAlias: string;

        /**
         * Creates a new QryMentionMsgsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryMentionMsgsReq instance
         */
        public static create(properties?: immessage.IQryMentionMsgsReq): immessage.QryMentionMsgsReq;

        /**
         * Encodes the specified QryMentionMsgsReq message. Does not implicitly {@link immessage.QryMentionMsgsReq.verify|verify} messages.
         * @param message QryMentionMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryMentionMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryMentionMsgsReq message, length delimited. Does not implicitly {@link immessage.QryMentionMsgsReq.verify|verify} messages.
         * @param message QryMentionMsgsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryMentionMsgsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryMentionMsgsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryMentionMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryMentionMsgsReq;

        /**
         * Decodes a QryMentionMsgsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryMentionMsgsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryMentionMsgsReq;

        /**
         * Verifies a QryMentionMsgsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryMentionMsgsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryMentionMsgsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryMentionMsgsReq;

        /**
         * Creates a plain object from a QryMentionMsgsReq message. Also converts values to other types if specified.
         * @param message QryMentionMsgsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryMentionMsgsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryMentionMsgsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryMentionMsgsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryMentionMsgsResp. */
    interface IQryMentionMsgsResp {

        /** QryMentionMsgsResp mentionMsgs */
        mentionMsgs?: (immessage.IDownMsg[]|null);

        /** QryMentionMsgsResp isFinished */
        isFinished?: (boolean|null);
    }

    /** Represents a QryMentionMsgsResp. */
    class QryMentionMsgsResp implements IQryMentionMsgsResp {

        /**
         * Constructs a new QryMentionMsgsResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryMentionMsgsResp);

        /** QryMentionMsgsResp mentionMsgs. */
        public mentionMsgs: immessage.IDownMsg[];

        /** QryMentionMsgsResp isFinished. */
        public isFinished: boolean;

        /**
         * Creates a new QryMentionMsgsResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryMentionMsgsResp instance
         */
        public static create(properties?: immessage.IQryMentionMsgsResp): immessage.QryMentionMsgsResp;

        /**
         * Encodes the specified QryMentionMsgsResp message. Does not implicitly {@link immessage.QryMentionMsgsResp.verify|verify} messages.
         * @param message QryMentionMsgsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryMentionMsgsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryMentionMsgsResp message, length delimited. Does not implicitly {@link immessage.QryMentionMsgsResp.verify|verify} messages.
         * @param message QryMentionMsgsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryMentionMsgsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryMentionMsgsResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryMentionMsgsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryMentionMsgsResp;

        /**
         * Decodes a QryMentionMsgsResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryMentionMsgsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryMentionMsgsResp;

        /**
         * Verifies a QryMentionMsgsResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryMentionMsgsResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryMentionMsgsResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryMentionMsgsResp;

        /**
         * Creates a plain object from a QryMentionMsgsResp message. Also converts values to other types if specified.
         * @param message QryMentionMsgsResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryMentionMsgsResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryMentionMsgsResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryMentionMsgsResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SyncConversationsReq. */
    interface ISyncConversationsReq {

        /** SyncConversationsReq startTime */
        startTime?: (number|Long|null);

        /** SyncConversationsReq count */
        count?: (number|null);
    }

    /** Represents a SyncConversationsReq. */
    class SyncConversationsReq implements ISyncConversationsReq {

        /**
         * Constructs a new SyncConversationsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISyncConversationsReq);

        /** SyncConversationsReq startTime. */
        public startTime: (number|Long);

        /** SyncConversationsReq count. */
        public count: number;

        /**
         * Creates a new SyncConversationsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SyncConversationsReq instance
         */
        public static create(properties?: immessage.ISyncConversationsReq): immessage.SyncConversationsReq;

        /**
         * Encodes the specified SyncConversationsReq message. Does not implicitly {@link immessage.SyncConversationsReq.verify|verify} messages.
         * @param message SyncConversationsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISyncConversationsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SyncConversationsReq message, length delimited. Does not implicitly {@link immessage.SyncConversationsReq.verify|verify} messages.
         * @param message SyncConversationsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISyncConversationsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SyncConversationsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SyncConversationsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SyncConversationsReq;

        /**
         * Decodes a SyncConversationsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SyncConversationsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SyncConversationsReq;

        /**
         * Verifies a SyncConversationsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SyncConversationsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SyncConversationsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.SyncConversationsReq;

        /**
         * Creates a plain object from a SyncConversationsReq message. Also converts values to other types if specified.
         * @param message SyncConversationsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SyncConversationsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SyncConversationsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SyncConversationsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryTotalUnreadCountReq. */
    interface IQryTotalUnreadCountReq {

        /** QryTotalUnreadCountReq time */
        time?: (number|Long|null);

        /** QryTotalUnreadCountReq filter */
        filter?: (immessage.IConverFilter|null);
    }

    /** Represents a QryTotalUnreadCountReq. */
    class QryTotalUnreadCountReq implements IQryTotalUnreadCountReq {

        /**
         * Constructs a new QryTotalUnreadCountReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryTotalUnreadCountReq);

        /** QryTotalUnreadCountReq time. */
        public time: (number|Long);

        /** QryTotalUnreadCountReq filter. */
        public filter?: (immessage.IConverFilter|null);

        /**
         * Creates a new QryTotalUnreadCountReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryTotalUnreadCountReq instance
         */
        public static create(properties?: immessage.IQryTotalUnreadCountReq): immessage.QryTotalUnreadCountReq;

        /**
         * Encodes the specified QryTotalUnreadCountReq message. Does not implicitly {@link immessage.QryTotalUnreadCountReq.verify|verify} messages.
         * @param message QryTotalUnreadCountReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryTotalUnreadCountReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryTotalUnreadCountReq message, length delimited. Does not implicitly {@link immessage.QryTotalUnreadCountReq.verify|verify} messages.
         * @param message QryTotalUnreadCountReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryTotalUnreadCountReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryTotalUnreadCountReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryTotalUnreadCountReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryTotalUnreadCountReq;

        /**
         * Decodes a QryTotalUnreadCountReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryTotalUnreadCountReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryTotalUnreadCountReq;

        /**
         * Verifies a QryTotalUnreadCountReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryTotalUnreadCountReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryTotalUnreadCountReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryTotalUnreadCountReq;

        /**
         * Creates a plain object from a QryTotalUnreadCountReq message. Also converts values to other types if specified.
         * @param message QryTotalUnreadCountReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryTotalUnreadCountReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryTotalUnreadCountReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryTotalUnreadCountReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ConverFilter. */
    interface IConverFilter {

        /** ConverFilter channelTypes */
        channelTypes?: (immessage.ChannelType[]|null);

        /** ConverFilter excludeConvers */
        excludeConvers?: (immessage.ISimpleConversation[]|null);

        /** ConverFilter includeConvers */
        includeConvers?: (immessage.ISimpleConversation[]|null);

        /** ConverFilter tag */
        tag?: (string|null);
    }

    /** Represents a ConverFilter. */
    class ConverFilter implements IConverFilter {

        /**
         * Constructs a new ConverFilter.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IConverFilter);

        /** ConverFilter channelTypes. */
        public channelTypes: immessage.ChannelType[];

        /** ConverFilter excludeConvers. */
        public excludeConvers: immessage.ISimpleConversation[];

        /** ConverFilter includeConvers. */
        public includeConvers: immessage.ISimpleConversation[];

        /** ConverFilter tag. */
        public tag: string;

        /**
         * Creates a new ConverFilter instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ConverFilter instance
         */
        public static create(properties?: immessage.IConverFilter): immessage.ConverFilter;

        /**
         * Encodes the specified ConverFilter message. Does not implicitly {@link immessage.ConverFilter.verify|verify} messages.
         * @param message ConverFilter message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IConverFilter, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ConverFilter message, length delimited. Does not implicitly {@link immessage.ConverFilter.verify|verify} messages.
         * @param message ConverFilter message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IConverFilter, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ConverFilter message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ConverFilter
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.ConverFilter;

        /**
         * Decodes a ConverFilter message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ConverFilter
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.ConverFilter;

        /**
         * Verifies a ConverFilter message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ConverFilter message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ConverFilter
         */
        public static fromObject(object: { [k: string]: any }): immessage.ConverFilter;

        /**
         * Creates a plain object from a ConverFilter message. Also converts values to other types if specified.
         * @param message ConverFilter
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.ConverFilter, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ConverFilter to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ConverFilter
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryTotalUnreadCountResp. */
    interface IQryTotalUnreadCountResp {

        /** QryTotalUnreadCountResp totalCount */
        totalCount?: (number|Long|null);
    }

    /** Represents a QryTotalUnreadCountResp. */
    class QryTotalUnreadCountResp implements IQryTotalUnreadCountResp {

        /**
         * Constructs a new QryTotalUnreadCountResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryTotalUnreadCountResp);

        /** QryTotalUnreadCountResp totalCount. */
        public totalCount: (number|Long);

        /**
         * Creates a new QryTotalUnreadCountResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryTotalUnreadCountResp instance
         */
        public static create(properties?: immessage.IQryTotalUnreadCountResp): immessage.QryTotalUnreadCountResp;

        /**
         * Encodes the specified QryTotalUnreadCountResp message. Does not implicitly {@link immessage.QryTotalUnreadCountResp.verify|verify} messages.
         * @param message QryTotalUnreadCountResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryTotalUnreadCountResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryTotalUnreadCountResp message, length delimited. Does not implicitly {@link immessage.QryTotalUnreadCountResp.verify|verify} messages.
         * @param message QryTotalUnreadCountResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryTotalUnreadCountResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryTotalUnreadCountResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryTotalUnreadCountResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryTotalUnreadCountResp;

        /**
         * Decodes a QryTotalUnreadCountResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryTotalUnreadCountResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryTotalUnreadCountResp;

        /**
         * Verifies a QryTotalUnreadCountResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryTotalUnreadCountResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryTotalUnreadCountResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryTotalUnreadCountResp;

        /**
         * Creates a plain object from a QryTotalUnreadCountResp message. Also converts values to other types if specified.
         * @param message QryTotalUnreadCountResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryTotalUnreadCountResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryTotalUnreadCountResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryTotalUnreadCountResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ConversationsReq. */
    interface IConversationsReq {

        /** ConversationsReq conversations */
        conversations?: (immessage.IConversation[]|null);
    }

    /** Represents a ConversationsReq. */
    class ConversationsReq implements IConversationsReq {

        /**
         * Constructs a new ConversationsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IConversationsReq);

        /** ConversationsReq conversations. */
        public conversations: immessage.IConversation[];

        /**
         * Creates a new ConversationsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ConversationsReq instance
         */
        public static create(properties?: immessage.IConversationsReq): immessage.ConversationsReq;

        /**
         * Encodes the specified ConversationsReq message. Does not implicitly {@link immessage.ConversationsReq.verify|verify} messages.
         * @param message ConversationsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IConversationsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ConversationsReq message, length delimited. Does not implicitly {@link immessage.ConversationsReq.verify|verify} messages.
         * @param message ConversationsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IConversationsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ConversationsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ConversationsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.ConversationsReq;

        /**
         * Decodes a ConversationsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ConversationsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.ConversationsReq;

        /**
         * Verifies a ConversationsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ConversationsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ConversationsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.ConversationsReq;

        /**
         * Creates a plain object from a ConversationsReq message. Also converts values to other types if specified.
         * @param message ConversationsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.ConversationsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ConversationsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ConversationsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ClearUnreadReq. */
    interface IClearUnreadReq {

        /** ClearUnreadReq conversations */
        conversations?: (immessage.IConversation[]|null);

        /** ClearUnreadReq noCmdMsg */
        noCmdMsg?: (boolean|null);
    }

    /** Represents a ClearUnreadReq. */
    class ClearUnreadReq implements IClearUnreadReq {

        /**
         * Constructs a new ClearUnreadReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IClearUnreadReq);

        /** ClearUnreadReq conversations. */
        public conversations: immessage.IConversation[];

        /** ClearUnreadReq noCmdMsg. */
        public noCmdMsg: boolean;

        /**
         * Creates a new ClearUnreadReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ClearUnreadReq instance
         */
        public static create(properties?: immessage.IClearUnreadReq): immessage.ClearUnreadReq;

        /**
         * Encodes the specified ClearUnreadReq message. Does not implicitly {@link immessage.ClearUnreadReq.verify|verify} messages.
         * @param message ClearUnreadReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IClearUnreadReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ClearUnreadReq message, length delimited. Does not implicitly {@link immessage.ClearUnreadReq.verify|verify} messages.
         * @param message ClearUnreadReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IClearUnreadReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ClearUnreadReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ClearUnreadReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.ClearUnreadReq;

        /**
         * Decodes a ClearUnreadReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ClearUnreadReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.ClearUnreadReq;

        /**
         * Verifies a ClearUnreadReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ClearUnreadReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ClearUnreadReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.ClearUnreadReq;

        /**
         * Creates a plain object from a ClearUnreadReq message. Also converts values to other types if specified.
         * @param message ClearUnreadReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.ClearUnreadReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ClearUnreadReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ClearUnreadReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an UndisturbConversReq. */
    interface IUndisturbConversReq {

        /** UndisturbConversReq items */
        items?: (immessage.IUndisturbConverItem[]|null);
    }

    /** Represents an UndisturbConversReq. */
    class UndisturbConversReq implements IUndisturbConversReq {

        /**
         * Constructs a new UndisturbConversReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUndisturbConversReq);

        /** UndisturbConversReq items. */
        public items: immessage.IUndisturbConverItem[];

        /**
         * Creates a new UndisturbConversReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UndisturbConversReq instance
         */
        public static create(properties?: immessage.IUndisturbConversReq): immessage.UndisturbConversReq;

        /**
         * Encodes the specified UndisturbConversReq message. Does not implicitly {@link immessage.UndisturbConversReq.verify|verify} messages.
         * @param message UndisturbConversReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUndisturbConversReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UndisturbConversReq message, length delimited. Does not implicitly {@link immessage.UndisturbConversReq.verify|verify} messages.
         * @param message UndisturbConversReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUndisturbConversReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an UndisturbConversReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UndisturbConversReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UndisturbConversReq;

        /**
         * Decodes an UndisturbConversReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UndisturbConversReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UndisturbConversReq;

        /**
         * Verifies an UndisturbConversReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an UndisturbConversReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UndisturbConversReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.UndisturbConversReq;

        /**
         * Creates a plain object from an UndisturbConversReq message. Also converts values to other types if specified.
         * @param message UndisturbConversReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UndisturbConversReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UndisturbConversReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UndisturbConversReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an UndisturbConverItem. */
    interface IUndisturbConverItem {

        /** UndisturbConverItem targetId */
        targetId?: (string|null);

        /** UndisturbConverItem channelType */
        channelType?: (immessage.ChannelType|null);

        /** UndisturbConverItem undisturbType */
        undisturbType?: (number|null);
    }

    /** Represents an UndisturbConverItem. */
    class UndisturbConverItem implements IUndisturbConverItem {

        /**
         * Constructs a new UndisturbConverItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUndisturbConverItem);

        /** UndisturbConverItem targetId. */
        public targetId: string;

        /** UndisturbConverItem channelType. */
        public channelType: immessage.ChannelType;

        /** UndisturbConverItem undisturbType. */
        public undisturbType: number;

        /**
         * Creates a new UndisturbConverItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UndisturbConverItem instance
         */
        public static create(properties?: immessage.IUndisturbConverItem): immessage.UndisturbConverItem;

        /**
         * Encodes the specified UndisturbConverItem message. Does not implicitly {@link immessage.UndisturbConverItem.verify|verify} messages.
         * @param message UndisturbConverItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUndisturbConverItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UndisturbConverItem message, length delimited. Does not implicitly {@link immessage.UndisturbConverItem.verify|verify} messages.
         * @param message UndisturbConverItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUndisturbConverItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an UndisturbConverItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UndisturbConverItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UndisturbConverItem;

        /**
         * Decodes an UndisturbConverItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UndisturbConverItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UndisturbConverItem;

        /**
         * Verifies an UndisturbConverItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an UndisturbConverItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UndisturbConverItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.UndisturbConverItem;

        /**
         * Creates a plain object from an UndisturbConverItem message. Also converts values to other types if specified.
         * @param message UndisturbConverItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UndisturbConverItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UndisturbConverItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UndisturbConverItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryTopConversReq. */
    interface IQryTopConversReq {

        /** QryTopConversReq startTime */
        startTime?: (number|Long|null);

        /** QryTopConversReq sortType */
        sortType?: (immessage.TopConverSortType|null);

        /** QryTopConversReq order */
        order?: (number|null);
    }

    /** Represents a QryTopConversReq. */
    class QryTopConversReq implements IQryTopConversReq {

        /**
         * Constructs a new QryTopConversReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryTopConversReq);

        /** QryTopConversReq startTime. */
        public startTime: (number|Long);

        /** QryTopConversReq sortType. */
        public sortType: immessage.TopConverSortType;

        /** QryTopConversReq order. */
        public order: number;

        /**
         * Creates a new QryTopConversReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryTopConversReq instance
         */
        public static create(properties?: immessage.IQryTopConversReq): immessage.QryTopConversReq;

        /**
         * Encodes the specified QryTopConversReq message. Does not implicitly {@link immessage.QryTopConversReq.verify|verify} messages.
         * @param message QryTopConversReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryTopConversReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryTopConversReq message, length delimited. Does not implicitly {@link immessage.QryTopConversReq.verify|verify} messages.
         * @param message QryTopConversReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryTopConversReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryTopConversReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryTopConversReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryTopConversReq;

        /**
         * Decodes a QryTopConversReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryTopConversReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryTopConversReq;

        /**
         * Verifies a QryTopConversReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryTopConversReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryTopConversReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryTopConversReq;

        /**
         * Creates a plain object from a QryTopConversReq message. Also converts values to other types if specified.
         * @param message QryTopConversReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryTopConversReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryTopConversReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryTopConversReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** TopConverSortType enum. */
    enum TopConverSortType {
        ByTopTime = 0,
        BySortTime = 1
    }

    /** Properties of a TopConversResp. */
    interface ITopConversResp {

        /** TopConversResp optTime */
        optTime?: (number|Long|null);
    }

    /** Represents a TopConversResp. */
    class TopConversResp implements ITopConversResp {

        /**
         * Constructs a new TopConversResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ITopConversResp);

        /** TopConversResp optTime. */
        public optTime: (number|Long);

        /**
         * Creates a new TopConversResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns TopConversResp instance
         */
        public static create(properties?: immessage.ITopConversResp): immessage.TopConversResp;

        /**
         * Encodes the specified TopConversResp message. Does not implicitly {@link immessage.TopConversResp.verify|verify} messages.
         * @param message TopConversResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ITopConversResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified TopConversResp message, length delimited. Does not implicitly {@link immessage.TopConversResp.verify|verify} messages.
         * @param message TopConversResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ITopConversResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a TopConversResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns TopConversResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.TopConversResp;

        /**
         * Decodes a TopConversResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns TopConversResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.TopConversResp;

        /**
         * Verifies a TopConversResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a TopConversResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns TopConversResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.TopConversResp;

        /**
         * Creates a plain object from a TopConversResp message. Also converts values to other types if specified.
         * @param message TopConversResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.TopConversResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this TopConversResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for TopConversResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryReadInfosReq. */
    interface IQryReadInfosReq {

        /** QryReadInfosReq targetId */
        targetId?: (string|null);

        /** QryReadInfosReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryReadInfosReq msgIds */
        msgIds?: (string[]|null);
    }

    /** Represents a QryReadInfosReq. */
    class QryReadInfosReq implements IQryReadInfosReq {

        /**
         * Constructs a new QryReadInfosReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryReadInfosReq);

        /** QryReadInfosReq targetId. */
        public targetId: string;

        /** QryReadInfosReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryReadInfosReq msgIds. */
        public msgIds: string[];

        /**
         * Creates a new QryReadInfosReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryReadInfosReq instance
         */
        public static create(properties?: immessage.IQryReadInfosReq): immessage.QryReadInfosReq;

        /**
         * Encodes the specified QryReadInfosReq message. Does not implicitly {@link immessage.QryReadInfosReq.verify|verify} messages.
         * @param message QryReadInfosReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryReadInfosReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryReadInfosReq message, length delimited. Does not implicitly {@link immessage.QryReadInfosReq.verify|verify} messages.
         * @param message QryReadInfosReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryReadInfosReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryReadInfosReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryReadInfosReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryReadInfosReq;

        /**
         * Decodes a QryReadInfosReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryReadInfosReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryReadInfosReq;

        /**
         * Verifies a QryReadInfosReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryReadInfosReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryReadInfosReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryReadInfosReq;

        /**
         * Creates a plain object from a QryReadInfosReq message. Also converts values to other types if specified.
         * @param message QryReadInfosReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryReadInfosReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryReadInfosReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryReadInfosReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryReadInfosResp. */
    interface IQryReadInfosResp {

        /** QryReadInfosResp items */
        items?: (immessage.IReadInfoItem[]|null);
    }

    /** Represents a QryReadInfosResp. */
    class QryReadInfosResp implements IQryReadInfosResp {

        /**
         * Constructs a new QryReadInfosResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryReadInfosResp);

        /** QryReadInfosResp items. */
        public items: immessage.IReadInfoItem[];

        /**
         * Creates a new QryReadInfosResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryReadInfosResp instance
         */
        public static create(properties?: immessage.IQryReadInfosResp): immessage.QryReadInfosResp;

        /**
         * Encodes the specified QryReadInfosResp message. Does not implicitly {@link immessage.QryReadInfosResp.verify|verify} messages.
         * @param message QryReadInfosResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryReadInfosResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryReadInfosResp message, length delimited. Does not implicitly {@link immessage.QryReadInfosResp.verify|verify} messages.
         * @param message QryReadInfosResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryReadInfosResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryReadInfosResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryReadInfosResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryReadInfosResp;

        /**
         * Decodes a QryReadInfosResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryReadInfosResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryReadInfosResp;

        /**
         * Verifies a QryReadInfosResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryReadInfosResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryReadInfosResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryReadInfosResp;

        /**
         * Creates a plain object from a QryReadInfosResp message. Also converts values to other types if specified.
         * @param message QryReadInfosResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryReadInfosResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryReadInfosResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryReadInfosResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ReadInfoItem. */
    interface IReadInfoItem {

        /** ReadInfoItem msgId */
        msgId?: (string|null);

        /** ReadInfoItem readCount */
        readCount?: (number|null);

        /** ReadInfoItem totalCount */
        totalCount?: (number|null);
    }

    /** Represents a ReadInfoItem. */
    class ReadInfoItem implements IReadInfoItem {

        /**
         * Constructs a new ReadInfoItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IReadInfoItem);

        /** ReadInfoItem msgId. */
        public msgId: string;

        /** ReadInfoItem readCount. */
        public readCount: number;

        /** ReadInfoItem totalCount. */
        public totalCount: number;

        /**
         * Creates a new ReadInfoItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ReadInfoItem instance
         */
        public static create(properties?: immessage.IReadInfoItem): immessage.ReadInfoItem;

        /**
         * Encodes the specified ReadInfoItem message. Does not implicitly {@link immessage.ReadInfoItem.verify|verify} messages.
         * @param message ReadInfoItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IReadInfoItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ReadInfoItem message, length delimited. Does not implicitly {@link immessage.ReadInfoItem.verify|verify} messages.
         * @param message ReadInfoItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IReadInfoItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ReadInfoItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ReadInfoItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.ReadInfoItem;

        /**
         * Decodes a ReadInfoItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ReadInfoItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.ReadInfoItem;

        /**
         * Verifies a ReadInfoItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ReadInfoItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ReadInfoItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.ReadInfoItem;

        /**
         * Creates a plain object from a ReadInfoItem message. Also converts values to other types if specified.
         * @param message ReadInfoItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.ReadInfoItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ReadInfoItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ReadInfoItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryReadDetailReq. */
    interface IQryReadDetailReq {

        /** QryReadDetailReq targetId */
        targetId?: (string|null);

        /** QryReadDetailReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryReadDetailReq msgId */
        msgId?: (string|null);
    }

    /** Represents a QryReadDetailReq. */
    class QryReadDetailReq implements IQryReadDetailReq {

        /**
         * Constructs a new QryReadDetailReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryReadDetailReq);

        /** QryReadDetailReq targetId. */
        public targetId: string;

        /** QryReadDetailReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryReadDetailReq msgId. */
        public msgId: string;

        /**
         * Creates a new QryReadDetailReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryReadDetailReq instance
         */
        public static create(properties?: immessage.IQryReadDetailReq): immessage.QryReadDetailReq;

        /**
         * Encodes the specified QryReadDetailReq message. Does not implicitly {@link immessage.QryReadDetailReq.verify|verify} messages.
         * @param message QryReadDetailReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryReadDetailReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryReadDetailReq message, length delimited. Does not implicitly {@link immessage.QryReadDetailReq.verify|verify} messages.
         * @param message QryReadDetailReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryReadDetailReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryReadDetailReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryReadDetailReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryReadDetailReq;

        /**
         * Decodes a QryReadDetailReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryReadDetailReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryReadDetailReq;

        /**
         * Verifies a QryReadDetailReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryReadDetailReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryReadDetailReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryReadDetailReq;

        /**
         * Creates a plain object from a QryReadDetailReq message. Also converts values to other types if specified.
         * @param message QryReadDetailReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryReadDetailReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryReadDetailReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryReadDetailReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryReadDetailResp. */
    interface IQryReadDetailResp {

        /** QryReadDetailResp readCount */
        readCount?: (number|null);

        /** QryReadDetailResp memberCount */
        memberCount?: (number|null);

        /** QryReadDetailResp readMembers */
        readMembers?: (immessage.IMemberReadDetailItem[]|null);

        /** QryReadDetailResp unreadMembers */
        unreadMembers?: (immessage.IMemberReadDetailItem[]|null);
    }

    /** Represents a QryReadDetailResp. */
    class QryReadDetailResp implements IQryReadDetailResp {

        /**
         * Constructs a new QryReadDetailResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryReadDetailResp);

        /** QryReadDetailResp readCount. */
        public readCount: number;

        /** QryReadDetailResp memberCount. */
        public memberCount: number;

        /** QryReadDetailResp readMembers. */
        public readMembers: immessage.IMemberReadDetailItem[];

        /** QryReadDetailResp unreadMembers. */
        public unreadMembers: immessage.IMemberReadDetailItem[];

        /**
         * Creates a new QryReadDetailResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryReadDetailResp instance
         */
        public static create(properties?: immessage.IQryReadDetailResp): immessage.QryReadDetailResp;

        /**
         * Encodes the specified QryReadDetailResp message. Does not implicitly {@link immessage.QryReadDetailResp.verify|verify} messages.
         * @param message QryReadDetailResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryReadDetailResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryReadDetailResp message, length delimited. Does not implicitly {@link immessage.QryReadDetailResp.verify|verify} messages.
         * @param message QryReadDetailResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryReadDetailResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryReadDetailResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryReadDetailResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryReadDetailResp;

        /**
         * Decodes a QryReadDetailResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryReadDetailResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryReadDetailResp;

        /**
         * Verifies a QryReadDetailResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryReadDetailResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryReadDetailResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryReadDetailResp;

        /**
         * Creates a plain object from a QryReadDetailResp message. Also converts values to other types if specified.
         * @param message QryReadDetailResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryReadDetailResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryReadDetailResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryReadDetailResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a MemberReadDetailItem. */
    interface IMemberReadDetailItem {

        /** MemberReadDetailItem member */
        member?: (immessage.IUserInfo|null);

        /** MemberReadDetailItem time */
        time?: (number|Long|null);
    }

    /** Represents a MemberReadDetailItem. */
    class MemberReadDetailItem implements IMemberReadDetailItem {

        /**
         * Constructs a new MemberReadDetailItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IMemberReadDetailItem);

        /** MemberReadDetailItem member. */
        public member?: (immessage.IUserInfo|null);

        /** MemberReadDetailItem time. */
        public time: (number|Long);

        /**
         * Creates a new MemberReadDetailItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns MemberReadDetailItem instance
         */
        public static create(properties?: immessage.IMemberReadDetailItem): immessage.MemberReadDetailItem;

        /**
         * Encodes the specified MemberReadDetailItem message. Does not implicitly {@link immessage.MemberReadDetailItem.verify|verify} messages.
         * @param message MemberReadDetailItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IMemberReadDetailItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified MemberReadDetailItem message, length delimited. Does not implicitly {@link immessage.MemberReadDetailItem.verify|verify} messages.
         * @param message MemberReadDetailItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IMemberReadDetailItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a MemberReadDetailItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns MemberReadDetailItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.MemberReadDetailItem;

        /**
         * Decodes a MemberReadDetailItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns MemberReadDetailItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.MemberReadDetailItem;

        /**
         * Verifies a MemberReadDetailItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a MemberReadDetailItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns MemberReadDetailItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.MemberReadDetailItem;

        /**
         * Creates a plain object from a MemberReadDetailItem message. Also converts values to other types if specified.
         * @param message MemberReadDetailItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.MemberReadDetailItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this MemberReadDetailItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for MemberReadDetailItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryConverReq. */
    interface IQryConverReq {

        /** QryConverReq targetId */
        targetId?: (string|null);

        /** QryConverReq channelType */
        channelType?: (immessage.ChannelType|null);

        /** QryConverReq isInner */
        isInner?: (boolean|null);

        /** QryConverReq userIds */
        userIds?: (string[]|null);

        /** QryConverReq targetIdAlias */
        targetIdAlias?: (string|null);
    }

    /** Represents a QryConverReq. */
    class QryConverReq implements IQryConverReq {

        /**
         * Constructs a new QryConverReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryConverReq);

        /** QryConverReq targetId. */
        public targetId: string;

        /** QryConverReq channelType. */
        public channelType: immessage.ChannelType;

        /** QryConverReq isInner. */
        public isInner: boolean;

        /** QryConverReq userIds. */
        public userIds: string[];

        /** QryConverReq targetIdAlias. */
        public targetIdAlias: string;

        /**
         * Creates a new QryConverReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryConverReq instance
         */
        public static create(properties?: immessage.IQryConverReq): immessage.QryConverReq;

        /**
         * Encodes the specified QryConverReq message. Does not implicitly {@link immessage.QryConverReq.verify|verify} messages.
         * @param message QryConverReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryConverReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryConverReq message, length delimited. Does not implicitly {@link immessage.QryConverReq.verify|verify} messages.
         * @param message QryConverReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryConverReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryConverReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryConverReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryConverReq;

        /**
         * Decodes a QryConverReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryConverReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryConverReq;

        /**
         * Verifies a QryConverReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryConverReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryConverReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryConverReq;

        /**
         * Creates a plain object from a QryConverReq message. Also converts values to other types if specified.
         * @param message QryConverReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryConverReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryConverReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryConverReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a TagConvers. */
    interface ITagConvers {

        /** TagConvers tag */
        tag?: (string|null);

        /** TagConvers tagName */
        tagName?: (string|null);

        /** TagConvers convers */
        convers?: (immessage.ISimpleConversation[]|null);
    }

    /** Represents a TagConvers. */
    class TagConvers implements ITagConvers {

        /**
         * Constructs a new TagConvers.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ITagConvers);

        /** TagConvers tag. */
        public tag: string;

        /** TagConvers tagName. */
        public tagName: string;

        /** TagConvers convers. */
        public convers: immessage.ISimpleConversation[];

        /**
         * Creates a new TagConvers instance using the specified properties.
         * @param [properties] Properties to set
         * @returns TagConvers instance
         */
        public static create(properties?: immessage.ITagConvers): immessage.TagConvers;

        /**
         * Encodes the specified TagConvers message. Does not implicitly {@link immessage.TagConvers.verify|verify} messages.
         * @param message TagConvers message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ITagConvers, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified TagConvers message, length delimited. Does not implicitly {@link immessage.TagConvers.verify|verify} messages.
         * @param message TagConvers message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ITagConvers, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a TagConvers message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns TagConvers
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.TagConvers;

        /**
         * Decodes a TagConvers message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns TagConvers
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.TagConvers;

        /**
         * Verifies a TagConvers message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a TagConvers message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns TagConvers
         */
        public static fromObject(object: { [k: string]: any }): immessage.TagConvers;

        /**
         * Creates a plain object from a TagConvers message. Also converts values to other types if specified.
         * @param message TagConvers
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.TagConvers, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this TagConvers to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for TagConvers
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserConverTags. */
    interface IUserConverTags {

        /** UserConverTags tags */
        tags?: (immessage.IConverTag[]|null);
    }

    /** Represents a UserConverTags. */
    class UserConverTags implements IUserConverTags {

        /**
         * Constructs a new UserConverTags.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserConverTags);

        /** UserConverTags tags. */
        public tags: immessage.IConverTag[];

        /**
         * Creates a new UserConverTags instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserConverTags instance
         */
        public static create(properties?: immessage.IUserConverTags): immessage.UserConverTags;

        /**
         * Encodes the specified UserConverTags message. Does not implicitly {@link immessage.UserConverTags.verify|verify} messages.
         * @param message UserConverTags message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserConverTags, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserConverTags message, length delimited. Does not implicitly {@link immessage.UserConverTags.verify|verify} messages.
         * @param message UserConverTags message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserConverTags, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserConverTags message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserConverTags
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserConverTags;

        /**
         * Decodes a UserConverTags message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserConverTags
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserConverTags;

        /**
         * Verifies a UserConverTags message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserConverTags message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserConverTags
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserConverTags;

        /**
         * Creates a plain object from a UserConverTags message. Also converts values to other types if specified.
         * @param message UserConverTags
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserConverTags, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserConverTags to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserConverTags
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ConverTag. */
    interface IConverTag {

        /** ConverTag tag */
        tag?: (string|null);

        /** ConverTag tagName */
        tagName?: (string|null);

        /** ConverTag tagType */
        tagType?: (immessage.ConverTagType|null);
    }

    /** Represents a ConverTag. */
    class ConverTag implements IConverTag {

        /**
         * Constructs a new ConverTag.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IConverTag);

        /** ConverTag tag. */
        public tag: string;

        /** ConverTag tagName. */
        public tagName: string;

        /** ConverTag tagType. */
        public tagType: immessage.ConverTagType;

        /**
         * Creates a new ConverTag instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ConverTag instance
         */
        public static create(properties?: immessage.IConverTag): immessage.ConverTag;

        /**
         * Encodes the specified ConverTag message. Does not implicitly {@link immessage.ConverTag.verify|verify} messages.
         * @param message ConverTag message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IConverTag, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ConverTag message, length delimited. Does not implicitly {@link immessage.ConverTag.verify|verify} messages.
         * @param message ConverTag message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IConverTag, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ConverTag message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ConverTag
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.ConverTag;

        /**
         * Decodes a ConverTag message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ConverTag
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.ConverTag;

        /**
         * Verifies a ConverTag message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ConverTag message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ConverTag
         */
        public static fromObject(object: { [k: string]: any }): immessage.ConverTag;

        /**
         * Creates a plain object from a ConverTag message. Also converts values to other types if specified.
         * @param message ConverTag
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.ConverTag, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ConverTag to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ConverTag
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a ConverExts. */
    interface IConverExts {

        /** ConverExts converTags */
        converTags?: ({ [k: string]: boolean }|null);
    }

    /** Represents a ConverExts. */
    class ConverExts implements IConverExts {

        /**
         * Constructs a new ConverExts.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IConverExts);

        /** ConverExts converTags. */
        public converTags: { [k: string]: boolean };

        /**
         * Creates a new ConverExts instance using the specified properties.
         * @param [properties] Properties to set
         * @returns ConverExts instance
         */
        public static create(properties?: immessage.IConverExts): immessage.ConverExts;

        /**
         * Encodes the specified ConverExts message. Does not implicitly {@link immessage.ConverExts.verify|verify} messages.
         * @param message ConverExts message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IConverExts, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified ConverExts message, length delimited. Does not implicitly {@link immessage.ConverExts.verify|verify} messages.
         * @param message ConverExts message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IConverExts, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a ConverExts message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns ConverExts
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.ConverExts;

        /**
         * Decodes a ConverExts message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns ConverExts
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.ConverExts;

        /**
         * Verifies a ConverExts message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a ConverExts message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns ConverExts
         */
        public static fromObject(object: { [k: string]: any }): immessage.ConverExts;

        /**
         * Creates a plain object from a ConverExts message. Also converts values to other types if specified.
         * @param message ConverExts
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.ConverExts, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this ConverExts to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for ConverExts
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** ConverTagType enum. */
    enum ConverTagType {
        UserConverTag = 0,
        SystemConverTag = 1,
        GlobalConverTag = 2
    }

    /** Properties of a UserInfo. */
    interface IUserInfo {

        /** UserInfo userId */
        userId?: (string|null);

        /** UserInfo nickname */
        nickname?: (string|null);

        /** UserInfo userPortrait */
        userPortrait?: (string|null);

        /** UserInfo extFields */
        extFields?: (immessage.IKvItem[]|null);

        /** UserInfo updatedTime */
        updatedTime?: (number|Long|null);

        /** UserInfo settings */
        settings?: (immessage.IKvItem[]|null);

        /** UserInfo statuses */
        statuses?: (immessage.IKvItem[]|null);

        /** UserInfo userType */
        userType?: (immessage.UserType|null);

        /** UserInfo noCover */
        noCover?: (boolean|null);

        /** UserInfo permitConvers */
        permitConvers?: (immessage.IPermitConver[]|null);
    }

    /** Represents a UserInfo. */
    class UserInfo implements IUserInfo {

        /**
         * Constructs a new UserInfo.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserInfo);

        /** UserInfo userId. */
        public userId: string;

        /** UserInfo nickname. */
        public nickname: string;

        /** UserInfo userPortrait. */
        public userPortrait: string;

        /** UserInfo extFields. */
        public extFields: immessage.IKvItem[];

        /** UserInfo updatedTime. */
        public updatedTime: (number|Long);

        /** UserInfo settings. */
        public settings: immessage.IKvItem[];

        /** UserInfo statuses. */
        public statuses: immessage.IKvItem[];

        /** UserInfo userType. */
        public userType: immessage.UserType;

        /** UserInfo noCover. */
        public noCover: boolean;

        /** UserInfo permitConvers. */
        public permitConvers: immessage.IPermitConver[];

        /**
         * Creates a new UserInfo instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserInfo instance
         */
        public static create(properties?: immessage.IUserInfo): immessage.UserInfo;

        /**
         * Encodes the specified UserInfo message. Does not implicitly {@link immessage.UserInfo.verify|verify} messages.
         * @param message UserInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserInfo message, length delimited. Does not implicitly {@link immessage.UserInfo.verify|verify} messages.
         * @param message UserInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserInfo message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserInfo;

        /**
         * Decodes a UserInfo message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserInfo;

        /**
         * Verifies a UserInfo message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserInfo message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserInfo
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserInfo;

        /**
         * Creates a plain object from a UserInfo message. Also converts values to other types if specified.
         * @param message UserInfo
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserInfo, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserInfo to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserInfo
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a PermitConver. */
    interface IPermitConver {

        /** PermitConver targetId */
        targetId?: (string|null);

        /** PermitConver channelType */
        channelType?: (immessage.ChannelType|null);

        /** PermitConver maxHisMsgCount */
        maxHisMsgCount?: (number|null);

        /** PermitConver targetIdAlias */
        targetIdAlias?: (string|null);

        /** PermitConver permitMsgTypes */
        permitMsgTypes?: (string[]|null);
    }

    /** Represents a PermitConver. */
    class PermitConver implements IPermitConver {

        /**
         * Constructs a new PermitConver.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IPermitConver);

        /** PermitConver targetId. */
        public targetId: string;

        /** PermitConver channelType. */
        public channelType: immessage.ChannelType;

        /** PermitConver maxHisMsgCount. */
        public maxHisMsgCount: number;

        /** PermitConver targetIdAlias. */
        public targetIdAlias: string;

        /** PermitConver permitMsgTypes. */
        public permitMsgTypes: string[];

        /**
         * Creates a new PermitConver instance using the specified properties.
         * @param [properties] Properties to set
         * @returns PermitConver instance
         */
        public static create(properties?: immessage.IPermitConver): immessage.PermitConver;

        /**
         * Encodes the specified PermitConver message. Does not implicitly {@link immessage.PermitConver.verify|verify} messages.
         * @param message PermitConver message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IPermitConver, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified PermitConver message, length delimited. Does not implicitly {@link immessage.PermitConver.verify|verify} messages.
         * @param message PermitConver message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IPermitConver, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a PermitConver message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns PermitConver
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.PermitConver;

        /**
         * Decodes a PermitConver message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns PermitConver
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.PermitConver;

        /**
         * Verifies a PermitConver message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a PermitConver message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns PermitConver
         */
        public static fromObject(object: { [k: string]: any }): immessage.PermitConver;

        /**
         * Creates a plain object from a PermitConver message. Also converts values to other types if specified.
         * @param message PermitConver
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.PermitConver, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this PermitConver to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for PermitConver
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** UserType enum. */
    enum UserType {
        User = 0,
        Bot = 1
    }

    /** Properties of a UserInfos. */
    interface IUserInfos {

        /** UserInfos userInfos */
        userInfos?: (immessage.IUserInfo[]|null);
    }

    /** Represents a UserInfos. */
    class UserInfos implements IUserInfos {

        /**
         * Constructs a new UserInfos.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserInfos);

        /** UserInfos userInfos. */
        public userInfos: immessage.IUserInfo[];

        /**
         * Creates a new UserInfos instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserInfos instance
         */
        public static create(properties?: immessage.IUserInfos): immessage.UserInfos;

        /**
         * Encodes the specified UserInfos message. Does not implicitly {@link immessage.UserInfos.verify|verify} messages.
         * @param message UserInfos message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserInfos, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserInfos message, length delimited. Does not implicitly {@link immessage.UserInfos.verify|verify} messages.
         * @param message UserInfos message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserInfos, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserInfos message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserInfos
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserInfos;

        /**
         * Decodes a UserInfos message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserInfos
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserInfos;

        /**
         * Verifies a UserInfos message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserInfos message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserInfos
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserInfos;

        /**
         * Creates a plain object from a UserInfos message. Also converts values to other types if specified.
         * @param message UserInfos
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserInfos, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserInfos to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserInfos
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserIdsReq. */
    interface IUserIdsReq {

        /** UserIdsReq userIds */
        userIds?: (string[]|null);

        /** UserIdsReq attTypes */
        attTypes?: (number[]|null);
    }

    /** Represents a UserIdsReq. */
    class UserIdsReq implements IUserIdsReq {

        /**
         * Constructs a new UserIdsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserIdsReq);

        /** UserIdsReq userIds. */
        public userIds: string[];

        /** UserIdsReq attTypes. */
        public attTypes: number[];

        /**
         * Creates a new UserIdsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserIdsReq instance
         */
        public static create(properties?: immessage.IUserIdsReq): immessage.UserIdsReq;

        /**
         * Encodes the specified UserIdsReq message. Does not implicitly {@link immessage.UserIdsReq.verify|verify} messages.
         * @param message UserIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserIdsReq message, length delimited. Does not implicitly {@link immessage.UserIdsReq.verify|verify} messages.
         * @param message UserIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserIdsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserIdsReq;

        /**
         * Decodes a UserIdsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserIdsReq;

        /**
         * Verifies a UserIdsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserIdsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserIdsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserIdsReq;

        /**
         * Creates a plain object from a UserIdsReq message. Also converts values to other types if specified.
         * @param message UserIdsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserIdsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserIdsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserIdsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserIdReq. */
    interface IUserIdReq {

        /** UserIdReq userId */
        userId?: (string|null);

        /** UserIdReq attTypes */
        attTypes?: (number[]|null);
    }

    /** Represents a UserIdReq. */
    class UserIdReq implements IUserIdReq {

        /**
         * Constructs a new UserIdReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserIdReq);

        /** UserIdReq userId. */
        public userId: string;

        /** UserIdReq attTypes. */
        public attTypes: number[];

        /**
         * Creates a new UserIdReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserIdReq instance
         */
        public static create(properties?: immessage.IUserIdReq): immessage.UserIdReq;

        /**
         * Encodes the specified UserIdReq message. Does not implicitly {@link immessage.UserIdReq.verify|verify} messages.
         * @param message UserIdReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserIdReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserIdReq message, length delimited. Does not implicitly {@link immessage.UserIdReq.verify|verify} messages.
         * @param message UserIdReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserIdReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserIdReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserIdReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserIdReq;

        /**
         * Decodes a UserIdReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserIdReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserIdReq;

        /**
         * Verifies a UserIdReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserIdReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserIdReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserIdReq;

        /**
         * Creates a plain object from a UserIdReq message. Also converts values to other types if specified.
         * @param message UserIdReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserIdReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserIdReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserIdReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserInfosResp. */
    interface IUserInfosResp {

        /** UserInfosResp userInfoMap */
        userInfoMap?: ({ [k: string]: immessage.IUserInfo }|null);
    }

    /** Represents a UserInfosResp. */
    class UserInfosResp implements IUserInfosResp {

        /**
         * Constructs a new UserInfosResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserInfosResp);

        /** UserInfosResp userInfoMap. */
        public userInfoMap: { [k: string]: immessage.IUserInfo };

        /**
         * Creates a new UserInfosResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserInfosResp instance
         */
        public static create(properties?: immessage.IUserInfosResp): immessage.UserInfosResp;

        /**
         * Encodes the specified UserInfosResp message. Does not implicitly {@link immessage.UserInfosResp.verify|verify} messages.
         * @param message UserInfosResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserInfosResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserInfosResp message, length delimited. Does not implicitly {@link immessage.UserInfosResp.verify|verify} messages.
         * @param message UserInfosResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserInfosResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserInfosResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserInfosResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserInfosResp;

        /**
         * Decodes a UserInfosResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserInfosResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserInfosResp;

        /**
         * Verifies a UserInfosResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserInfosResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserInfosResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserInfosResp;

        /**
         * Creates a plain object from a UserInfosResp message. Also converts values to other types if specified.
         * @param message UserInfosResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserInfosResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserInfosResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserInfosResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserRegResp. */
    interface IUserRegResp {

        /** UserRegResp userId */
        userId?: (string|null);

        /** UserRegResp token */
        token?: (string|null);

        /** UserRegResp nickname */
        nickname?: (string|null);

        /** UserRegResp userPortrait */
        userPortrait?: (string|null);

        /** UserRegResp extFields */
        extFields?: (immessage.IKvItem[]|null);

        /** UserRegResp updatedTime */
        updatedTime?: (number|Long|null);
    }

    /** Represents a UserRegResp. */
    class UserRegResp implements IUserRegResp {

        /**
         * Constructs a new UserRegResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserRegResp);

        /** UserRegResp userId. */
        public userId: string;

        /** UserRegResp token. */
        public token: string;

        /** UserRegResp nickname. */
        public nickname: string;

        /** UserRegResp userPortrait. */
        public userPortrait: string;

        /** UserRegResp extFields. */
        public extFields: immessage.IKvItem[];

        /** UserRegResp updatedTime. */
        public updatedTime: (number|Long);

        /**
         * Creates a new UserRegResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserRegResp instance
         */
        public static create(properties?: immessage.IUserRegResp): immessage.UserRegResp;

        /**
         * Encodes the specified UserRegResp message. Does not implicitly {@link immessage.UserRegResp.verify|verify} messages.
         * @param message UserRegResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserRegResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserRegResp message, length delimited. Does not implicitly {@link immessage.UserRegResp.verify|verify} messages.
         * @param message UserRegResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserRegResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserRegResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserRegResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserRegResp;

        /**
         * Decodes a UserRegResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserRegResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserRegResp;

        /**
         * Verifies a UserRegResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserRegResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserRegResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserRegResp;

        /**
         * Creates a plain object from a UserRegResp message. Also converts values to other types if specified.
         * @param message UserRegResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserRegResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserRegResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserRegResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserOnlineStatusReq. */
    interface IUserOnlineStatusReq {

        /** UserOnlineStatusReq userIds */
        userIds?: (string[]|null);
    }

    /** Represents a UserOnlineStatusReq. */
    class UserOnlineStatusReq implements IUserOnlineStatusReq {

        /**
         * Constructs a new UserOnlineStatusReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserOnlineStatusReq);

        /** UserOnlineStatusReq userIds. */
        public userIds: string[];

        /**
         * Creates a new UserOnlineStatusReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserOnlineStatusReq instance
         */
        public static create(properties?: immessage.IUserOnlineStatusReq): immessage.UserOnlineStatusReq;

        /**
         * Encodes the specified UserOnlineStatusReq message. Does not implicitly {@link immessage.UserOnlineStatusReq.verify|verify} messages.
         * @param message UserOnlineStatusReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserOnlineStatusReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserOnlineStatusReq message, length delimited. Does not implicitly {@link immessage.UserOnlineStatusReq.verify|verify} messages.
         * @param message UserOnlineStatusReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserOnlineStatusReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserOnlineStatusReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserOnlineStatusReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserOnlineStatusReq;

        /**
         * Decodes a UserOnlineStatusReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserOnlineStatusReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserOnlineStatusReq;

        /**
         * Verifies a UserOnlineStatusReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserOnlineStatusReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserOnlineStatusReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserOnlineStatusReq;

        /**
         * Creates a plain object from a UserOnlineStatusReq message. Also converts values to other types if specified.
         * @param message UserOnlineStatusReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserOnlineStatusReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserOnlineStatusReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserOnlineStatusReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserOnlineStatusResp. */
    interface IUserOnlineStatusResp {

        /** UserOnlineStatusResp items */
        items?: (immessage.IUserOnlineItem[]|null);
    }

    /** Represents a UserOnlineStatusResp. */
    class UserOnlineStatusResp implements IUserOnlineStatusResp {

        /**
         * Constructs a new UserOnlineStatusResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserOnlineStatusResp);

        /** UserOnlineStatusResp items. */
        public items: immessage.IUserOnlineItem[];

        /**
         * Creates a new UserOnlineStatusResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserOnlineStatusResp instance
         */
        public static create(properties?: immessage.IUserOnlineStatusResp): immessage.UserOnlineStatusResp;

        /**
         * Encodes the specified UserOnlineStatusResp message. Does not implicitly {@link immessage.UserOnlineStatusResp.verify|verify} messages.
         * @param message UserOnlineStatusResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserOnlineStatusResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserOnlineStatusResp message, length delimited. Does not implicitly {@link immessage.UserOnlineStatusResp.verify|verify} messages.
         * @param message UserOnlineStatusResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserOnlineStatusResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserOnlineStatusResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserOnlineStatusResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserOnlineStatusResp;

        /**
         * Decodes a UserOnlineStatusResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserOnlineStatusResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserOnlineStatusResp;

        /**
         * Verifies a UserOnlineStatusResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserOnlineStatusResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserOnlineStatusResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserOnlineStatusResp;

        /**
         * Creates a plain object from a UserOnlineStatusResp message. Also converts values to other types if specified.
         * @param message UserOnlineStatusResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserOnlineStatusResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserOnlineStatusResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserOnlineStatusResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserOnlineItem. */
    interface IUserOnlineItem {

        /** UserOnlineItem userId */
        userId?: (string|null);

        /** UserOnlineItem isOnline */
        isOnline?: (boolean|null);
    }

    /** Represents a UserOnlineItem. */
    class UserOnlineItem implements IUserOnlineItem {

        /**
         * Constructs a new UserOnlineItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserOnlineItem);

        /** UserOnlineItem userId. */
        public userId: string;

        /** UserOnlineItem isOnline. */
        public isOnline: boolean;

        /**
         * Creates a new UserOnlineItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserOnlineItem instance
         */
        public static create(properties?: immessage.IUserOnlineItem): immessage.UserOnlineItem;

        /**
         * Encodes the specified UserOnlineItem message. Does not implicitly {@link immessage.UserOnlineItem.verify|verify} messages.
         * @param message UserOnlineItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserOnlineItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserOnlineItem message, length delimited. Does not implicitly {@link immessage.UserOnlineItem.verify|verify} messages.
         * @param message UserOnlineItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserOnlineItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserOnlineItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserOnlineItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserOnlineItem;

        /**
         * Decodes a UserOnlineItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserOnlineItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserOnlineItem;

        /**
         * Verifies a UserOnlineItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserOnlineItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserOnlineItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserOnlineItem;

        /**
         * Creates a plain object from a UserOnlineItem message. Also converts values to other types if specified.
         * @param message UserOnlineItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserOnlineItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserOnlineItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserOnlineItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BanUsersReq. */
    interface IBanUsersReq {

        /** BanUsersReq banUsers */
        banUsers?: (immessage.IBanUser[]|null);

        /** BanUsersReq isAdd */
        isAdd?: (boolean|null);
    }

    /** Represents a BanUsersReq. */
    class BanUsersReq implements IBanUsersReq {

        /**
         * Constructs a new BanUsersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBanUsersReq);

        /** BanUsersReq banUsers. */
        public banUsers: immessage.IBanUser[];

        /** BanUsersReq isAdd. */
        public isAdd: boolean;

        /**
         * Creates a new BanUsersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BanUsersReq instance
         */
        public static create(properties?: immessage.IBanUsersReq): immessage.BanUsersReq;

        /**
         * Encodes the specified BanUsersReq message. Does not implicitly {@link immessage.BanUsersReq.verify|verify} messages.
         * @param message BanUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBanUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BanUsersReq message, length delimited. Does not implicitly {@link immessage.BanUsersReq.verify|verify} messages.
         * @param message BanUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBanUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BanUsersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BanUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BanUsersReq;

        /**
         * Decodes a BanUsersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BanUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BanUsersReq;

        /**
         * Verifies a BanUsersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BanUsersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BanUsersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.BanUsersReq;

        /**
         * Creates a plain object from a BanUsersReq message. Also converts values to other types if specified.
         * @param message BanUsersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BanUsersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BanUsersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BanUsersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BanUser. */
    interface IBanUser {

        /** BanUser userId */
        userId?: (string|null);

        /** BanUser endTime */
        endTime?: (number|Long|null);

        /** BanUser createdTime */
        createdTime?: (number|Long|null);

        /** BanUser scopeKey */
        scopeKey?: (string|null);

        /** BanUser scopeValue */
        scopeValue?: (string|null);

        /** BanUser ext */
        ext?: (string|null);
    }

    /** Represents a BanUser. */
    class BanUser implements IBanUser {

        /**
         * Constructs a new BanUser.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBanUser);

        /** BanUser userId. */
        public userId: string;

        /** BanUser endTime. */
        public endTime: (number|Long);

        /** BanUser createdTime. */
        public createdTime: (number|Long);

        /** BanUser scopeKey. */
        public scopeKey: string;

        /** BanUser scopeValue. */
        public scopeValue: string;

        /** BanUser ext. */
        public ext: string;

        /**
         * Creates a new BanUser instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BanUser instance
         */
        public static create(properties?: immessage.IBanUser): immessage.BanUser;

        /**
         * Encodes the specified BanUser message. Does not implicitly {@link immessage.BanUser.verify|verify} messages.
         * @param message BanUser message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBanUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BanUser message, length delimited. Does not implicitly {@link immessage.BanUser.verify|verify} messages.
         * @param message BanUser message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBanUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BanUser message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BanUser
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BanUser;

        /**
         * Decodes a BanUser message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BanUser
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BanUser;

        /**
         * Verifies a BanUser message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BanUser message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BanUser
         */
        public static fromObject(object: { [k: string]: any }): immessage.BanUser;

        /**
         * Creates a plain object from a BanUser message. Also converts values to other types if specified.
         * @param message BanUser
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BanUser, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BanUser to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BanUser
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryBanUsersReq. */
    interface IQryBanUsersReq {

        /** QryBanUsersReq limit */
        limit?: (number|Long|null);

        /** QryBanUsersReq offset */
        offset?: (string|null);
    }

    /** Represents a QryBanUsersReq. */
    class QryBanUsersReq implements IQryBanUsersReq {

        /**
         * Constructs a new QryBanUsersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryBanUsersReq);

        /** QryBanUsersReq limit. */
        public limit: (number|Long);

        /** QryBanUsersReq offset. */
        public offset: string;

        /**
         * Creates a new QryBanUsersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryBanUsersReq instance
         */
        public static create(properties?: immessage.IQryBanUsersReq): immessage.QryBanUsersReq;

        /**
         * Encodes the specified QryBanUsersReq message. Does not implicitly {@link immessage.QryBanUsersReq.verify|verify} messages.
         * @param message QryBanUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryBanUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryBanUsersReq message, length delimited. Does not implicitly {@link immessage.QryBanUsersReq.verify|verify} messages.
         * @param message QryBanUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryBanUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryBanUsersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryBanUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryBanUsersReq;

        /**
         * Decodes a QryBanUsersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryBanUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryBanUsersReq;

        /**
         * Verifies a QryBanUsersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryBanUsersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryBanUsersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryBanUsersReq;

        /**
         * Creates a plain object from a QryBanUsersReq message. Also converts values to other types if specified.
         * @param message QryBanUsersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryBanUsersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryBanUsersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryBanUsersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryBanUsersResp. */
    interface IQryBanUsersResp {

        /** QryBanUsersResp items */
        items?: (immessage.IBanUser[]|null);

        /** QryBanUsersResp offset */
        offset?: (string|null);
    }

    /** Represents a QryBanUsersResp. */
    class QryBanUsersResp implements IQryBanUsersResp {

        /**
         * Constructs a new QryBanUsersResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryBanUsersResp);

        /** QryBanUsersResp items. */
        public items: immessage.IBanUser[];

        /** QryBanUsersResp offset. */
        public offset: string;

        /**
         * Creates a new QryBanUsersResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryBanUsersResp instance
         */
        public static create(properties?: immessage.IQryBanUsersResp): immessage.QryBanUsersResp;

        /**
         * Encodes the specified QryBanUsersResp message. Does not implicitly {@link immessage.QryBanUsersResp.verify|verify} messages.
         * @param message QryBanUsersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryBanUsersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryBanUsersResp message, length delimited. Does not implicitly {@link immessage.QryBanUsersResp.verify|verify} messages.
         * @param message QryBanUsersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryBanUsersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryBanUsersResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryBanUsersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryBanUsersResp;

        /**
         * Decodes a QryBanUsersResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryBanUsersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryBanUsersResp;

        /**
         * Verifies a QryBanUsersResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryBanUsersResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryBanUsersResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryBanUsersResp;

        /**
         * Creates a plain object from a QryBanUsersResp message. Also converts values to other types if specified.
         * @param message QryBanUsersResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryBanUsersResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryBanUsersResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryBanUsersResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BlockUsersReq. */
    interface IBlockUsersReq {

        /** BlockUsersReq userIds */
        userIds?: (string[]|null);

        /** BlockUsersReq isAdd */
        isAdd?: (boolean|null);
    }

    /** Represents a BlockUsersReq. */
    class BlockUsersReq implements IBlockUsersReq {

        /**
         * Constructs a new BlockUsersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBlockUsersReq);

        /** BlockUsersReq userIds. */
        public userIds: string[];

        /** BlockUsersReq isAdd. */
        public isAdd: boolean;

        /**
         * Creates a new BlockUsersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BlockUsersReq instance
         */
        public static create(properties?: immessage.IBlockUsersReq): immessage.BlockUsersReq;

        /**
         * Encodes the specified BlockUsersReq message. Does not implicitly {@link immessage.BlockUsersReq.verify|verify} messages.
         * @param message BlockUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBlockUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BlockUsersReq message, length delimited. Does not implicitly {@link immessage.BlockUsersReq.verify|verify} messages.
         * @param message BlockUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBlockUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BlockUsersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BlockUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BlockUsersReq;

        /**
         * Decodes a BlockUsersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BlockUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BlockUsersReq;

        /**
         * Verifies a BlockUsersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BlockUsersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BlockUsersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.BlockUsersReq;

        /**
         * Creates a plain object from a BlockUsersReq message. Also converts values to other types if specified.
         * @param message BlockUsersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BlockUsersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BlockUsersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BlockUsersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryBlockUsersReq. */
    interface IQryBlockUsersReq {

        /** QryBlockUsersReq userId */
        userId?: (string|null);

        /** QryBlockUsersReq limit */
        limit?: (number|Long|null);

        /** QryBlockUsersReq offset */
        offset?: (string|null);
    }

    /** Represents a QryBlockUsersReq. */
    class QryBlockUsersReq implements IQryBlockUsersReq {

        /**
         * Constructs a new QryBlockUsersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryBlockUsersReq);

        /** QryBlockUsersReq userId. */
        public userId: string;

        /** QryBlockUsersReq limit. */
        public limit: (number|Long);

        /** QryBlockUsersReq offset. */
        public offset: string;

        /**
         * Creates a new QryBlockUsersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryBlockUsersReq instance
         */
        public static create(properties?: immessage.IQryBlockUsersReq): immessage.QryBlockUsersReq;

        /**
         * Encodes the specified QryBlockUsersReq message. Does not implicitly {@link immessage.QryBlockUsersReq.verify|verify} messages.
         * @param message QryBlockUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryBlockUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryBlockUsersReq message, length delimited. Does not implicitly {@link immessage.QryBlockUsersReq.verify|verify} messages.
         * @param message QryBlockUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryBlockUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryBlockUsersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryBlockUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryBlockUsersReq;

        /**
         * Decodes a QryBlockUsersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryBlockUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryBlockUsersReq;

        /**
         * Verifies a QryBlockUsersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryBlockUsersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryBlockUsersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryBlockUsersReq;

        /**
         * Creates a plain object from a QryBlockUsersReq message. Also converts values to other types if specified.
         * @param message QryBlockUsersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryBlockUsersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryBlockUsersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryBlockUsersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BlockUser. */
    interface IBlockUser {

        /** BlockUser blockUserId */
        blockUserId?: (string|null);

        /** BlockUser createdTime */
        createdTime?: (number|Long|null);
    }

    /** Represents a BlockUser. */
    class BlockUser implements IBlockUser {

        /**
         * Constructs a new BlockUser.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBlockUser);

        /** BlockUser blockUserId. */
        public blockUserId: string;

        /** BlockUser createdTime. */
        public createdTime: (number|Long);

        /**
         * Creates a new BlockUser instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BlockUser instance
         */
        public static create(properties?: immessage.IBlockUser): immessage.BlockUser;

        /**
         * Encodes the specified BlockUser message. Does not implicitly {@link immessage.BlockUser.verify|verify} messages.
         * @param message BlockUser message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBlockUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BlockUser message, length delimited. Does not implicitly {@link immessage.BlockUser.verify|verify} messages.
         * @param message BlockUser message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBlockUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BlockUser message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BlockUser
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BlockUser;

        /**
         * Decodes a BlockUser message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BlockUser
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BlockUser;

        /**
         * Verifies a BlockUser message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BlockUser message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BlockUser
         */
        public static fromObject(object: { [k: string]: any }): immessage.BlockUser;

        /**
         * Creates a plain object from a BlockUser message. Also converts values to other types if specified.
         * @param message BlockUser
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BlockUser, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BlockUser to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BlockUser
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryBlockUsersResp. */
    interface IQryBlockUsersResp {

        /** QryBlockUsersResp items */
        items?: (immessage.IBlockUser[]|null);

        /** QryBlockUsersResp offset */
        offset?: (string|null);
    }

    /** Represents a QryBlockUsersResp. */
    class QryBlockUsersResp implements IQryBlockUsersResp {

        /**
         * Constructs a new QryBlockUsersResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryBlockUsersResp);

        /** QryBlockUsersResp items. */
        public items: immessage.IBlockUser[];

        /** QryBlockUsersResp offset. */
        public offset: string;

        /**
         * Creates a new QryBlockUsersResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryBlockUsersResp instance
         */
        public static create(properties?: immessage.IQryBlockUsersResp): immessage.QryBlockUsersResp;

        /**
         * Encodes the specified QryBlockUsersResp message. Does not implicitly {@link immessage.QryBlockUsersResp.verify|verify} messages.
         * @param message QryBlockUsersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryBlockUsersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryBlockUsersResp message, length delimited. Does not implicitly {@link immessage.QryBlockUsersResp.verify|verify} messages.
         * @param message QryBlockUsersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryBlockUsersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryBlockUsersResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryBlockUsersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryBlockUsersResp;

        /**
         * Decodes a QryBlockUsersResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryBlockUsersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryBlockUsersResp;

        /**
         * Verifies a QryBlockUsersResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryBlockUsersResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryBlockUsersResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryBlockUsersResp;

        /**
         * Creates a plain object from a QryBlockUsersResp message. Also converts values to other types if specified.
         * @param message QryBlockUsersResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryBlockUsersResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryBlockUsersResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryBlockUsersResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CheckBlockUserResp. */
    interface ICheckBlockUserResp {

        /** CheckBlockUserResp isBlock */
        isBlock?: (boolean|null);
    }

    /** Represents a CheckBlockUserResp. */
    class CheckBlockUserResp implements ICheckBlockUserResp {

        /**
         * Constructs a new CheckBlockUserResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ICheckBlockUserResp);

        /** CheckBlockUserResp isBlock. */
        public isBlock: boolean;

        /**
         * Creates a new CheckBlockUserResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CheckBlockUserResp instance
         */
        public static create(properties?: immessage.ICheckBlockUserResp): immessage.CheckBlockUserResp;

        /**
         * Encodes the specified CheckBlockUserResp message. Does not implicitly {@link immessage.CheckBlockUserResp.verify|verify} messages.
         * @param message CheckBlockUserResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ICheckBlockUserResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CheckBlockUserResp message, length delimited. Does not implicitly {@link immessage.CheckBlockUserResp.verify|verify} messages.
         * @param message CheckBlockUserResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ICheckBlockUserResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CheckBlockUserResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CheckBlockUserResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.CheckBlockUserResp;

        /**
         * Decodes a CheckBlockUserResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CheckBlockUserResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.CheckBlockUserResp;

        /**
         * Verifies a CheckBlockUserResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CheckBlockUserResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CheckBlockUserResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.CheckBlockUserResp;

        /**
         * Creates a plain object from a CheckBlockUserResp message. Also converts values to other types if specified.
         * @param message CheckBlockUserResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.CheckBlockUserResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CheckBlockUserResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CheckBlockUserResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** OnlineType enum. */
    enum OnlineType {
        Offline = 0,
        Online = 1
    }

    /** Properties of an OnlineStatus. */
    interface IOnlineStatus {

        /** OnlineStatus type */
        type?: (immessage.OnlineType|null);

        /** OnlineStatus targetSession */
        targetSession?: (string|null);

        /** OnlineStatus targetIndex */
        targetIndex?: (number|null);

        /** OnlineStatus platforms */
        platforms?: (string[]|null);
    }

    /** Represents an OnlineStatus. */
    class OnlineStatus implements IOnlineStatus {

        /**
         * Constructs a new OnlineStatus.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IOnlineStatus);

        /** OnlineStatus type. */
        public type: immessage.OnlineType;

        /** OnlineStatus targetSession. */
        public targetSession: string;

        /** OnlineStatus targetIndex. */
        public targetIndex: number;

        /** OnlineStatus platforms. */
        public platforms: string[];

        /**
         * Creates a new OnlineStatus instance using the specified properties.
         * @param [properties] Properties to set
         * @returns OnlineStatus instance
         */
        public static create(properties?: immessage.IOnlineStatus): immessage.OnlineStatus;

        /**
         * Encodes the specified OnlineStatus message. Does not implicitly {@link immessage.OnlineStatus.verify|verify} messages.
         * @param message OnlineStatus message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IOnlineStatus, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified OnlineStatus message, length delimited. Does not implicitly {@link immessage.OnlineStatus.verify|verify} messages.
         * @param message OnlineStatus message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IOnlineStatus, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an OnlineStatus message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns OnlineStatus
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.OnlineStatus;

        /**
         * Decodes an OnlineStatus message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns OnlineStatus
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.OnlineStatus;

        /**
         * Verifies an OnlineStatus message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an OnlineStatus message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns OnlineStatus
         */
        public static fromObject(object: { [k: string]: any }): immessage.OnlineStatus;

        /**
         * Creates a plain object from an OnlineStatus message. Also converts values to other types if specified.
         * @param message OnlineStatus
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.OnlineStatus, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this OnlineStatus to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for OnlineStatus
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a KickUserReq. */
    interface IKickUserReq {

        /** KickUserReq userId */
        userId?: (string|null);

        /** KickUserReq ext */
        ext?: (string|null);

        /** KickUserReq platforms */
        platforms?: (string[]|null);

        /** KickUserReq deviceIds */
        deviceIds?: (string[]|null);

        /** KickUserReq ips */
        ips?: (string[]|null);
    }

    /** Represents a KickUserReq. */
    class KickUserReq implements IKickUserReq {

        /**
         * Constructs a new KickUserReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IKickUserReq);

        /** KickUserReq userId. */
        public userId: string;

        /** KickUserReq ext. */
        public ext: string;

        /** KickUserReq platforms. */
        public platforms: string[];

        /** KickUserReq deviceIds. */
        public deviceIds: string[];

        /** KickUserReq ips. */
        public ips: string[];

        /**
         * Creates a new KickUserReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns KickUserReq instance
         */
        public static create(properties?: immessage.IKickUserReq): immessage.KickUserReq;

        /**
         * Encodes the specified KickUserReq message. Does not implicitly {@link immessage.KickUserReq.verify|verify} messages.
         * @param message KickUserReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IKickUserReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified KickUserReq message, length delimited. Does not implicitly {@link immessage.KickUserReq.verify|verify} messages.
         * @param message KickUserReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IKickUserReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a KickUserReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns KickUserReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.KickUserReq;

        /**
         * Decodes a KickUserReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns KickUserReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.KickUserReq;

        /**
         * Verifies a KickUserReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a KickUserReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns KickUserReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.KickUserReq;

        /**
         * Creates a plain object from a KickUserReq message. Also converts values to other types if specified.
         * @param message KickUserReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.KickUserReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this KickUserReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for KickUserReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserUndisturb. */
    interface IUserUndisturb {

        /** UserUndisturb switch */
        "switch"?: (boolean|null);

        /** UserUndisturb timezone */
        timezone?: (string|null);

        /** UserUndisturb rules */
        rules?: (immessage.IUserUndisturbItem[]|null);
    }

    /** Represents a UserUndisturb. */
    class UserUndisturb implements IUserUndisturb {

        /**
         * Constructs a new UserUndisturb.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserUndisturb);

        /** UserUndisturb switch. */
        public switch: boolean;

        /** UserUndisturb timezone. */
        public timezone: string;

        /** UserUndisturb rules. */
        public rules: immessage.IUserUndisturbItem[];

        /**
         * Creates a new UserUndisturb instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserUndisturb instance
         */
        public static create(properties?: immessage.IUserUndisturb): immessage.UserUndisturb;

        /**
         * Encodes the specified UserUndisturb message. Does not implicitly {@link immessage.UserUndisturb.verify|verify} messages.
         * @param message UserUndisturb message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserUndisturb, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserUndisturb message, length delimited. Does not implicitly {@link immessage.UserUndisturb.verify|verify} messages.
         * @param message UserUndisturb message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserUndisturb, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserUndisturb message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserUndisturb
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserUndisturb;

        /**
         * Decodes a UserUndisturb message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserUndisturb
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserUndisturb;

        /**
         * Verifies a UserUndisturb message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserUndisturb message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserUndisturb
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserUndisturb;

        /**
         * Creates a plain object from a UserUndisturb message. Also converts values to other types if specified.
         * @param message UserUndisturb
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserUndisturb, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserUndisturb to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserUndisturb
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserUndisturbItem. */
    interface IUserUndisturbItem {

        /** UserUndisturbItem start */
        start?: (string|null);

        /** UserUndisturbItem end */
        end?: (string|null);
    }

    /** Represents a UserUndisturbItem. */
    class UserUndisturbItem implements IUserUndisturbItem {

        /**
         * Constructs a new UserUndisturbItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserUndisturbItem);

        /** UserUndisturbItem start. */
        public start: string;

        /** UserUndisturbItem end. */
        public end: string;

        /**
         * Creates a new UserUndisturbItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserUndisturbItem instance
         */
        public static create(properties?: immessage.IUserUndisturbItem): immessage.UserUndisturbItem;

        /**
         * Encodes the specified UserUndisturbItem message. Does not implicitly {@link immessage.UserUndisturbItem.verify|verify} messages.
         * @param message UserUndisturbItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserUndisturbItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserUndisturbItem message, length delimited. Does not implicitly {@link immessage.UserUndisturbItem.verify|verify} messages.
         * @param message UserUndisturbItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserUndisturbItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserUndisturbItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserUndisturbItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserUndisturbItem;

        /**
         * Decodes a UserUndisturbItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserUndisturbItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserUndisturbItem;

        /**
         * Verifies a UserUndisturbItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserUndisturbItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserUndisturbItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserUndisturbItem;

        /**
         * Creates a plain object from a UserUndisturbItem message. Also converts values to other types if specified.
         * @param message UserUndisturbItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserUndisturbItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserUndisturbItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserUndisturbItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserPushStatus. */
    interface IUserPushStatus {

        /** UserPushStatus canPush */
        canPush?: (boolean|null);
    }

    /** Represents a UserPushStatus. */
    class UserPushStatus implements IUserPushStatus {

        /**
         * Constructs a new UserPushStatus.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUserPushStatus);

        /** UserPushStatus canPush. */
        public canPush: boolean;

        /**
         * Creates a new UserPushStatus instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserPushStatus instance
         */
        public static create(properties?: immessage.IUserPushStatus): immessage.UserPushStatus;

        /**
         * Encodes the specified UserPushStatus message. Does not implicitly {@link immessage.UserPushStatus.verify|verify} messages.
         * @param message UserPushStatus message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUserPushStatus, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserPushStatus message, length delimited. Does not implicitly {@link immessage.UserPushStatus.verify|verify} messages.
         * @param message UserPushStatus message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUserPushStatus, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserPushStatus message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserPushStatus
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UserPushStatus;

        /**
         * Decodes a UserPushStatus message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserPushStatus
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UserPushStatus;

        /**
         * Verifies a UserPushStatus message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserPushStatus message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserPushStatus
         */
        public static fromObject(object: { [k: string]: any }): immessage.UserPushStatus;

        /**
         * Creates a plain object from a UserPushStatus message. Also converts values to other types if specified.
         * @param message UserPushStatus
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UserPushStatus, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserPushStatus to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserPushStatus
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a BatchMuteUsersReq. */
    interface IBatchMuteUsersReq {

        /** BatchMuteUsersReq userIds */
        userIds?: (string[]|null);

        /** BatchMuteUsersReq isDelete */
        isDelete?: (boolean|null);
    }

    /** Represents a BatchMuteUsersReq. */
    class BatchMuteUsersReq implements IBatchMuteUsersReq {

        /**
         * Constructs a new BatchMuteUsersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IBatchMuteUsersReq);

        /** BatchMuteUsersReq userIds. */
        public userIds: string[];

        /** BatchMuteUsersReq isDelete. */
        public isDelete: boolean;

        /**
         * Creates a new BatchMuteUsersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns BatchMuteUsersReq instance
         */
        public static create(properties?: immessage.IBatchMuteUsersReq): immessage.BatchMuteUsersReq;

        /**
         * Encodes the specified BatchMuteUsersReq message. Does not implicitly {@link immessage.BatchMuteUsersReq.verify|verify} messages.
         * @param message BatchMuteUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IBatchMuteUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified BatchMuteUsersReq message, length delimited. Does not implicitly {@link immessage.BatchMuteUsersReq.verify|verify} messages.
         * @param message BatchMuteUsersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IBatchMuteUsersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a BatchMuteUsersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns BatchMuteUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.BatchMuteUsersReq;

        /**
         * Decodes a BatchMuteUsersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns BatchMuteUsersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.BatchMuteUsersReq;

        /**
         * Verifies a BatchMuteUsersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a BatchMuteUsersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns BatchMuteUsersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.BatchMuteUsersReq;

        /**
         * Creates a plain object from a BatchMuteUsersReq message. Also converts values to other types if specified.
         * @param message BatchMuteUsersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.BatchMuteUsersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this BatchMuteUsersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for BatchMuteUsersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a FriendIdsReq. */
    interface IFriendIdsReq {

        /** FriendIdsReq friendIds */
        friendIds?: (string[]|null);
    }

    /** Represents a FriendIdsReq. */
    class FriendIdsReq implements IFriendIdsReq {

        /**
         * Constructs a new FriendIdsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IFriendIdsReq);

        /** FriendIdsReq friendIds. */
        public friendIds: string[];

        /**
         * Creates a new FriendIdsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns FriendIdsReq instance
         */
        public static create(properties?: immessage.IFriendIdsReq): immessage.FriendIdsReq;

        /**
         * Encodes the specified FriendIdsReq message. Does not implicitly {@link immessage.FriendIdsReq.verify|verify} messages.
         * @param message FriendIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IFriendIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified FriendIdsReq message, length delimited. Does not implicitly {@link immessage.FriendIdsReq.verify|verify} messages.
         * @param message FriendIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IFriendIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a FriendIdsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns FriendIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.FriendIdsReq;

        /**
         * Decodes a FriendIdsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns FriendIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.FriendIdsReq;

        /**
         * Verifies a FriendIdsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a FriendIdsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns FriendIdsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.FriendIdsReq;

        /**
         * Creates a plain object from a FriendIdsReq message. Also converts values to other types if specified.
         * @param message FriendIdsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.FriendIdsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this FriendIdsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for FriendIdsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a FriendMembersReq. */
    interface IFriendMembersReq {

        /** FriendMembersReq friendMembers */
        friendMembers?: (immessage.IFriendMember[]|null);
    }

    /** Represents a FriendMembersReq. */
    class FriendMembersReq implements IFriendMembersReq {

        /**
         * Constructs a new FriendMembersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IFriendMembersReq);

        /** FriendMembersReq friendMembers. */
        public friendMembers: immessage.IFriendMember[];

        /**
         * Creates a new FriendMembersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns FriendMembersReq instance
         */
        public static create(properties?: immessage.IFriendMembersReq): immessage.FriendMembersReq;

        /**
         * Encodes the specified FriendMembersReq message. Does not implicitly {@link immessage.FriendMembersReq.verify|verify} messages.
         * @param message FriendMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IFriendMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified FriendMembersReq message, length delimited. Does not implicitly {@link immessage.FriendMembersReq.verify|verify} messages.
         * @param message FriendMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IFriendMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a FriendMembersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns FriendMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.FriendMembersReq;

        /**
         * Decodes a FriendMembersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns FriendMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.FriendMembersReq;

        /**
         * Verifies a FriendMembersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a FriendMembersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns FriendMembersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.FriendMembersReq;

        /**
         * Creates a plain object from a FriendMembersReq message. Also converts values to other types if specified.
         * @param message FriendMembersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.FriendMembersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this FriendMembersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for FriendMembersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryFriendsReq. */
    interface IQryFriendsReq {

        /** QryFriendsReq limit */
        limit?: (number|Long|null);

        /** QryFriendsReq offset */
        offset?: (string|null);
    }

    /** Represents a QryFriendsReq. */
    class QryFriendsReq implements IQryFriendsReq {

        /**
         * Constructs a new QryFriendsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryFriendsReq);

        /** QryFriendsReq limit. */
        public limit: (number|Long);

        /** QryFriendsReq offset. */
        public offset: string;

        /**
         * Creates a new QryFriendsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryFriendsReq instance
         */
        public static create(properties?: immessage.IQryFriendsReq): immessage.QryFriendsReq;

        /**
         * Encodes the specified QryFriendsReq message. Does not implicitly {@link immessage.QryFriendsReq.verify|verify} messages.
         * @param message QryFriendsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryFriendsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryFriendsReq message, length delimited. Does not implicitly {@link immessage.QryFriendsReq.verify|verify} messages.
         * @param message QryFriendsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryFriendsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryFriendsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryFriendsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryFriendsReq;

        /**
         * Decodes a QryFriendsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryFriendsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryFriendsReq;

        /**
         * Verifies a QryFriendsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryFriendsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryFriendsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryFriendsReq;

        /**
         * Creates a plain object from a QryFriendsReq message. Also converts values to other types if specified.
         * @param message QryFriendsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryFriendsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryFriendsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryFriendsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryFriendsWithPageReq. */
    interface IQryFriendsWithPageReq {

        /** QryFriendsWithPageReq page */
        page?: (number|Long|null);

        /** QryFriendsWithPageReq size */
        size?: (number|Long|null);

        /** QryFriendsWithPageReq orderTag */
        orderTag?: (string|null);
    }

    /** Represents a QryFriendsWithPageReq. */
    class QryFriendsWithPageReq implements IQryFriendsWithPageReq {

        /**
         * Constructs a new QryFriendsWithPageReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryFriendsWithPageReq);

        /** QryFriendsWithPageReq page. */
        public page: (number|Long);

        /** QryFriendsWithPageReq size. */
        public size: (number|Long);

        /** QryFriendsWithPageReq orderTag. */
        public orderTag: string;

        /**
         * Creates a new QryFriendsWithPageReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryFriendsWithPageReq instance
         */
        public static create(properties?: immessage.IQryFriendsWithPageReq): immessage.QryFriendsWithPageReq;

        /**
         * Encodes the specified QryFriendsWithPageReq message. Does not implicitly {@link immessage.QryFriendsWithPageReq.verify|verify} messages.
         * @param message QryFriendsWithPageReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryFriendsWithPageReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryFriendsWithPageReq message, length delimited. Does not implicitly {@link immessage.QryFriendsWithPageReq.verify|verify} messages.
         * @param message QryFriendsWithPageReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryFriendsWithPageReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryFriendsWithPageReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryFriendsWithPageReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryFriendsWithPageReq;

        /**
         * Decodes a QryFriendsWithPageReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryFriendsWithPageReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryFriendsWithPageReq;

        /**
         * Verifies a QryFriendsWithPageReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryFriendsWithPageReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryFriendsWithPageReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryFriendsWithPageReq;

        /**
         * Creates a plain object from a QryFriendsWithPageReq message. Also converts values to other types if specified.
         * @param message QryFriendsWithPageReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryFriendsWithPageReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryFriendsWithPageReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryFriendsWithPageReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryFriendsResp. */
    interface IQryFriendsResp {

        /** QryFriendsResp items */
        items?: (immessage.IFriendMember[]|null);

        /** QryFriendsResp offset */
        offset?: (string|null);
    }

    /** Represents a QryFriendsResp. */
    class QryFriendsResp implements IQryFriendsResp {

        /**
         * Constructs a new QryFriendsResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryFriendsResp);

        /** QryFriendsResp items. */
        public items: immessage.IFriendMember[];

        /** QryFriendsResp offset. */
        public offset: string;

        /**
         * Creates a new QryFriendsResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryFriendsResp instance
         */
        public static create(properties?: immessage.IQryFriendsResp): immessage.QryFriendsResp;

        /**
         * Encodes the specified QryFriendsResp message. Does not implicitly {@link immessage.QryFriendsResp.verify|verify} messages.
         * @param message QryFriendsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryFriendsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryFriendsResp message, length delimited. Does not implicitly {@link immessage.QryFriendsResp.verify|verify} messages.
         * @param message QryFriendsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryFriendsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryFriendsResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryFriendsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryFriendsResp;

        /**
         * Decodes a QryFriendsResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryFriendsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryFriendsResp;

        /**
         * Verifies a QryFriendsResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryFriendsResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryFriendsResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryFriendsResp;

        /**
         * Creates a plain object from a QryFriendsResp message. Also converts values to other types if specified.
         * @param message QryFriendsResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryFriendsResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryFriendsResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryFriendsResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a FriendMember. */
    interface IFriendMember {

        /** FriendMember friendId */
        friendId?: (string|null);

        /** FriendMember orderTag */
        orderTag?: (string|null);
    }

    /** Represents a FriendMember. */
    class FriendMember implements IFriendMember {

        /**
         * Constructs a new FriendMember.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IFriendMember);

        /** FriendMember friendId. */
        public friendId: string;

        /** FriendMember orderTag. */
        public orderTag: string;

        /**
         * Creates a new FriendMember instance using the specified properties.
         * @param [properties] Properties to set
         * @returns FriendMember instance
         */
        public static create(properties?: immessage.IFriendMember): immessage.FriendMember;

        /**
         * Encodes the specified FriendMember message. Does not implicitly {@link immessage.FriendMember.verify|verify} messages.
         * @param message FriendMember message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IFriendMember, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified FriendMember message, length delimited. Does not implicitly {@link immessage.FriendMember.verify|verify} messages.
         * @param message FriendMember message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IFriendMember, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a FriendMember message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns FriendMember
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.FriendMember;

        /**
         * Decodes a FriendMember message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns FriendMember
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.FriendMember;

        /**
         * Verifies a FriendMember message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a FriendMember message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns FriendMember
         */
        public static fromObject(object: { [k: string]: any }): immessage.FriendMember;

        /**
         * Creates a plain object from a FriendMember message. Also converts values to other types if specified.
         * @param message FriendMember
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.FriendMember, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this FriendMember to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for FriendMember
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CheckFriendsReq. */
    interface ICheckFriendsReq {

        /** CheckFriendsReq friendIds */
        friendIds?: (string[]|null);
    }

    /** Represents a CheckFriendsReq. */
    class CheckFriendsReq implements ICheckFriendsReq {

        /**
         * Constructs a new CheckFriendsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ICheckFriendsReq);

        /** CheckFriendsReq friendIds. */
        public friendIds: string[];

        /**
         * Creates a new CheckFriendsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CheckFriendsReq instance
         */
        public static create(properties?: immessage.ICheckFriendsReq): immessage.CheckFriendsReq;

        /**
         * Encodes the specified CheckFriendsReq message. Does not implicitly {@link immessage.CheckFriendsReq.verify|verify} messages.
         * @param message CheckFriendsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ICheckFriendsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CheckFriendsReq message, length delimited. Does not implicitly {@link immessage.CheckFriendsReq.verify|verify} messages.
         * @param message CheckFriendsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ICheckFriendsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CheckFriendsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CheckFriendsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.CheckFriendsReq;

        /**
         * Decodes a CheckFriendsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CheckFriendsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.CheckFriendsReq;

        /**
         * Verifies a CheckFriendsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CheckFriendsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CheckFriendsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.CheckFriendsReq;

        /**
         * Creates a plain object from a CheckFriendsReq message. Also converts values to other types if specified.
         * @param message CheckFriendsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.CheckFriendsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CheckFriendsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CheckFriendsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CheckFriendsResp. */
    interface ICheckFriendsResp {

        /** CheckFriendsResp checkResults */
        checkResults?: ({ [k: string]: boolean }|null);
    }

    /** Represents a CheckFriendsResp. */
    class CheckFriendsResp implements ICheckFriendsResp {

        /**
         * Constructs a new CheckFriendsResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ICheckFriendsResp);

        /** CheckFriendsResp checkResults. */
        public checkResults: { [k: string]: boolean };

        /**
         * Creates a new CheckFriendsResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CheckFriendsResp instance
         */
        public static create(properties?: immessage.ICheckFriendsResp): immessage.CheckFriendsResp;

        /**
         * Encodes the specified CheckFriendsResp message. Does not implicitly {@link immessage.CheckFriendsResp.verify|verify} messages.
         * @param message CheckFriendsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ICheckFriendsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CheckFriendsResp message, length delimited. Does not implicitly {@link immessage.CheckFriendsResp.verify|verify} messages.
         * @param message CheckFriendsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ICheckFriendsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CheckFriendsResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CheckFriendsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.CheckFriendsResp;

        /**
         * Decodes a CheckFriendsResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CheckFriendsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.CheckFriendsResp;

        /**
         * Verifies a CheckFriendsResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CheckFriendsResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CheckFriendsResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.CheckFriendsResp;

        /**
         * Creates a plain object from a CheckFriendsResp message. Also converts values to other types if specified.
         * @param message CheckFriendsResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.CheckFriendsResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CheckFriendsResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CheckFriendsResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupInfo. */
    interface IGroupInfo {

        /** GroupInfo groupId */
        groupId?: (string|null);

        /** GroupInfo groupName */
        groupName?: (string|null);

        /** GroupInfo groupPortrait */
        groupPortrait?: (string|null);

        /** GroupInfo isMute */
        isMute?: (number|null);

        /** GroupInfo extFields */
        extFields?: (immessage.IKvItem[]|null);

        /** GroupInfo updatedTime */
        updatedTime?: (number|Long|null);

        /** GroupInfo settings */
        settings?: (immessage.IKvItem[]|null);

        /** GroupInfo memberCount */
        memberCount?: (number|null);
    }

    /** Represents a GroupInfo. */
    class GroupInfo implements IGroupInfo {

        /**
         * Constructs a new GroupInfo.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupInfo);

        /** GroupInfo groupId. */
        public groupId: string;

        /** GroupInfo groupName. */
        public groupName: string;

        /** GroupInfo groupPortrait. */
        public groupPortrait: string;

        /** GroupInfo isMute. */
        public isMute: number;

        /** GroupInfo extFields. */
        public extFields: immessage.IKvItem[];

        /** GroupInfo updatedTime. */
        public updatedTime: (number|Long);

        /** GroupInfo settings. */
        public settings: immessage.IKvItem[];

        /** GroupInfo memberCount. */
        public memberCount: number;

        /**
         * Creates a new GroupInfo instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupInfo instance
         */
        public static create(properties?: immessage.IGroupInfo): immessage.GroupInfo;

        /**
         * Encodes the specified GroupInfo message. Does not implicitly {@link immessage.GroupInfo.verify|verify} messages.
         * @param message GroupInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupInfo message, length delimited. Does not implicitly {@link immessage.GroupInfo.verify|verify} messages.
         * @param message GroupInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupInfo message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupInfo;

        /**
         * Decodes a GroupInfo message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupInfo;

        /**
         * Verifies a GroupInfo message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupInfo message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupInfo
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupInfo;

        /**
         * Creates a plain object from a GroupInfo message. Also converts values to other types if specified.
         * @param message GroupInfo
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupInfo, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupInfo to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupInfo
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GrpMemberInfo. */
    interface IGrpMemberInfo {

        /** GrpMemberInfo grpDisplayName */
        grpDisplayName?: (string|null);

        /** GrpMemberInfo extFields */
        extFields?: (immessage.IKvItem[]|null);

        /** GrpMemberInfo updatedTime */
        updatedTime?: (number|Long|null);
    }

    /** Represents a GrpMemberInfo. */
    class GrpMemberInfo implements IGrpMemberInfo {

        /**
         * Constructs a new GrpMemberInfo.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGrpMemberInfo);

        /** GrpMemberInfo grpDisplayName. */
        public grpDisplayName: string;

        /** GrpMemberInfo extFields. */
        public extFields: immessage.IKvItem[];

        /** GrpMemberInfo updatedTime. */
        public updatedTime: (number|Long);

        /**
         * Creates a new GrpMemberInfo instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GrpMemberInfo instance
         */
        public static create(properties?: immessage.IGrpMemberInfo): immessage.GrpMemberInfo;

        /**
         * Encodes the specified GrpMemberInfo message. Does not implicitly {@link immessage.GrpMemberInfo.verify|verify} messages.
         * @param message GrpMemberInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGrpMemberInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GrpMemberInfo message, length delimited. Does not implicitly {@link immessage.GrpMemberInfo.verify|verify} messages.
         * @param message GrpMemberInfo message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGrpMemberInfo, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GrpMemberInfo message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GrpMemberInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GrpMemberInfo;

        /**
         * Decodes a GrpMemberInfo message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GrpMemberInfo
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GrpMemberInfo;

        /**
         * Verifies a GrpMemberInfo message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GrpMemberInfo message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GrpMemberInfo
         */
        public static fromObject(object: { [k: string]: any }): immessage.GrpMemberInfo;

        /**
         * Creates a plain object from a GrpMemberInfo message. Also converts values to other types if specified.
         * @param message GrpMemberInfo
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GrpMemberInfo, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GrpMemberInfo to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GrpMemberInfo
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupMembersReq. */
    interface IGroupMembersReq {

        /** GroupMembersReq groupId */
        groupId?: (string|null);

        /** GroupMembersReq groupName */
        groupName?: (string|null);

        /** GroupMembersReq groupPortrait */
        groupPortrait?: (string|null);

        /** GroupMembersReq memberIds */
        memberIds?: (string[]|null);

        /** GroupMembersReq extFields */
        extFields?: (immessage.IKvItem[]|null);

        /** GroupMembersReq settings */
        settings?: (immessage.IKvItem[]|null);
    }

    /** Represents a GroupMembersReq. */
    class GroupMembersReq implements IGroupMembersReq {

        /**
         * Constructs a new GroupMembersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupMembersReq);

        /** GroupMembersReq groupId. */
        public groupId: string;

        /** GroupMembersReq groupName. */
        public groupName: string;

        /** GroupMembersReq groupPortrait. */
        public groupPortrait: string;

        /** GroupMembersReq memberIds. */
        public memberIds: string[];

        /** GroupMembersReq extFields. */
        public extFields: immessage.IKvItem[];

        /** GroupMembersReq settings. */
        public settings: immessage.IKvItem[];

        /**
         * Creates a new GroupMembersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupMembersReq instance
         */
        public static create(properties?: immessage.IGroupMembersReq): immessage.GroupMembersReq;

        /**
         * Encodes the specified GroupMembersReq message. Does not implicitly {@link immessage.GroupMembersReq.verify|verify} messages.
         * @param message GroupMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupMembersReq message, length delimited. Does not implicitly {@link immessage.GroupMembersReq.verify|verify} messages.
         * @param message GroupMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupMembersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupMembersReq;

        /**
         * Decodes a GroupMembersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupMembersReq;

        /**
         * Verifies a GroupMembersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupMembersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupMembersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupMembersReq;

        /**
         * Creates a plain object from a GroupMembersReq message. Also converts values to other types if specified.
         * @param message GroupMembersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupMembersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupMembersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupMembersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupMuteReq. */
    interface IGroupMuteReq {

        /** GroupMuteReq groupId */
        groupId?: (string|null);

        /** GroupMuteReq isMute */
        isMute?: (number|null);
    }

    /** Represents a GroupMuteReq. */
    class GroupMuteReq implements IGroupMuteReq {

        /**
         * Constructs a new GroupMuteReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupMuteReq);

        /** GroupMuteReq groupId. */
        public groupId: string;

        /** GroupMuteReq isMute. */
        public isMute: number;

        /**
         * Creates a new GroupMuteReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupMuteReq instance
         */
        public static create(properties?: immessage.IGroupMuteReq): immessage.GroupMuteReq;

        /**
         * Encodes the specified GroupMuteReq message. Does not implicitly {@link immessage.GroupMuteReq.verify|verify} messages.
         * @param message GroupMuteReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupMuteReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupMuteReq message, length delimited. Does not implicitly {@link immessage.GroupMuteReq.verify|verify} messages.
         * @param message GroupMuteReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupMuteReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupMuteReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupMuteReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupMuteReq;

        /**
         * Decodes a GroupMuteReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupMuteReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupMuteReq;

        /**
         * Verifies a GroupMuteReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupMuteReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupMuteReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupMuteReq;

        /**
         * Creates a plain object from a GroupMuteReq message. Also converts values to other types if specified.
         * @param message GroupMuteReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupMuteReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupMuteReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupMuteReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupInfoReq. */
    interface IGroupInfoReq {

        /** GroupInfoReq groupId */
        groupId?: (string|null);

        /** GroupInfoReq careFields */
        careFields?: (string[]|null);
    }

    /** Represents a GroupInfoReq. */
    class GroupInfoReq implements IGroupInfoReq {

        /**
         * Constructs a new GroupInfoReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupInfoReq);

        /** GroupInfoReq groupId. */
        public groupId: string;

        /** GroupInfoReq careFields. */
        public careFields: string[];

        /**
         * Creates a new GroupInfoReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupInfoReq instance
         */
        public static create(properties?: immessage.IGroupInfoReq): immessage.GroupInfoReq;

        /**
         * Encodes the specified GroupInfoReq message. Does not implicitly {@link immessage.GroupInfoReq.verify|verify} messages.
         * @param message GroupInfoReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupInfoReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupInfoReq message, length delimited. Does not implicitly {@link immessage.GroupInfoReq.verify|verify} messages.
         * @param message GroupInfoReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupInfoReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupInfoReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupInfoReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupInfoReq;

        /**
         * Decodes a GroupInfoReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupInfoReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupInfoReq;

        /**
         * Verifies a GroupInfoReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupInfoReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupInfoReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupInfoReq;

        /**
         * Creates a plain object from a GroupInfoReq message. Also converts values to other types if specified.
         * @param message GroupInfoReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupInfoReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupInfoReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupInfoReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupIdsReq. */
    interface IGroupIdsReq {

        /** GroupIdsReq groupIds */
        groupIds?: (string[]|null);
    }

    /** Represents a GroupIdsReq. */
    class GroupIdsReq implements IGroupIdsReq {

        /**
         * Constructs a new GroupIdsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupIdsReq);

        /** GroupIdsReq groupIds. */
        public groupIds: string[];

        /**
         * Creates a new GroupIdsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupIdsReq instance
         */
        public static create(properties?: immessage.IGroupIdsReq): immessage.GroupIdsReq;

        /**
         * Encodes the specified GroupIdsReq message. Does not implicitly {@link immessage.GroupIdsReq.verify|verify} messages.
         * @param message GroupIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupIdsReq message, length delimited. Does not implicitly {@link immessage.GroupIdsReq.verify|verify} messages.
         * @param message GroupIdsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupIdsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupIdsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupIdsReq;

        /**
         * Decodes a GroupIdsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupIdsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupIdsReq;

        /**
         * Verifies a GroupIdsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupIdsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupIdsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupIdsReq;

        /**
         * Creates a plain object from a GroupIdsReq message. Also converts values to other types if specified.
         * @param message GroupIdsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupIdsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupIdsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupIdsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupInfosResp. */
    interface IGroupInfosResp {

        /** GroupInfosResp groupInfoMap */
        groupInfoMap?: ({ [k: string]: immessage.IGroupInfo }|null);
    }

    /** Represents a GroupInfosResp. */
    class GroupInfosResp implements IGroupInfosResp {

        /**
         * Constructs a new GroupInfosResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupInfosResp);

        /** GroupInfosResp groupInfoMap. */
        public groupInfoMap: { [k: string]: immessage.IGroupInfo };

        /**
         * Creates a new GroupInfosResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupInfosResp instance
         */
        public static create(properties?: immessage.IGroupInfosResp): immessage.GroupInfosResp;

        /**
         * Encodes the specified GroupInfosResp message. Does not implicitly {@link immessage.GroupInfosResp.verify|verify} messages.
         * @param message GroupInfosResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupInfosResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupInfosResp message, length delimited. Does not implicitly {@link immessage.GroupInfosResp.verify|verify} messages.
         * @param message GroupInfosResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupInfosResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupInfosResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupInfosResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupInfosResp;

        /**
         * Decodes a GroupInfosResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupInfosResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupInfosResp;

        /**
         * Verifies a GroupInfosResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupInfosResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupInfosResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupInfosResp;

        /**
         * Creates a plain object from a GroupInfosResp message. Also converts values to other types if specified.
         * @param message GroupInfosResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupInfosResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupInfosResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupInfosResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupMemberMuteReq. */
    interface IGroupMemberMuteReq {

        /** GroupMemberMuteReq groupId */
        groupId?: (string|null);

        /** GroupMemberMuteReq memberIds */
        memberIds?: (string[]|null);

        /** GroupMemberMuteReq isMute */
        isMute?: (number|null);

        /** GroupMemberMuteReq muteEndAt */
        muteEndAt?: (number|Long|null);
    }

    /** Represents a GroupMemberMuteReq. */
    class GroupMemberMuteReq implements IGroupMemberMuteReq {

        /**
         * Constructs a new GroupMemberMuteReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupMemberMuteReq);

        /** GroupMemberMuteReq groupId. */
        public groupId: string;

        /** GroupMemberMuteReq memberIds. */
        public memberIds: string[];

        /** GroupMemberMuteReq isMute. */
        public isMute: number;

        /** GroupMemberMuteReq muteEndAt. */
        public muteEndAt: (number|Long);

        /**
         * Creates a new GroupMemberMuteReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupMemberMuteReq instance
         */
        public static create(properties?: immessage.IGroupMemberMuteReq): immessage.GroupMemberMuteReq;

        /**
         * Encodes the specified GroupMemberMuteReq message. Does not implicitly {@link immessage.GroupMemberMuteReq.verify|verify} messages.
         * @param message GroupMemberMuteReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupMemberMuteReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupMemberMuteReq message, length delimited. Does not implicitly {@link immessage.GroupMemberMuteReq.verify|verify} messages.
         * @param message GroupMemberMuteReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupMemberMuteReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupMemberMuteReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupMemberMuteReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupMemberMuteReq;

        /**
         * Decodes a GroupMemberMuteReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupMemberMuteReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupMemberMuteReq;

        /**
         * Verifies a GroupMemberMuteReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupMemberMuteReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupMemberMuteReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupMemberMuteReq;

        /**
         * Creates a plain object from a GroupMemberMuteReq message. Also converts values to other types if specified.
         * @param message GroupMemberMuteReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupMemberMuteReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupMemberMuteReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupMemberMuteReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupMemberAllowReq. */
    interface IGroupMemberAllowReq {

        /** GroupMemberAllowReq groupId */
        groupId?: (string|null);

        /** GroupMemberAllowReq memberIds */
        memberIds?: (string[]|null);

        /** GroupMemberAllowReq isAllow */
        isAllow?: (number|null);
    }

    /** Represents a GroupMemberAllowReq. */
    class GroupMemberAllowReq implements IGroupMemberAllowReq {

        /**
         * Constructs a new GroupMemberAllowReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupMemberAllowReq);

        /** GroupMemberAllowReq groupId. */
        public groupId: string;

        /** GroupMemberAllowReq memberIds. */
        public memberIds: string[];

        /** GroupMemberAllowReq isAllow. */
        public isAllow: number;

        /**
         * Creates a new GroupMemberAllowReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupMemberAllowReq instance
         */
        public static create(properties?: immessage.IGroupMemberAllowReq): immessage.GroupMemberAllowReq;

        /**
         * Encodes the specified GroupMemberAllowReq message. Does not implicitly {@link immessage.GroupMemberAllowReq.verify|verify} messages.
         * @param message GroupMemberAllowReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupMemberAllowReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupMemberAllowReq message, length delimited. Does not implicitly {@link immessage.GroupMemberAllowReq.verify|verify} messages.
         * @param message GroupMemberAllowReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupMemberAllowReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupMemberAllowReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupMemberAllowReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupMemberAllowReq;

        /**
         * Decodes a GroupMemberAllowReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupMemberAllowReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupMemberAllowReq;

        /**
         * Verifies a GroupMemberAllowReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupMemberAllowReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupMemberAllowReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupMemberAllowReq;

        /**
         * Creates a plain object from a GroupMemberAllowReq message. Also converts values to other types if specified.
         * @param message GroupMemberAllowReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupMemberAllowReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupMemberAllowReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupMemberAllowReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupMembersResp. */
    interface IGroupMembersResp {

        /** GroupMembersResp items */
        items?: (immessage.IGroupMember[]|null);

        /** GroupMembersResp offset */
        offset?: (string|null);
    }

    /** Represents a GroupMembersResp. */
    class GroupMembersResp implements IGroupMembersResp {

        /**
         * Constructs a new GroupMembersResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupMembersResp);

        /** GroupMembersResp items. */
        public items: immessage.IGroupMember[];

        /** GroupMembersResp offset. */
        public offset: string;

        /**
         * Creates a new GroupMembersResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupMembersResp instance
         */
        public static create(properties?: immessage.IGroupMembersResp): immessage.GroupMembersResp;

        /**
         * Encodes the specified GroupMembersResp message. Does not implicitly {@link immessage.GroupMembersResp.verify|verify} messages.
         * @param message GroupMembersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupMembersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupMembersResp message, length delimited. Does not implicitly {@link immessage.GroupMembersResp.verify|verify} messages.
         * @param message GroupMembersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupMembersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupMembersResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupMembersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupMembersResp;

        /**
         * Decodes a GroupMembersResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupMembersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupMembersResp;

        /**
         * Verifies a GroupMembersResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupMembersResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupMembersResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupMembersResp;

        /**
         * Creates a plain object from a GroupMembersResp message. Also converts values to other types if specified.
         * @param message GroupMembersResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupMembersResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupMembersResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupMembersResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupMember. */
    interface IGroupMember {

        /** GroupMember memberId */
        memberId?: (string|null);

        /** GroupMember isMute */
        isMute?: (number|null);

        /** GroupMember isAllow */
        isAllow?: (number|null);

        /** GroupMember extFields */
        extFields?: (immessage.IKvItem[]|null);

        /** GroupMember settings */
        settings?: (immessage.IKvItem[]|null);

        /** GroupMember memberType */
        memberType?: (immessage.UserType|null);
    }

    /** Represents a GroupMember. */
    class GroupMember implements IGroupMember {

        /**
         * Constructs a new GroupMember.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupMember);

        /** GroupMember memberId. */
        public memberId: string;

        /** GroupMember isMute. */
        public isMute: number;

        /** GroupMember isAllow. */
        public isAllow: number;

        /** GroupMember extFields. */
        public extFields: immessage.IKvItem[];

        /** GroupMember settings. */
        public settings: immessage.IKvItem[];

        /** GroupMember memberType. */
        public memberType: immessage.UserType;

        /**
         * Creates a new GroupMember instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupMember instance
         */
        public static create(properties?: immessage.IGroupMember): immessage.GroupMember;

        /**
         * Encodes the specified GroupMember message. Does not implicitly {@link immessage.GroupMember.verify|verify} messages.
         * @param message GroupMember message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupMember, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupMember message, length delimited. Does not implicitly {@link immessage.GroupMember.verify|verify} messages.
         * @param message GroupMember message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupMember, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupMember message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupMember
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupMember;

        /**
         * Decodes a GroupMember message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupMember
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupMember;

        /**
         * Verifies a GroupMember message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupMember message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupMember
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupMember;

        /**
         * Creates a plain object from a GroupMember message. Also converts values to other types if specified.
         * @param message GroupMember
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupMember, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupMember to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupMember
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryGroupMembersReq. */
    interface IQryGroupMembersReq {

        /** QryGroupMembersReq groupId */
        groupId?: (string|null);

        /** QryGroupMembersReq limit */
        limit?: (number|Long|null);

        /** QryGroupMembersReq offset */
        offset?: (string|null);
    }

    /** Represents a QryGroupMembersReq. */
    class QryGroupMembersReq implements IQryGroupMembersReq {

        /**
         * Constructs a new QryGroupMembersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryGroupMembersReq);

        /** QryGroupMembersReq groupId. */
        public groupId: string;

        /** QryGroupMembersReq limit. */
        public limit: (number|Long);

        /** QryGroupMembersReq offset. */
        public offset: string;

        /**
         * Creates a new QryGroupMembersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryGroupMembersReq instance
         */
        public static create(properties?: immessage.IQryGroupMembersReq): immessage.QryGroupMembersReq;

        /**
         * Encodes the specified QryGroupMembersReq message. Does not implicitly {@link immessage.QryGroupMembersReq.verify|verify} messages.
         * @param message QryGroupMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryGroupMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryGroupMembersReq message, length delimited. Does not implicitly {@link immessage.QryGroupMembersReq.verify|verify} messages.
         * @param message QryGroupMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryGroupMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryGroupMembersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryGroupMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryGroupMembersReq;

        /**
         * Decodes a QryGroupMembersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryGroupMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryGroupMembersReq;

        /**
         * Verifies a QryGroupMembersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryGroupMembersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryGroupMembersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryGroupMembersReq;

        /**
         * Creates a plain object from a QryGroupMembersReq message. Also converts values to other types if specified.
         * @param message QryGroupMembersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryGroupMembersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryGroupMembersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryGroupMembersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CheckGroupMembersReq. */
    interface ICheckGroupMembersReq {

        /** CheckGroupMembersReq groupId */
        groupId?: (string|null);

        /** CheckGroupMembersReq memberIds */
        memberIds?: (string[]|null);
    }

    /** Represents a CheckGroupMembersReq. */
    class CheckGroupMembersReq implements ICheckGroupMembersReq {

        /**
         * Constructs a new CheckGroupMembersReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ICheckGroupMembersReq);

        /** CheckGroupMembersReq groupId. */
        public groupId: string;

        /** CheckGroupMembersReq memberIds. */
        public memberIds: string[];

        /**
         * Creates a new CheckGroupMembersReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CheckGroupMembersReq instance
         */
        public static create(properties?: immessage.ICheckGroupMembersReq): immessage.CheckGroupMembersReq;

        /**
         * Encodes the specified CheckGroupMembersReq message. Does not implicitly {@link immessage.CheckGroupMembersReq.verify|verify} messages.
         * @param message CheckGroupMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ICheckGroupMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CheckGroupMembersReq message, length delimited. Does not implicitly {@link immessage.CheckGroupMembersReq.verify|verify} messages.
         * @param message CheckGroupMembersReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ICheckGroupMembersReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CheckGroupMembersReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CheckGroupMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.CheckGroupMembersReq;

        /**
         * Decodes a CheckGroupMembersReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CheckGroupMembersReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.CheckGroupMembersReq;

        /**
         * Verifies a CheckGroupMembersReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CheckGroupMembersReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CheckGroupMembersReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.CheckGroupMembersReq;

        /**
         * Creates a plain object from a CheckGroupMembersReq message. Also converts values to other types if specified.
         * @param message CheckGroupMembersReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.CheckGroupMembersReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CheckGroupMembersReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CheckGroupMembersReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CheckGroupMembersResp. */
    interface ICheckGroupMembersResp {

        /** CheckGroupMembersResp memberIdMap */
        memberIdMap?: ({ [k: string]: (number|Long) }|null);
    }

    /** Represents a CheckGroupMembersResp. */
    class CheckGroupMembersResp implements ICheckGroupMembersResp {

        /**
         * Constructs a new CheckGroupMembersResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ICheckGroupMembersResp);

        /** CheckGroupMembersResp memberIdMap. */
        public memberIdMap: { [k: string]: (number|Long) };

        /**
         * Creates a new CheckGroupMembersResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CheckGroupMembersResp instance
         */
        public static create(properties?: immessage.ICheckGroupMembersResp): immessage.CheckGroupMembersResp;

        /**
         * Encodes the specified CheckGroupMembersResp message. Does not implicitly {@link immessage.CheckGroupMembersResp.verify|verify} messages.
         * @param message CheckGroupMembersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ICheckGroupMembersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CheckGroupMembersResp message, length delimited. Does not implicitly {@link immessage.CheckGroupMembersResp.verify|verify} messages.
         * @param message CheckGroupMembersResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ICheckGroupMembersResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CheckGroupMembersResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CheckGroupMembersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.CheckGroupMembersResp;

        /**
         * Decodes a CheckGroupMembersResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CheckGroupMembersResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.CheckGroupMembersResp;

        /**
         * Verifies a CheckGroupMembersResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CheckGroupMembersResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CheckGroupMembersResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.CheckGroupMembersResp;

        /**
         * Creates a plain object from a CheckGroupMembersResp message. Also converts values to other types if specified.
         * @param message CheckGroupMembersResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.CheckGroupMembersResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CheckGroupMembersResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CheckGroupMembersResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryGrpSnapshotReq. */
    interface IQryGrpSnapshotReq {

        /** QryGrpSnapshotReq groupId */
        groupId?: (string|null);

        /** QryGrpSnapshotReq nearlyTime */
        nearlyTime?: (number|Long|null);
    }

    /** Represents a QryGrpSnapshotReq. */
    class QryGrpSnapshotReq implements IQryGrpSnapshotReq {

        /**
         * Constructs a new QryGrpSnapshotReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryGrpSnapshotReq);

        /** QryGrpSnapshotReq groupId. */
        public groupId: string;

        /** QryGrpSnapshotReq nearlyTime. */
        public nearlyTime: (number|Long);

        /**
         * Creates a new QryGrpSnapshotReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryGrpSnapshotReq instance
         */
        public static create(properties?: immessage.IQryGrpSnapshotReq): immessage.QryGrpSnapshotReq;

        /**
         * Encodes the specified QryGrpSnapshotReq message. Does not implicitly {@link immessage.QryGrpSnapshotReq.verify|verify} messages.
         * @param message QryGrpSnapshotReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryGrpSnapshotReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryGrpSnapshotReq message, length delimited. Does not implicitly {@link immessage.QryGrpSnapshotReq.verify|verify} messages.
         * @param message QryGrpSnapshotReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryGrpSnapshotReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryGrpSnapshotReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryGrpSnapshotReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryGrpSnapshotReq;

        /**
         * Decodes a QryGrpSnapshotReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryGrpSnapshotReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryGrpSnapshotReq;

        /**
         * Verifies a QryGrpSnapshotReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryGrpSnapshotReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryGrpSnapshotReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryGrpSnapshotReq;

        /**
         * Creates a plain object from a QryGrpSnapshotReq message. Also converts values to other types if specified.
         * @param message QryGrpSnapshotReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryGrpSnapshotReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryGrpSnapshotReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryGrpSnapshotReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a GroupSnapshot. */
    interface IGroupSnapshot {

        /** GroupSnapshot groupId */
        groupId?: (string|null);

        /** GroupSnapshot memberIds */
        memberIds?: (string[]|null);
    }

    /** Represents a GroupSnapshot. */
    class GroupSnapshot implements IGroupSnapshot {

        /**
         * Constructs a new GroupSnapshot.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IGroupSnapshot);

        /** GroupSnapshot groupId. */
        public groupId: string;

        /** GroupSnapshot memberIds. */
        public memberIds: string[];

        /**
         * Creates a new GroupSnapshot instance using the specified properties.
         * @param [properties] Properties to set
         * @returns GroupSnapshot instance
         */
        public static create(properties?: immessage.IGroupSnapshot): immessage.GroupSnapshot;

        /**
         * Encodes the specified GroupSnapshot message. Does not implicitly {@link immessage.GroupSnapshot.verify|verify} messages.
         * @param message GroupSnapshot message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IGroupSnapshot, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified GroupSnapshot message, length delimited. Does not implicitly {@link immessage.GroupSnapshot.verify|verify} messages.
         * @param message GroupSnapshot message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IGroupSnapshot, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a GroupSnapshot message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns GroupSnapshot
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.GroupSnapshot;

        /**
         * Decodes a GroupSnapshot message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns GroupSnapshot
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.GroupSnapshot;

        /**
         * Verifies a GroupSnapshot message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a GroupSnapshot message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns GroupSnapshot
         */
        public static fromObject(object: { [k: string]: any }): immessage.GroupSnapshot;

        /**
         * Creates a plain object from a GroupSnapshot message. Also converts values to other types if specified.
         * @param message GroupSnapshot
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.GroupSnapshot, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this GroupSnapshot to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for GroupSnapshot
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryGrpMemberSettingsReq. */
    interface IQryGrpMemberSettingsReq {

        /** QryGrpMemberSettingsReq memberId */
        memberId?: (string|null);
    }

    /** Represents a QryGrpMemberSettingsReq. */
    class QryGrpMemberSettingsReq implements IQryGrpMemberSettingsReq {

        /**
         * Constructs a new QryGrpMemberSettingsReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryGrpMemberSettingsReq);

        /** QryGrpMemberSettingsReq memberId. */
        public memberId: string;

        /**
         * Creates a new QryGrpMemberSettingsReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryGrpMemberSettingsReq instance
         */
        public static create(properties?: immessage.IQryGrpMemberSettingsReq): immessage.QryGrpMemberSettingsReq;

        /**
         * Encodes the specified QryGrpMemberSettingsReq message. Does not implicitly {@link immessage.QryGrpMemberSettingsReq.verify|verify} messages.
         * @param message QryGrpMemberSettingsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryGrpMemberSettingsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryGrpMemberSettingsReq message, length delimited. Does not implicitly {@link immessage.QryGrpMemberSettingsReq.verify|verify} messages.
         * @param message QryGrpMemberSettingsReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryGrpMemberSettingsReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryGrpMemberSettingsReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryGrpMemberSettingsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryGrpMemberSettingsReq;

        /**
         * Decodes a QryGrpMemberSettingsReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryGrpMemberSettingsReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryGrpMemberSettingsReq;

        /**
         * Verifies a QryGrpMemberSettingsReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryGrpMemberSettingsReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryGrpMemberSettingsReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryGrpMemberSettingsReq;

        /**
         * Creates a plain object from a QryGrpMemberSettingsReq message. Also converts values to other types if specified.
         * @param message QryGrpMemberSettingsReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryGrpMemberSettingsReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryGrpMemberSettingsReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryGrpMemberSettingsReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryGrpMemberSettingsResp. */
    interface IQryGrpMemberSettingsResp {

        /** QryGrpMemberSettingsResp groupId */
        groupId?: (string|null);

        /** QryGrpMemberSettingsResp memberId */
        memberId?: (string|null);

        /** QryGrpMemberSettingsResp isMember */
        isMember?: (boolean|null);

        /** QryGrpMemberSettingsResp joinTime */
        joinTime?: (number|Long|null);

        /** QryGrpMemberSettingsResp groupSettings */
        groupSettings?: ({ [k: string]: string }|null);

        /** QryGrpMemberSettingsResp memberSettings */
        memberSettings?: ({ [k: string]: string }|null);

        /** QryGrpMemberSettingsResp memberExts */
        memberExts?: ({ [k: string]: string }|null);
    }

    /** Represents a QryGrpMemberSettingsResp. */
    class QryGrpMemberSettingsResp implements IQryGrpMemberSettingsResp {

        /**
         * Constructs a new QryGrpMemberSettingsResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryGrpMemberSettingsResp);

        /** QryGrpMemberSettingsResp groupId. */
        public groupId: string;

        /** QryGrpMemberSettingsResp memberId. */
        public memberId: string;

        /** QryGrpMemberSettingsResp isMember. */
        public isMember: boolean;

        /** QryGrpMemberSettingsResp joinTime. */
        public joinTime: (number|Long);

        /** QryGrpMemberSettingsResp groupSettings. */
        public groupSettings: { [k: string]: string };

        /** QryGrpMemberSettingsResp memberSettings. */
        public memberSettings: { [k: string]: string };

        /** QryGrpMemberSettingsResp memberExts. */
        public memberExts: { [k: string]: string };

        /**
         * Creates a new QryGrpMemberSettingsResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryGrpMemberSettingsResp instance
         */
        public static create(properties?: immessage.IQryGrpMemberSettingsResp): immessage.QryGrpMemberSettingsResp;

        /**
         * Encodes the specified QryGrpMemberSettingsResp message. Does not implicitly {@link immessage.QryGrpMemberSettingsResp.verify|verify} messages.
         * @param message QryGrpMemberSettingsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryGrpMemberSettingsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryGrpMemberSettingsResp message, length delimited. Does not implicitly {@link immessage.QryGrpMemberSettingsResp.verify|verify} messages.
         * @param message QryGrpMemberSettingsResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryGrpMemberSettingsResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryGrpMemberSettingsResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryGrpMemberSettingsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryGrpMemberSettingsResp;

        /**
         * Decodes a QryGrpMemberSettingsResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryGrpMemberSettingsResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryGrpMemberSettingsResp;

        /**
         * Verifies a QryGrpMemberSettingsResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryGrpMemberSettingsResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryGrpMemberSettingsResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryGrpMemberSettingsResp;

        /**
         * Creates a plain object from a QryGrpMemberSettingsResp message. Also converts values to other types if specified.
         * @param message QryGrpMemberSettingsResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryGrpMemberSettingsResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryGrpMemberSettingsResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryGrpMemberSettingsResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a QryFileCredReq. */
    interface IQryFileCredReq {

        /** QryFileCredReq fileType */
        fileType?: (immessage.FileType|null);

        /** QryFileCredReq ext */
        ext?: (string|null);
    }

    /** Represents a QryFileCredReq. */
    class QryFileCredReq implements IQryFileCredReq {

        /**
         * Constructs a new QryFileCredReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryFileCredReq);

        /** QryFileCredReq fileType. */
        public fileType: immessage.FileType;

        /** QryFileCredReq ext. */
        public ext: string;

        /**
         * Creates a new QryFileCredReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryFileCredReq instance
         */
        public static create(properties?: immessage.IQryFileCredReq): immessage.QryFileCredReq;

        /**
         * Encodes the specified QryFileCredReq message. Does not implicitly {@link immessage.QryFileCredReq.verify|verify} messages.
         * @param message QryFileCredReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryFileCredReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryFileCredReq message, length delimited. Does not implicitly {@link immessage.QryFileCredReq.verify|verify} messages.
         * @param message QryFileCredReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryFileCredReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryFileCredReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryFileCredReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryFileCredReq;

        /**
         * Decodes a QryFileCredReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryFileCredReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryFileCredReq;

        /**
         * Verifies a QryFileCredReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryFileCredReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryFileCredReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryFileCredReq;

        /**
         * Creates a plain object from a QryFileCredReq message. Also converts values to other types if specified.
         * @param message QryFileCredReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryFileCredReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryFileCredReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryFileCredReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** FileType enum. */
    enum FileType {
        DefaultFileType = 0,
        Image = 1,
        Audio = 2,
        Video = 3,
        File = 4,
        Log = 5
    }

    /** Properties of a QryFileCredResp. */
    interface IQryFileCredResp {

        /** QryFileCredResp ossType */
        ossType?: (immessage.OssType|null);

        /** QryFileCredResp qiniuCred */
        qiniuCred?: (immessage.IQiNiuCredResp|null);

        /** QryFileCredResp preSignResp */
        preSignResp?: (immessage.IPreSignResp|null);
    }

    /** Represents a QryFileCredResp. */
    class QryFileCredResp implements IQryFileCredResp {

        /**
         * Constructs a new QryFileCredResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQryFileCredResp);

        /** QryFileCredResp ossType. */
        public ossType: immessage.OssType;

        /** QryFileCredResp qiniuCred. */
        public qiniuCred?: (immessage.IQiNiuCredResp|null);

        /** QryFileCredResp preSignResp. */
        public preSignResp?: (immessage.IPreSignResp|null);

        /** QryFileCredResp ossOf. */
        public ossOf?: ("qiniuCred"|"preSignResp");

        /**
         * Creates a new QryFileCredResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QryFileCredResp instance
         */
        public static create(properties?: immessage.IQryFileCredResp): immessage.QryFileCredResp;

        /**
         * Encodes the specified QryFileCredResp message. Does not implicitly {@link immessage.QryFileCredResp.verify|verify} messages.
         * @param message QryFileCredResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQryFileCredResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QryFileCredResp message, length delimited. Does not implicitly {@link immessage.QryFileCredResp.verify|verify} messages.
         * @param message QryFileCredResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQryFileCredResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QryFileCredResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QryFileCredResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QryFileCredResp;

        /**
         * Decodes a QryFileCredResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QryFileCredResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QryFileCredResp;

        /**
         * Verifies a QryFileCredResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QryFileCredResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QryFileCredResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QryFileCredResp;

        /**
         * Creates a plain object from a QryFileCredResp message. Also converts values to other types if specified.
         * @param message QryFileCredResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QryFileCredResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QryFileCredResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QryFileCredResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** OssType enum. */
    enum OssType {
        DefaultOss = 0,
        QiNiu = 1,
        S3 = 2,
        Minio = 3,
        Oss = 4
    }

    /** Properties of a QiNiuCredResp. */
    interface IQiNiuCredResp {

        /** QiNiuCredResp domain */
        domain?: (string|null);

        /** QiNiuCredResp token */
        token?: (string|null);
    }

    /** Represents a QiNiuCredResp. */
    class QiNiuCredResp implements IQiNiuCredResp {

        /**
         * Constructs a new QiNiuCredResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IQiNiuCredResp);

        /** QiNiuCredResp domain. */
        public domain: string;

        /** QiNiuCredResp token. */
        public token: string;

        /**
         * Creates a new QiNiuCredResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns QiNiuCredResp instance
         */
        public static create(properties?: immessage.IQiNiuCredResp): immessage.QiNiuCredResp;

        /**
         * Encodes the specified QiNiuCredResp message. Does not implicitly {@link immessage.QiNiuCredResp.verify|verify} messages.
         * @param message QiNiuCredResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IQiNiuCredResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified QiNiuCredResp message, length delimited. Does not implicitly {@link immessage.QiNiuCredResp.verify|verify} messages.
         * @param message QiNiuCredResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IQiNiuCredResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a QiNiuCredResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns QiNiuCredResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.QiNiuCredResp;

        /**
         * Decodes a QiNiuCredResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns QiNiuCredResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.QiNiuCredResp;

        /**
         * Verifies a QiNiuCredResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a QiNiuCredResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns QiNiuCredResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.QiNiuCredResp;

        /**
         * Creates a plain object from a QiNiuCredResp message. Also converts values to other types if specified.
         * @param message QiNiuCredResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.QiNiuCredResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this QiNiuCredResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for QiNiuCredResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a PreSignResp. */
    interface IPreSignResp {

        /** PreSignResp url */
        url?: (string|null);

        /** PreSignResp objKey */
        objKey?: (string|null);

        /** PreSignResp policy */
        policy?: (string|null);

        /** PreSignResp signVersion */
        signVersion?: (string|null);

        /** PreSignResp credential */
        credential?: (string|null);

        /** PreSignResp date */
        date?: (string|null);

        /** PreSignResp signature */
        signature?: (string|null);
    }

    /** Represents a PreSignResp. */
    class PreSignResp implements IPreSignResp {

        /**
         * Constructs a new PreSignResp.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IPreSignResp);

        /** PreSignResp url. */
        public url: string;

        /** PreSignResp objKey. */
        public objKey: string;

        /** PreSignResp policy. */
        public policy: string;

        /** PreSignResp signVersion. */
        public signVersion: string;

        /** PreSignResp credential. */
        public credential: string;

        /** PreSignResp date. */
        public date: string;

        /** PreSignResp signature. */
        public signature: string;

        /**
         * Creates a new PreSignResp instance using the specified properties.
         * @param [properties] Properties to set
         * @returns PreSignResp instance
         */
        public static create(properties?: immessage.IPreSignResp): immessage.PreSignResp;

        /**
         * Encodes the specified PreSignResp message. Does not implicitly {@link immessage.PreSignResp.verify|verify} messages.
         * @param message PreSignResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IPreSignResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified PreSignResp message, length delimited. Does not implicitly {@link immessage.PreSignResp.verify|verify} messages.
         * @param message PreSignResp message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IPreSignResp, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a PreSignResp message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns PreSignResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.PreSignResp;

        /**
         * Decodes a PreSignResp message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns PreSignResp
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.PreSignResp;

        /**
         * Verifies a PreSignResp message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a PreSignResp message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns PreSignResp
         */
        public static fromObject(object: { [k: string]: any }): immessage.PreSignResp;

        /**
         * Creates a plain object from a PreSignResp message. Also converts values to other types if specified.
         * @param message PreSignResp
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.PreSignResp, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this PreSignResp to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for PreSignResp
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an UploadLogStatusReq. */
    interface IUploadLogStatusReq {

        /** UploadLogStatusReq msgId */
        msgId?: (string|null);

        /** UploadLogStatusReq logUrl */
        logUrl?: (string|null);

        /** UploadLogStatusReq state */
        state?: (number|null);
    }

    /** Represents an UploadLogStatusReq. */
    class UploadLogStatusReq implements IUploadLogStatusReq {

        /**
         * Constructs a new UploadLogStatusReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IUploadLogStatusReq);

        /** UploadLogStatusReq msgId. */
        public msgId: string;

        /** UploadLogStatusReq logUrl. */
        public logUrl: string;

        /** UploadLogStatusReq state. */
        public state: number;

        /**
         * Creates a new UploadLogStatusReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UploadLogStatusReq instance
         */
        public static create(properties?: immessage.IUploadLogStatusReq): immessage.UploadLogStatusReq;

        /**
         * Encodes the specified UploadLogStatusReq message. Does not implicitly {@link immessage.UploadLogStatusReq.verify|verify} messages.
         * @param message UploadLogStatusReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IUploadLogStatusReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UploadLogStatusReq message, length delimited. Does not implicitly {@link immessage.UploadLogStatusReq.verify|verify} messages.
         * @param message UploadLogStatusReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IUploadLogStatusReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an UploadLogStatusReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UploadLogStatusReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.UploadLogStatusReq;

        /**
         * Decodes an UploadLogStatusReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UploadLogStatusReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.UploadLogStatusReq;

        /**
         * Verifies an UploadLogStatusReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an UploadLogStatusReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UploadLogStatusReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.UploadLogStatusReq;

        /**
         * Creates a plain object from an UploadLogStatusReq message. Also converts values to other types if specified.
         * @param message UploadLogStatusReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.UploadLogStatusReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UploadLogStatusReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UploadLogStatusReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SubMsgs. */
    interface ISubMsgs {

        /** SubMsgs subMsgs */
        subMsgs?: (immessage.ISubMsg[]|null);
    }

    /** Represents a SubMsgs. */
    class SubMsgs implements ISubMsgs {

        /**
         * Constructs a new SubMsgs.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISubMsgs);

        /** SubMsgs subMsgs. */
        public subMsgs: immessage.ISubMsg[];

        /**
         * Creates a new SubMsgs instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SubMsgs instance
         */
        public static create(properties?: immessage.ISubMsgs): immessage.SubMsgs;

        /**
         * Encodes the specified SubMsgs message. Does not implicitly {@link immessage.SubMsgs.verify|verify} messages.
         * @param message SubMsgs message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISubMsgs, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SubMsgs message, length delimited. Does not implicitly {@link immessage.SubMsgs.verify|verify} messages.
         * @param message SubMsgs message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISubMsgs, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SubMsgs message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SubMsgs
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SubMsgs;

        /**
         * Decodes a SubMsgs message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SubMsgs
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SubMsgs;

        /**
         * Verifies a SubMsgs message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SubMsgs message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SubMsgs
         */
        public static fromObject(object: { [k: string]: any }): immessage.SubMsgs;

        /**
         * Creates a plain object from a SubMsgs message. Also converts values to other types if specified.
         * @param message SubMsgs
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SubMsgs, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SubMsgs to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SubMsgs
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a SubMsg. */
    interface ISubMsg {

        /** SubMsg msg */
        msg?: (immessage.IDownMsg|null);

        /** SubMsg platform */
        platform?: (string|null);
    }

    /** Represents a SubMsg. */
    class SubMsg implements ISubMsg {

        /**
         * Constructs a new SubMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ISubMsg);

        /** SubMsg msg. */
        public msg?: (immessage.IDownMsg|null);

        /** SubMsg platform. */
        public platform: string;

        /**
         * Creates a new SubMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns SubMsg instance
         */
        public static create(properties?: immessage.ISubMsg): immessage.SubMsg;

        /**
         * Encodes the specified SubMsg message. Does not implicitly {@link immessage.SubMsg.verify|verify} messages.
         * @param message SubMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ISubMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified SubMsg message, length delimited. Does not implicitly {@link immessage.SubMsg.verify|verify} messages.
         * @param message SubMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ISubMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a SubMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns SubMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.SubMsg;

        /**
         * Decodes a SubMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns SubMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.SubMsg;

        /**
         * Verifies a SubMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a SubMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns SubMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.SubMsg;

        /**
         * Creates a plain object from a SubMsg message. Also converts values to other types if specified.
         * @param message SubMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.SubMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this SubMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for SubMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of an OnlineOfflineMsg. */
    interface IOnlineOfflineMsg {

        /** OnlineOfflineMsg type */
        type?: (immessage.OnlineType|null);

        /** OnlineOfflineMsg userId */
        userId?: (string|null);

        /** OnlineOfflineMsg deviceId */
        deviceId?: (string|null);

        /** OnlineOfflineMsg platform */
        platform?: (string|null);

        /** OnlineOfflineMsg clientIp */
        clientIp?: (string|null);

        /** OnlineOfflineMsg sessionId */
        sessionId?: (string|null);

        /** OnlineOfflineMsg timestamp */
        timestamp?: (number|Long|null);

        /** OnlineOfflineMsg connectionExt */
        connectionExt?: (string|null);

        /** OnlineOfflineMsg instanceId */
        instanceId?: (string|null);
    }

    /** Represents an OnlineOfflineMsg. */
    class OnlineOfflineMsg implements IOnlineOfflineMsg {

        /**
         * Constructs a new OnlineOfflineMsg.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.IOnlineOfflineMsg);

        /** OnlineOfflineMsg type. */
        public type: immessage.OnlineType;

        /** OnlineOfflineMsg userId. */
        public userId: string;

        /** OnlineOfflineMsg deviceId. */
        public deviceId: string;

        /** OnlineOfflineMsg platform. */
        public platform: string;

        /** OnlineOfflineMsg clientIp. */
        public clientIp: string;

        /** OnlineOfflineMsg sessionId. */
        public sessionId: string;

        /** OnlineOfflineMsg timestamp. */
        public timestamp: (number|Long);

        /** OnlineOfflineMsg connectionExt. */
        public connectionExt: string;

        /** OnlineOfflineMsg instanceId. */
        public instanceId: string;

        /**
         * Creates a new OnlineOfflineMsg instance using the specified properties.
         * @param [properties] Properties to set
         * @returns OnlineOfflineMsg instance
         */
        public static create(properties?: immessage.IOnlineOfflineMsg): immessage.OnlineOfflineMsg;

        /**
         * Encodes the specified OnlineOfflineMsg message. Does not implicitly {@link immessage.OnlineOfflineMsg.verify|verify} messages.
         * @param message OnlineOfflineMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.IOnlineOfflineMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified OnlineOfflineMsg message, length delimited. Does not implicitly {@link immessage.OnlineOfflineMsg.verify|verify} messages.
         * @param message OnlineOfflineMsg message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.IOnlineOfflineMsg, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes an OnlineOfflineMsg message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns OnlineOfflineMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.OnlineOfflineMsg;

        /**
         * Decodes an OnlineOfflineMsg message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns OnlineOfflineMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.OnlineOfflineMsg;

        /**
         * Verifies an OnlineOfflineMsg message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates an OnlineOfflineMsg message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns OnlineOfflineMsg
         */
        public static fromObject(object: { [k: string]: any }): immessage.OnlineOfflineMsg;

        /**
         * Creates a plain object from an OnlineOfflineMsg message. Also converts values to other types if specified.
         * @param message OnlineOfflineMsg
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.OnlineOfflineMsg, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this OnlineOfflineMsg to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for OnlineOfflineMsg
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a TransReq. */
    interface ITransReq {

        /** TransReq items */
        items?: (immessage.ITransItem[]|null);

        /** TransReq targetLang */
        targetLang?: (string|null);

        /** TransReq sourceLang */
        sourceLang?: (string|null);
    }

    /** Represents a TransReq. */
    class TransReq implements ITransReq {

        /**
         * Constructs a new TransReq.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ITransReq);

        /** TransReq items. */
        public items: immessage.ITransItem[];

        /** TransReq targetLang. */
        public targetLang: string;

        /** TransReq sourceLang. */
        public sourceLang: string;

        /**
         * Creates a new TransReq instance using the specified properties.
         * @param [properties] Properties to set
         * @returns TransReq instance
         */
        public static create(properties?: immessage.ITransReq): immessage.TransReq;

        /**
         * Encodes the specified TransReq message. Does not implicitly {@link immessage.TransReq.verify|verify} messages.
         * @param message TransReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ITransReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified TransReq message, length delimited. Does not implicitly {@link immessage.TransReq.verify|verify} messages.
         * @param message TransReq message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ITransReq, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a TransReq message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns TransReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.TransReq;

        /**
         * Decodes a TransReq message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns TransReq
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.TransReq;

        /**
         * Verifies a TransReq message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a TransReq message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns TransReq
         */
        public static fromObject(object: { [k: string]: any }): immessage.TransReq;

        /**
         * Creates a plain object from a TransReq message. Also converts values to other types if specified.
         * @param message TransReq
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.TransReq, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this TransReq to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for TransReq
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a TransItem. */
    interface ITransItem {

        /** TransItem key */
        key?: (string|null);

        /** TransItem content */
        content?: (string|null);
    }

    /** Represents a TransItem. */
    class TransItem implements ITransItem {

        /**
         * Constructs a new TransItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: immessage.ITransItem);

        /** TransItem key. */
        public key: string;

        /** TransItem content. */
        public content: string;

        /**
         * Creates a new TransItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns TransItem instance
         */
        public static create(properties?: immessage.ITransItem): immessage.TransItem;

        /**
         * Encodes the specified TransItem message. Does not implicitly {@link immessage.TransItem.verify|verify} messages.
         * @param message TransItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: immessage.ITransItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified TransItem message, length delimited. Does not implicitly {@link immessage.TransItem.verify|verify} messages.
         * @param message TransItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: immessage.ITransItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a TransItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns TransItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): immessage.TransItem;

        /**
         * Decodes a TransItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns TransItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): immessage.TransItem;

        /**
         * Verifies a TransItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a TransItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns TransItem
         */
        public static fromObject(object: { [k: string]: any }): immessage.TransItem;

        /**
         * Creates a plain object from a TransItem message. Also converts values to other types if specified.
         * @param message TransItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: immessage.TransItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this TransItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for TransItem
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }
}
