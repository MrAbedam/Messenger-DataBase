INSERT INTO Conversation (conv_id)
VALUES ('12341234-1111-1111-1111-111111111111'); -- Mohammad → Ali

INSERT INTO public_conversation (conv_id, owner_user_id, title)
VALUES ('12341234-1111-1111-1111-111111111111',
        '00fb9bb7-0c85-409d-b7b5-f13c783be03d', 'ch1');

INSERT INTO channel(conv_id)
values ('12341234-1111-1111-1111-111111111111');

INSERT INTO User_Conversations (conv_id, user_id)
VALUES ('12341234-1111-1111-1111-111111111111', '00fb9bb7-0c85-409d-b7b5-f13c783be03d');

INSERT INTO subscribed_to (conv_id, user_id)
VALUES ('12341234-1111-1111-1111-111111111111', '00fb9bb7-0c85-409d-b7b5-f13c783be03d');


INSERT INTO Conversation (conv_id)
VALUES ('56785678-1111-1111-1111-111111111111'); -- Mohammad → Ali

INSERT INTO public_conversation (conv_id, owner_user_id, title)
VALUES ('56785678-1111-1111-1111-111111111111',
        '00fb9bb7-0c85-409d-b7b5-f13c783be03d', 'ch2');
INSERT INTO channel(conv_id)
values ('56785678-1111-1111-1111-111111111111');
INSERT INTO User_Conversations (conv_id, user_id)
VALUES ('56785678-1111-1111-1111-111111111111', '00fb9bb7-0c85-409d-b7b5-f13c783be03d');

INSERT INTO subscribed_to (conv_id, user_id)
VALUES ('56785678-1111-1111-1111-111111111111', '00fb9bb7-0c85-409d-b7b5-f13c783be03d');



INSERT INTO Conversation (conv_id)
VALUES ('43214321-1111-1111-1111-111111111111'); -- Mohammad → Ali

INSERT INTO public_conversation (conv_id, owner_user_id, title)
VALUES ('43214321-1111-1111-1111-111111111111',
        '09ff06c8-ef3a-4d42-bd67-45071dd3fea1', 'ch3');
INSERT INTO channel(conv_id)
values ('43214321-1111-1111-1111-111111111111');
INSERT INTO User_Conversations (conv_id, user_id)
VALUES ('43214321-1111-1111-1111-111111111111', '09ff06c8-ef3a-4d42-bd67-45071dd3fea1');


INSERT INTO subscribed_to (conv_id, user_id)
VALUES ('43214321-1111-1111-1111-111111111111', '09ff06c8-ef3a-4d42-bd67-45071dd3fea1');



SELECT username from users join
(select owner_user_id from  public_conversation
where conv_id in (select conv_id from channel)) on owner_user_id = users.user_id group by username having count(username) > 1