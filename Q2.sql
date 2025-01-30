select first_name
from human_user
         join (select c_user_id
               from contact
                        join users on users.user_id = contact.user_id
               where users.username = 'mohamad'
               intersect
               (select c_user_id
                from contact
                         join users on users.user_id = contact.user_id
                where users.username = 'ali')) on human_user.user_id = c_user_id
group by first_name;






-- Add User 1
WITH new_user AS (
    INSERT INTO Users (user_id, username, bio)
        VALUES (gen_random_uuid(), 'User1', '')
        ON CONFLICT (user_id) DO NOTHING
        RETURNING user_id)
INSERT
INTO Human_user (user_id, phone_number, first_name, last_name)
SELECT user_id, '1111111111', 'Alice', 'Smith'
FROM new_user
UNION ALL
SELECT user_id, '1111111111', 'Alice', 'Smith'
FROM Users
WHERE username = 'User1'
LIMIT 1;

-- Add User 2
WITH new_user AS (
    INSERT INTO Users (user_id, username, bio)
        VALUES (gen_random_uuid(), 'User2', '')
        ON CONFLICT (user_id) DO NOTHING
        RETURNING user_id)
INSERT
INTO Human_user (user_id, phone_number, first_name, last_name)
SELECT user_id, '2222222222', 'Bob', 'Johnson'
FROM new_user
UNION ALL
SELECT user_id, '2222222222', 'Bob', 'Johnson'
FROM Users
WHERE username = 'User2'
LIMIT 1;

-- Add User 3
WITH new_user AS (
    INSERT INTO Users (user_id, username, bio)
        VALUES (gen_random_uuid(), 'User3', '')
        ON CONFLICT (user_id) DO NOTHING
        RETURNING user_id)
INSERT
INTO Human_user (user_id, phone_number, first_name, last_name)
SELECT user_id, '3333333333', 'Charlie', 'Brown'
FROM new_user
UNION ALL
SELECT user_id, '3333333333', 'Charlie', 'Brown'
FROM Users
WHERE username = 'User3'
LIMIT 1;

-- Add User 4
WITH new_user AS (
    INSERT INTO Users (user_id, username, bio)
        VALUES (gen_random_uuid(), 'User4', '')
        ON CONFLICT (user_id) DO NOTHING
        RETURNING user_id)
INSERT
INTO Human_user (user_id, phone_number, first_name, last_name)
SELECT user_id, '4444444444', 'David', 'Williams'
FROM new_user
UNION ALL
SELECT user_id, '4444444444', 'David', 'Williams'
FROM Users
WHERE username = 'User4'
LIMIT 1;

-- Add User 5
WITH new_user AS (
    INSERT INTO Users (user_id, username, bio)
        VALUES (gen_random_uuid(), 'User5', '')
        ON CONFLICT (user_id) DO NOTHING
        RETURNING user_id)
INSERT
INTO Human_user (user_id, phone_number, first_name, last_name)
SELECT user_id, '5555555555', 'Eve', 'Jones'
FROM new_user
UNION ALL
SELECT user_id, '5555555555', 'Eve', 'Jones'
FROM Users
WHERE username = 'User5'
LIMIT 1;



select user_id
from Users
where username = 'User3';
-- Add contacts between User1 and others
INSERT INTO Contact (user_id, c_user_id, first_name, last_name)
VALUES ('14cb8e3c-d10c-42ba-81f7-931f50443806',
        '40d47981-58bc-4ef3-ac72-663b2a3b002a',
        'Baaa', 'Booo');

INSERT INTO Contact (user_id, c_user_id, first_name)
VALUES ('3b5c1a1d-aebc-40eb-b063-ab60ba0514cf',
        '40d47981-58bc-4ef3-ac72-663b2a3b002a',
        'Aghaye');



INSERT INTO Contact (user_id, c_user_id, first_name, last_name)
VALUES ('14cb8e3c-d10c-42ba-81f7-931f50443806',
        'a28d2ab8-dcb1-493c-8c79-599bea3f2bf0',
        'Baaaaaaa', 'Booooooo');

INSERT INTO Contact (user_id, c_user_id, first_name)
VALUES ('3b5c1a1d-aebc-40eb-b063-ab60ba0514cf',
        'a28d2ab8-dcb1-493c-8c79-599bea3f2bf0',
        'Khanoome');

INSERT INTO Contact (user_id, c_user_id, first_name)
VALUES ('3b5c1a1d-aebc-40eb-b063-ab60ba0514cf',
        '00fb9bb7-0c85-409d-b7b5-f13c783be03d',
        'Shabani');

