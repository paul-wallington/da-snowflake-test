import urllib
import json
import os
import snowflake.connector as sf
from common import Functions
# import datetime
# import boto3
# from botocore.client import ClientError
# status_code = 200
# import s3fs


def invoke_snowflake_load_from_s3_event(event, context):

    env = os.environ.get('env')
    if env is None:
        env = 'dev'
    print('Setting environment to ' + env + '...')

    print('Getting parameters from parameter store...')

    # Snowflake connection parameters
    param = '/snowflake/' + env + '/ac-param'
    ac = Functions.get_parameter(param, False)

    param = '/snowflake/' + env + '/un-param'
    un = Functions.get_parameter(param, False)

    param = '/snowflake/' + env + '/pw-param'
    pw = Functions.get_parameter(param, True)

    # Snowflake data load parameters
    param = '/snowflake/' + env + '/role-param'
    role = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/db-param'
    db = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/schema-param'
    schema = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/wh-param'
    wh = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/file-format-param'
    file_format = Functions.get_parameter(param, True)

    # connect to snowflake data warehouse
    conn = sf.connect(
        account=ac,
        user=un,
        password=pw,
        role=role,
        warehouse=wh,
        database=db,
        schema=schema,
        ocsp_response_cache_filename="/tmp/ocsp_response_cache"
    )
    print('Snowflake connection opened...')

    try:
        # sql = 'USE ROLE {}'.format(role)
        # Functions.execute_query(conn, sql)

        sql = 'SELECT current_role()'
        print('role: ' + Functions.return_query(conn, sql))

        sql = 'SELECT current_warehouse()'
        print('warehouse: ' + Functions.return_query(conn, sql))

        try:
            sql = 'ALTER WAREHOUSE {} RESUME'.format(wh)
            Functions.execute_query(conn, sql)

        except Exception as e:
            print(e)

        sql = 'SELECT current_schema()'
        print('schema: ' + Functions.return_query(conn, sql))

        sql = 'SELECT current_database()'
        print('database: ' + Functions.return_query(conn, sql))

        # fs = s3fs.S3FileSystem(anon=False)
        # fs.mkdir("tfgm-wallingtonp")
        # fs.touch("tfgm-wallingtonp/test.txt")
        # fs.ls("tfgm-wallingtonp/")

        # get the object that triggered lambda
        # https://docs.aws.amazon.com/AmazonS3/latest/dev/notification-content-structure.html
        try:
            bucket = event['Records'][0]['s3']['bucket']['name']
            arn = event['Records'][0]['s3']['bucket']['arn']

            for record in event['Records']:
                key = record['s3']['object']['key']
                size = record['s3']['object']['size']
                print(
                    'bucket: ' + bucket
                    + '\narn: ' + arn
                    + '\nkey: ' + key
                    + '\nsize: ' + str(size)
                )
        except Exception as e:
            print(e)

        try:
            sql = 'TRUNCATE ' + schema + '.OutputAreaJson'
            print(sql)
            Functions.execute_query(conn, sql)

            sql = "copy into " + schema + ".OutputAreaJson from @" + str.replace(bucket, "-", "_") + "/" + key + \
                  " FILE_FORMAT = '" + file_format + "' ON_ERROR = 'ABORT_STATEMENT';"
            print(sql) 
            Functions.execute_query(conn, sql)

        except Exception as e:
            print(e)

        # sql = 'SELECT current_version()'
        # with conn:
        #    with conn.cursor() as cursor:
        #        cursor.execute(sql)    
        #        result = cursor.fetchone()
        #        print(result)
        # print('Got here2')
        # for c in cursor:
        # print(c)
        # except Exception as e:
        #    print(e)
        # finally:
        #    cursor.close()

        # print(one_row[0])

        # sql = 'select * from "TFGMDW"."STG"."OUTPUTAREAJSON"'

        # with conn:
        #    with conn.cursor() as cur:
        #        cur.execute(sql)
        #        for c in cur:
        #            print(c)
        #        one_row = cur.fetchone()
        #        print(one_row[0])

    except Exception as e:
        print(e)

    finally:
        conn.close()
        print('Snowflake connection closed...')


def invoke_snowflake_load_from_cloudwatch_event(event, context):

    env = os.environ.get('env')
    if env is None:
        env = 'dev'
    print('Setting environment to ' + env + '...')

    print('Getting parameters from parameter store...')

    # Snowflake connection parameters
    param = '/snowflake/' + env + '/ac-param'
    ac = Functions.get_parameter(param, False)

    param = '/snowflake/' + env + '/un-param'
    un = Functions.get_parameter(param, False)

    param = '/snowflake/' + env + '/pw-param'
    pw = Functions.get_parameter(param, True)

    # Snowflake data load parameters
    param = '/snowflake/' + env + '/role-param'
    role = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/db-param'
    db = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/schema-param'
    schema = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/wh-param'
    wh = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/file-format-param'
    file_format = Functions.get_parameter(param, True)

    # connect to snowflake data warehouse
    conn = sf.connect(
        account=ac,
        user=un,
        password=pw,
        role=role,
        warehouse=wh,
        database=db,
        schema=schema,
        ocsp_response_cache_filename="/tmp/ocsp_response_cache"
    )
    print('Snowflake connection opened...')

    try:
        sql = 'SELECT current_role()'
        print('role: ' + Functions.return_query(conn, sql))

        sql = 'SELECT current_warehouse()'
        print('warehouse: ' + Functions.return_query(conn, sql))

        try:
            sql = 'ALTER WAREHOUSE {} RESUME'.format(wh)
            Functions.execute_query(conn, sql)

        except Exception as e:
            print(e)

        sql = 'SELECT current_schema()'
        print('schema: ' + Functions.return_query(conn, sql))

        sql = 'SELECT current_database()'
        print('database: ' + Functions.return_query(conn, sql))

        # get the object that triggered cloudwatch
        # https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/EventTypes.html#events-for-services-not-listed
        try:
            bucket = event['detail']['requestParameters']['bucketName']
            key = event['detail']['requestParameters']['key']

            print(
                'bucket: ' + bucket
                + '\nkey: ' + key
            )

        except Exception as e:
            print(e)

        try:
            sql = 'TRUNCATE ' + schema + '.OutputAreaJson'
            print(sql)
            Functions.execute_query(conn, sql)

            sql = "copy into " + schema + ".OutputAreaJson from @" + str.replace(bucket, "-", "_") + "/" + key + \
                  " FILE_FORMAT = '" + file_format + "' ON_ERROR = 'ABORT_STATEMENT';"
            print(sql)
            Functions.execute_query(conn, sql)

        except Exception as e:
            print(e)

    except Exception as e:
        print(e)

    finally:
        conn.close()
        print('Snowflake connection closed...')

    if __name__ == "__main__":
        # snowflake_validate({}, {})

        json_event = "/var/task/event.json"
        with open(json_event) as response:
            _event = json.load(response)
            invoke_snowflake_load_from_cloudwatch_event(_event, '')

