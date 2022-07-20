

-- role names:
set ingestion_role_name = 'INGESTION'; --reproting tools/business users
set transformation_role_name = 'TRANSFORMATION'; --ETL Tools
set reporting_role_name = 'REPORTING'; --Transformation tool(DBT)/Data team
set datateam_role_name = 'DATATEAM';

-- role names:
set reader_role_postfix = '__READER'; --reproting tools/business users
set writer_role_postfix = '__WRITE'; --ETL Tools
set admin_role_postfix = '__ADMIN'; --Transformation tool(DBT)/Data team

--warehouse names:
set ingestion_wh_name = 'WH_INGESTION'; --ETL tool
set transformation_wh_name = 'WH_TRANSFORMATION'; --Transformation tool(DBT)
set reporting_wh_name = 'WH_REPORTING'; --Reporting tools
set datateam_wh_name = 'WH_DATATEAM'; -- Data team

--database name
set db_name = 'ANALYTICS';

--schema names:
set raw_schema_name = 'RAW';
set staging_schema_name = 'STG';
set dwh_schema_name = 'DWH';


--user names
set user1_name = 'Liat';
set user2_name = 'Yonatan';

--inital password
set initial_password = 'Data Guild Rocks';
--user_names5


set raw_reader_role_name = $raw_schema_name ||  $reader_role_postfix;
set raw_writer_role_name = $raw_schema_name ||  $writer_role_postfix;
set raw_admin_role_name = $raw_schema_name ||  $admin_role_postfix;
set stg_reader_role_name = $staging_schema_name ||  $reader_role_postfix;
set stg_writer_role_name = $staging_schema_name ||  $writer_role_postfix;
set stg_admin_role_name = $staging_schema_name ||  $admin_role_postfix;
set dwh_reader_role_name = $dwh_schema_name ||  $reader_role_postfix;
set dwh_writer_role_name = $dwh_schema_name ||  $writer_role_postfix;
set dwh_admin_role_name = $dwh_schema_name ||  $admin_role_postfix;







 

begin;
 --using sysadmin as i saw in an example
use role sysadmin;

--creating warehouses
create warehouse if not exists identifier($ingestion_wh_name)
 warehouse_size = xsmall
 warehouse_type = standard
 auto_suspend = 10
 auto_resume = true
 initially_suspended = true;
 
create warehouse if not exists identifier($transformation_wh_name)
 warehouse_size = xsmall
 warehouse_type = standard
 auto_suspend = 10
 auto_resume = true
 initially_suspended = true;
 
create warehouse if not exists identifier($reporting_wh_name)
 warehouse_size = xsmall
 warehouse_type = standard
 auto_suspend = 10
 auto_resume = true
 initially_suspended = true;
 
create warehouse if not exists identifier($datateam_wh_name)
 warehouse_size = xsmall
 warehouse_type = standard
 auto_suspend = 60
 auto_resume = true
 initially_suspended = true;
 
 


 -- create databases
 create database if not exists identifier($db_name);

 commit;
 

 
 
 --create schemas
begin;
use role sysadmin;
USE DATABASE identifier($db_name);
CREATE SCHEMA IF NOT EXISTS identifier($raw_schema_name);
CREATE SCHEMA IF NOT EXISTS identifier($staging_schema_name);
CREATE SCHEMA IF NOT EXISTS identifier($dwh_schema_name);

commit;

 BEGIN;
  use role securityadmin;
  --creating roles
--functional roles
create role if not exists identifier($ingestion_role_name);
create role if not exists identifier($transformation_role_name);
create role if not exists identifier($reporting_role_name);
create role if not exists identifier($datateam_role_name);
--schema specific roles
create role if not exists identifier($raw_reader_role_name);
create role if not exists identifier($raw_writer_role_name);
create role if not exists identifier($raw_admin_role_name);
create role if not exists identifier($stg_reader_role_name);
create role if not exists identifier($stg_writer_role_name);
create role if not exists identifier($stg_admin_role_name);
create role if not exists identifier($dwh_reader_role_name);
create role if not exists identifier($dwh_writer_role_name);
create role if not exists identifier($dwh_admin_role_name);

commit;


begin;
use role securityadmin;
 -- create  users
 create user if not exists identifier($user1_name)
 password = $initial_password
 MUST_CHANGE_PASSWORD = TRUE
 default_role = $transformation_role_name
 default_warehouse = $transformation_wh_name;
 
create user if not exists identifier($user2_name)
 password = $initial_password
 MUST_CHANGE_PASSWORD = TRUE
 default_role = $reporting_role_name
 default_warehouse = $reporting_wh_name;
 
commit;

--grant roles to users
begin;
use role securityadmin;
grant role identifier($transformation_role_name) to user identifier($user1_name);
grant role identifier($reporting_role_name) to user identifier($user2_name);
commit;



begin;
use role securityadmin;
 -- grant  warehouse access
 grant USAGE
 on warehouse identifier($ingestion_wh_name)
 to role identifier($ingestion_role_name);
 
 grant USAGE
 on warehouse identifier($reporting_wh_name)
 to role identifier($transformation_role_name);
 
 grant USAGE
 on warehouse identifier($transformation_wh_name)
 to role identifier($reporting_role_name);

 grant USAGE
 on warehouse identifier($transformation_wh_name)
 to role identifier($datateam_role_name);

 commit;
 

 begin;

 -- grant db access
 use role securityadmin;
 
