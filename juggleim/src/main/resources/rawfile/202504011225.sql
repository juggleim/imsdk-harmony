create table message(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conver_id VARCHAR(64),
    conver_type SMALLINT default 0,
    client_id VARCHAR(64),
    sender VARCHAR(64),
    direction boolean,
    msg_id VARCHAR(64),
    msg_seq INTEGER default 0,
    msg_index INTEGER,
    msg_type VARCHAR(64),
    sent_time INTEGER,
    msg_content text,
    ext text,
    state SMALLINT,
    flags INTEGER default 0,
    has_read boolean,
    read_count INTEGER default 0,
    member_count INTEGER default 0,
    is_deleted boolean default 0,
    search_content text,
    mention_info text,
    refer_msg_id VARCHAR(64)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_message ON message(msg_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_message_client_id ON message(client_id);
CREATE INDEX IF NOT EXISTS idx_message_conver ON message(conver_type,conver_id);
CREATE INDEX IF NOT EXISTS idx_message_conver_ts ON message(conver_type,conver_id,sent_time);