echo "Change directory to root..."
cd ~/
echo "Create .bash_profile..."
touch .bash_profile
echo "Get snowsql bash install script..."
curl -O https://sfc-snowsql-updates.s3.us-west-2.amazonaws.com/bootstrap/1.1/linux_x86_64/snowsql-1.1.86-linux_x86_64.bash | bash
echo "Give snowsql bash install script 'execute' permissions..."
chmod u=rwx ./snowsql-1.1.86-linux_x86_64.bash
echo "Populate snowsql environment variables to enable automated install..."
SNOWSQL_DEST=~/bin SNOWSQL_LOGIN_SHELL=~/.bash_profile bash snowsql-1.1.86-linux_x86_64.bash
echo "Export root/bin folder to PATH environment variable..."
export PATH=~/bin:$PATH
echo "Reset shell..."
tset
echo "Remove snowsql bash install script..."
rm snowsql-1.1.86-linux_x86_64.bash
# https://askubuntu.com/questions/53177/bash-script-to-set-environment-variables-not-working
echo "Populate SNOWSQL_ACCOUNT environment variable..."
export SNOWSQL_ACCOUNT=$(aws ssm get-parameter --name /snowflake/dev/ac-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_USER environment variable..." 
export SNOWSQL_USER=$(aws ssm get-parameter --name /snowflake/dev/ro-un-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_PWD environment variable..." 
export SNOWSQL_PWD=$(aws ssm get-parameter --name /snowflake/dev/ro-pw-param --with-decryption --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_WAREHOUSE environment variable..." 
export SNOWSQL_WAREHOUSE=$(aws ssm get-parameter --name /snowflake/dev/wh-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_DATABASE environment variable..." 
export SNOWSQL_DATABASE=$(aws ssm get-parameter --name /snowflake/dev/db-param --query Parameter.Value | cut -d '"' -f 2)
echo "Populate SNOWSQL_SCHEMA environment variable..." 
export SNOWSQL_SCHEMA=$(aws ssm get-parameter --name /snowflake/dev/schema-param --query Parameter.Value | cut -d '"' -f 2)
snowsql -f /var/task/describe-integration.sql
snowsql STORAGE_AWS_IAM_USER_ARN=$(snowsql -f /var/task/get-property-value.sql)
echo $STORAGE_AWS_IAM_USER_ARN
cd /var/task/