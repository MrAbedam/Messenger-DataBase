
---structure phase


CREATE TABLE Conversation (
                              conv_id UUID PRIMARY KEY DEFAULT gen_random_uuid()
);

CREATE TABLE Private_Chat (
                              conv_id UUID PRIMARY KEY REFERENCES Conversation(conv_id) ON DELETE CASCADE,
                              is_secret_chat BOOLEAN NOT NULL DEFAULT FALSE,
                              wallpaper UUID REFERENCES Media(media_id) ON DELETE SET NULL
);

CREATE TABLE User_Conversations (
                                    conv_id UUID REFERENCES Conversation(conv_id) ON DELETE CASCADE,
                                    user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                                    exception_notification STRING NULL,
                                    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Public_Conversation (
                                     conv_id UUID PRIMARY KEY REFERENCES Conversation(conv_id) ON DELETE CASCADE,
                                     owner_user_id UUID NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
                                     title STRING NOT NULL CHECK (char_length(title) <= 10),
                                     description STRING CHECK (char_length(description) <= 10),
                                     date_created TIMESTAMP DEFAULT now(),
                                     allowed_reactions STRING(30) DEFAULT '111111111111111111111111111111',
                                     is_public BOOLEAN DEFAULT FALSE
);


CREATE TABLE groups (
                        conv_id UUID PRIMARY KEY REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
                        is_history_hidden BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE Channel (
                         conv_id UUID PRIMARY KEY REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
                         sign_message BOOLEAN NOT NULL DEFAULT FALSE,
                         discussion UUID UNIQUE REFERENCES groups(conv_id) ON DELETE SET NULL
);

CREATE TABLE Advertisement (
                               conv_id UUID REFERENCES Channel(conv_id) ON DELETE CASCADE,
                               adver_conv_id UUID REFERENCES Channel(conv_id) ON DELETE CASCADE,
                               PRIMARY KEY (conv_id, adver_conv_id)
);

CREATE TABLE Booster (
                         conv_id UUID REFERENCES Channel(conv_id) ON DELETE CASCADE,
                         user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                         amount INT NOT NULL CHECK (amount > 0),
                         PRIMARY KEY (conv_id, user_id)
);


CREATE TABLE Invite_Link (
                             conv_id UUID REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
                             user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                             name STRING(10) NOT NULL,
                             expire_time TIMESTAMP NULL,
                             url_link STRING UNIQUE NOT NULL,
                             user_limit INT NULL CHECK (user_limit >= 0),
                             user_joined INT DEFAULT 0 CHECK (user_joined >= 0),
                             PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Shared_Media (
                              conv_id UUID  REFERENCES Conversation(conv_id) ON DELETE CASCADE,
                              media_id UUID REFERENCES Media(media_id) ON DELETE CASCADE,
                              PRIMARY KEY (conv_id, media_id)
);

CREATE TABLE Has_PV (
                        conv_id UUID REFERENCES Private_Chat(conv_id) ON DELETE CASCADE,
                        user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                        PRIMARY KEY (conv_id, user_id)
);


CREATE TABLE Ban (
                     conv_id UUID REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
                     user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                     PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Admins (
                        conv_id UUID REFERENCES Channel(conv_id) ON DELETE CASCADE,
                        user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                        channel_permission STRING(10) NOT NULL DEFAULT '1111111111' ,
                        PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Member_of (
                           user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                           conv_id UUID REFERENCES groups(conv_id) ON DELETE CASCADE,
                           nickname STRING(10),
                           membership_date TIMESTAMP DEFAULT now(),
                           group_permission STRING(24) DEFAULT '111111111111100000000000',
                           PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Subscribed_to (
                               user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
                               conv_id UUID REFERENCES Channel(conv_id) ON DELETE CASCADE,
                               sub_date TIMESTAMP DEFAULT now(),
                               PRIMARY KEY (conv_id, user_id)
);




---- insert phase
insert into users(username,bio) values ('MmdAbed','Dead Tired');
insert into users(username,bio) values ('mmdhraad','Nerd emoji');

insert into human_user(user_id,phone_number,first_name,last_name, dob, last_seen_time, two_step_pass) values
    ('d1d78108-41ec-43d9-bb01-300e982cdd70','09363340','Mmd','Abed','2023-11-29',now(),'dude');

insert into human_user(user_id,phone_number,first_name,last_name, dob, last_seen_time, two_step_pass) values
    ( '00fb9bb7-0c85-409d-b7b5-f13c783be03d','09934140','MmdHossein','Raad','2021-10-03',now(),'easypass');



-- group insert


insert into Conversation values ('00000000-0000-0000-0000-000000000000'); -- channel1
insert into Conversation values ('00000001-0000-0000-0000-000000000000'); -- group mmd and mmdhrad
insert into Conversation values ('00000002-0000-0000-0000-000000000000'); -- pv mmd to mmdhrad

INSERT INTO Private_Chat (conv_id, is_secret_chat, wallpaper)
VALUES ('00000002-0000-0000-0000-000000000000', FALSE, NULL); --Private Chat

INSERT INTO User_Conversations (conv_id, user_id, exception_notification)
VALUES
    ('00000002-0000-0000-0000-000000000000', 'd1d78108-41ec-43d9-bb01-300e982cdd70', NULL),  -- MmdAbed
    ('00000002-0000-0000-0000-000000000000', '00fb9bb7-0c85-409d-b7b5-f13c783be03d', NULL);  -- mmdhraad

INSERT INTO Has_PV (conv_id, user_id)
VALUES
    ('00000002-0000-0000-0000-000000000000', 'd1d78108-41ec-43d9-bb01-300e982cdd70'),  -- MmdAbed
    ('00000002-0000-0000-0000-000000000000', '00fb9bb7-0c85-409d-b7b5-f13c783be03d');  -- mmdhraad


select * from users;
select * from public.human_user;
select * from Conversation;
select * from has_pv;


-- raad part
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

-- abeds_part

CREATE TABLE Message
(
    message_id     UUID PRIMARY KEY                     DEFAULT gen_random_uuid(),
    send_time      TIMESTAMP                            DEFAULT now(),
    message_type   STRING(10) NOT NULL CHECK (message_type IN ('normal', 'poll', 'sticker')),
    sender_user_id UUID NOT NULL REFERENCES Users (user_id),
    conv_id        UUID NOT NULL REFERENCES Conversation (conv_id),
    forward_from   UUID REFERENCES Message (message_id) DEFAULT null,
    reply_to       UUID REFERENCES Message (message_id) DEFAULT null
);

CREATE TABLE Normal_Message
(
    message_id UUID PRIMARY KEY REFERENCES Message (message_id),
    edit_time  TIMESTAMP,
    text       STRING(500)
);

CREATE TABLE Message_Sticker
(
    message_id UUID PRIMARY KEY REFERENCES Message (message_id),
    sticker_id UUID NOT NULL REFERENCES Sticker (sticker_id)
);

CREATE TABLE Poll_Message
(
    message_id     UUID PRIMARY KEY REFERENCES Message (message_id),
    question       STRING(100) NOT NULL,
    poll_type      BIT(3) NOT NULL DEFAULT B'100',
    poll_option_id UUID            DEFAULT NULL
);

CREATE TABLE Poll_Option
(
    opt_id       UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    message_id   UUID             NOT NULL REFERENCES Poll_Message (message_id),
    option_text  STRING(50),
    vote_counter INT                       DEFAULT 0
);

ALTER TABLE Poll_Message
    ADD CONSTRAINT fk_poll_option_id FOREIGN KEY (poll_option_id) REFERENCES Poll_Option (opt_id);

CREATE TABLE Vote
(
    user_id        UUID NOT NULL REFERENCES Human_user (user_id),
    poll_option_id UUID NOT NULL REFERENCES Poll_Option (opt_id),
    PRIMARY KEY (user_id, poll_option_id)
);

CREATE TABLE Reacts (
                        user_id UUID NOT NULL REFERENCES Human_user(user_id),
                        message_id UUID NOT NULL REFERENCES Message(message_id),
                        emoji STRING(10) DEFAULT '👍🏻' ,
                        time TIMESTAMP DEFAULT now(),
                        PRIMARY KEY (user_id, message_id)
);

CREATE TABLE Call (
                      call_log_id UUID PRIMARY KEY,
                      status STRING(2) DEFAULT '0',
                      duration INTERVAL DEFAULT '0 minutes'::INTERVAL,
                      initiate_date TIMESTAMP DEFAULT now(),
                      caller_user_id UUID NOT NULL REFERENCES Human_user(user_id),
                      callee_user_id UUID NOT NULL REFERENCES Human_user(user_id)
);

CREATE TABLE Card (
                      card_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                      expiration_date DATE NOT NULL ,
                      card_number STRING(16) NOT NULL
);

CREATE TABLE Payment (
                         payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                         amount DECIMAL not null ,
                         currency STRING(10) DEFAULT  'USD',
                         payment_date DATE DEFAULT now(),
                         card_id UUID NOT NULL REFERENCES Card(card_id),
                         user_id UUID NOT NULL REFERENCES Users(user_id)
);