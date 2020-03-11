import os
import time
import boto3
import json
from datetime import datetime
from common import Functions


def invoke_wait(event, context):

    pipeline = boto3.client('codepipeline')

    time.sleep(5)

    pipeline.put_job_success_result(
        jobId=event['CodePipeline.job']['id']
    )


def empty_s3_buckets(event, context):

    env = os.environ['env']
    print(f'Setting environment to {env}...')

    print('Getting parameters from parameter store...')

    param = '/code-pipeline/' + env + '/snowflake-lambda-code-pipeline-s3'
    s3bucket = Functions.get_parameter(param, False)
    print(f'Parameter {param} value is: {s3bucket}')

    Functions.empty_s3(s3bucket)
