# https://askubuntu.com/questions/53177/bash-script-to-set-environment-variables-not-working
echo "Populate SNOWSQL_ACCOUNT environment variable..."
export SNOWSQL_ACCOUNT=$(aws ssm get-parameter --name /snowflake/dev/ac-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_USER environment variable..." 
export SNOWSQL_USER=$(aws ssm get-parameter --name /snowflake/dev/un-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_PWD environment variable..." 
export SNOWSQL_PWD=$(aws ssm get-parameter --name /snowflake/dev/pw-param --with-decryption --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_WAREHOUSE environment variable..." 
export SNOWSQL_WAREHOUSE=$(aws ssm get-parameter --name /snowflake/dev/wh-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_DATABASE environment variable..." 
export SNOWSQL_DATABASE=$(aws ssm get-parameter --name /snowflake/dev/db-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_SCHEMA environment variable..." 
export SNOWSQL_SCHEMA=$(aws ssm get-parameter --name /snowflake/dev/schema-param --query Parameter.Value | cut -d '"' -f 2)