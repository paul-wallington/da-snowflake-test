#!/bin/bash
aws s3 rm s3://tfgm-wallingtonp-test --recursive
aws s3 cp /var/task/test.json s3://tfgm-wallingtonp-test/stg/OutputAreaJson/test.json