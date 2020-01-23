DESC STORAGE INTEGRATION tfgm_da_snowflake_landing_integration;
SELECT "property_value" FROM table(result_scan(last_query_id()))
WHERE "property" = 'STORAGE_AWS_IAM_USER_ARN';