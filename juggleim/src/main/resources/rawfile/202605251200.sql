ALTER TABLE messages ADD COLUMN subchannel VARCHAR(64) DEFAULT '';
ALTER TABLE conversations ADD COLUMN subchannel VARCHAR(64) DEFAULT '';
ALTER TABLE conversations ADD COLUMN last_msg_subchannel VARCHAR(64) DEFAULT '';
ALTER TABLE conversation_tags ADD COLUMN subchannel VARCHAR(64) DEFAULT '';
DROP INDEX IF EXISTS idx_conversation;
DROP INDEX IF EXISTS idx_conver_tag;
CREATE UNIQUE INDEX IF NOT EXISTS idx_conversation ON conversations(conver_type,conver_id,subchannel);
CREATE UNIQUE INDEX IF NOT EXISTS idx_conver_tag ON conversation_tags(tag_id,conver_type,conver_id,subchannel);
CREATE INDEX IF NOT EXISTS idx_messages_conver_subchannel ON messages(conver_type,conver_id,subchannel);
CREATE INDEX IF NOT EXISTS idx_messages_conver_subchannel_ts ON messages(conver_type,conver_id,subchannel,sent_time);
CREATE TABLE IF NOT EXISTS conversation_tag_infos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_id VARCHAR(64),
    tag_name VARCHAR(128),
    tag_type SMALLINT DEFAULT 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_conver_tag_info ON conversation_tag_infos(tag_id);
CREATE TABLE IF NOT EXISTS friends(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id VARCHAR(64),
    is_friend SMALLINT DEFAULT 0,
    alias VARCHAR(128) DEFAULT '',
    updated_time INTEGER DEFAULT 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_friend ON friends(user_id);
CREATE TABLE IF NOT EXISTS message_reactions(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    message_id VARCHAR(64),
    reactions text
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_message_reactions ON message_reactions(message_id);
CREATE TABLE IF NOT EXISTS moments(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    moment_id VARCHAR(64),
    content text,
    media_json text,
    user_json text,
    reaction_json text,
    comment_json text,
    create_time INTEGER DEFAULT 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_moment ON moments(moment_id);
CREATE INDEX IF NOT EXISTS idx_moment_time ON moments(create_time);
