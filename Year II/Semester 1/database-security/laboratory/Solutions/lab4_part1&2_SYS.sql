--Lab 4
--1.1
GRANT CREATE SESSION TO ELEARN_APP_ADMIN;

--1.2
GRANT CREATE TABLE TO ELEARN_APP_ADMIN;

--1.3
select name from
system_privilege_map where
name like '%ANY%' order by name;

GRANT CREATE ANY TABLE TO ELEARN_APP_ADMIN;

GRANT CREATE ANY INDEX TO ELEARN_APP_ADMIN;

select owner, object_name from all_objects where owner like '%ELEARN%';

GRANT ALTER ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN;

--2
--2.2
GRANT CREATE ANY TABLE TO ELEARN_APP_ADMIN;
GRANT CREATE ANY INDEX TO ELEARN_APP_ADMIN;

GRANT CREATE VIEW TO ELEARN_APP_ADMIN ;

GRANT SELECT ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT SELECT ON ELEARN_professor2.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT SELECT ON ELEARN_assistant3.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;

GRANT CREATE TRIGGER TO ELEARN_APP_ADMIN;

GRANT INSERT ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT INSERT ON ELEARN_professor2.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT INSERT ON ELEARN_assistant3.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;

--2.3
GRANT CREATE PROCEDURE TO ELEARN_APP_ADMIN;

GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;

REVOKE DELETE ON ELEARN_professor1.FEEDBACK FROM ELEARN_APP_ADMIN;
GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN;


desc dba_role_privs;
desc dba_user_privs;
desc dba_tab_privs;

select grantee, owner, table_name, grantor, privilege, grantable
from dba_tab_privs
where lower(table_name) = 'feedback';

grant create role to elearn_app_admin;

SELECT * FROM DBA_role_privs WHERE grantee like '%ELEARN%';

-- Lab 4 
-- 2.3 case 2) revisited

REVOKE EXECUTE ON ELEARN_APP_ADMIN.DELETE_SPAM FROM
ELEARN_assistant3;

REVOKE DELETE ON ELEARN_professor1.FEEDBACK FROM ELEARN_APP_ADMIN;
GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN;
GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN with grant option;

------

--PART 2

alter pluggable database orclpdb open;

show con_name;

alter session set container=orclpdb;

grant create role to elearn_app_admin;

alter user elearn_assistant3 identified by assistant3;