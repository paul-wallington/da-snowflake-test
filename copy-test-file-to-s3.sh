#!/bin/bash
aws s3 rm s3://da-wallingtonp-test --recursive
aws s3 cp /var/task/test.json s3://da-wallingtonp-test/stg/OutputAreaJson/test.json