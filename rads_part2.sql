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