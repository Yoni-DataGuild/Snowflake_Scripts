

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
use role accountadmin;


drop warehouse if  exists identifier($ingestion_wh_name);
drop warehouse if  exists identifier($transformation_wh_name);
drop warehouse if  exists identifier($reporting_wh_name);
drop warehouse if  exists identifier($datateam_wh_name);


drop role if exists identifier($ingestion_role_name);
drop role if exists identifier($transformation_role_name);
drop role if exists identifier($reporting_role_name);
drop role if exists identifier($datateam_role_name);
--schema specific roles
drop role if exists identifier($raw_reader_role_name);
drop role if exists  identifier($raw_writer_role_name);
drop role if exists  identifier($raw_admin_role_name);
drop role if exists  identifier($stg_reader_role_name);
drop role if exists  identifier($stg_writer_role_name);
drop role if exists  identifier($stg_admin_role_name);
drop role if exists  identifier($dwh_reader_role_name);
drop role if exists  identifier($dwh_writer_role_name);
drop role if exists  identifier($dwh_admin_role_name);

drop user if exists identifier($user1_name);
drop user if exists identifier($user2_name);

USE DATABASE identifier($db_name);
DROP SCHEMA IF EXISTS identifier($raw_schema_name);
DROP SCHEMA IF EXISTS identifier($staging_schema_name);
DROP SCHEMA IF EXISTS identifier($dwh_schema_name);
drop database if exists identifier($db_name);






commit;