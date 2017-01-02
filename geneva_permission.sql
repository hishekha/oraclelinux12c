create user geneva_admin identified by geneva_admin default tablespace users temporary tablespace temp profile default;
grant dba, connect to geneva_admin;

grant select on sys.dba_roles to geneva_admin;
grant select on sys.dba_role_privs to geneva_admin;
grant select on sys.dba_tab_privs to geneva_admin;
grant select on sys.dba_data_files to geneva_admin;
grant select on sys.dba_profiles to geneva_admin with grant option;
grant select on sys.dba_users to geneva_admin with grant option;
grant select on sys.dba_tablespaces to geneva_admin with grant option;
grant select on sys.gv_$sqlarea to geneva_admin;
grant select on sys.gv_$session to geneva_admin;
grant select on sys.gv_$transaction to geneva_admin;
grant alter session to geneva_admin;
grant grant any roles to geneva_admin;
grant create role to geneva_admin;
grant create sequence to geneva_admin;
grant create table to geneva_admin;
grant create view to geneva_admin;
grant create trigger to geneva_admin;
grant alter tablespace to geneva_admin;
grant create public synonym to geneva_admin;
grant drop public synonym to geneva_admin;

grant execute on dbms_alert to geneva_admin;
grant execute on dbms_pipe to geneva_admin;
grant execute on dbms_lock to geneva_admin;
grant execute on dbms_server_alert to geneva_admin;
grant execute on sys.server_error to geneva_admin;
grant execute on sys.server_error_msg to geneva_admin;
grant execute on sys.space_error_info to geneva_admin;
grant administer database trigger to geneva_admin;

grant execute on dbms_aq to geneva_admin with grant option;
grant select on sys.dba_queue_schedules to geneva_admin with grant option;
grant select on sys.dba_queue_subscribers to geneva_admin with grant option;

grant execute on dbms_streams_adm to geneva_admin with grant option;
grant execute on dbms_capture_adm to geneva_admin with grant option;
grant execute on dbms_apply_adm to geneva_admin with grant option;
grant execute on dbms_propagation_adm to geneva_admin with grant option;
                                            
grant select on sys.dba_propagation to geneva_admin with grant option;
grant select on sys.dba_capture to geneva_admin with grant option;
grant select on sys.dba_apply to geneva_admin with grant option;
grant select on sys.dba_streams_rules to geneva_admin with grant option;
                                            
grant execute on dbms_streams_messaging to geneva_admin with grant option;
grant execute on dbms_streams to geneva_admin with grant option;
grant execute on dbms_rule_adm to geneva_admin with grant option;
grant execute on dbms_aqadm to geneva_admin;