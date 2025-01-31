WITH UserGroupCount AS (
    SELECT
        user_id,
        COUNT(conv_id) AS group_count
    FROM
        Member_of
    GROUP BY
        user_id
),
WantedUsers AS (
    SELECT
        user_id
    FROM
        UserGroupCount
    WHERE
        group_count <= 1
)
SELECT
    hu.first_name
FROM
    human_user hu
WHERE
    hu.user_id IN (SELECT user_id FROM WantedUsers)
    OR hu.user_id NOT IN (SELECT user_id FROM Member_of);