grant ALL
 on database identifier($db_name)
 to role identifier($datateam_role_name);
 
grant USAGE
 on database identifier($db_name)
 to role identifier($ingestion_role_name);
 
grant USAGE
 on database identifier($db_name)
 to role identifier($reporting_role_name);

 
grant USAGE
 on database identifier($db_name)
 to role identifier($transformation_role_name);

 commit;

 --grant schema specific roles to functional roles
 begin;
use role securityadmin;
grant role identifier($raw_admin_role_name) to role identifier($datateam_role_name);
grant role identifier($stg_admin_role_name) to role identifier($datateam_role_name);
grant role identifier($dwh_admin_role_name) to role identifier($datateam_role_name);

grant role identifier($raw_writer_role_name) to role identifier($ingestion_role_name);

grant role identifier($stg_writer_role_name) to role identifier($transformation_role_name);
grant role identifier($dwh_writer_role_name) to role identifier($transformation_role_name);

grant role identifier($dwh_reader_role_name) to role identifier($transformation_role_name);

commit;


  -- grant schema access to schema specific roles
begin;
use role sysadmin;
USE DATABASE identifier($db_name);

grant ALL on schema identifier($raw_schema_name) to role identifier($raw_admin_role_name);

grant USAGE on schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);
grant CREATE TABLE on schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);
grant CREATE VIEW on schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);
grant MONITOR on schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);

grant USAGE on schema identifier($raw_schema_name) to role identifier($raw_reader_role_name);
grant MONITOR on schema identifier($raw_schema_name) to role identifier($raw_reader_role_name);


grant ALL on schema identifier($staging_schema_name) to role identifier($stg_admin_role_name);

grant USAGE on schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);
grant CREATE TABLE on schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);
grant CREATE VIEW on schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);
grant MONITOR on schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);

grant USAGE on schema identifier($staging_schema_name) to role identifier($stg_reader_role_name);
grant MONITOR on schema identifier($staging_schema_name) to role identifier($stg_reader_role_name);


grant ALL on schema identifier($dwh_schema_name) to role identifier($dwh_admin_role_name);

grant USAGE on schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);
grant CREATE TABLE on schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);
grant CREATE VIEW on schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);
grant MONITOR on schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);

grant USAGE on schema identifier($dwh_schema_name) to role identifier($dwh_reader_role_name);
grant MONITOR on schema identifier($dwh_schema_name) to role identifier($dwh_reader_role_name);

 commit;

  -- grant future table access to schema specific roles
begin;
use role ACCOUNTADMIN;
USE DATABASE identifier($db_name);

grant ALL on  future tables in schema identifier($raw_schema_name) to role identifier($raw_admin_role_name);

grant SELECT on future tables in  schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);
grant INSERT on future tables in  schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);
grant DELETE on future tables in  schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);

grant SELECT on future tables in  schema identifier($raw_schema_name) to role identifier($raw_reader_role_name);

grant ALL on future tables in  schema identifier($staging_schema_name) to role identifier($stg_admin_role_name);

grant SELECT on future tables in  schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);
grant INSERT on future tables in  schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);
grant DELETE on future tables in  schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);

grant SELECT on future tables in  schema identifier($staging_schema_name) to role identifier($stg_reader_role_name);

grant ALL on future tables in  schema identifier($dwh_schema_name) to role identifier($dwh_admin_role_name);

grant SELECT on future tables in  schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);
grant INSERT on future tables in  schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);
grant DELETE on future tables in  schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);

grant SELECT on future tables in schema identifier($dwh_schema_name) to role identifier($dwh_reader_role_name);

 commit;

  -- grant future view access to schema specific roles
begin;
use role ACCOUNTADMIN;
USE DATABASE identifier($db_name);

grant ALL on  future views  in schema identifier($raw_schema_name) to role identifier($raw_admin_role_name);

grant SELECT on future views in  schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);
grant INSERT on future views in  schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);
grant DELETE on future views in  schema identifier($raw_schema_name) to role identifier($raw_writer_role_name);

grant SELECT on future views in  schema identifier($raw_schema_name) to role identifier($raw_reader_role_name);

grant ALL on future views in  schema identifier($staging_schema_name) to role identifier($stg_admin_role_name);

grant SELECT on future views in  schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);
grant INSERT on future views in  schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);
grant DELETE on future views in  schema identifier($staging_schema_name) to role identifier($stg_writer_role_name);

grant SELECT on future views in  schema identifier($staging_schema_name) to role identifier($stg_reader_role_name);

grant ALL on future views in  schema identifier($dwh_schema_name) to role identifier($dwh_admin_role_name);

grant SELECT on future views in  schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);
grant INSERT on future views in  schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);
grant DELETE on future views in  schema identifier($dwh_schema_name) to role identifier($dwh_writer_role_name);

grant SELECT on future views in schema identifier($dwh_schema_name) to role identifier($dwh_reader_role_name);

 commit;