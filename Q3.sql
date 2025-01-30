SELECT c.title AS group_name, COUNT(DISTINCT message_id) AS message_count
FROM groups g
         JOIN public_conversation c ON g.conv_id = c.conv_id
         JOIN Member_of m ON g.conv_id = m.conv_id
         JOIN Message msg ON c.conv_id = msg.conv_id
GROUP BY c.title
HAVING COUNT(DISTINCT m.user_id) > 2
ORDER BY message_count DESC;



INSERT INTO Member_of
values ('00fb9bb7-0c85-409d-b7b5-f13c783be03d',
        'f29062ea-b948-48ab-9017-77483c76b3b3');

INSERT INTO Member_of
values ('14cb8e3c-d10c-42ba-81f7-931f50443806',
        'f29062ea-b948-48ab-9017-77483c76b3b3');

INSERT INTO Member_of
values ('3330570c-337e-484a-8ff3-3f6d85cbb03f',
        'f29062ea-b948-48ab-9017-77483c76b3b3');

INSERT INTO Member_of
values ('1cd97282-a5e2-4bce-b16d-86b0f8e9ba88',
        'f29062ea-b948-48ab-9017-77483c76b3b3');

INSERT INTO user_conversations
values ('f29062ea-b948-48ab-9017-77483c76b3b3',
        '1cd97282-a5e2-4bce-b16d-86b0f8e9ba88');

INSERT INTO user_conversations
values ('f29062ea-b948-48ab-9017-77483c76b3b3',
        '3330570c-337e-484a-8ff3-3f6d85cbb03f');

INSERT INTO user_conversations
values ('f29062ea-b948-48ab-9017-77483c76b3b3',
        'f29062ea-b948-48ab-9017-77483c76b3b3');

INSERT INTO user_conversations
values ('f29062ea-b948-48ab-9017-77483c76b3b3',
        '00fb9bb7-0c85-409d-b7b5-f13c783be03d');


SELECT pc.conv_id, title
from public_conversation as pc
         join groups on groups.conv_id = pc.conv_id;

INSERT INTO public_conversation
values ('7b435b0d-d571-49f1-b6bf-4f4bf0e9384b',
        '00fb9bb7-0c85-409d-b7b5-f13c783be03d',
        'Group2');
INSERT INTO groups
values ('7b435b0d-d571-49f1-b6bf-4f4bf0e9384b');

INSERT INTO Member_of
values ('00fb9bb7-0c85-409d-b7b5-f13c783be03d',
        '7b435b0d-d571-49f1-b6bf-4f4bf0e9384b');

-- (select pc.title, pc.conv_id
--  from public_conversation as pc
--           join (select member_of.conv_id, count(*) as num from member_of) on pc.conv_id = member_of.conv_id
--  GROUP BY

select count(*)
from message;