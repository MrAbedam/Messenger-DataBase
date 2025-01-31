
INSERT INTO Media (path, media_type, file_size, uploader_id)
VALUES
    ('/path/to/raad_media4.jpg', 'image', 5600, '00fb9bb7-0c85-409d-b7b5-f13c783be03d'),
    ('/path/to/raad_media5.mp4', 'video', 15000, '00fb9bb7-0c85-409d-b7b5-f13c783be03d');

WITH UserGroupCount AS (
    SELECT
        user_id,
        COUNT(conv_id) AS group_count
    FROM
        Member_of
    GROUP BY
        user_id
),
TopUser AS (
    SELECT
        user_id
    FROM
        UserGroupCount
    ORDER BY
        group_count DESC
    LIMIT 1
)
SELECT
    username,
    COALESCE(SUM(m.file_size), 0) AS total_uploaded_file_size
FROM
    Users
    JOIN TopUser tu ON Users.user_id = tu.user_id
    LEFT JOIN Media m ON Users.user_id = m.uploader_id
GROUP BY
    username;

