#!/bin/bash
echo "Change directory to /root..."
cd ~/
echo "Create .bash_profile..."
touch .bash_profile
echo "Create .bashrc..."
touch .bashrc
echo "Export root/bin folder to .bashrc..."
echo 'export PATH=~/bin:$PATH' >>~/.bashrc
echo "Get snowsql bash install script..."
curl https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.2-linux_x86_64.bash -o snowsql-linux_x86_64.bash | bash
echo "Give snowsql bash install script 'execute' permissions..."
chmod u=rwx ./snowsql-linux_x86_64.bash
echo "Populate snowsql environment variables to enable automated install..."
SNOWSQL_DEST=~/bin SNOWSQL_LOGIN_SHELL=~/.bash_profile bash snowsql-linux_x86_64.bash
echo "Export root/bin folder to PATH environment variable..."
export PATH=~/bin:$PATH
# echo "Reset shell..."
# tset
echo "Remove snowsql bash install script..."
rm snowsql-linux_x86_64.bash
# echo "Change directory back to /var/task..."
# cd /var/task/





