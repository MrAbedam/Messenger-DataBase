
---structure phase

CREATE TABLE Conversation (
    conv_id UUID PRIMARY KEY DEFAULT gen_random_uuid()
);

CREATE TABLE Private_Chat (
    conv_id UUID PRIMARY KEY REFERENCES Conversation(conv_id) ON DELETE CASCADE,
    is_secret_chat BOOLEAN NOT NULL DEFAULT FALSE,
    wallpaper UUID UNIQUE REFERENCES Media(media_id) ON DELETE SET NULL
);

CREATE TABLE User_Conversations (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    exception_notification STRING NULL,
    PRIMARY KEY (conv_id, user_id),
    UNIQUE (conv_id, user_id)
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
    conv_id UUID NOT NULL UNIQUE REFERENCES Channel(conv_id) ON DELETE CASCADE,
    adver_conv_id UUID NOT NULL UNIQUE REFERENCES Channel(conv_id) ON DELETE CASCADE,
    PRIMARY KEY (conv_id, adver_conv_id)
);

CREATE TABLE Booster (
    conv_id UUID NOT NULL REFERENCES Channel(conv_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    amount INT NOT NULL CHECK (amount > 0),
    PRIMARY KEY (conv_id, user_id),
    UNIQUE (conv_id, user_id)
);

CREATE TABLE Invite_Link (
    conv_id UUID NOT NULL UNIQUE REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
    user_id UUID NOT NULL UNIQUE REFERENCES Users(user_id) ON DELETE CASCADE,
    name STRING(10) NOT NULL,
    expire_time TIMESTAMP NULL,
    url_link STRING UNIQUE NOT NULL,
    user_limit INT NULL CHECK (user_limit >= 0),
    user_joined INT DEFAULT 0 CHECK (user_joined >= 0),
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Shared_Media (
    conv_id UUID NOT NULL UNIQUE REFERENCES Conversation(conv_id) ON DELETE CASCADE,
    media_id UUID NOT NULL UNIQUE REFERENCES Media(media_id) ON DELETE CASCADE,
    PRIMARY KEY (conv_id, media_id)
);

CREATE TABLE Has_PV (
    conv_id UUID NOT NULL UNIQUE REFERENCES Private_Chat(conv_id) ON DELETE CASCADE,
    user_id UUID NOT NULL UNIQUE REFERENCES Users(user_id) ON DELETE CASCADE,
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Ban (
    conv_id UUID NOT NULL UNIQUE REFERENCES Public_Conversation(conv_id) ON DELETE CASCADE,
    user_id UUID NOT NULL UNIQUE REFERENCES Users(user_id) ON DELETE CASCADE,
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Admins (
    conv_id UUID NOT NULL UNIQUE REFERENCES Channel(conv_id) ON DELETE CASCADE,
    user_id UUID NOT NULL UNIQUE REFERENCES Users(user_id) ON DELETE CASCADE,
    channel_permission STRING(10) NOT NULL DEFAULT '1111111111' ,
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Member_of (
    user_id UUID NOT NULL UNIQUE REFERENCES Users(user_id) ON DELETE CASCADE,
    conv_id UUID NOT NULL UNIQUE REFERENCES "Group"(conv_id) ON DELETE CASCADE,
    nickname STRING(10),
    membership_date TIMESTAMP DEFAULT now(),
    group_permission STRING(24) DEFAULT '111111111111100000000000',
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Subscribed_to (
    user_id UUID NOT NULL UNIQUE REFERENCES Users(user_id) ON DELETE CASCADE,
    conv_id UUID NOT NULL UNIQUE REFERENCES Channel(conv_id) ON DELETE CASCADE,
    sub_date TIMESTAMP DEFAULT now(),
    PRIMARY KEY (conv_id, user_id)
);




---- insert phase