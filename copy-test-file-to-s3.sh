#!/bin/bash
aws s3 rm s3://da-snowflake-landing --recursive
aws s3 cp /var/task/test.json s3://da-snowflake-landing/stg/OutputAreaJson/test.json