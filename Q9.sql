WITH UserIDs AS (
    SELECT user_id,username
    FROM users
    WHERE username IN ('User1', 'mmdhraad')
),
CommonGroups AS (
    SELECT mo1.conv_id
    FROM Member_of mo1
    JOIN Member_of mo2 ON mo1.conv_id = mo2.conv_id
    WHERE mo1.user_id = (SELECT user_id FROM UserIDs WHERE username = 'User1')
      AND mo2.user_id = (SELECT user_id FROM UserIDs WHERE username = 'mmdhraad')
)
SELECT text
FROM Message natural join normal_message
WHERE conv_id IN (SELECT conv_id FROM CommonGroups);


-- all types:
--SELECT m.*
--FROM Message m
--WHERE m.conv_id IN (SELECT conv_id FROM CommonGroups);
--

--- chon midunim normal message and join mizanim vagarana halat adi mitavanad poll_message ya sticker_message ham bashad