INSERT INTO Conversation (conv_id)
VALUES ('11111111-1111-1234-1111-111111111111'); -- Mohammad → Ali

INSERT INTO Private_Chat (conv_id, is_secret_chat, wallpaper)
VALUES ('11111111-1111-1234-1111-111111111111', FALSE, NULL)
INSERT INTO User_Conversations (conv_id, user_id)
VALUES ('11111111-1111-1234-1111-111111111111', 'a8c6d9dd-b633-47e8-be9b-3ae2bdf9482a'),
       ('11111111-1111-1234-1111-111111111111', '00fb9bb7-0c85-409d-b7b5-f13c783be03d');


INSERT INTO users
values (gen_random_uuid(), 'first-bot');

INSERT INTO bot
values ('a8c6d9dd-b633-47e8-be9b-3ae2bdf9482a');
INSERT INTO bot
values ('27bc3357-e126-467b-b36d-879788550427');

select user_id
from users
where username = 'second-bot';


INSERT INTO users
values (gen_random_uuid(), 'second-bot');



INSERT INTO Conversation (conv_id)
VALUES ('12341234-1111-1234-1111-111111111111'); -- Mohammad → Ali

INSERT INTO Private_Chat (conv_id, is_secret_chat, wallpaper)
VALUES ('12341234-1111-1234-1111-111111111111', FALSE, NULL)
INSERT INTO User_Conversations (conv_id, user_id)
VALUES ('12341234-1111-1234-1111-111111111111', 'a8c6d9dd-b633-47e8-be9b-3ae2bdf9482a'),
       ('12341234-1111-1234-1111-111111111111', '09ff06c8-ef3a-4d42-bd67-45071dd3fea1');



select AVG(LENGTH(normal_message.text)) AS avg_text_length
from normal_message
         natural join message as nsmg
where conv_id in (select conv_id
                  from User_Conversations
                  where user_id in (select users.user_id from users where username = 'first-bot'));
