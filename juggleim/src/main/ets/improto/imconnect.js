/*eslint-disable block-scoped-var, id-length, no-control-regex, no-magic-numbers, no-prototype-builtins, no-redeclare, no-shadow, no-var, sort-vars*/
import { index } from "@ohos/protobufjs";
const $protobuf = index;
import Long from 'long';
$protobuf.util.Long=Long
$protobuf.configure()

// Common aliases
const $Reader = $protobuf.Reader, $Writer = $protobuf.Writer, $util = $protobuf.util;

// Exported root namespace
const $root = $protobuf.roots["default"] || ($protobuf.roots["default"] = {});

export const imconnect = $root.imconnect = (() => {

    /**
     * Namespace imconnect.
     * @exports imconnect
     * @namespace
     */
    const imconnect = {};

    imconnect.ConnectMsgBody = (function() {

        /**
         * Properties of a ConnectMsgBody.
         * @memberof imconnect
         * @interface IConnectMsgBody
         * @property {string|null} [protoId] ConnectMsgBody protoId
         * @property {string|null} [sdkVersion] ConnectMsgBody sdkVersion
         * @property {string|null} [appkey] ConnectMsgBody appkey
         * @property {string|null} [token] ConnectMsgBody token
         * @property {string|null} [deviceId] ConnectMsgBody deviceId
         * @property {string|null} [platform] ConnectMsgBody platform
         * @property {string|null} [deviceCompany] ConnectMsgBody deviceCompany
         * @property {string|null} [deviceModel] ConnectMsgBody deviceModel
         * @property {string|null} [deviceOsVersion] ConnectMsgBody deviceOsVersion
         * @property {string|null} [pushToken] ConnectMsgBody pushToken
         * @property {string|null} [networkId] ConnectMsgBody networkId
         * @property {string|null} [ispNum] ConnectMsgBody ispNum
         * @property {string|null} [clientIp] ConnectMsgBody clientIp
         * @property {string|null} [packageName] ConnectMsgBody packageName
         * @property {string|null} [pushChannel] ConnectMsgBody pushChannel
         * @property {string|null} [ext] ConnectMsgBody ext
         * @property {string|null} [instanceId] ConnectMsgBody instanceId
         * @property {string|null} [language] ConnectMsgBody language
         * @property {boolean|null} [isBackend] ConnectMsgBody isBackend
         * @property {string|null} [voipToken] ConnectMsgBody voipToken
         */

        /**
         * Constructs a new ConnectMsgBody.
         * @memberof imconnect
         * @classdesc Represents a ConnectMsgBody.
         * @implements IConnectMsgBody
         * @constructor
         * @param {imconnect.IConnectMsgBody=} [properties] Properties to set
         */
        function ConnectMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * ConnectMsgBody protoId.
         * @member {string} protoId
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.protoId = "";

        /**
         * ConnectMsgBody sdkVersion.
         * @member {string} sdkVersion
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.sdkVersion = "";

        /**
         * ConnectMsgBody appkey.
         * @member {string} appkey
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.appkey = "";

        /**
         * ConnectMsgBody token.
         * @member {string} token
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.token = "";

        /**
         * ConnectMsgBody deviceId.
         * @member {string} deviceId
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.deviceId = "";

        /**
         * ConnectMsgBody platform.
         * @member {string} platform
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.platform = "";

        /**
         * ConnectMsgBody deviceCompany.
         * @member {string} deviceCompany
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.deviceCompany = "";

        /**
         * ConnectMsgBody deviceModel.
         * @member {string} deviceModel
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.deviceModel = "";

        /**
         * ConnectMsgBody deviceOsVersion.
         * @member {string} deviceOsVersion
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.deviceOsVersion = "";

        /**
         * ConnectMsgBody pushToken.
         * @member {string} pushToken
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.pushToken = "";

        /**
         * ConnectMsgBody networkId.
         * @member {string} networkId
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.networkId = "";

        /**
         * ConnectMsgBody ispNum.
         * @member {string} ispNum
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.ispNum = "";

        /**
         * ConnectMsgBody clientIp.
         * @member {string} clientIp
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.clientIp = "";

        /**
         * ConnectMsgBody packageName.
         * @member {string} packageName
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.packageName = "";

        /**
         * ConnectMsgBody pushChannel.
         * @member {string} pushChannel
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.pushChannel = "";

        /**
         * ConnectMsgBody ext.
         * @member {string} ext
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.ext = "";

        /**
         * ConnectMsgBody instanceId.
         * @member {string} instanceId
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.instanceId = "";

        /**
         * ConnectMsgBody language.
         * @member {string} language
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.language = "";

        /**
         * ConnectMsgBody isBackend.
         * @member {boolean} isBackend
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.isBackend = false;

        /**
         * ConnectMsgBody voipToken.
         * @member {string} voipToken
         * @memberof imconnect.ConnectMsgBody
         * @instance
         */
        ConnectMsgBody.prototype.voipToken = "";

        /**
         * Creates a new ConnectMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {imconnect.IConnectMsgBody=} [properties] Properties to set
         * @returns {imconnect.ConnectMsgBody} ConnectMsgBody instance
         */
        ConnectMsgBody.create = function create(properties) {
            return new ConnectMsgBody(properties);
        };

        /**
         * Encodes the specified ConnectMsgBody message. Does not implicitly {@link imconnect.ConnectMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {imconnect.IConnectMsgBody} message ConnectMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        ConnectMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.protoId != null && Object.hasOwnProperty.call(message, "protoId"))
                writer.uint32(/* id 1, wireType 2 =*/10).string(message.protoId);
            if (message.sdkVersion != null && Object.hasOwnProperty.call(message, "sdkVersion"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.sdkVersion);
            if (message.appkey != null && Object.hasOwnProperty.call(message, "appkey"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.appkey);
            if (message.token != null && Object.hasOwnProperty.call(message, "token"))
                writer.uint32(/* id 4, wireType 2 =*/34).string(message.token);
            if (message.deviceId != null && Object.hasOwnProperty.call(message, "deviceId"))
                writer.uint32(/* id 5, wireType 2 =*/42).string(message.deviceId);
            if (message.platform != null && Object.hasOwnProperty.call(message, "platform"))
                writer.uint32(/* id 6, wireType 2 =*/50).string(message.platform);
            if (message.deviceCompany != null && Object.hasOwnProperty.call(message, "deviceCompany"))
                writer.uint32(/* id 7, wireType 2 =*/58).string(message.deviceCompany);
            if (message.deviceModel != null && Object.hasOwnProperty.call(message, "deviceModel"))
                writer.uint32(/* id 8, wireType 2 =*/66).string(message.deviceModel);
            if (message.deviceOsVersion != null && Object.hasOwnProperty.call(message, "deviceOsVersion"))
                writer.uint32(/* id 9, wireType 2 =*/74).string(message.deviceOsVersion);
            if (message.pushToken != null && Object.hasOwnProperty.call(message, "pushToken"))
                writer.uint32(/* id 10, wireType 2 =*/82).string(message.pushToken);
            if (message.networkId != null && Object.hasOwnProperty.call(message, "networkId"))
                writer.uint32(/* id 11, wireType 2 =*/90).string(message.networkId);
            if (message.ispNum != null && Object.hasOwnProperty.call(message, "ispNum"))
                writer.uint32(/* id 12, wireType 2 =*/98).string(message.ispNum);
            if (message.clientIp != null && Object.hasOwnProperty.call(message, "clientIp"))
                writer.uint32(/* id 13, wireType 2 =*/106).string(message.clientIp);
            if (message.packageName != null && Object.hasOwnProperty.call(message, "packageName"))
                writer.uint32(/* id 14, wireType 2 =*/114).string(message.packageName);
            if (message.pushChannel != null && Object.hasOwnProperty.call(message, "pushChannel"))
                writer.uint32(/* id 15, wireType 2 =*/122).string(message.pushChannel);
            if (message.ext != null && Object.hasOwnProperty.call(message, "ext"))
                writer.uint32(/* id 16, wireType 2 =*/130).string(message.ext);
            if (message.instanceId != null && Object.hasOwnProperty.call(message, "instanceId"))
                writer.uint32(/* id 17, wireType 2 =*/138).string(message.instanceId);
            if (message.language != null && Object.hasOwnProperty.call(message, "language"))
                writer.uint32(/* id 18, wireType 2 =*/146).string(message.language);
            if (message.isBackend != null && Object.hasOwnProperty.call(message, "isBackend"))
                writer.uint32(/* id 19, wireType 0 =*/152).bool(message.isBackend);
            if (message.voipToken != null && Object.hasOwnProperty.call(message, "voipToken"))
                writer.uint32(/* id 20, wireType 2 =*/162).string(message.voipToken);
            return writer;
        };

        /**
         * Encodes the specified ConnectMsgBody message, length delimited. Does not implicitly {@link imconnect.ConnectMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {imconnect.IConnectMsgBody} message ConnectMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        ConnectMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a ConnectMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.ConnectMsgBody} ConnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        ConnectMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.ConnectMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.protoId = reader.string();
                        break;
                    }
                case 2: {
                        message.sdkVersion = reader.string();
                        break;
                    }
                case 3: {
                        message.appkey = reader.string();
                        break;
                    }
                case 4: {
                        message.token = reader.string();
                        break;
                    }
                case 5: {
                        message.deviceId = reader.string();
                        break;
                    }
                case 6: {
                        message.platform = reader.string();
                        break;
                    }
                case 7: {
                        message.deviceCompany = reader.string();
                        break;
                    }
                case 8: {
                        message.deviceModel = reader.string();
                        break;
                    }
                case 9: {
                        message.deviceOsVersion = reader.string();
                        break;
                    }
                case 10: {
                        message.pushToken = reader.string();
                        break;
                    }
                case 11: {
                        message.networkId = reader.string();
                        break;
                    }
                case 12: {
                        message.ispNum = reader.string();
                        break;
                    }
                case 13: {
                        message.clientIp = reader.string();
                        break;
                    }
                case 14: {
                        message.packageName = reader.string();
                        break;
                    }
                case 15: {
                        message.pushChannel = reader.string();
                        break;
                    }
                case 16: {
                        message.ext = reader.string();
                        break;
                    }
                case 17: {
                        message.instanceId = reader.string();
                        break;
                    }
                case 18: {
                        message.language = reader.string();
                        break;
                    }
                case 19: {
                        message.isBackend = reader.bool();
                        break;
                    }
                case 20: {
                        message.voipToken = reader.string();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a ConnectMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.ConnectMsgBody} ConnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        ConnectMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a ConnectMsgBody message.
         * @function verify
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        ConnectMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.protoId != null && message.hasOwnProperty("protoId"))
                if (!$util.isString(message.protoId))
                    return "protoId: string expected";
            if (message.sdkVersion != null && message.hasOwnProperty("sdkVersion"))
                if (!$util.isString(message.sdkVersion))
                    return "sdkVersion: string expected";
            if (message.appkey != null && message.hasOwnProperty("appkey"))
                if (!$util.isString(message.appkey))
                    return "appkey: string expected";
            if (message.token != null && message.hasOwnProperty("token"))
                if (!$util.isString(message.token))
                    return "token: string expected";
            if (message.deviceId != null && message.hasOwnProperty("deviceId"))
                if (!$util.isString(message.deviceId))
                    return "deviceId: string expected";
            if (message.platform != null && message.hasOwnProperty("platform"))
                if (!$util.isString(message.platform))
                    return "platform: string expected";
            if (message.deviceCompany != null && message.hasOwnProperty("deviceCompany"))
                if (!$util.isString(message.deviceCompany))
                    return "deviceCompany: string expected";
            if (message.deviceModel != null && message.hasOwnProperty("deviceModel"))
                if (!$util.isString(message.deviceModel))
                    return "deviceModel: string expected";
            if (message.deviceOsVersion != null && message.hasOwnProperty("deviceOsVersion"))
                if (!$util.isString(message.deviceOsVersion))
                    return "deviceOsVersion: string expected";
            if (message.pushToken != null && message.hasOwnProperty("pushToken"))
                if (!$util.isString(message.pushToken))
                    return "pushToken: string expected";
            if (message.networkId != null && message.hasOwnProperty("networkId"))
                if (!$util.isString(message.networkId))
                    return "networkId: string expected";
            if (message.ispNum != null && message.hasOwnProperty("ispNum"))
                if (!$util.isString(message.ispNum))
                    return "ispNum: string expected";
            if (message.clientIp != null && message.hasOwnProperty("clientIp"))
                if (!$util.isString(message.clientIp))
                    return "clientIp: string expected";
            if (message.packageName != null && message.hasOwnProperty("packageName"))
                if (!$util.isString(message.packageName))
                    return "packageName: string expected";
            if (message.pushChannel != null && message.hasOwnProperty("pushChannel"))
                if (!$util.isString(message.pushChannel))
                    return "pushChannel: string expected";
            if (message.ext != null && message.hasOwnProperty("ext"))
                if (!$util.isString(message.ext))
                    return "ext: string expected";
            if (message.instanceId != null && message.hasOwnProperty("instanceId"))
                if (!$util.isString(message.instanceId))
                    return "instanceId: string expected";
            if (message.language != null && message.hasOwnProperty("language"))
                if (!$util.isString(message.language))
                    return "language: string expected";
            if (message.isBackend != null && message.hasOwnProperty("isBackend"))
                if (typeof message.isBackend !== "boolean")
                    return "isBackend: boolean expected";
            if (message.voipToken != null && message.hasOwnProperty("voipToken"))
                if (!$util.isString(message.voipToken))
                    return "voipToken: string expected";
            return null;
        };

        /**
         * Creates a ConnectMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.ConnectMsgBody} ConnectMsgBody
         */
        ConnectMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.ConnectMsgBody)
                return object;
            let message = new $root.imconnect.ConnectMsgBody();
            if (object.protoId != null)
                message.protoId = String(object.protoId);
            if (object.sdkVersion != null)
                message.sdkVersion = String(object.sdkVersion);
            if (object.appkey != null)
                message.appkey = String(object.appkey);
            if (object.token != null)
                message.token = String(object.token);
            if (object.deviceId != null)
                message.deviceId = String(object.deviceId);
            if (object.platform != null)
                message.platform = String(object.platform);
            if (object.deviceCompany != null)
                message.deviceCompany = String(object.deviceCompany);
            if (object.deviceModel != null)
                message.deviceModel = String(object.deviceModel);
            if (object.deviceOsVersion != null)
                message.deviceOsVersion = String(object.deviceOsVersion);
            if (object.pushToken != null)
                message.pushToken = String(object.pushToken);
            if (object.networkId != null)
                message.networkId = String(object.networkId);
            if (object.ispNum != null)
                message.ispNum = String(object.ispNum);
            if (object.clientIp != null)
                message.clientIp = String(object.clientIp);
            if (object.packageName != null)
                message.packageName = String(object.packageName);
            if (object.pushChannel != null)
                message.pushChannel = String(object.pushChannel);
            if (object.ext != null)
                message.ext = String(object.ext);
            if (object.instanceId != null)
                message.instanceId = String(object.instanceId);
            if (object.language != null)
                message.language = String(object.language);
            if (object.isBackend != null)
                message.isBackend = Boolean(object.isBackend);
            if (object.voipToken != null)
                message.voipToken = String(object.voipToken);
            return message;
        };

        /**
         * Creates a plain object from a ConnectMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {imconnect.ConnectMsgBody} message ConnectMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        ConnectMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.protoId = "";
                object.sdkVersion = "";
                object.appkey = "";
                object.token = "";
                object.deviceId = "";
                object.platform = "";
                object.deviceCompany = "";
                object.deviceModel = "";
                object.deviceOsVersion = "";
                object.pushToken = "";
                object.networkId = "";
                object.ispNum = "";
                object.clientIp = "";
                object.packageName = "";
                object.pushChannel = "";
                object.ext = "";
                object.instanceId = "";
                object.language = "";
                object.isBackend = false;
                object.voipToken = "";
            }
            if (message.protoId != null && message.hasOwnProperty("protoId"))
                object.protoId = message.protoId;
            if (message.sdkVersion != null && message.hasOwnProperty("sdkVersion"))
                object.sdkVersion = message.sdkVersion;
            if (message.appkey != null && message.hasOwnProperty("appkey"))
                object.appkey = message.appkey;
            if (message.token != null && message.hasOwnProperty("token"))
                object.token = message.token;
            if (message.deviceId != null && message.hasOwnProperty("deviceId"))
                object.deviceId = message.deviceId;
            if (message.platform != null && message.hasOwnProperty("platform"))
                object.platform = message.platform;
            if (message.deviceCompany != null && message.hasOwnProperty("deviceCompany"))
                object.deviceCompany = message.deviceCompany;
            if (message.deviceModel != null && message.hasOwnProperty("deviceModel"))
                object.deviceModel = message.deviceModel;
            if (message.deviceOsVersion != null && message.hasOwnProperty("deviceOsVersion"))
                object.deviceOsVersion = message.deviceOsVersion;
            if (message.pushToken != null && message.hasOwnProperty("pushToken"))
                object.pushToken = message.pushToken;
            if (message.networkId != null && message.hasOwnProperty("networkId"))
                object.networkId = message.networkId;
            if (message.ispNum != null && message.hasOwnProperty("ispNum"))
                object.ispNum = message.ispNum;
            if (message.clientIp != null && message.hasOwnProperty("clientIp"))
                object.clientIp = message.clientIp;
            if (message.packageName != null && message.hasOwnProperty("packageName"))
                object.packageName = message.packageName;
            if (message.pushChannel != null && message.hasOwnProperty("pushChannel"))
                object.pushChannel = message.pushChannel;
            if (message.ext != null && message.hasOwnProperty("ext"))
                object.ext = message.ext;
            if (message.instanceId != null && message.hasOwnProperty("instanceId"))
                object.instanceId = message.instanceId;
            if (message.language != null && message.hasOwnProperty("language"))
                object.language = message.language;
            if (message.isBackend != null && message.hasOwnProperty("isBackend"))
                object.isBackend = message.isBackend;
            if (message.voipToken != null && message.hasOwnProperty("voipToken"))
                object.voipToken = message.voipToken;
            return object;
        };

        /**
         * Converts this ConnectMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.ConnectMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        ConnectMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for ConnectMsgBody
         * @function getTypeUrl
         * @memberof imconnect.ConnectMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        ConnectMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.ConnectMsgBody";
        };

        return ConnectMsgBody;
    })();

    imconnect.ConnectAckMsgBody = (function() {

        /**
         * Properties of a ConnectAckMsgBody.
         * @memberof imconnect
         * @interface IConnectAckMsgBody
         * @property {number|null} [code] ConnectAckMsgBody code
         * @property {string|null} [userId] ConnectAckMsgBody userId
         * @property {string|null} [session] ConnectAckMsgBody session
         * @property {number|Long|null} [timestamp] ConnectAckMsgBody timestamp
         * @property {string|null} [ext] ConnectAckMsgBody ext
         */

        /**
         * Constructs a new ConnectAckMsgBody.
         * @memberof imconnect
         * @classdesc Represents a ConnectAckMsgBody.
         * @implements IConnectAckMsgBody
         * @constructor
         * @param {imconnect.IConnectAckMsgBody=} [properties] Properties to set
         */
        function ConnectAckMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * ConnectAckMsgBody code.
         * @member {number} code
         * @memberof imconnect.ConnectAckMsgBody
         * @instance
         */
        ConnectAckMsgBody.prototype.code = 0;

        /**
         * ConnectAckMsgBody userId.
         * @member {string} userId
         * @memberof imconnect.ConnectAckMsgBody
         * @instance
         */
        ConnectAckMsgBody.prototype.userId = "";

        /**
         * ConnectAckMsgBody session.
         * @member {string} session
         * @memberof imconnect.ConnectAckMsgBody
         * @instance
         */
        ConnectAckMsgBody.prototype.session = "";

        /**
         * ConnectAckMsgBody timestamp.
         * @member {number|Long} timestamp
         * @memberof imconnect.ConnectAckMsgBody
         * @instance
         */
        ConnectAckMsgBody.prototype.timestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * ConnectAckMsgBody ext.
         * @member {string} ext
         * @memberof imconnect.ConnectAckMsgBody
         * @instance
         */
        ConnectAckMsgBody.prototype.ext = "";

        /**
         * Creates a new ConnectAckMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {imconnect.IConnectAckMsgBody=} [properties] Properties to set
         * @returns {imconnect.ConnectAckMsgBody} ConnectAckMsgBody instance
         */
        ConnectAckMsgBody.create = function create(properties) {
            return new ConnectAckMsgBody(properties);
        };

        /**
         * Encodes the specified ConnectAckMsgBody message. Does not implicitly {@link imconnect.ConnectAckMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {imconnect.IConnectAckMsgBody} message ConnectAckMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        ConnectAckMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.code != null && Object.hasOwnProperty.call(message, "code"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.code);
            if (message.userId != null && Object.hasOwnProperty.call(message, "userId"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.userId);
            if (message.session != null && Object.hasOwnProperty.call(message, "session"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.session);
            if (message.timestamp != null && Object.hasOwnProperty.call(message, "timestamp"))
                writer.uint32(/* id 4, wireType 0 =*/32).int64(message.timestamp);
            if (message.ext != null && Object.hasOwnProperty.call(message, "ext"))
                writer.uint32(/* id 5, wireType 2 =*/42).string(message.ext);
            return writer;
        };

        /**
         * Encodes the specified ConnectAckMsgBody message, length delimited. Does not implicitly {@link imconnect.ConnectAckMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {imconnect.IConnectAckMsgBody} message ConnectAckMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        ConnectAckMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a ConnectAckMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.ConnectAckMsgBody} ConnectAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        ConnectAckMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.ConnectAckMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.code = reader.int32();
                        break;
                    }
                case 2: {
                        message.userId = reader.string();
                        break;
                    }
                case 3: {
                        message.session = reader.string();
                        break;
                    }
                case 4: {
                        message.timestamp = reader.int64();
                        break;
                    }
                case 5: {
                        message.ext = reader.string();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a ConnectAckMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.ConnectAckMsgBody} ConnectAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        ConnectAckMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a ConnectAckMsgBody message.
         * @function verify
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        ConnectAckMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.code != null && message.hasOwnProperty("code"))
                if (!$util.isInteger(message.code))
                    return "code: integer expected";
            if (message.userId != null && message.hasOwnProperty("userId"))
                if (!$util.isString(message.userId))
                    return "userId: string expected";
            if (message.session != null && message.hasOwnProperty("session"))
                if (!$util.isString(message.session))
                    return "session: string expected";
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (!$util.isInteger(message.timestamp) && !(message.timestamp && $util.isInteger(message.timestamp.low) && $util.isInteger(message.timestamp.high)))
                    return "timestamp: integer|Long expected";
            if (message.ext != null && message.hasOwnProperty("ext"))
                if (!$util.isString(message.ext))
                    return "ext: string expected";
            return null;
        };

        /**
         * Creates a ConnectAckMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.ConnectAckMsgBody} ConnectAckMsgBody
         */
        ConnectAckMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.ConnectAckMsgBody)
                return object;
            let message = new $root.imconnect.ConnectAckMsgBody();
            if (object.code != null)
                message.code = object.code | 0;
            if (object.userId != null)
                message.userId = String(object.userId);
            if (object.session != null)
                message.session = String(object.session);
            if (object.timestamp != null)
                if ($util.Long)
                    (message.timestamp = $util.Long.fromValue(object.timestamp)).unsigned = false;
                else if (typeof object.timestamp === "string")
                    message.timestamp = parseInt(object.timestamp, 10);
                else if (typeof object.timestamp === "number")
                    message.timestamp = object.timestamp;
                else if (typeof object.timestamp === "object")
                    message.timestamp = new $util.LongBits(object.timestamp.low >>> 0, object.timestamp.high >>> 0).toNumber();
            if (object.ext != null)
                message.ext = String(object.ext);
            return message;
        };

        /**
         * Creates a plain object from a ConnectAckMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {imconnect.ConnectAckMsgBody} message ConnectAckMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        ConnectAckMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.code = 0;
                object.userId = "";
                object.session = "";
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.timestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.timestamp = options.longs === String ? "0" : 0;
                object.ext = "";
            }
            if (message.code != null && message.hasOwnProperty("code"))
                object.code = message.code;
            if (message.userId != null && message.hasOwnProperty("userId"))
                object.userId = message.userId;
            if (message.session != null && message.hasOwnProperty("session"))
                object.session = message.session;
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (typeof message.timestamp === "number")
                    object.timestamp = options.longs === String ? String(message.timestamp) : message.timestamp;
                else
                    object.timestamp = options.longs === String ? $util.Long.prototype.toString.call(message.timestamp) : options.longs === Number ? new $util.LongBits(message.timestamp.low >>> 0, message.timestamp.high >>> 0).toNumber() : message.timestamp;
            if (message.ext != null && message.hasOwnProperty("ext"))
                object.ext = message.ext;
            return object;
        };

        /**
         * Converts this ConnectAckMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.ConnectAckMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        ConnectAckMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for ConnectAckMsgBody
         * @function getTypeUrl
         * @memberof imconnect.ConnectAckMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        ConnectAckMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.ConnectAckMsgBody";
        };

        return ConnectAckMsgBody;
    })();

    imconnect.DisconnectMsgBody = (function() {

        /**
         * Properties of a DisconnectMsgBody.
         * @memberof imconnect
         * @interface IDisconnectMsgBody
         * @property {number|null} [code] DisconnectMsgBody code
         * @property {number|Long|null} [timestamp] DisconnectMsgBody timestamp
         * @property {string|null} [ext] DisconnectMsgBody ext
         */

        /**
         * Constructs a new DisconnectMsgBody.
         * @memberof imconnect
         * @classdesc Represents a DisconnectMsgBody.
         * @implements IDisconnectMsgBody
         * @constructor
         * @param {imconnect.IDisconnectMsgBody=} [properties] Properties to set
         */
        function DisconnectMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * DisconnectMsgBody code.
         * @member {number} code
         * @memberof imconnect.DisconnectMsgBody
         * @instance
         */
        DisconnectMsgBody.prototype.code = 0;

        /**
         * DisconnectMsgBody timestamp.
         * @member {number|Long} timestamp
         * @memberof imconnect.DisconnectMsgBody
         * @instance
         */
        DisconnectMsgBody.prototype.timestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * DisconnectMsgBody ext.
         * @member {string} ext
         * @memberof imconnect.DisconnectMsgBody
         * @instance
         */
        DisconnectMsgBody.prototype.ext = "";

        /**
         * Creates a new DisconnectMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {imconnect.IDisconnectMsgBody=} [properties] Properties to set
         * @returns {imconnect.DisconnectMsgBody} DisconnectMsgBody instance
         */
        DisconnectMsgBody.create = function create(properties) {
            return new DisconnectMsgBody(properties);
        };

        /**
         * Encodes the specified DisconnectMsgBody message. Does not implicitly {@link imconnect.DisconnectMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {imconnect.IDisconnectMsgBody} message DisconnectMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        DisconnectMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.code != null && Object.hasOwnProperty.call(message, "code"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.code);
            if (message.timestamp != null && Object.hasOwnProperty.call(message, "timestamp"))
                writer.uint32(/* id 2, wireType 0 =*/16).int64(message.timestamp);
            if (message.ext != null && Object.hasOwnProperty.call(message, "ext"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.ext);
            return writer;
        };

        /**
         * Encodes the specified DisconnectMsgBody message, length delimited. Does not implicitly {@link imconnect.DisconnectMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {imconnect.IDisconnectMsgBody} message DisconnectMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        DisconnectMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a DisconnectMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.DisconnectMsgBody} DisconnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        DisconnectMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.DisconnectMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.code = reader.int32();
                        break;
                    }
                case 2: {
                        message.timestamp = reader.int64();
                        break;
                    }
                case 3: {
                        message.ext = reader.string();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a DisconnectMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.DisconnectMsgBody} DisconnectMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        DisconnectMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a DisconnectMsgBody message.
         * @function verify
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        DisconnectMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.code != null && message.hasOwnProperty("code"))
                if (!$util.isInteger(message.code))
                    return "code: integer expected";
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (!$util.isInteger(message.timestamp) && !(message.timestamp && $util.isInteger(message.timestamp.low) && $util.isInteger(message.timestamp.high)))
                    return "timestamp: integer|Long expected";
            if (message.ext != null && message.hasOwnProperty("ext"))
                if (!$util.isString(message.ext))
                    return "ext: string expected";
            return null;
        };

        /**
         * Creates a DisconnectMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.DisconnectMsgBody} DisconnectMsgBody
         */
        DisconnectMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.DisconnectMsgBody)
                return object;
            let message = new $root.imconnect.DisconnectMsgBody();
            if (object.code != null)
                message.code = object.code | 0;
            if (object.timestamp != null)
                if ($util.Long)
                    (message.timestamp = $util.Long.fromValue(object.timestamp)).unsigned = false;
                else if (typeof object.timestamp === "string")
                    message.timestamp = parseInt(object.timestamp, 10);
                else if (typeof object.timestamp === "number")
                    message.timestamp = object.timestamp;
                else if (typeof object.timestamp === "object")
                    message.timestamp = new $util.LongBits(object.timestamp.low >>> 0, object.timestamp.high >>> 0).toNumber();
            if (object.ext != null)
                message.ext = String(object.ext);
            return message;
        };

        /**
         * Creates a plain object from a DisconnectMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {imconnect.DisconnectMsgBody} message DisconnectMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        DisconnectMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.code = 0;
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.timestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.timestamp = options.longs === String ? "0" : 0;
                object.ext = "";
            }
            if (message.code != null && message.hasOwnProperty("code"))
                object.code = message.code;
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (typeof message.timestamp === "number")
                    object.timestamp = options.longs === String ? String(message.timestamp) : message.timestamp;
                else
                    object.timestamp = options.longs === String ? $util.Long.prototype.toString.call(message.timestamp) : options.longs === Number ? new $util.LongBits(message.timestamp.low >>> 0, message.timestamp.high >>> 0).toNumber() : message.timestamp;
            if (message.ext != null && message.hasOwnProperty("ext"))
                object.ext = message.ext;
            return object;
        };

        /**
         * Converts this DisconnectMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.DisconnectMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        DisconnectMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for DisconnectMsgBody
         * @function getTypeUrl
         * @memberof imconnect.DisconnectMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        DisconnectMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.DisconnectMsgBody";
        };

        return DisconnectMsgBody;
    })();

    imconnect.PublishMsgBody = (function() {

        /**
         * Properties of a PublishMsgBody.
         * @memberof imconnect
         * @interface IPublishMsgBody
         * @property {number|null} [index] PublishMsgBody index
         * @property {string|null} [topic] PublishMsgBody topic
         * @property {string|null} [targetId] PublishMsgBody targetId
         * @property {number|Long|null} [timestamp] PublishMsgBody timestamp
         * @property {Uint8Array|null} [data] PublishMsgBody data
         */

        /**
         * Constructs a new PublishMsgBody.
         * @memberof imconnect
         * @classdesc Represents a PublishMsgBody.
         * @implements IPublishMsgBody
         * @constructor
         * @param {imconnect.IPublishMsgBody=} [properties] Properties to set
         */
        function PublishMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * PublishMsgBody index.
         * @member {number} index
         * @memberof imconnect.PublishMsgBody
         * @instance
         */
        PublishMsgBody.prototype.index = 0;

        /**
         * PublishMsgBody topic.
         * @member {string} topic
         * @memberof imconnect.PublishMsgBody
         * @instance
         */
        PublishMsgBody.prototype.topic = "";

        /**
         * PublishMsgBody targetId.
         * @member {string} targetId
         * @memberof imconnect.PublishMsgBody
         * @instance
         */
        PublishMsgBody.prototype.targetId = "";

        /**
         * PublishMsgBody timestamp.
         * @member {number|Long} timestamp
         * @memberof imconnect.PublishMsgBody
         * @instance
         */
        PublishMsgBody.prototype.timestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * PublishMsgBody data.
         * @member {Uint8Array} data
         * @memberof imconnect.PublishMsgBody
         * @instance
         */
        PublishMsgBody.prototype.data = $util.newBuffer([]);

        /**
         * Creates a new PublishMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {imconnect.IPublishMsgBody=} [properties] Properties to set
         * @returns {imconnect.PublishMsgBody} PublishMsgBody instance
         */
        PublishMsgBody.create = function create(properties) {
            return new PublishMsgBody(properties);
        };

        /**
         * Encodes the specified PublishMsgBody message. Does not implicitly {@link imconnect.PublishMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {imconnect.IPublishMsgBody} message PublishMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        PublishMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.index != null && Object.hasOwnProperty.call(message, "index"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.index);
            if (message.topic != null && Object.hasOwnProperty.call(message, "topic"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.topic);
            if (message.targetId != null && Object.hasOwnProperty.call(message, "targetId"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.targetId);
            if (message.timestamp != null && Object.hasOwnProperty.call(message, "timestamp"))
                writer.uint32(/* id 4, wireType 0 =*/32).int64(message.timestamp);
            if (message.data != null && Object.hasOwnProperty.call(message, "data"))
                writer.uint32(/* id 5, wireType 2 =*/42).bytes(message.data);
            return writer;
        };

        /**
         * Encodes the specified PublishMsgBody message, length delimited. Does not implicitly {@link imconnect.PublishMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {imconnect.IPublishMsgBody} message PublishMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        PublishMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a PublishMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.PublishMsgBody} PublishMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        PublishMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.PublishMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.index = reader.int32();
                        break;
                    }
                case 2: {
                        message.topic = reader.string();
                        break;
                    }
                case 3: {
                        message.targetId = reader.string();
                        break;
                    }
                case 4: {
                        message.timestamp = reader.int64();
                        break;
                    }
                case 5: {
                        message.data = reader.bytes();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a PublishMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.PublishMsgBody} PublishMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        PublishMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a PublishMsgBody message.
         * @function verify
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        PublishMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.index != null && message.hasOwnProperty("index"))
                if (!$util.isInteger(message.index))
                    return "index: integer expected";
            if (message.topic != null && message.hasOwnProperty("topic"))
                if (!$util.isString(message.topic))
                    return "topic: string expected";
            if (message.targetId != null && message.hasOwnProperty("targetId"))
                if (!$util.isString(message.targetId))
                    return "targetId: string expected";
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (!$util.isInteger(message.timestamp) && !(message.timestamp && $util.isInteger(message.timestamp.low) && $util.isInteger(message.timestamp.high)))
                    return "timestamp: integer|Long expected";
            if (message.data != null && message.hasOwnProperty("data"))
                if (!(message.data && typeof message.data.length === "number" || $util.isString(message.data)))
                    return "data: buffer expected";
            return null;
        };

        /**
         * Creates a PublishMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.PublishMsgBody} PublishMsgBody
         */
        PublishMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.PublishMsgBody)
                return object;
            let message = new $root.imconnect.PublishMsgBody();
            if (object.index != null)
                message.index = object.index | 0;
            if (object.topic != null)
                message.topic = String(object.topic);
            if (object.targetId != null)
                message.targetId = String(object.targetId);
            if (object.timestamp != null)
                if ($util.Long)
                    (message.timestamp = $util.Long.fromValue(object.timestamp)).unsigned = false;
                else if (typeof object.timestamp === "string")
                    message.timestamp = parseInt(object.timestamp, 10);
                else if (typeof object.timestamp === "number")
                    message.timestamp = object.timestamp;
                else if (typeof object.timestamp === "object")
                    message.timestamp = new $util.LongBits(object.timestamp.low >>> 0, object.timestamp.high >>> 0).toNumber();
            if (object.data != null)
                if (typeof object.data === "string")
                    $util.base64.decode(object.data, message.data = $util.newBuffer($util.base64.length(object.data)), 0);
                else if (object.data.length >= 0)
                    message.data = object.data;
            return message;
        };

        /**
         * Creates a plain object from a PublishMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {imconnect.PublishMsgBody} message PublishMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        PublishMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.index = 0;
                object.topic = "";
                object.targetId = "";
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.timestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.timestamp = options.longs === String ? "0" : 0;
                if (options.bytes === String)
                    object.data = "";
                else {
                    object.data = [];
                    if (options.bytes !== Array)
                        object.data = $util.newBuffer(object.data);
                }
            }
            if (message.index != null && message.hasOwnProperty("index"))
                object.index = message.index;
            if (message.topic != null && message.hasOwnProperty("topic"))
                object.topic = message.topic;
            if (message.targetId != null && message.hasOwnProperty("targetId"))
                object.targetId = message.targetId;
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (typeof message.timestamp === "number")
                    object.timestamp = options.longs === String ? String(message.timestamp) : message.timestamp;
                else
                    object.timestamp = options.longs === String ? $util.Long.prototype.toString.call(message.timestamp) : options.longs === Number ? new $util.LongBits(message.timestamp.low >>> 0, message.timestamp.high >>> 0).toNumber() : message.timestamp;
            if (message.data != null && message.hasOwnProperty("data"))
                object.data = options.bytes === String ? $util.base64.encode(message.data, 0, message.data.length) : options.bytes === Array ? Array.prototype.slice.call(message.data) : message.data;
            return object;
        };

        /**
         * Converts this PublishMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.PublishMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        PublishMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for PublishMsgBody
         * @function getTypeUrl
         * @memberof imconnect.PublishMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        PublishMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.PublishMsgBody";
        };

        return PublishMsgBody;
    })();

    imconnect.PublishAckMsgBody = (function() {

        /**
         * Properties of a PublishAckMsgBody.
         * @memberof imconnect
         * @interface IPublishAckMsgBody
         * @property {number|null} [index] PublishAckMsgBody index
         * @property {number|null} [code] PublishAckMsgBody code
         * @property {string|null} [msgId] PublishAckMsgBody msgId
         * @property {number|Long|null} [timestamp] PublishAckMsgBody timestamp
         * @property {number|Long|null} [msgSeqNo] PublishAckMsgBody msgSeqNo
         * @property {number|null} [memberCount] PublishAckMsgBody memberCount
         * @property {string|null} [clientMsgId] PublishAckMsgBody clientMsgId
         * @property {imconnect.ISimplifiedDownMsg|null} [modifiedMsg] PublishAckMsgBody modifiedMsg
         */

        /**
         * Constructs a new PublishAckMsgBody.
         * @memberof imconnect
         * @classdesc Represents a PublishAckMsgBody.
         * @implements IPublishAckMsgBody
         * @constructor
         * @param {imconnect.IPublishAckMsgBody=} [properties] Properties to set
         */
        function PublishAckMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * PublishAckMsgBody index.
         * @member {number} index
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.index = 0;

        /**
         * PublishAckMsgBody code.
         * @member {number} code
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.code = 0;

        /**
         * PublishAckMsgBody msgId.
         * @member {string} msgId
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.msgId = "";

        /**
         * PublishAckMsgBody timestamp.
         * @member {number|Long} timestamp
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.timestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * PublishAckMsgBody msgSeqNo.
         * @member {number|Long} msgSeqNo
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.msgSeqNo = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * PublishAckMsgBody memberCount.
         * @member {number} memberCount
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.memberCount = 0;

        /**
         * PublishAckMsgBody clientMsgId.
         * @member {string} clientMsgId
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.clientMsgId = "";

        /**
         * PublishAckMsgBody modifiedMsg.
         * @member {imconnect.ISimplifiedDownMsg|null|undefined} modifiedMsg
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         */
        PublishAckMsgBody.prototype.modifiedMsg = null;

        /**
         * Creates a new PublishAckMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {imconnect.IPublishAckMsgBody=} [properties] Properties to set
         * @returns {imconnect.PublishAckMsgBody} PublishAckMsgBody instance
         */
        PublishAckMsgBody.create = function create(properties) {
            return new PublishAckMsgBody(properties);
        };

        /**
         * Encodes the specified PublishAckMsgBody message. Does not implicitly {@link imconnect.PublishAckMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {imconnect.IPublishAckMsgBody} message PublishAckMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        PublishAckMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.index != null && Object.hasOwnProperty.call(message, "index"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.index);
            if (message.code != null && Object.hasOwnProperty.call(message, "code"))
                writer.uint32(/* id 2, wireType 0 =*/16).int32(message.code);
            if (message.msgId != null && Object.hasOwnProperty.call(message, "msgId"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.msgId);
            if (message.timestamp != null && Object.hasOwnProperty.call(message, "timestamp"))
                writer.uint32(/* id 4, wireType 0 =*/32).int64(message.timestamp);
            if (message.msgSeqNo != null && Object.hasOwnProperty.call(message, "msgSeqNo"))
                writer.uint32(/* id 5, wireType 0 =*/40).int64(message.msgSeqNo);
            if (message.memberCount != null && Object.hasOwnProperty.call(message, "memberCount"))
                writer.uint32(/* id 6, wireType 0 =*/48).int32(message.memberCount);
            if (message.clientMsgId != null && Object.hasOwnProperty.call(message, "clientMsgId"))
                writer.uint32(/* id 7, wireType 2 =*/58).string(message.clientMsgId);
            if (message.modifiedMsg != null && Object.hasOwnProperty.call(message, "modifiedMsg"))
                $root.imconnect.SimplifiedDownMsg.encode(message.modifiedMsg, writer.uint32(/* id 8, wireType 2 =*/66).fork()).ldelim();
            return writer;
        };

        /**
         * Encodes the specified PublishAckMsgBody message, length delimited. Does not implicitly {@link imconnect.PublishAckMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {imconnect.IPublishAckMsgBody} message PublishAckMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        PublishAckMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a PublishAckMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.PublishAckMsgBody} PublishAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        PublishAckMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.PublishAckMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.index = reader.int32();
                        break;
                    }
                case 2: {
                        message.code = reader.int32();
                        break;
                    }
                case 3: {
                        message.msgId = reader.string();
                        break;
                    }
                case 4: {
                        message.timestamp = reader.int64();
                        break;
                    }
                case 5: {
                        message.msgSeqNo = reader.int64();
                        break;
                    }
                case 6: {
                        message.memberCount = reader.int32();
                        break;
                    }
                case 7: {
                        message.clientMsgId = reader.string();
                        break;
                    }
                case 8: {
                        message.modifiedMsg = $root.imconnect.SimplifiedDownMsg.decode(reader, reader.uint32());
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a PublishAckMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.PublishAckMsgBody} PublishAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        PublishAckMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a PublishAckMsgBody message.
         * @function verify
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        PublishAckMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.index != null && message.hasOwnProperty("index"))
                if (!$util.isInteger(message.index))
                    return "index: integer expected";
            if (message.code != null && message.hasOwnProperty("code"))
                if (!$util.isInteger(message.code))
                    return "code: integer expected";
            if (message.msgId != null && message.hasOwnProperty("msgId"))
                if (!$util.isString(message.msgId))
                    return "msgId: string expected";
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (!$util.isInteger(message.timestamp) && !(message.timestamp && $util.isInteger(message.timestamp.low) && $util.isInteger(message.timestamp.high)))
                    return "timestamp: integer|Long expected";
            if (message.msgSeqNo != null && message.hasOwnProperty("msgSeqNo"))
                if (!$util.isInteger(message.msgSeqNo) && !(message.msgSeqNo && $util.isInteger(message.msgSeqNo.low) && $util.isInteger(message.msgSeqNo.high)))
                    return "msgSeqNo: integer|Long expected";
            if (message.memberCount != null && message.hasOwnProperty("memberCount"))
                if (!$util.isInteger(message.memberCount))
                    return "memberCount: integer expected";
            if (message.clientMsgId != null && message.hasOwnProperty("clientMsgId"))
                if (!$util.isString(message.clientMsgId))
                    return "clientMsgId: string expected";
            if (message.modifiedMsg != null && message.hasOwnProperty("modifiedMsg")) {
                let error = $root.imconnect.SimplifiedDownMsg.verify(message.modifiedMsg);
                if (error)
                    return "modifiedMsg." + error;
            }
            return null;
        };

        /**
         * Creates a PublishAckMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.PublishAckMsgBody} PublishAckMsgBody
         */
        PublishAckMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.PublishAckMsgBody)
                return object;
            let message = new $root.imconnect.PublishAckMsgBody();
            if (object.index != null)
                message.index = object.index | 0;
            if (object.code != null)
                message.code = object.code | 0;
            if (object.msgId != null)
                message.msgId = String(object.msgId);
            if (object.timestamp != null)
                if ($util.Long)
                    (message.timestamp = $util.Long.fromValue(object.timestamp)).unsigned = false;
                else if (typeof object.timestamp === "string")
                    message.timestamp = parseInt(object.timestamp, 10);
                else if (typeof object.timestamp === "number")
                    message.timestamp = object.timestamp;
                else if (typeof object.timestamp === "object")
                    message.timestamp = new $util.LongBits(object.timestamp.low >>> 0, object.timestamp.high >>> 0).toNumber();
            if (object.msgSeqNo != null)
                if ($util.Long)
                    (message.msgSeqNo = $util.Long.fromValue(object.msgSeqNo)).unsigned = false;
                else if (typeof object.msgSeqNo === "string")
                    message.msgSeqNo = parseInt(object.msgSeqNo, 10);
                else if (typeof object.msgSeqNo === "number")
                    message.msgSeqNo = object.msgSeqNo;
                else if (typeof object.msgSeqNo === "object")
                    message.msgSeqNo = new $util.LongBits(object.msgSeqNo.low >>> 0, object.msgSeqNo.high >>> 0).toNumber();
            if (object.memberCount != null)
                message.memberCount = object.memberCount | 0;
            if (object.clientMsgId != null)
                message.clientMsgId = String(object.clientMsgId);
            if (object.modifiedMsg != null) {
                if (typeof object.modifiedMsg !== "object")
                    throw TypeError(".imconnect.PublishAckMsgBody.modifiedMsg: object expected");
                message.modifiedMsg = $root.imconnect.SimplifiedDownMsg.fromObject(object.modifiedMsg);
            }
            return message;
        };

        /**
         * Creates a plain object from a PublishAckMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {imconnect.PublishAckMsgBody} message PublishAckMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        PublishAckMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.index = 0;
                object.code = 0;
                object.msgId = "";
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.timestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.timestamp = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.msgSeqNo = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.msgSeqNo = options.longs === String ? "0" : 0;
                object.memberCount = 0;
                object.clientMsgId = "";
                object.modifiedMsg = null;
            }
            if (message.index != null && message.hasOwnProperty("index"))
                object.index = message.index;
            if (message.code != null && message.hasOwnProperty("code"))
                object.code = message.code;
            if (message.msgId != null && message.hasOwnProperty("msgId"))
                object.msgId = message.msgId;
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (typeof message.timestamp === "number")
                    object.timestamp = options.longs === String ? String(message.timestamp) : message.timestamp;
                else
                    object.timestamp = options.longs === String ? $util.Long.prototype.toString.call(message.timestamp) : options.longs === Number ? new $util.LongBits(message.timestamp.low >>> 0, message.timestamp.high >>> 0).toNumber() : message.timestamp;
            if (message.msgSeqNo != null && message.hasOwnProperty("msgSeqNo"))
                if (typeof message.msgSeqNo === "number")
                    object.msgSeqNo = options.longs === String ? String(message.msgSeqNo) : message.msgSeqNo;
                else
                    object.msgSeqNo = options.longs === String ? $util.Long.prototype.toString.call(message.msgSeqNo) : options.longs === Number ? new $util.LongBits(message.msgSeqNo.low >>> 0, message.msgSeqNo.high >>> 0).toNumber() : message.msgSeqNo;
            if (message.memberCount != null && message.hasOwnProperty("memberCount"))
                object.memberCount = message.memberCount;
            if (message.clientMsgId != null && message.hasOwnProperty("clientMsgId"))
                object.clientMsgId = message.clientMsgId;
            if (message.modifiedMsg != null && message.hasOwnProperty("modifiedMsg"))
                object.modifiedMsg = $root.imconnect.SimplifiedDownMsg.toObject(message.modifiedMsg, options);
            return object;
        };

        /**
         * Converts this PublishAckMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.PublishAckMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        PublishAckMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for PublishAckMsgBody
         * @function getTypeUrl
         * @memberof imconnect.PublishAckMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        PublishAckMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.PublishAckMsgBody";
        };

        return PublishAckMsgBody;
    })();

    imconnect.SimplifiedDownMsg = (function() {

        /**
         * Properties of a SimplifiedDownMsg.
         * @memberof imconnect
         * @interface ISimplifiedDownMsg
         * @property {string|null} [msgType] SimplifiedDownMsg msgType
         * @property {Uint8Array|null} [msgContent] SimplifiedDownMsg msgContent
         */

        /**
         * Constructs a new SimplifiedDownMsg.
         * @memberof imconnect
         * @classdesc Represents a SimplifiedDownMsg.
         * @implements ISimplifiedDownMsg
         * @constructor
         * @param {imconnect.ISimplifiedDownMsg=} [properties] Properties to set
         */
        function SimplifiedDownMsg(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * SimplifiedDownMsg msgType.
         * @member {string} msgType
         * @memberof imconnect.SimplifiedDownMsg
         * @instance
         */
        SimplifiedDownMsg.prototype.msgType = "";

        /**
         * SimplifiedDownMsg msgContent.
         * @member {Uint8Array} msgContent
         * @memberof imconnect.SimplifiedDownMsg
         * @instance
         */
        SimplifiedDownMsg.prototype.msgContent = $util.newBuffer([]);

        /**
         * Creates a new SimplifiedDownMsg instance using the specified properties.
         * @function create
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {imconnect.ISimplifiedDownMsg=} [properties] Properties to set
         * @returns {imconnect.SimplifiedDownMsg} SimplifiedDownMsg instance
         */
        SimplifiedDownMsg.create = function create(properties) {
            return new SimplifiedDownMsg(properties);
        };

        /**
         * Encodes the specified SimplifiedDownMsg message. Does not implicitly {@link imconnect.SimplifiedDownMsg.verify|verify} messages.
         * @function encode
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {imconnect.ISimplifiedDownMsg} message SimplifiedDownMsg message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        SimplifiedDownMsg.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.msgType != null && Object.hasOwnProperty.call(message, "msgType"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.msgType);
            if (message.msgContent != null && Object.hasOwnProperty.call(message, "msgContent"))
                writer.uint32(/* id 7, wireType 2 =*/58).bytes(message.msgContent);
            return writer;
        };

        /**
         * Encodes the specified SimplifiedDownMsg message, length delimited. Does not implicitly {@link imconnect.SimplifiedDownMsg.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {imconnect.ISimplifiedDownMsg} message SimplifiedDownMsg message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        SimplifiedDownMsg.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a SimplifiedDownMsg message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.SimplifiedDownMsg} SimplifiedDownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        SimplifiedDownMsg.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.SimplifiedDownMsg();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 3: {
                        message.msgType = reader.string();
                        break;
                    }
                case 7: {
                        message.msgContent = reader.bytes();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a SimplifiedDownMsg message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.SimplifiedDownMsg} SimplifiedDownMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        SimplifiedDownMsg.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a SimplifiedDownMsg message.
         * @function verify
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        SimplifiedDownMsg.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.msgType != null && message.hasOwnProperty("msgType"))
                if (!$util.isString(message.msgType))
                    return "msgType: string expected";
            if (message.msgContent != null && message.hasOwnProperty("msgContent"))
                if (!(message.msgContent && typeof message.msgContent.length === "number" || $util.isString(message.msgContent)))
                    return "msgContent: buffer expected";
            return null;
        };

        /**
         * Creates a SimplifiedDownMsg message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.SimplifiedDownMsg} SimplifiedDownMsg
         */
        SimplifiedDownMsg.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.SimplifiedDownMsg)
                return object;
            let message = new $root.imconnect.SimplifiedDownMsg();
            if (object.msgType != null)
                message.msgType = String(object.msgType);
            if (object.msgContent != null)
                if (typeof object.msgContent === "string")
                    $util.base64.decode(object.msgContent, message.msgContent = $util.newBuffer($util.base64.length(object.msgContent)), 0);
                else if (object.msgContent.length >= 0)
                    message.msgContent = object.msgContent;
            return message;
        };

        /**
         * Creates a plain object from a SimplifiedDownMsg message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {imconnect.SimplifiedDownMsg} message SimplifiedDownMsg
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        SimplifiedDownMsg.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.msgType = "";
                if (options.bytes === String)
                    object.msgContent = "";
                else {
                    object.msgContent = [];
                    if (options.bytes !== Array)
                        object.msgContent = $util.newBuffer(object.msgContent);
                }
            }
            if (message.msgType != null && message.hasOwnProperty("msgType"))
                object.msgType = message.msgType;
            if (message.msgContent != null && message.hasOwnProperty("msgContent"))
                object.msgContent = options.bytes === String ? $util.base64.encode(message.msgContent, 0, message.msgContent.length) : options.bytes === Array ? Array.prototype.slice.call(message.msgContent) : message.msgContent;
            return object;
        };

        /**
         * Converts this SimplifiedDownMsg to JSON.
         * @function toJSON
         * @memberof imconnect.SimplifiedDownMsg
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        SimplifiedDownMsg.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for SimplifiedDownMsg
         * @function getTypeUrl
         * @memberof imconnect.SimplifiedDownMsg
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        SimplifiedDownMsg.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.SimplifiedDownMsg";
        };

        return SimplifiedDownMsg;
    })();

    imconnect.QueryMsgBody = (function() {

        /**
         * Properties of a QueryMsgBody.
         * @memberof imconnect
         * @interface IQueryMsgBody
         * @property {number|null} [index] QueryMsgBody index
         * @property {string|null} [topic] QueryMsgBody topic
         * @property {string|null} [targetId] QueryMsgBody targetId
         * @property {number|Long|null} [timestamp] QueryMsgBody timestamp
         * @property {Uint8Array|null} [data] QueryMsgBody data
         */

        /**
         * Constructs a new QueryMsgBody.
         * @memberof imconnect
         * @classdesc Represents a QueryMsgBody.
         * @implements IQueryMsgBody
         * @constructor
         * @param {imconnect.IQueryMsgBody=} [properties] Properties to set
         */
        function QueryMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * QueryMsgBody index.
         * @member {number} index
         * @memberof imconnect.QueryMsgBody
         * @instance
         */
        QueryMsgBody.prototype.index = 0;

        /**
         * QueryMsgBody topic.
         * @member {string} topic
         * @memberof imconnect.QueryMsgBody
         * @instance
         */
        QueryMsgBody.prototype.topic = "";

        /**
         * QueryMsgBody targetId.
         * @member {string} targetId
         * @memberof imconnect.QueryMsgBody
         * @instance
         */
        QueryMsgBody.prototype.targetId = "";

        /**
         * QueryMsgBody timestamp.
         * @member {number|Long} timestamp
         * @memberof imconnect.QueryMsgBody
         * @instance
         */
        QueryMsgBody.prototype.timestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * QueryMsgBody data.
         * @member {Uint8Array} data
         * @memberof imconnect.QueryMsgBody
         * @instance
         */
        QueryMsgBody.prototype.data = $util.newBuffer([]);

        /**
         * Creates a new QueryMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {imconnect.IQueryMsgBody=} [properties] Properties to set
         * @returns {imconnect.QueryMsgBody} QueryMsgBody instance
         */
        QueryMsgBody.create = function create(properties) {
            return new QueryMsgBody(properties);
        };

        /**
         * Encodes the specified QueryMsgBody message. Does not implicitly {@link imconnect.QueryMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {imconnect.IQueryMsgBody} message QueryMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        QueryMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.index != null && Object.hasOwnProperty.call(message, "index"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.index);
            if (message.topic != null && Object.hasOwnProperty.call(message, "topic"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.topic);
            if (message.targetId != null && Object.hasOwnProperty.call(message, "targetId"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.targetId);
            if (message.timestamp != null && Object.hasOwnProperty.call(message, "timestamp"))
                writer.uint32(/* id 4, wireType 0 =*/32).int64(message.timestamp);
            if (message.data != null && Object.hasOwnProperty.call(message, "data"))
                writer.uint32(/* id 5, wireType 2 =*/42).bytes(message.data);
            return writer;
        };

        /**
         * Encodes the specified QueryMsgBody message, length delimited. Does not implicitly {@link imconnect.QueryMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {imconnect.IQueryMsgBody} message QueryMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        QueryMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a QueryMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.QueryMsgBody} QueryMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        QueryMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.QueryMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.index = reader.int32();
                        break;
                    }
                case 2: {
                        message.topic = reader.string();
                        break;
                    }
                case 3: {
                        message.targetId = reader.string();
                        break;
                    }
                case 4: {
                        message.timestamp = reader.int64();
                        break;
                    }
                case 5: {
                        message.data = reader.bytes();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a QueryMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.QueryMsgBody} QueryMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        QueryMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a QueryMsgBody message.
         * @function verify
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        QueryMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.index != null && message.hasOwnProperty("index"))
                if (!$util.isInteger(message.index))
                    return "index: integer expected";
            if (message.topic != null && message.hasOwnProperty("topic"))
                if (!$util.isString(message.topic))
                    return "topic: string expected";
            if (message.targetId != null && message.hasOwnProperty("targetId"))
                if (!$util.isString(message.targetId))
                    return "targetId: string expected";
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (!$util.isInteger(message.timestamp) && !(message.timestamp && $util.isInteger(message.timestamp.low) && $util.isInteger(message.timestamp.high)))
                    return "timestamp: integer|Long expected";
            if (message.data != null && message.hasOwnProperty("data"))
                if (!(message.data && typeof message.data.length === "number" || $util.isString(message.data)))
                    return "data: buffer expected";
            return null;
        };

        /**
         * Creates a QueryMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.QueryMsgBody} QueryMsgBody
         */
        QueryMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.QueryMsgBody)
                return object;
            let message = new $root.imconnect.QueryMsgBody();
            if (object.index != null)
                message.index = object.index | 0;
            if (object.topic != null)
                message.topic = String(object.topic);
            if (object.targetId != null)
                message.targetId = String(object.targetId);
            if (object.timestamp != null)
                if ($util.Long)
                    (message.timestamp = $util.Long.fromValue(object.timestamp)).unsigned = false;
                else if (typeof object.timestamp === "string")
                    message.timestamp = parseInt(object.timestamp, 10);
                else if (typeof object.timestamp === "number")
                    message.timestamp = object.timestamp;
                else if (typeof object.timestamp === "object")
                    message.timestamp = new $util.LongBits(object.timestamp.low >>> 0, object.timestamp.high >>> 0).toNumber();
            if (object.data != null)
                if (typeof object.data === "string")
                    $util.base64.decode(object.data, message.data = $util.newBuffer($util.base64.length(object.data)), 0);
                else if (object.data.length >= 0)
                    message.data = object.data;
            return message;
        };

        /**
         * Creates a plain object from a QueryMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {imconnect.QueryMsgBody} message QueryMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        QueryMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.index = 0;
                object.topic = "";
                object.targetId = "";
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.timestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.timestamp = options.longs === String ? "0" : 0;
                if (options.bytes === String)
                    object.data = "";
                else {
                    object.data = [];
                    if (options.bytes !== Array)
                        object.data = $util.newBuffer(object.data);
                }
            }
            if (message.index != null && message.hasOwnProperty("index"))
                object.index = message.index;
            if (message.topic != null && message.hasOwnProperty("topic"))
                object.topic = message.topic;
            if (message.targetId != null && message.hasOwnProperty("targetId"))
                object.targetId = message.targetId;
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (typeof message.timestamp === "number")
                    object.timestamp = options.longs === String ? String(message.timestamp) : message.timestamp;
                else
                    object.timestamp = options.longs === String ? $util.Long.prototype.toString.call(message.timestamp) : options.longs === Number ? new $util.LongBits(message.timestamp.low >>> 0, message.timestamp.high >>> 0).toNumber() : message.timestamp;
            if (message.data != null && message.hasOwnProperty("data"))
                object.data = options.bytes === String ? $util.base64.encode(message.data, 0, message.data.length) : options.bytes === Array ? Array.prototype.slice.call(message.data) : message.data;
            return object;
        };

        /**
         * Converts this QueryMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.QueryMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        QueryMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for QueryMsgBody
         * @function getTypeUrl
         * @memberof imconnect.QueryMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        QueryMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.QueryMsgBody";
        };

        return QueryMsgBody;
    })();

    imconnect.QueryAckMsgBody = (function() {

        /**
         * Properties of a QueryAckMsgBody.
         * @memberof imconnect
         * @interface IQueryAckMsgBody
         * @property {number|null} [index] QueryAckMsgBody index
         * @property {number|null} [code] QueryAckMsgBody code
         * @property {number|Long|null} [timestamp] QueryAckMsgBody timestamp
         * @property {Uint8Array|null} [data] QueryAckMsgBody data
         */

        /**
         * Constructs a new QueryAckMsgBody.
         * @memberof imconnect
         * @classdesc Represents a QueryAckMsgBody.
         * @implements IQueryAckMsgBody
         * @constructor
         * @param {imconnect.IQueryAckMsgBody=} [properties] Properties to set
         */
        function QueryAckMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * QueryAckMsgBody index.
         * @member {number} index
         * @memberof imconnect.QueryAckMsgBody
         * @instance
         */
        QueryAckMsgBody.prototype.index = 0;

        /**
         * QueryAckMsgBody code.
         * @member {number} code
         * @memberof imconnect.QueryAckMsgBody
         * @instance
         */
        QueryAckMsgBody.prototype.code = 0;

        /**
         * QueryAckMsgBody timestamp.
         * @member {number|Long} timestamp
         * @memberof imconnect.QueryAckMsgBody
         * @instance
         */
        QueryAckMsgBody.prototype.timestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * QueryAckMsgBody data.
         * @member {Uint8Array} data
         * @memberof imconnect.QueryAckMsgBody
         * @instance
         */
        QueryAckMsgBody.prototype.data = $util.newBuffer([]);

        /**
         * Creates a new QueryAckMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {imconnect.IQueryAckMsgBody=} [properties] Properties to set
         * @returns {imconnect.QueryAckMsgBody} QueryAckMsgBody instance
         */
        QueryAckMsgBody.create = function create(properties) {
            return new QueryAckMsgBody(properties);
        };

        /**
         * Encodes the specified QueryAckMsgBody message. Does not implicitly {@link imconnect.QueryAckMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {imconnect.IQueryAckMsgBody} message QueryAckMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        QueryAckMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.index != null && Object.hasOwnProperty.call(message, "index"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.index);
            if (message.code != null && Object.hasOwnProperty.call(message, "code"))
                writer.uint32(/* id 2, wireType 0 =*/16).int32(message.code);
            if (message.timestamp != null && Object.hasOwnProperty.call(message, "timestamp"))
                writer.uint32(/* id 3, wireType 0 =*/24).int64(message.timestamp);
            if (message.data != null && Object.hasOwnProperty.call(message, "data"))
                writer.uint32(/* id 4, wireType 2 =*/34).bytes(message.data);
            return writer;
        };

        /**
         * Encodes the specified QueryAckMsgBody message, length delimited. Does not implicitly {@link imconnect.QueryAckMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {imconnect.IQueryAckMsgBody} message QueryAckMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        QueryAckMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a QueryAckMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.QueryAckMsgBody} QueryAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        QueryAckMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.QueryAckMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.index = reader.int32();
                        break;
                    }
                case 2: {
                        message.code = reader.int32();
                        break;
                    }
                case 3: {
                        message.timestamp = reader.int64();
                        break;
                    }
                case 4: {
                        message.data = reader.bytes();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a QueryAckMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.QueryAckMsgBody} QueryAckMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        QueryAckMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a QueryAckMsgBody message.
         * @function verify
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        QueryAckMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.index != null && message.hasOwnProperty("index"))
                if (!$util.isInteger(message.index))
                    return "index: integer expected";
            if (message.code != null && message.hasOwnProperty("code"))
                if (!$util.isInteger(message.code))
                    return "code: integer expected";
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (!$util.isInteger(message.timestamp) && !(message.timestamp && $util.isInteger(message.timestamp.low) && $util.isInteger(message.timestamp.high)))
                    return "timestamp: integer|Long expected";
            if (message.data != null && message.hasOwnProperty("data"))
                if (!(message.data && typeof message.data.length === "number" || $util.isString(message.data)))
                    return "data: buffer expected";
            return null;
        };

        /**
         * Creates a QueryAckMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.QueryAckMsgBody} QueryAckMsgBody
         */
        QueryAckMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.QueryAckMsgBody)
                return object;
            let message = new $root.imconnect.QueryAckMsgBody();
            if (object.index != null)
                message.index = object.index | 0;
            if (object.code != null)
                message.code = object.code | 0;
            if (object.timestamp != null)
                if ($util.Long)
                    (message.timestamp = $util.Long.fromValue(object.timestamp)).unsigned = false;
                else if (typeof object.timestamp === "string")
                    message.timestamp = parseInt(object.timestamp, 10);
                else if (typeof object.timestamp === "number")
                    message.timestamp = object.timestamp;
                else if (typeof object.timestamp === "object")
                    message.timestamp = new $util.LongBits(object.timestamp.low >>> 0, object.timestamp.high >>> 0).toNumber();
            if (object.data != null)
                if (typeof object.data === "string")
                    $util.base64.decode(object.data, message.data = $util.newBuffer($util.base64.length(object.data)), 0);
                else if (object.data.length >= 0)
                    message.data = object.data;
            return message;
        };

        /**
         * Creates a plain object from a QueryAckMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {imconnect.QueryAckMsgBody} message QueryAckMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        QueryAckMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.index = 0;
                object.code = 0;
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.timestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.timestamp = options.longs === String ? "0" : 0;
                if (options.bytes === String)
                    object.data = "";
                else {
                    object.data = [];
                    if (options.bytes !== Array)
                        object.data = $util.newBuffer(object.data);
                }
            }
            if (message.index != null && message.hasOwnProperty("index"))
                object.index = message.index;
            if (message.code != null && message.hasOwnProperty("code"))
                object.code = message.code;
            if (message.timestamp != null && message.hasOwnProperty("timestamp"))
                if (typeof message.timestamp === "number")
                    object.timestamp = options.longs === String ? String(message.timestamp) : message.timestamp;
                else
                    object.timestamp = options.longs === String ? $util.Long.prototype.toString.call(message.timestamp) : options.longs === Number ? new $util.LongBits(message.timestamp.low >>> 0, message.timestamp.high >>> 0).toNumber() : message.timestamp;
            if (message.data != null && message.hasOwnProperty("data"))
                object.data = options.bytes === String ? $util.base64.encode(message.data, 0, message.data.length) : options.bytes === Array ? Array.prototype.slice.call(message.data) : message.data;
            return object;
        };

        /**
         * Converts this QueryAckMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.QueryAckMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        QueryAckMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for QueryAckMsgBody
         * @function getTypeUrl
         * @memberof imconnect.QueryAckMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        QueryAckMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.QueryAckMsgBody";
        };

        return QueryAckMsgBody;
    })();

    imconnect.QueryConfirmMsgBody = (function() {

        /**
         * Properties of a QueryConfirmMsgBody.
         * @memberof imconnect
         * @interface IQueryConfirmMsgBody
         * @property {number|null} [index] QueryConfirmMsgBody index
         */

        /**
         * Constructs a new QueryConfirmMsgBody.
         * @memberof imconnect
         * @classdesc Represents a QueryConfirmMsgBody.
         * @implements IQueryConfirmMsgBody
         * @constructor
         * @param {imconnect.IQueryConfirmMsgBody=} [properties] Properties to set
         */
        function QueryConfirmMsgBody(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * QueryConfirmMsgBody index.
         * @member {number} index
         * @memberof imconnect.QueryConfirmMsgBody
         * @instance
         */
        QueryConfirmMsgBody.prototype.index = 0;

        /**
         * Creates a new QueryConfirmMsgBody instance using the specified properties.
         * @function create
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {imconnect.IQueryConfirmMsgBody=} [properties] Properties to set
         * @returns {imconnect.QueryConfirmMsgBody} QueryConfirmMsgBody instance
         */
        QueryConfirmMsgBody.create = function create(properties) {
            return new QueryConfirmMsgBody(properties);
        };

        /**
         * Encodes the specified QueryConfirmMsgBody message. Does not implicitly {@link imconnect.QueryConfirmMsgBody.verify|verify} messages.
         * @function encode
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {imconnect.IQueryConfirmMsgBody} message QueryConfirmMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        QueryConfirmMsgBody.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.index != null && Object.hasOwnProperty.call(message, "index"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.index);
            return writer;
        };

        /**
         * Encodes the specified QueryConfirmMsgBody message, length delimited. Does not implicitly {@link imconnect.QueryConfirmMsgBody.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {imconnect.IQueryConfirmMsgBody} message QueryConfirmMsgBody message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        QueryConfirmMsgBody.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a QueryConfirmMsgBody message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.QueryConfirmMsgBody} QueryConfirmMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        QueryConfirmMsgBody.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.QueryConfirmMsgBody();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.index = reader.int32();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a QueryConfirmMsgBody message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.QueryConfirmMsgBody} QueryConfirmMsgBody
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        QueryConfirmMsgBody.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a QueryConfirmMsgBody message.
         * @function verify
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        QueryConfirmMsgBody.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.index != null && message.hasOwnProperty("index"))
                if (!$util.isInteger(message.index))
                    return "index: integer expected";
            return null;
        };

        /**
         * Creates a QueryConfirmMsgBody message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.QueryConfirmMsgBody} QueryConfirmMsgBody
         */
        QueryConfirmMsgBody.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.QueryConfirmMsgBody)
                return object;
            let message = new $root.imconnect.QueryConfirmMsgBody();
            if (object.index != null)
                message.index = object.index | 0;
            return message;
        };

        /**
         * Creates a plain object from a QueryConfirmMsgBody message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {imconnect.QueryConfirmMsgBody} message QueryConfirmMsgBody
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        QueryConfirmMsgBody.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults)
                object.index = 0;
            if (message.index != null && message.hasOwnProperty("index"))
                object.index = message.index;
            return object;
        };

        /**
         * Converts this QueryConfirmMsgBody to JSON.
         * @function toJSON
         * @memberof imconnect.QueryConfirmMsgBody
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        QueryConfirmMsgBody.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for QueryConfirmMsgBody
         * @function getTypeUrl
         * @memberof imconnect.QueryConfirmMsgBody
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        QueryConfirmMsgBody.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.QueryConfirmMsgBody";
        };

        return QueryConfirmMsgBody;
    })();

    imconnect.ImWebsocketMsg = (function() {

        /**
         * Properties of an ImWebsocketMsg.
         * @memberof imconnect
         * @interface IImWebsocketMsg
         * @property {number|null} [version] ImWebsocketMsg version
         * @property {number|null} [cmd] ImWebsocketMsg cmd
         * @property {number|null} [qos] ImWebsocketMsg qos
         * @property {Uint8Array|null} [payload] ImWebsocketMsg payload
         * @property {imconnect.IConnectMsgBody|null} [connectMsgBody] ImWebsocketMsg connectMsgBody
         * @property {imconnect.IConnectAckMsgBody|null} [ConnectAckMsgBody] ImWebsocketMsg ConnectAckMsgBody
         * @property {imconnect.IDisconnectMsgBody|null} [disconnectMsgBody] ImWebsocketMsg disconnectMsgBody
         * @property {imconnect.IPublishMsgBody|null} [publishMsgBody] ImWebsocketMsg publishMsgBody
         * @property {imconnect.IPublishAckMsgBody|null} [pubAckMsgBody] ImWebsocketMsg pubAckMsgBody
         * @property {imconnect.IQueryMsgBody|null} [qryMsgBody] ImWebsocketMsg qryMsgBody
         * @property {imconnect.IQueryAckMsgBody|null} [qryAckMsgBody] ImWebsocketMsg qryAckMsgBody
         * @property {imconnect.IQueryConfirmMsgBody|null} [qryConfirmMsgBody] ImWebsocketMsg qryConfirmMsgBody
         */

        /**
         * Constructs a new ImWebsocketMsg.
         * @memberof imconnect
         * @classdesc Represents an ImWebsocketMsg.
         * @implements IImWebsocketMsg
         * @constructor
         * @param {imconnect.IImWebsocketMsg=} [properties] Properties to set
         */
        function ImWebsocketMsg(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * ImWebsocketMsg version.
         * @member {number} version
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.version = 0;

        /**
         * ImWebsocketMsg cmd.
         * @member {number} cmd
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.cmd = 0;

        /**
         * ImWebsocketMsg qos.
         * @member {number} qos
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.qos = 0;

        /**
         * ImWebsocketMsg payload.
         * @member {Uint8Array} payload
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.payload = $util.newBuffer([]);

        /**
         * ImWebsocketMsg connectMsgBody.
         * @member {imconnect.IConnectMsgBody|null|undefined} connectMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.connectMsgBody = null;

        /**
         * ImWebsocketMsg ConnectAckMsgBody.
         * @member {imconnect.IConnectAckMsgBody|null|undefined} ConnectAckMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.ConnectAckMsgBody = null;

        /**
         * ImWebsocketMsg disconnectMsgBody.
         * @member {imconnect.IDisconnectMsgBody|null|undefined} disconnectMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.disconnectMsgBody = null;

        /**
         * ImWebsocketMsg publishMsgBody.
         * @member {imconnect.IPublishMsgBody|null|undefined} publishMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.publishMsgBody = null;

        /**
         * ImWebsocketMsg pubAckMsgBody.
         * @member {imconnect.IPublishAckMsgBody|null|undefined} pubAckMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.pubAckMsgBody = null;

        /**
         * ImWebsocketMsg qryMsgBody.
         * @member {imconnect.IQueryMsgBody|null|undefined} qryMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.qryMsgBody = null;

        /**
         * ImWebsocketMsg qryAckMsgBody.
         * @member {imconnect.IQueryAckMsgBody|null|undefined} qryAckMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.qryAckMsgBody = null;

        /**
         * ImWebsocketMsg qryConfirmMsgBody.
         * @member {imconnect.IQueryConfirmMsgBody|null|undefined} qryConfirmMsgBody
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        ImWebsocketMsg.prototype.qryConfirmMsgBody = null;

        // OneOf field names bound to virtual getters and setters
        let $oneOfFields;

        /**
         * ImWebsocketMsg testof.
         * @member {"connectMsgBody"|"ConnectAckMsgBody"|"disconnectMsgBody"|"publishMsgBody"|"pubAckMsgBody"|"qryMsgBody"|"qryAckMsgBody"|"qryConfirmMsgBody"|undefined} testof
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         */
        Object.defineProperty(ImWebsocketMsg.prototype, "testof", {
            get: $util.oneOfGetter($oneOfFields = ["connectMsgBody", "ConnectAckMsgBody", "disconnectMsgBody", "publishMsgBody", "pubAckMsgBody", "qryMsgBody", "qryAckMsgBody", "qryConfirmMsgBody"]),
            set: $util.oneOfSetter($oneOfFields)
        });

        /**
         * Creates a new ImWebsocketMsg instance using the specified properties.
         * @function create
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {imconnect.IImWebsocketMsg=} [properties] Properties to set
         * @returns {imconnect.ImWebsocketMsg} ImWebsocketMsg instance
         */
        ImWebsocketMsg.create = function create(properties) {
            return new ImWebsocketMsg(properties);
        };

        /**
         * Encodes the specified ImWebsocketMsg message. Does not implicitly {@link imconnect.ImWebsocketMsg.verify|verify} messages.
         * @function encode
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {imconnect.IImWebsocketMsg} message ImWebsocketMsg message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        ImWebsocketMsg.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.version != null && Object.hasOwnProperty.call(message, "version"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.version);
            if (message.cmd != null && Object.hasOwnProperty.call(message, "cmd"))
                writer.uint32(/* id 2, wireType 0 =*/16).int32(message.cmd);
            if (message.qos != null && Object.hasOwnProperty.call(message, "qos"))
                writer.uint32(/* id 3, wireType 0 =*/24).int32(message.qos);
            if (message.payload != null && Object.hasOwnProperty.call(message, "payload"))
                writer.uint32(/* id 4, wireType 2 =*/34).bytes(message.payload);
            if (message.connectMsgBody != null && Object.hasOwnProperty.call(message, "connectMsgBody"))
                $root.imconnect.ConnectMsgBody.encode(message.connectMsgBody, writer.uint32(/* id 11, wireType 2 =*/90).fork()).ldelim();
            if (message.ConnectAckMsgBody != null && Object.hasOwnProperty.call(message, "ConnectAckMsgBody"))
                $root.imconnect.ConnectAckMsgBody.encode(message.ConnectAckMsgBody, writer.uint32(/* id 12, wireType 2 =*/98).fork()).ldelim();
            if (message.disconnectMsgBody != null && Object.hasOwnProperty.call(message, "disconnectMsgBody"))
                $root.imconnect.DisconnectMsgBody.encode(message.disconnectMsgBody, writer.uint32(/* id 13, wireType 2 =*/106).fork()).ldelim();
            if (message.publishMsgBody != null && Object.hasOwnProperty.call(message, "publishMsgBody"))
                $root.imconnect.PublishMsgBody.encode(message.publishMsgBody, writer.uint32(/* id 14, wireType 2 =*/114).fork()).ldelim();
            if (message.pubAckMsgBody != null && Object.hasOwnProperty.call(message, "pubAckMsgBody"))
                $root.imconnect.PublishAckMsgBody.encode(message.pubAckMsgBody, writer.uint32(/* id 15, wireType 2 =*/122).fork()).ldelim();
            if (message.qryMsgBody != null && Object.hasOwnProperty.call(message, "qryMsgBody"))
                $root.imconnect.QueryMsgBody.encode(message.qryMsgBody, writer.uint32(/* id 16, wireType 2 =*/130).fork()).ldelim();
            if (message.qryAckMsgBody != null && Object.hasOwnProperty.call(message, "qryAckMsgBody"))
                $root.imconnect.QueryAckMsgBody.encode(message.qryAckMsgBody, writer.uint32(/* id 17, wireType 2 =*/138).fork()).ldelim();
            if (message.qryConfirmMsgBody != null && Object.hasOwnProperty.call(message, "qryConfirmMsgBody"))
                $root.imconnect.QueryConfirmMsgBody.encode(message.qryConfirmMsgBody, writer.uint32(/* id 18, wireType 2 =*/146).fork()).ldelim();
            return writer;
        };

        /**
         * Encodes the specified ImWebsocketMsg message, length delimited. Does not implicitly {@link imconnect.ImWebsocketMsg.verify|verify} messages.
         * @function encodeDelimited
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {imconnect.IImWebsocketMsg} message ImWebsocketMsg message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        ImWebsocketMsg.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes an ImWebsocketMsg message from the specified reader or buffer.
         * @function decode
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {imconnect.ImWebsocketMsg} ImWebsocketMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        ImWebsocketMsg.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.imconnect.ImWebsocketMsg();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.version = reader.int32();
                        break;
                    }
                case 2: {
                        message.cmd = reader.int32();
                        break;
                    }
                case 3: {
                        message.qos = reader.int32();
                        break;
                    }
                case 4: {
                        message.payload = reader.bytes();
                        break;
                    }
                case 11: {
                        message.connectMsgBody = $root.imconnect.ConnectMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                case 12: {
                        message.ConnectAckMsgBody = $root.imconnect.ConnectAckMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                case 13: {
                        message.disconnectMsgBody = $root.imconnect.DisconnectMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                case 14: {
                        message.publishMsgBody = $root.imconnect.PublishMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                case 15: {
                        message.pubAckMsgBody = $root.imconnect.PublishAckMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                case 16: {
                        message.qryMsgBody = $root.imconnect.QueryMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                case 17: {
                        message.qryAckMsgBody = $root.imconnect.QueryAckMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                case 18: {
                        message.qryConfirmMsgBody = $root.imconnect.QueryConfirmMsgBody.decode(reader, reader.uint32());
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes an ImWebsocketMsg message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {imconnect.ImWebsocketMsg} ImWebsocketMsg
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        ImWebsocketMsg.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies an ImWebsocketMsg message.
         * @function verify
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        ImWebsocketMsg.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            let properties = {};
            if (message.version != null && message.hasOwnProperty("version"))
                if (!$util.isInteger(message.version))
                    return "version: integer expected";
            if (message.cmd != null && message.hasOwnProperty("cmd"))
                if (!$util.isInteger(message.cmd))
                    return "cmd: integer expected";
            if (message.qos != null && message.hasOwnProperty("qos"))
                if (!$util.isInteger(message.qos))
                    return "qos: integer expected";
            if (message.payload != null && message.hasOwnProperty("payload"))
                if (!(message.payload && typeof message.payload.length === "number" || $util.isString(message.payload)))
                    return "payload: buffer expected";
            if (message.connectMsgBody != null && message.hasOwnProperty("connectMsgBody")) {
                properties.testof = 1;
                {
                    let error = $root.imconnect.ConnectMsgBody.verify(message.connectMsgBody);
                    if (error)
                        return "connectMsgBody." + error;
                }
            }
            if (message.ConnectAckMsgBody != null && message.hasOwnProperty("ConnectAckMsgBody")) {
                if (properties.testof === 1)
                    return "testof: multiple values";
                properties.testof = 1;
                {
                    let error = $root.imconnect.ConnectAckMsgBody.verify(message.ConnectAckMsgBody);
                    if (error)
                        return "ConnectAckMsgBody." + error;
                }
            }
            if (message.disconnectMsgBody != null && message.hasOwnProperty("disconnectMsgBody")) {
                if (properties.testof === 1)
                    return "testof: multiple values";
                properties.testof = 1;
                {
                    let error = $root.imconnect.DisconnectMsgBody.verify(message.disconnectMsgBody);
                    if (error)
                        return "disconnectMsgBody." + error;
                }
            }
            if (message.publishMsgBody != null && message.hasOwnProperty("publishMsgBody")) {
                if (properties.testof === 1)
                    return "testof: multiple values";
                properties.testof = 1;
                {
                    let error = $root.imconnect.PublishMsgBody.verify(message.publishMsgBody);
                    if (error)
                        return "publishMsgBody." + error;
                }
            }
            if (message.pubAckMsgBody != null && message.hasOwnProperty("pubAckMsgBody")) {
                if (properties.testof === 1)
                    return "testof: multiple values";
                properties.testof = 1;
                {
                    let error = $root.imconnect.PublishAckMsgBody.verify(message.pubAckMsgBody);
                    if (error)
                        return "pubAckMsgBody." + error;
                }
            }
            if (message.qryMsgBody != null && message.hasOwnProperty("qryMsgBody")) {
                if (properties.testof === 1)
                    return "testof: multiple values";
                properties.testof = 1;
                {
                    let error = $root.imconnect.QueryMsgBody.verify(message.qryMsgBody);
                    if (error)
                        return "qryMsgBody." + error;
                }
            }
            if (message.qryAckMsgBody != null && message.hasOwnProperty("qryAckMsgBody")) {
                if (properties.testof === 1)
                    return "testof: multiple values";
                properties.testof = 1;
                {
                    let error = $root.imconnect.QueryAckMsgBody.verify(message.qryAckMsgBody);
                    if (error)
                        return "qryAckMsgBody." + error;
                }
            }
            if (message.qryConfirmMsgBody != null && message.hasOwnProperty("qryConfirmMsgBody")) {
                if (properties.testof === 1)
                    return "testof: multiple values";
                properties.testof = 1;
                {
                    let error = $root.imconnect.QueryConfirmMsgBody.verify(message.qryConfirmMsgBody);
                    if (error)
                        return "qryConfirmMsgBody." + error;
                }
            }
            return null;
        };

        /**
         * Creates an ImWebsocketMsg message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {imconnect.ImWebsocketMsg} ImWebsocketMsg
         */
        ImWebsocketMsg.fromObject = function fromObject(object) {
            if (object instanceof $root.imconnect.ImWebsocketMsg)
                return object;
            let message = new $root.imconnect.ImWebsocketMsg();
            if (object.version != null)
                message.version = object.version | 0;
            if (object.cmd != null)
                message.cmd = object.cmd | 0;
            if (object.qos != null)
                message.qos = object.qos | 0;
            if (object.payload != null)
                if (typeof object.payload === "string")
                    $util.base64.decode(object.payload, message.payload = $util.newBuffer($util.base64.length(object.payload)), 0);
                else if (object.payload.length >= 0)
                    message.payload = object.payload;
            if (object.connectMsgBody != null) {
                if (typeof object.connectMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.connectMsgBody: object expected");
                message.connectMsgBody = $root.imconnect.ConnectMsgBody.fromObject(object.connectMsgBody);
            }
            if (object.ConnectAckMsgBody != null) {
                if (typeof object.ConnectAckMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.ConnectAckMsgBody: object expected");
                message.ConnectAckMsgBody = $root.imconnect.ConnectAckMsgBody.fromObject(object.ConnectAckMsgBody);
            }
            if (object.disconnectMsgBody != null) {
                if (typeof object.disconnectMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.disconnectMsgBody: object expected");
                message.disconnectMsgBody = $root.imconnect.DisconnectMsgBody.fromObject(object.disconnectMsgBody);
            }
            if (object.publishMsgBody != null) {
                if (typeof object.publishMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.publishMsgBody: object expected");
                message.publishMsgBody = $root.imconnect.PublishMsgBody.fromObject(object.publishMsgBody);
            }
            if (object.pubAckMsgBody != null) {
                if (typeof object.pubAckMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.pubAckMsgBody: object expected");
                message.pubAckMsgBody = $root.imconnect.PublishAckMsgBody.fromObject(object.pubAckMsgBody);
            }
            if (object.qryMsgBody != null) {
                if (typeof object.qryMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.qryMsgBody: object expected");
                message.qryMsgBody = $root.imconnect.QueryMsgBody.fromObject(object.qryMsgBody);
            }
            if (object.qryAckMsgBody != null) {
                if (typeof object.qryAckMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.qryAckMsgBody: object expected");
                message.qryAckMsgBody = $root.imconnect.QueryAckMsgBody.fromObject(object.qryAckMsgBody);
            }
            if (object.qryConfirmMsgBody != null) {
                if (typeof object.qryConfirmMsgBody !== "object")
                    throw TypeError(".imconnect.ImWebsocketMsg.qryConfirmMsgBody: object expected");
                message.qryConfirmMsgBody = $root.imconnect.QueryConfirmMsgBody.fromObject(object.qryConfirmMsgBody);
            }
            return message;
        };

        /**
         * Creates a plain object from an ImWebsocketMsg message. Also converts values to other types if specified.
         * @function toObject
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {imconnect.ImWebsocketMsg} message ImWebsocketMsg
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        ImWebsocketMsg.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.version = 0;
                object.cmd = 0;
                object.qos = 0;
                if (options.bytes === String)
                    object.payload = "";
                else {
                    object.payload = [];
                    if (options.bytes !== Array)
                        object.payload = $util.newBuffer(object.payload);
                }
            }
            if (message.version != null && message.hasOwnProperty("version"))
                object.version = message.version;
            if (message.cmd != null && message.hasOwnProperty("cmd"))
                object.cmd = message.cmd;
            if (message.qos != null && message.hasOwnProperty("qos"))
                object.qos = message.qos;
            if (message.payload != null && message.hasOwnProperty("payload"))
                object.payload = options.bytes === String ? $util.base64.encode(message.payload, 0, message.payload.length) : options.bytes === Array ? Array.prototype.slice.call(message.payload) : message.payload;
            if (message.connectMsgBody != null && message.hasOwnProperty("connectMsgBody")) {
                object.connectMsgBody = $root.imconnect.ConnectMsgBody.toObject(message.connectMsgBody, options);
                if (options.oneofs)
                    object.testof = "connectMsgBody";
            }
            if (message.ConnectAckMsgBody != null && message.hasOwnProperty("ConnectAckMsgBody")) {
                object.ConnectAckMsgBody = $root.imconnect.ConnectAckMsgBody.toObject(message.ConnectAckMsgBody, options);
                if (options.oneofs)
                    object.testof = "ConnectAckMsgBody";
            }
            if (message.disconnectMsgBody != null && message.hasOwnProperty("disconnectMsgBody")) {
                object.disconnectMsgBody = $root.imconnect.DisconnectMsgBody.toObject(message.disconnectMsgBody, options);
                if (options.oneofs)
                    object.testof = "disconnectMsgBody";
            }
            if (message.publishMsgBody != null && message.hasOwnProperty("publishMsgBody")) {
                object.publishMsgBody = $root.imconnect.PublishMsgBody.toObject(message.publishMsgBody, options);
                if (options.oneofs)
                    object.testof = "publishMsgBody";
            }
            if (message.pubAckMsgBody != null && message.hasOwnProperty("pubAckMsgBody")) {
                object.pubAckMsgBody = $root.imconnect.PublishAckMsgBody.toObject(message.pubAckMsgBody, options);
                if (options.oneofs)
                    object.testof = "pubAckMsgBody";
            }
            if (message.qryMsgBody != null && message.hasOwnProperty("qryMsgBody")) {
                object.qryMsgBody = $root.imconnect.QueryMsgBody.toObject(message.qryMsgBody, options);
                if (options.oneofs)
                    object.testof = "qryMsgBody";
            }
            if (message.qryAckMsgBody != null && message.hasOwnProperty("qryAckMsgBody")) {
                object.qryAckMsgBody = $root.imconnect.QueryAckMsgBody.toObject(message.qryAckMsgBody, options);
                if (options.oneofs)
                    object.testof = "qryAckMsgBody";
            }
            if (message.qryConfirmMsgBody != null && message.hasOwnProperty("qryConfirmMsgBody")) {
                object.qryConfirmMsgBody = $root.imconnect.QueryConfirmMsgBody.toObject(message.qryConfirmMsgBody, options);
                if (options.oneofs)
                    object.testof = "qryConfirmMsgBody";
            }
            return object;
        };

        /**
         * Converts this ImWebsocketMsg to JSON.
         * @function toJSON
         * @memberof imconnect.ImWebsocketMsg
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        ImWebsocketMsg.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for ImWebsocketMsg
         * @function getTypeUrl
         * @memberof imconnect.ImWebsocketMsg
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        ImWebsocketMsg.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/imconnect.ImWebsocketMsg";
        };

        return ImWebsocketMsg;
    })();

    return imconnect;
})();

export { $root as default };
