-- connect /as sysdba
-- alter session set container=CINEMA;
-- grant sysdba to cinema_admin;
-- grant create tablespace to cinema_admin;
-- alter session set container=CDB$ROOT;

create tablespace TS_CINEMA
    datafile 'C:\app\Nastia2211\oradata\orcl\cinema\TS_CINEMA.dbf'
    size 10m
    autoextend on next 5m
    maxsize 30m;

create temporary tablespace TS_CINEMA_TEMP
    tempfile 'C:\app\Nastia2211\oradata\orcl\cinema\TS_CINEMA_TEMP.dbf'
    size 10m
    autoextend on next 5m
    maxsize 30m;
  
-- connect /as sysdba
-- alter session set container=CINEMA;
-- grant create role to cinema_admin;
-- alter session set container=CDB$ROOT;
-- create role RL_CINEMA_ADMIN;
create role RL_CINEMA_USER;

-- grant create profile to cinema_admin;
create profile PF_CINEMA_USER limit
    password_life_time 180 
    sessions_per_user 3 
    failed_login_attempts 7 
    password_lock_time 1 
    password_reuse_time 10
    password_grace_time default
    connect_time 180
    idle_time 30;

-- grant create user profile to cinema_admin;    
create user CINEMA_USER identified by user123
    default tablespace TS_CINEMA
    temporary tablespace TS_CINEMA_TEMP
    profile PF_CINEMA_USER
    account unlock;

    



