from __future__ import print_function

import json
import random
import string
import boto3
import os
import logging
import sys
import functions_framework
from zoneinfo import ZoneInfo
from datetime import datetime, timedelta
from boto3.dynamodb.conditions import Attr
from google.cloud import secretmanager

MODE = os.environ.get('MODE', 'DEV')
PROJECT_ID = os.environ["PROJECT_ID"]

secret_manager_client = secretmanager.SecretManagerServiceClient()
name = f"projects/{PROJECT_ID}/secrets/mcdb-dev-db/versions/latest"
response = secret_manager_client.access_secret_version(name=name)
my_secret_value = response.payload.data.decode("UTF-8")
secret_object = json.loads(my_secret_value)

dynamodb_client = boto3.resource(
    service_name='dynamodb',
    region_name='ap-south-1',
    aws_access_key_id='AKIA6FOVSXXWLUJAK5PP',
    aws_secret_access_key='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'
)
lambda_client = boto3.client(
    'lambda',
    region_name='ap-south-1',
    aws_access_key_id='AKIA6FOVSXXWLUJAK5PP',
    aws_secret_access_key='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'
)

# Dynamo tables
VRDDI_USER_TABLE = "VrddiUser"
VRDDI_AUTHENTICATION_TABLE = "VrddiAuthentication"
OTP_EXPIRY_SEC = 600  # default otp expiry 10 mins
SESSION_EXPIRY_SEC = 600


# get logger


def get_logger():
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    formatter = logging.Formatter(
        '[%(asctime)s] %(levelname)s [%(name)s:%(lineno)s] %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger


logger = get_logger()


def generate_random_number(n=6):
    range_start = 10 ** (n - 1)
    range_end = (10 ** n) - 1
    return random.randint(range_start, range_end)


def generate_random_string(length=32):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))


def get_current_time():
    return datetime.now(ZoneInfo('Asia/Kolkata'))


def store_authentication(ddb, mobile, otp, session_token, verification_string, organization_id, session_is_valid=False):
    authentication_table = os.environ.get(
        'VRDDI_AUTHENTICATION_TABLE', VRDDI_AUTHENTICATION_TABLE)
    otp_expiry = os.environ.get('OTP_EXPIRY_SEC', OTP_EXPIRY_SEC)
    session_expiry = os.environ.get('SESSION_EXPIRY_SEC', SESSION_EXPIRY_SEC)
    otp_expiry_at = get_current_time() + timedelta(seconds=otp_expiry)
    session_expiry_at = get_current_time() + timedelta(seconds=session_expiry)
    payload = {
        'id': session_token,
        'mobile': mobile,
        'otp': otp,
        'otp_expiry': otp_expiry_at.isoformat(),
        'session_expiry': session_expiry_at.isoformat(),
        'is_valid': session_is_valid,
        'created_at': get_current_time().isoformat(),
        'verification_string': verification_string,
        'org_id': organization_id
    }
    table = ddb.Table(authentication_table)
    table.put_item(Item=payload)


def send_otp(mobile, otp, lambda_client):
    message = f"""
    Hello! please enter {otp} for verification of mobile number. Vrddi
    """
    payload_json = {
        "mobile": mobile,
        "message": message
    }
    payload = json.dumps(payload_json)
    print(f"Invoking worker lambda, payload:{payload}")
    response = lambda_client.invoke(FunctionName=os.environ.get(
        'VRDDI_SMS_HANDLER_LAMBDA', 'Vrddi_SMS_Handler_Lambda'
    ), InvocationType='RequestResponse', Payload=payload)
    print(f"Invoked lambda response: {response}")
    print(response['Payload'].read())


def validate_user(ddb, mobile, organization_id):
    user_table = os.environ.get('VRDDI_USER_TABLE', VRDDI_USER_TABLE)
    table = ddb.Table(user_table)
    response = table.scan(
        FilterExpression=Attr('mobile').eq(mobile) & Attr(
            'org_id').eq(organization_id)
    )
    response_items = response.get("Items")
    if response_items:
        return True
    else:
        return False


# lambda handler

@functions_framework.http
def user_login(request):
    logger.info('VrddiLoginLambda - v_1.0')
    mobile = request.get_json().get('mobile')
    organization_id = request.get_json().get('organization_id')
    logger.info(
        f"User '{mobile}' is trying to login with '{organization_id}' organization")
    if not mobile:
        return {
            'status': 400,
            'message': 'VrddiLoginLambda: mobile field is required.'
        }
    if not organization_id:
        return {
            'status': 400,
            'message': f'organization_id field is required'
        }
    if not mobile.startswith('+'):
        mobile = f"+{mobile}"
    try:
        # checking user is exist or not
        user_instance = validate_user(
            ddb=dynamodb_client, mobile=mobile, organization_id=organization_id
        )
        if not user_instance:
            return {
                'status': 400,
                'message': f"VrddiLoginLambda: User '{mobile}' does not exist"
            }

        if MODE != 'DEV':
            session_token = generate_random_string()
            otp = generate_random_number()
            verification_string = generate_random_string()
            session_is_valid = False
        else:
            session_token = generate_random_string()
            otp = "123456"
            verification_string = generate_random_string()
            session_is_valid = False

        # store authentication in dynamodb
        store_authentication(
            ddb=dynamodb_client,
            mobile=mobile,
            otp=otp,
            session_token=session_token,
            verification_string=verification_string,
            organization_id=organization_id,
            session_is_valid=session_is_valid
        )

        response_data = {}
        if MODE != 'DEV':
            send_otp(mobile=mobile, otp=otp, lambda_client=lambda_client)
        else:
            response_data['session'] = {
                'token': session_token,
                'otp': otp
            }

        response_data.update({
            'mobile': mobile,
            'organization_id': organization_id,
            'verification_string': verification_string
        })

        return {
            'status': 200,
            'message': f'OTP generated successfully for {mobile} mobile number',
            'data': response_data
        }

    except Exception as e:
        print('VrddiLoginLambda exception - {}'.format(e))
        return {
            'status': 400,
            'message': f'OTP generation failed for {mobile} mobile number',
            'error': 'VrddiLoginLambda exception: {}'.format(e)
        }
