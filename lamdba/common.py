import boto3
from botocore.exceptions import ClientError, ParamValidationError


class Functions:

    @staticmethod
    def get_parameter(param_name, decrypt):

        try:
            ssm = boto3.client('ssm')
            param_response = ssm.get_parameter(Name=param_name, WithDecryption=decrypt)['Parameter']['Value']

        except ssm.exceptions.ParameterNotFound:
            print(f'Parameter {param_name} not found')
        except ParamValidationError as pve:
            print('Parameter validation error: %s' % pve)
        except ClientError as ce:
            print('Unexpected error: %s' % ce)
        else:
            print(f'Parameter {param_name} found')

            return param_response

    def execute_query(conn, sql):
        cursor = conn.cursor()
        cursor.execute(sql)
        cursor.close()

    def return_query(conn, sql):
        cursor = conn.cursor()
        cursor.execute(sql)
        result = cursor.fetchone()
        return result[0]
        cursor.close()