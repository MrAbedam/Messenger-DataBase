-- abeds_part
CREATE TABLE Users
(
    user_id        UUID PRIMARY KEY,
    username       STRING(10) UNIQUE,
    bio            STRING(50) DEFAULT '',
    public_prof_id UUID
);
ALTER TABLE Users
    ALTER COLUMN user_id SET DEFAULT gen_random_uuid();

CREATE TABLE Media
(
    media_id    UUID PRIMARY KEY,
    path        STRING UNIQUE NOT NULL,
    media_type  STRING(10),
    file_size   INT,
    uploader_id UUID          NOT NULL
);

ALTER TABLE Users
    ADD CONSTRAINT fk_public_prof_id FOREIGN KEY (public_prof_id) REFERENCES Media (media_id);
ALTER TABLE Media
    ADD CONSTRAINT fk_uploader_id FOREIGN KEY (uploader_id) REFERENCES Users (user_id);

ALTER TABLE Media
    ALTER COLUMN media_id SET DEFAULT gen_random_uuid();


show tables;

INSERT INTO Users (username, bio)
VALUES ('john_doe', 'Software Engineer');


CREATE TABLE Human_user
(
    user_id                 UUID PRIMARY KEY REFERENCES Users (user_id),
    phone_number            STRING(10) NOT NULL UNIQUE,
    first_name              STRING(10)NOT NULL DEFAULT '',
    last_name               STRING(10) DEFAULT '',
    dob                     DATE,
    last_seen_time          TIMESTAMP,
    notification_preference STRING(3) DEFAULT '111',
    privacy_preference      STRING(9) DEFAULT '111111111',
    two_step_pass           STRING(20) DEFAULT NULL
);

-- add human user by this code :
WITH new_user AS (
    INSERT INTO Users (user_id, username, bio)
        VALUES (gen_random_uuid(), 'JohnD', '')
        ON CONFLICT (user_id) DO NOTHING
        RETURNING user_id)
INSERT
INTO Human_user (user_id, phone_number, first_name, last_name)
SELECT user_id, '1234567890', 'John', 'Doe'
FROM new_user
UNION ALL
SELECT user_id, '1234567890', 'John', 'Doe'
FROM Users
WHERE username = 'JohnD'
LIMIT 1;


CREATE TABLE Contact
(
    user_id    UUID NOT NULL REFERENCES Human_user (user_id),
    c_user_id  UUID NOT NULL REFERENCES Human_user (user_id),
    first_name STRING(10) NOT NULL,
    last_name  STRING(10) DEFAULT '',
    PRIMARY KEY (user_id, c_user_id)
);
CREATE TABLE Premium
(
    user_id         UUID PRIMARY KEY REFERENCES Human_user (user_id),
    expiration_date DATE DEFAULT now()
);

CREATE TABLE Private_Prof
(
    media_id UUID PRIMARY KEY,
    user_id  UUID      NOT NULL REFERENCES Human_user (user_id),
    time_set TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE Block_user
(
    blocker_user_id UUID NOT NULL REFERENCES Human_user (user_id),
    blocked_user_id UUID NOT NULL REFERENCES Users (user_id),
    PRIMARY KEY (blocker_user_id, blocked_user_id)
);

CREATE TABLE Bot
(
    user_id       UUID PRIMARY KEY REFERENCES Users (user_id),
    users_counter INT DEFAULT 0
);

CREATE TABLE Bot_Commands
(
    user_id  UUID NOT NULL REFERENCES Users (user_id),
    cmd_text STRING(10) NOT NULL,
    PRIMARY KEY (user_id, cmd_text)
);

CREATE TABLE Story
(
    user_id  UUID NOT NULL REFERENCES Users (user_id),
    media_id UUID NOT NULL REFERENCES Media (media_id),
    PRIMARY KEY (user_id, media_id)
);

CREATE TABLE Send_Slicker
(
    user_id    UUID NOT NULL REFERENCES Users (user_id),
    sticker_id UUID NOT NULL,
    counter    INT,
    PRIMARY KEY (user_id, sticker_id)
);

ALTER TABLE Send_Slicker
    ADD CONSTRAINT fk_sticker_id FOREIGN KEY (sticker_id) REFERENCES Sticker (sticker_id);
ALTER TABLE Has_Slicker_Pack
    ADD CONSTRAINT fk_sticker_pack_id FOREIGN KEY (sticker_pack_id) REFERENCES Sticker_Pack (sticker_pack_id);


CREATE TABLE Has_Slicker_Pack
(
    user_id         UUID NOT NULL REFERENCES Users (user_id),
    sticker_pack_id UUID NOT NULL,
    PRIMARY KEY (user_id, sticker_pack_id)
);

CREATE TABLE Session
(
    session_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id       UUID NOT NULL REFERENCES Users (user_id),
    auth_status        STRING(2) NOT NULL DEFAULT '0',
    ip                 STRING(10) NOT NULL,
    location           STRING(10) DEFAULT 'Unknown',
    create_time        DATE NOT NULL    DEFAULT now(),
    last_activity      DATE NOT NULL    DEFAULT now(),
    device             STRING(10) DEFAULT 'Unknown',
    app_os             STRING(10) DEFAULT 'Unknown',
    access_secret_call BIT(2)           DEFAULT B'11'
);


CREATE TABLE Sticker_Pack
(
    sticker_pack_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            STRING(10) NOT NULL,
    url             STRING UNIQUE,
    user_id         UUID NOT NULL REFERENCES Users (user_id)
);

CREATE TABLE Sticker
(
    sticker_id      UUID PRIMARY KEY,
    emoji           STRING(10),
    media_id        UUID UNIQUE NOT NULL REFERENCES Media (media_id),
    sticker_pack_id UUID UNIQUE REFERENCES Sticker_Pack (sticker_pack_id)
);

CREATE TABLE Chosen_Privacy
(
    user_id           UUID NOT NULL REFERENCES Human_user (user_id),
    ex_user_id        UUID NOT NULL REFERENCES Users (user_id),
    exception_privacy STRING(9) NOT NULL,
    PRIMARY KEY (user_id, ex_user_id)
);

