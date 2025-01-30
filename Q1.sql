
INSERT INTO Conversation (conv_id) VALUES ('11111111-1111-1111-1111-111111111111'); -- Mohammad → Ali
INSERT INTO Conversation (conv_id) VALUES ('22222222-2222-2222-2222-222222222222'); -- Ali → Mohammad

INSERT INTO Private_Chat (conv_id, is_secret_chat, wallpaper)
VALUES
    ('11111111-1111-1111-1111-111111111111', FALSE, NULL),
    ('22222222-2222-2222-2222-222222222222', FALSE, NULL);

INSERT INTO User_Conversations (conv_id, user_id, exception_notification)
VALUES
    ('11111111-1111-1111-1111-111111111111', '14cb8e3c-d10c-42ba-81f7-931f50443806', NULL), -- Mohammad
    ('11111111-1111-1111-1111-111111111111', '3b5c1a1d-aebc-40eb-b063-ab60ba0514cf', NULL), -- Ali
    ('22222222-2222-2222-2222-222222222222', '3b5c1a1d-aebc-40eb-b063-ab60ba0514cf', NULL), -- Ali
    ('22222222-2222-2222-2222-222222222222', '14cb8e3c-d10c-42ba-81f7-931f50443806', NULL); -- Mohammad

INSERT INTO Has_PV (conv_id, user_id)
VALUES
    ('11111111-1111-1111-1111-111111111111', '14cb8e3c-d10c-42ba-81f7-931f50443806'), -- Mohammad
    ('11111111-1111-1111-1111-111111111111', '3b5c1a1d-aebc-40eb-b063-ab60ba0514cf'), -- Ali
    ('22222222-2222-2222-2222-222222222222', '3b5c1a1d-aebc-40eb-b063-ab60ba0514cf'), -- Ali
    ('22222222-2222-2222-2222-222222222222', '14cb8e3c-d10c-42ba-81f7-931f50443806'); -- Mohammad

INSERT INTO Media (media_id, path, media_type, file_size, uploader_id)
VALUES
    ('aaaaaa1-1111-1111-1111-111111111111', 'sticker1.png', 'sticker', 500, '14cb8e3c-d10c-42ba-81f7-931f50443806'),
    ('aaaaaa2-2222-2222-2222-222222222222', 'sticker2.png', 'sticker', 600, '14cb8e3c-d10c-42ba-81f7-931f50443806'),
    ('aaaaaa3-3333-3333-3333-333333333333', 'sticker3.png', 'sticker', 550, '14cb8e3c-d10c-42ba-81f7-931f50443806'),
    ('aaaaaa4-4444-4444-4444-444444444444', 'sticker4.png', 'sticker', 580, '14cb8e3c-d10c-42ba-81f7-931f50443806');

INSERT INTO Sticker (sticker_id, emoji, media_id, sticker_pack_id)
VALUES
    ('12345678-1111-1111-1111-111111111111', '😂', 'aaaaaa1-1111-1111-1111-111111111111', NULL),
    ('12345678-2222-2222-2222-222222222222', '🔥', 'aaaaaa2-2222-2222-2222-222222222222', NULL),
    ('12345678-3333-3333-3333-333333333333', '👍', 'aaaaaa3-3333-3333-3333-333333333333', NULL),
    ('12345678-4444-4444-4444-444444444444', '🎉', 'aaaaaa4-4444-4444-4444-444444444444', NULL);

INSERT INTO Send_Slicker (user_id, sticker_id, counter)
VALUES
    ('14cb8e3c-d10c-42ba-81f7-931f50443806', '12345678-1111-1111-1111-111111111111', 1), -- Sent once
    ('14cb8e3c-d10c-42ba-81f7-931f50443806', '12345678-2222-2222-2222-222222222222', 2), -- Sent twice
    ('14cb8e3c-d10c-42ba-81f7-931f50443806', '12345678-3333-3333-3333-333333333333', 2), -- Sent twice
    ('14cb8e3c-d10c-42ba-81f7-931f50443806', '12345678-4444-4444-4444-444444444444', 2); -- Sent twice


select send_slicker.sticker_id as sticker_id, counter as number_of_sends from send_slicker natural join users
                     where username ='mohamad'
order by send_slicker.counter desc
limit 3;