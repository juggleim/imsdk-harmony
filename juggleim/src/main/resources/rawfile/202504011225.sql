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
    subchannel VARCHAR(64) default '',
    client_msg_no INTEGER default 0,
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
    local_attribute text DEFAULT '',
    mention_info text,
    refer_msg_id VARCHAR(64),
    reactions text,
    life_time INTEGER DEFAULT 0,
    life_time_after_read INTEGER DEFAULT 0,
    destroy_time INTEGER DEFAULT 0,
    read_time INTEGER DEFAULT 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_messages ON messages(msg_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_messages_client_id ON messages(client_id);
CREATE INDEX IF NOT EXISTS idx_messages_client_msg_no ON messages(client_msg_no);
CREATE INDEX IF NOT EXISTS idx_messages_destroy_time ON messages(destroy_time);
CREATE INDEX IF NOT EXISTS idx_messages_conver ON messages(conver_type,conver_id);
CREATE INDEX IF NOT EXISTS idx_messages_conver_ts ON messages(conver_type,conver_id,sent_time);
CREATE INDEX IF NOT EXISTS idx_messages_conver_subchannel ON messages(conver_type,conver_id,subchannel);
CREATE INDEX IF NOT EXISTS idx_messages_conver_subchannel_ts ON messages(conver_type,conver_id,subchannel,sent_time);

create table conversations(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conver_id VARCHAR(64) default '',
    conver_type SMALLINT default 0,
    subchannel VARCHAR(64) default '',
    draft text,
    conver_time INTEGER default 0,
    last_msg_id VARCHAR(64) default '',
    last_msg_time INTEGER default 0,
    last_msg_seq_no INTEGER default 0,
    last_read_msg_index INTEGER default 0,
    last_msg_index INTEGER default 0,
    is_top SMALLINT default 0,
    top_time INTEGER default 0,
    is_mute SMALLINT default 0,
    mention_info VARCHAR(64) default '',
    last_msg_type VARCHAR(64) default '',
    last_msg_client_id VARCHAR(64) default '',
    last_msg_direction SMALLINT default 0,
    last_msg_state SMALLINT default 0,
    last_msg_has_read SMALLINT default 0,
    last_msg_sender_id VARCHAR(64) default '',
    last_msg_subchannel VARCHAR(64) default '',
    last_msg_content text default '',
    last_msg_mention_info text default '',
    unread_tag INTEGER default 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_conversation ON conversations(conver_type,conver_id,subchannel);

create table conversation_tags(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_id VARCHAR(64),
    conver_type SMALLINT,
    conver_id VARCHAR(64),
    subchannel VARCHAR(64) default ''
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_conver_tag ON conversation_tags(tag_id,conver_type,conver_id,subchannel);

create table conversation_tag_infos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_id VARCHAR(64),
    tag_name VARCHAR(128),
    tag_type SMALLINT default 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_conver_tag_info ON conversation_tag_infos(tag_id);

create table users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id VARCHAR(64),
    name VARCHAR(64),
    portrait text,
    extension text,
    user_type SMALLINT,
    upd_time INTEGER
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_user ON users(user_id);

create table groups(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id VARCHAR(64),
    name VARCHAR(64),
    portrait text,
    extension text,
    upd_time INTEGER
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_group ON groups(group_id);

create table friends(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id VARCHAR(64),
    is_friend SMALLINT default 0,
    alias VARCHAR(128) default '',
    updated_time INTEGER default 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_friend ON friends(user_id);

create table group_members(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id VARCHAR(64),
    member_id VARCHAR(64),
    display_name VARCHAR(64),
    extension text
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_member ON group_members(group_id,member_id);

create table message_reactions(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    message_id VARCHAR(64),
    reactions text
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_message_reactions ON message_reactions(message_id);

create table moments(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    moment_id VARCHAR(64),
    content text,
    media_json text,
    user_json text,
    reaction_json text,
    comment_json text,
    create_time INTEGER default 0
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_moment ON moments(moment_id);
CREATE INDEX IF NOT EXISTS idx_moment_time ON moments(create_time);
