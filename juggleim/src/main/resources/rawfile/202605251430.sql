ALTER TABLE messages ADD COLUMN life_time INTEGER DEFAULT 0;
ALTER TABLE messages ADD COLUMN life_time_after_read INTEGER DEFAULT 0;
ALTER TABLE messages ADD COLUMN destroy_time INTEGER DEFAULT 0;
ALTER TABLE messages ADD COLUMN read_time INTEGER DEFAULT 0;
CREATE INDEX IF NOT EXISTS idx_messages_destroy_time ON messages(destroy_time);
