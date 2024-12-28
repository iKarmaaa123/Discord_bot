import boto3
from botocore.exceptions import ClientError
import json
import os


def get_secret(secret_name):
    secret_name = secret_name
    region_name = "us-east-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name="secretsmanager",
        region_name=region_name
    )

    get_secret_value_response = client.get_secret_value(
        SecretId=secret_name
    )

    secret = get_secret_value_response['SecretString']
    secret=json.loads(secret)
    for key, value in secret.items():os.environ[key] = value

get_secret("discord_token")
