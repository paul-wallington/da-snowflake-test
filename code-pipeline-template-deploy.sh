#!/bin/bash
sam package --template-file code-pipeline-template.yaml --output-template-file ~/packaged-code-pipeline-template.yaml --s3-bucket tfgm-da-lamdba --s3-prefix "da-snowflake-code-pipeline"
aws cloudformation deploy --template-file ~/packaged-code-pipeline-template.yaml --stack-name snowflake-code-pipeline --parameter-overrides RepositoryName=da-snowflake-test GitHubOwner=paulwallingtontfgm --capabilities CAPABILITY_NAMED_IAM
cd /var/task