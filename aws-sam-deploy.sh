#!/bin/bash
pip3 install --upgrade pip
REQUIREMENTS=$(find /var/task -type f -iname "requirements.txt")		
pip3 install -r $REQUIREMENTS --upgrade								## ## Installs to /var/lang/lib/python3.7/site-packages
sam build --build-dir ~/
cd ~/
export SAM_CLI_TELEMETRY=0
sam package --output-template-file ~/packaged-template.yaml --s3-bucket tfgm-da-lamdba --s3-prefix "da-snowflake-test"
aws cloudformation deploy --template-file ~/packaged-template.yaml --stack-name snowflake-testing --capabilities CAPABILITY_NAMED_IAM
cd /var/task