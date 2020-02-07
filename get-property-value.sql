!set quiet=true;
!set echo=false;
!set friendly=false;
!set header=false;
!set timing=false;

SET
   QUERYID = 
   (
      SELECT TOP 1 QUERY_ID::VARCHAR
        FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
        WHERE QUERY_TEXT = 'DESC STORAGE INTEGRATION tfgm_da_snowflake_landing_integration;' 
      ORDER BY start_time DESC
   );

SELECT "property_value" FROM table(result_scan($QUERYID))
WHERE "property" = 'STORAGE_AWS_IAM_USER_ARN';

SELECT "property_value" FROM table(result_scan($QUERYID))
WHERE "property" = 'STORAGE_AWS_EXTERNAL_ID';