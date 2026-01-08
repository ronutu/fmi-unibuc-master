--Lab 4
--2.3
execute elearn_app_admin.delete_spam('avantajos');

select * from session_privs;

--Exercises
--1
-- Test method 1
select * from elearn_app_admin.homework;

-- Test method 2
select * from elearn_app_admin.view_homework;

-- Test method 3
select * from elearn_app_admin.homework; --successful only after user reconnects
------
--2
select * from session_privs;
select * from session_roles;
select * from user_tab_privs;
select * from user_col_privs;

--Method 1
update elearn_app_admin.homework set deadline = deadline + 10 where id = 1;
select * from elearn_app_admin.homework;
commit;

--Method 2
update elearn_app_admin.view_homework set deadline = deadline + 10 where id = 1;

select * from elearn_app_admin.view_homework;
rollback;

update elearn_app_admin.view_homework set id = 5 where id = 1;

--Method 3
update elearn_app_admin.homework set deadline = deadline + 10 where id = 1;
select * from elearn_app_admin.homework;

update elearn_app_admin.homework set deadline = deadline - 10 where id = 1;

commit;

update elearn_app_admin.homework set deadline = deadline + 10 where id = 1;

commit;

--3
select * from elearn_app_admin.solves;

execute elearn_app_admin.proc_marking(10, 1, 3, 4);
execute elearn_app_admin.proc_marking(30, 1, 3, 8);

--after revoke:
execute elearn_app_admin.proc_marking(40, 2, 3, 10); --not OK
