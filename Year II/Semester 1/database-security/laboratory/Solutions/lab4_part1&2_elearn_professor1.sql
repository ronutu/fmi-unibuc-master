--1
select * from session_privs;

select * from tab;

ALTER TABLE ELEARN_professor1.FEEDBACK drop column feedback_date;

DROP TABLE ELEARN_professor1.FEEDBACK ;

INSERT INTO ELEARN_professor1.FEEDBACK VALUES (1, 'very interesting and useful subject', SYSDATE);

select * from ELEARN_professor1.FEEDBACK ;

--2
--2.1
INSERT INTO ELEARN_APP_ADMIN.COURSE VALUES (2,'NETWORKING',3, 2,5,'E',28,28,0);

delete from feedback;
commit;

desc feedback;

select * from feedback;

--Exercises
--1
select * from elearn_app_admin.homework;

--2
select * from user_tab_privs;
select * from session_roles;