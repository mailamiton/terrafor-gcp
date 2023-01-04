import functions_framework
import os
from google.cloud import secretmanager
import sqlalchemy
import json

project_id = os.environ["PROJECT_ID"]

client = secretmanager.SecretManagerServiceClient()
name = f"projects/{project_id}/secrets/mcdb-dev-db/versions/latest"
response = client.access_secret_version(name=name)
my_secret_value = response.payload.data.decode("UTF-8")
secret_object = json.loads(my_secret_value)


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
    print("username :::: " + secret_object['username'])
    return 'Hello World!'
