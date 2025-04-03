create table confs(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conf_key VARCHAR(64),
    conf_value VARCHAR(100)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_key ON confs(conf_key);

create table messages(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conver_id VARCHAR(64),
    conver_type SMALLINT default 0,
    client_id VARCHAR(64),
    sender_id VARCHAR(64),
    direction SMALLINT,
    msg_id VARCHAR(64),
    msg_seq_no INTEGER default 0,
    msg_index INTEGER,
    msg_type VARCHAR(64),
    sent_time INTEGER,
    msg_content text,
    ext text,
    state SMALLINT,
    flags INTEGER default 0,
    has_read SMALLINT,
    read_count INTEGER default 0,
    member_count INTEGER default 0,
    is_deleted SMALLINT default 0,
    search_content text,
    mention_info text,
    refer_msg_id VARCHAR(64),
    reactions text
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_messages ON messages(msg_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_messages_client_id ON messages(client_id);
CREATE INDEX IF NOT EXISTS idx_messages_conver ON messages(conver_type,conver_id);
CREATE INDEX IF NOT EXISTS idx_messages_conver_ts ON messages(conver_type,conver_id,sent_time);

create table conversations(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conver_id VARCHAR(64),
    conver_type SMALLINT default 0,
    draft text,
    sync_time INTEGER,
    conver_time INTEGER,
    last_msg_id VARCHAR(64),
    last_read_msg_index INTEGER,
    last_msg_index INTEGER,
    is_top SMALLINT,
    top_time INTEGER,
    is_mute SMALLINT,
    mention_info VARCHAR(64),
    last_msg_type VARCHAR(64),
    last_msg_client_id VARCHAR(64),
    last_msg_direction SMALLINT,
    last_msg_state SMALLINT,
    last_msg_has_read SMALLINT,
    last_msg_sender_id VARCHAR(64),
    last_msg_content text,
    last_msg_mention_info text,
    last_msg_seq_no INTEGER,
    unread_tag INTEGER
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_conversation ON conversations(conver_type,conver_id);

create table conversation_tags(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_id VARCHAR(64),
    conver_type SMALLINT,
    conver_id VARCHAR(64)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_conver_tag ON conversation_tags(tag_id,conver_type,conver_id);

create table users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id VARCHAR(64),
    name VARCHAR(64),
    portrait text,
    extension text,
    user_type SMALLINT
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_user ON users(user_id);

create table groups(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id VARCHAR(64),
    name VARCHAR(64),
    portrait text,
    extension text
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_group ON groups(group_id);

create table group_members(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id VARCHAR(64),
    member_id VARCHAR(64),
    display_name VARCHAR(64),
    extension text
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_member ON group_members(group_id,member_id);
