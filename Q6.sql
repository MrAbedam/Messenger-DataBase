
select first_name from human_user
where human_user.user_id in (SELECT user_id from member_of group by user_id  having count(conv_id) < 2)
or human_user.user_id not in (SELECT user_id from member_of);




