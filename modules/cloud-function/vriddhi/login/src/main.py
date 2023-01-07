import functions_framework
import os
from google.cloud import secretmanager
import sqlalchemy
import json
import boto3
from boto3.dynamodb.conditions import Attr

project_id = os.environ["PROJECT_ID"]

client = secretmanager.SecretManagerServiceClient()
name = f"projects/{project_id}/secrets/mcdb-dev-db/versions/latest"
response = client.access_secret_version(name=name)
my_secret_value = response.payload.data.decode("UTF-8")
secret_object = json.loads(my_secret_value)

ddb = boto3.resource(service_name='dynamodb', region_name='ap-south-1',
                     aws_access_key_id='AKIA6FOVSXXWLUJAK5PP',
                     aws_secret_access_key='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')


@functions_framework.http
def hello_get(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    Note:
        For more information on how Flask integrates with Cloud
        Functions, see the `Writing HTTP functions` page.
        <https://cloud.google.com/functions/docs/writing/http#http_frameworks>
    """
    mobile = "+91-9898989898"
    organization_id = "61f1c5d797aa482d8137e09c397624bb"
    user_instance = validate_user(
        ddb=ddb, mobile=mobile, organization_id=organization_id)
    print("username :::: " + secret_object['username'])
    return user_instance


def validate_user(ddb, mobile, organization_id):
    user_table = "VrddiAuthentication"
    table = ddb.Table(user_table)
    response = table.scan(
        FilterExpression=Attr('mobile').eq(mobile) & Attr(
            'org_id').eq(organization_id)
    )
    response_items = response.get("Items")
    print("response_items", response_items[0])
    return response_items[0]
