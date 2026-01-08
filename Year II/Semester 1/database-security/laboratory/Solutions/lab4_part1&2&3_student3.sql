select * from session_privs;
select * from session_roles;

select * from user_tab_privs;
select * from user_col_privs;

--nok, because student3 is in undergraduate 3rd year
insert into elearn_app_admin.solves(homework_id, student_id, upload_date) values(1, 1, sysdate);

