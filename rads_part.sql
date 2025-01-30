-- abeds_part
CREATE TABLE Users (
                       user_id UUID PRIMARY KEY,
                       username STRING(10) UNIQUE ,
                       bio STRING(50) DEFAULT '',
                       public_prof_id UUID
);
ALTER TABLE Users ALTER COLUMN user_id SET DEFAULT gen_random_uuid();

CREATE TABLE Media (
                       media_id UUID PRIMARY KEY,
                       path STRING UNIQUE NOT NULL,
                       media_type STRING(10),
                       file_size INT,
                       uploader_id UUID NOT NULL
);

ALTER TABLE Users ADD CONSTRAINT fk_public_prof_id FOREIGN KEY (public_prof_id) REFERENCES Media(media_id);
ALTER TABLE Media ADD CONSTRAINT fk_uploader_id FOREIGN KEY (uploader_id) REFERENCES Users(user_id);

ALTER TABLE Media ALTER COLUMN media_id SET DEFAULT gen_random_uuid();


show tables;

INSERT INTO Users (username, bio) VALUES ('john_doe', 'Software Engineer');


CREATE TABLE Human_user (
                            user_id UUID PRIMARY KEY REFERENCES Users(user_id),
                            phone_number STRING(10) NOT NULL UNIQUE,
                            first_name STRING(10)NOT NULL DEFAULT '',
                            last_name STRING(10) DEFAULT '',
                            dob DATE,
                            last_seen_time TIMESTAMP,
                            notification_preference STRING(3) DEFAULT '111',
                            privacy_preference STRING(9) DEFAULT '111111111',
                            two_step_pass STRING(20) DEFAULT NULL
);

-- add human user by this code :
WITH new_user AS (
    INSERT INTO Users (user_id, username, bio)
        VALUES (gen_random_uuid(), 'JohnD', '')
        ON CONFLICT (user_id) DO NOTHING
        RETURNING user_id
)
INSERT INTO Human_user (user_id, phone_number, first_name, last_name)
SELECT user_id, '1234567890', 'John', 'Doe' FROM new_user
UNION ALL
SELECT user_id, '1234567890', 'John', 'Doe' FROM Users WHERE username = 'JohnD'
LIMIT 1;
