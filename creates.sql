-- Page 1 Tables

CREATE TABLE Conversation (
    conv_id UUID PRIMARY KEY,
    is_history_hidden BOOL
);

CREATE TABLE Channel (
    conv_id UUID PRIMARY KEY REFERENCES Conversation(conv_id),
    sign_message BOOL
);

CREATE TABLE Private_Chat (
    conv_id UUID PRIMARY KEY REFERENCES Conversation(conv_id),
    is_sacret_chat BOOL,
    media_id UUID UNIQUE NOT NULL -- Assuming media_id references another table
);

CREATE TABLE Public_Conversation (
    conv_id UUID PRIMARY KEY REFERENCES Conversation(conv_id),
    owner_user_id UUID NOT NULL REFERENCES User(user_id),
    title STRING(10) NOT NULL,
    description STRING(10),
    data_created DATE,
    allowed_reactions STRING(30) DEFAULT 'All 1',
    is_public BOOL DEFAULT false
);

CREATE TABLE Shared_Media (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    media_id UUID NOT NULL, -- Assuming media_id references another table
    PRIMARY KEY (conv_id, media_id)
);

CREATE TABLE User_Conversations (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    exception_notification STRING(9),
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Booster (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    amount INT NOT NULL,
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Has_PV (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Ban (
    conv_id UUID NOT NULL REFERENCES Public_Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Advertisement (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    advert_conv_id UUID NOT NULL, -- Assuming advert_conv_id references another table
    PRIMARY KEY (conv_id, advert_conv_id)
);

CREATE TABLE Invite_Link (
    conv_id UUID NOT NULL REFERENCES Public_Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    name STRING(10),
    expire_time DATE,
    url_link STRING UNIQUE NOT NULL,
    user_limit INT,
    user_jolned INT,
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Group (
    user_id UUID PRIMARY KEY,
    is_history_hidden BOOL NOT NULL,
    first_name STRING(10) NOT NULL,
    last_name STRING(10),
    dob DATE,
    last_seen_time TIMESTAMP,
    notification_preference STRING(3) DEFAULT '111',
    privacy_preference STRING(9),
    two_step_pass STRING(20) DEFAULT NULL
);

CREATE TABLE Member_Of (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    nickname STRING(10),
    membership_date DATE,
    group_permission STRING(24) DEFAULT '13 1',
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Admin (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    channel_permission STRING(10) DEFAULT 'All 1',
    PRIMARY KEY (conv_id, user_id)
);

CREATE TABLE Subscribed_To (
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    user_id UUID NOT NULL REFERENCES User(user_id),
    sub_date DATE,
    PRIMARY KEY (conv_id, user_id)
);

-- Page 2 Tables

CREATE TABLE User (
    user_id UUID PRIMARY KEY,
    username STRING UNIQUE DEFAULT '**',
    bio UUID, -- Assuming bio references another table
    public_port_id UUID -- Assuming public_port_id references another table
);

CREATE TABLE Human_user (
    user_id UUID PRIMARY KEY REFERENCES User(user_id),
    phone_number STRING(10),
    first_name STRING NOT NULL UNIQUE,
    last_name STRING(10) NOT NULL,
    doc DATE,
    last_seen_time TIMESTAMP,
    notification_perference STRING(3) DEFAULT '111',
    privacy_perference STRING(9),
    two_step_pass STRING(20) DEFAULT NULL
);

CREATE TABLE Contact (
    user_id UUID NOT NULL REFERENCES Human_user(user_id),
    c_user_id UUID NOT NULL REFERENCES Human_user(user_id),
    first_name STRING(10) NOT NULL,
    last_name STRING(10),
    PRIMARY KEY (user_id, c_user_id)
);

CREATE TABLE Phantom (
    user_id UUID PRIMARY KEY REFERENCES User(user_id),
    expiration_date DATE
);

CREATE TABLE Private_Prof (
    media_id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES User(user_id),
    time_set TIMESTAMP NOT NULL
);

CREATE TABLE Block_user (
    blocker_user_id UUID NOT NULL REFERENCES Human_user(user_id),
    blocked_user_id UUID NOT NULL REFERENCES User(user_id),
    PRIMARY KEY (blocker_user_id, blocked_user_id)
);

CREATE TABLE Host (
    user_id UUID PRIMARY KEY REFERENCES User(user_id),
    users_counter INT
);

CREATE TABLE Bot_Commands (
    user_id UUID NOT NULL REFERENCES User(user_id),
    cmd_text STRING(10) NOT NULL,
    PRIMARY KEY (user_id, cmd_text)
);

CREATE TABLE Story (
    user_id UUID NOT NULL REFERENCES User(user_id),
    media_id UUID NOT NULL, -- Assuming media_id references another table
    PRIMARY KEY (user_id, media_id)
);

CREATE TABLE Send_Slicker (
    user_id UUID NOT NULL REFERENCES User(user_id),
    sticker_id UUID NOT NULL, -- Assuming sticker_id references another table
    counter INT,
    PRIMARY KEY (user_id, sticker_id)
);

CREATE TABLE Has_Slicker_Pack (
    user_id UUID NOT NULL REFERENCES User(user_id),
    sticker_pack_id UUID NOT NULL, -- Assuming sticker_pack_id references another table
    PRIMARY KEY (user_id, sticker_pack_id)
);

CREATE TABLE Session (
    session_id UUID PRIMARY KEY,
    auth_user_id UUID NOT NULL REFERENCES User(user_id),
    auth_status STRING(2) NOT NULL,
    ip STRING(10) NOT NULL,
    location STRING(10),
    create_time DATE NOT NULL,
    last_activity DATE NOT NULL,
    device STRING(10),
    app_os STRING(10),
    access_secret_call BIT(2) DEFAULT B'11'
);

-- Page 3 Tables

CREATE TABLE Message (
    message_id UUID PRIMARY KEY,
    send_time TIMESTAMP,
    message_type STRING(10),
    sender_user_id UUID NOT NULL REFERENCES User(user_id),
    conv_id UUID NOT NULL REFERENCES Conversation(conv_id),
    forward_from UUID REFERENCES Message(message_id),
    reply_to UUID REFERENCES Message(message_id)
);

CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    amount DECIMAL,
    currency STRING(10),
    payment_date DATE,
    card_id UUID NOT NULL, -- Assuming card_id references another table
    user_id UUID NOT NULL REFERENCES User(user_id)
);

CREATE TABLE Name (
    message_id UUID PRIMARY KEY REFERENCES Message(message_id),
    edit_time DATE,
    text STRING(10)
);

CREATE TABLE Sticker_Pack (
    sticker_pack_id UUID PRIMARY KEY,
    name STRING(10),
    url STRING UNIQUE NOT NULL,
    user_id UUID NOT NULL REFERENCES User(user_id)
);

CREATE TABLE Message_Sticker (
    message_id UUID PRIMARY KEY REFERENCES Message(message_id),
    sticker_id UUID NOT NULL -- Assuming sticker_id references another table
);

CREATE TABLE Post_Message (
    message_id UUID PRIMARY KEY REFERENCES Message(message_id),
    question STRING(10) NOT NULL,
    poll_type BIT(3) NOT NULL DEFAULT B'100',
    poll_option_id UUID NOT NULL -- Assuming poll_option_id references another table
);

CREATE TABLE Vote (
    user_id UUID NOT NULL REFERENCES User(user_id),
    poll_option_id UUID NOT NULL, -- Assuming poll_option_id references another table
    PRIMARY KEY (user_id, poll_option_id)
);

CREATE TABLE Post_Option (
    message_id UUID NOT NULL REFERENCES Message(message_id),
    opt_id INT NOT NULL,
    option_text STRING(10),
    vote_counter INT DEFAULT 0,
    PRIMARY KEY (message_id, opt_id)
);

CREATE TABLE Card (
    card_id UUID PRIMARY KEY,
    expiration_date DATE,
    card_number STRING(16)
);

CREATE TABLE Call (
    call_log_id UUID PRIMARY KEY,
    status STRING(2),
    duration INTERVAL,
    initiate_date TIMESTAMP,
    caller_user_id UUID NOT NULL REFERENCES User(user_id),
    callee_user_id UUID NOT NULL REFERENCES User(user_id)
);

CREATE TABLE Sticker (
    sticker_id UUID PRIMARY KEY,
    email STRING(10),
    media_id UUID UNIQUE NOT NULL, -- Assuming media_id references another table
    sticker_pack_id UUID UNIQUE -- Assuming sticker_pack_id references another table
);

CREATE TABLE Reacts (
    user_id UUID NOT NULL REFERENCES User(user_id),
    message_id UUID NOT NULL REFERENCES Message(message_id),
    email STRING(10),
    time TIMESTAMP,
    PRIMARY KEY (user_id, message_id)
);

CREATE TABLE Media (
    media_id UUID PRIMARY KEY,
    path STRING UNIQUE NOT NULL,
    media_type STRING(10),
    file_size INT,
    uploader_id UUID NOT NULL REFERENCES User(user_id),
    attach_message_id UUID REFERENCES Message(message_id)
);