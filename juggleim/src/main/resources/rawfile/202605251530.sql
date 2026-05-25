ALTER TABLE messages ADD COLUMN client_msg_no INTEGER DEFAULT 0;
CREATE INDEX IF NOT EXISTS idx_messages_client_msg_no ON messages(client_msg_no);
