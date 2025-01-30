-- abeds_part
CREATE TABLE Users (
                       user_id UUID PRIMARY KEY,
                       username STRING(10) UNIQUE ,
                       bio STRING(50) DEFAULT '',
                       public_prof_id UUID
);

CREATE TABLE Media (
                       media_id UUID PRIMARY KEY,
                       path STRING UNIQUE NOT NULL,
                       media_type STRING(10),
                       file_size INT,
                       uploader_id UUID NOT NULL
);

ALTER TABLE Users ADD CONSTRAINT fk_public_prof_id FOREIGN KEY (public_prof_id) REFERENCES Media(media_id);
ALTER TABLE Media ADD CONSTRAINT fk_uploader_id FOREIGN KEY (uploader_id) REFERENCES Users(user_id);

ALTER TABLE Users ALTER COLUMN user_id SET DEFAULT gen_random_uuid();
ALTER TABLE Media ALTER COLUMN media_id SET DEFAULT gen_random_uuid();
ALTER TABLE Users ALTER COLUMN username TYPE STRING(10);


show tables;

INSERT INTO Users (username, bio) VALUES ('john_doe', 'Software Engineer');


