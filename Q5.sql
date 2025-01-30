
INSERT INTO Media (path, media_type, file_size, uploader_id)
VALUES
    ('/path/to/raad_media1.jpg', 'image', 5000, '00fb9bb7-0c85-409d-b7b5-f13c783be03d'),
    ('/path/to/raad_media2.mp4', 'video', 15000, '00fb9bb7-0c85-409d-b7b5-f13c783be03d');

WITH UserGroupCount AS (
    SELECT
        mo.user_id,
        COUNT(mo.conv_id) AS group_count
    FROM
        Member_of mo
    GROUP BY
        mo.user_id
),
TopUser AS (
    SELECT
        ugc.user_id
    FROM
        UserGroupCount ugc
    ORDER BY
        ugc.group_count DESC
    LIMIT 1
)
SELECT
    u.username,
    COALESCE(SUM(m.file_size), 0) AS total_uploaded_file_size
FROM
    Users u
    JOIN TopUser tu ON u.user_id = tu.user_id
    LEFT JOIN Media m ON u.user_id = m.uploader_id
GROUP BY
    u.username;

