
---structure phase

drop table subscribed_to;
drop table member_of;
drop table admins;
drop table Ban;
drop table has_pv;
drop table shared_media;
drop table invite_link;
drop table booster;
drop table advertisement;
drop table channel;
drop table "Group";
drop table public_conversation;
drop table user_conversations;
drop table private_chat;
drop table conversation;



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


CREATE TABLE "Group" (
    conv_id UUID PRIMARY KEY REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
    is_history_hidden BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE Channel (
    conv_id UUID PRIMARY KEY REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
    sign_message BOOLEAN NOT NULL DEFAULT FALSE,
    discussion UUID UNIQUE REFERENCES "Group"(conv_id) ON DELETE SET NULL
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
    conv_id UUID REFERENCES "Group"(conv_id) ON DELETE CASCADE,
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