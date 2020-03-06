import time
import boto3

pipeline = boto3.client('codepipeline')


def invoke_wait(event, context):

    time.sleep(5)

    response = pipeline.put_job_success_result(
        jobId=event['CodePipeline.job']['id']
    )