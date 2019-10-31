import urllib
import os
import snowflake.connector as sf
from common import Functions


def snowflake_validate(event, context):

    env = os.environ['env']
    print('Setting environment to ' + env + '...')

    print('Getting parameters from parameter store...')

    # Snowflake connection parameters
    param = '/snowflake/' + env + '/ac-param'
    ac = Functions.get_parameter(param, False)

    param = '/snowflake/' + env + '/un-param'
    un = Functions.get_parameter(param, False)

    param = '/snowflake/' + env + '/pw-param'
    pw = Functions.get_parameter(param, True)

    # connect to snowflake data warehouse
    conn = sf.connect(
        account=ac,
        user=un,
        password=pw
    )
    print('Snowflake connection opened...')

    # Snowflake data load parameters
    param = '/snowflake/' + env + '/file-format-param'
    pw = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/db-param'
    pw = Functions.get_parameter(param, True)

    param = '/snowflake/' + env + '/schema-param'
    pw = Functions.get_parameter(param, True)

    try:

        sql = 'USE DATABASE {}'.format('SNOWFLAKE_SAMPLE_DATA')
        Functions.execute_query(conn, sql)

        sql = 'SELECT current_database()'
        print(Functions.return_query(conn, sql))

        # get the object that triggered lambda
        bucket = event['Records'][0]['s3']['bucket']['name']
        #key = urllib.unquote_plus(event['Records'][0]['s3']['object']['key'].encode('utf8'))
        key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'].encode('utf8'))
        file_name = os.path.basename(key)
        full_dir = os.path.dirname(key)
        snow_table = os.path.basename(full_dir)
        print(
            "bucket: " + bucket
            + "\n key: " + key
            + "\n file_name: " + file_name
            + "\n full_dir: " + full_dir
            + "\n SNOW_TABLE: " + snow_table)


        #sql = 'SELECT current_version()'
        #with conn:
        #    with conn.cursor() as cursor:
        #        cursor.execute(sql)
        #        result = cursor.fetchone()
        #        print(result)
        #print('Got here2')
        #for c in cursor:
        #print(c)
        #except Exception as e:
        #    print(e)
        #finally:
        #    cursor.close()

        #print(one_row[0])

        #sql = 'select * from "TFGMDW"."STG"."OUTPUTAREAJSON"'

        #with conn:
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


if __name__ == "__main__":
    snowflake_validate({}, {})







