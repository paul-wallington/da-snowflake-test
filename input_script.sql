!set output_format=plain;
!set echo=False;
DESC STORAGE INTEGRATION tfgm_da_snowflake_landing_integration;

SET
   QUERYID = 
   (
      SELECT
         TOP 1 QUERY_ID 
      FROM
         table(information_schema.query_history_by_session()) 
      WHERE
         QUERY_TEXT = 'DESC STORAGE INTEGRATION tfgm_da_snowflake_landing_integration;' 
         AND SESSION_ID IN 
         (
            SELECT
               CURRENT_SESSION()
         )
      ORDER BY
         start_time DESC
   );


SELECT "property_value" FROM table(result_scan($QUERYID))
WHERE "property" = 'STORAGE_AWS_IAM_USER_ARN';