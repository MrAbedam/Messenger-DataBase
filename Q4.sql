

SELECT pc.title AS group_name, COUNT(m.message_id) AS message_count
FROM groups g
JOIN Public_Conversation pc ON g.conv_id = pc.conv_id
JOIN Message m ON g.conv_id = m.conv_id
WHERE m.send_time >= NOW() - INTERVAL '10 days'
GROUP BY pc.title
ORDER BY message_count DESC;

