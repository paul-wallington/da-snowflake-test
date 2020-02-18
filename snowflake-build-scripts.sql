// Create Schema
CREATE SCHEMA stg

// Create File Format
CREATE OR REPLACE FILE FORMAT JSON_FILE_TYPE
  TYPE = JSON
  IGNORE_UTF8_ERRORS = TRUE
;

// Create Tables
CREATE OR REPLACE TABLE stg.OutputArea
(
    OutputAreaKey INT NOT NULL IDENTITY(1, 1),
    DataSourceKey TINYINT NULL,
    OutputArea CHAR(9),
    LowerSuperOutputArea CHAR(9),
    MiddleSuperOutputArea CHAR(9),
    LocalAuthorityDistrict CHAR(9),
    LowerSuperOutputAreaName VARCHAR(50),
    MiddleSuperOutputAreaName VARCHAR(50),
    LocalAuthorityDistrictName VARCHAR(50)
)

CREATE OR REPLACE TABLE stg.OutputAreaJson
(
    JsonString VARIANT
)


// Create View
CREATE OR REPLACE VIEW stg.vOutputArea COMMENT='Test view' 
AS
SELECT DISTINCT 69 AS DataSourceKey,
f.value:attributes.oa11cd AS OutputArea, 
f.value:attributes.lsoa11cd AS LowerSuperOutputArea, 
f.value:attributes.msoa11cd AS MiddleSuperOutputArea, 
f.value:attributes.ladcd AS LocalAuthorityDistrict, 
f.value:attributes.lsoa11nm AS LowerSuperOutputAreaName, 
f.value:attributes.msoa11nm AS MiddleSuperOutputAreaName, 
f.value:attributes.ladnm AS LocalAuthorityDistrictName
FROM stg.OutputAreaJson OAJ
  , lateral flatten(input => jsonstring:features) f   
ORDER BY f.value:attributes.oa11cd


// https://docs.snowflake.net/manuals/user-guide/data-load-s3-config.html#

// OPTION 1 
// https://docs.snowflake.net/manuals/user-guide/data-load-s3-config.html#option-1-configuring-a-snowflake-storage-integration
// Creating a storage integration is recommended by snowflake. Currently have Insufficient privileges to do this on dev sandbox

// Create Integration
CREATE OR REPLACE STORAGE INTEGRATION stg.da_snowflake_landing_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE   
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::177539856531:role/eu-west-2-da-snowflake-s3-access-role-da-snowflake-landing'
  STORAGE_ALLOWED_LOCATIONS = ('s3://da-snowflake-landing/stg/OutputAreaJson/')
  
GRANT USAGE ON integration da_snowflake_landing_integration to role SYSADMIN;

// Create Stage
CREATE OR REPLACE stage da_snowflake_landing
  storage_integration = da_snowflake_landing_integration
  url='s3://da-snowflake-landing/stg/OutputAreaJson/'
  file_format = JSON_FILE_TYPE
  //on_error='skip'

GRANT CREATE stage on schema STG to SYSADMIN;
GRANT USAGE ON stage da_snowflake_landing to role SYSADMIN;
