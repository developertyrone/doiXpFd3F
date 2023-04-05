import json
import random
from datetime import datetime
import boto3
import os
from boto3.dynamodb.conditions import Key
import validators
import logging
from cachetools import cached, TTLCache

dynamodb = boto3.resource('dynamodb', region_name=os.environ['REGION'])
url_table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])

@cached(cache=TTLCache(maxsize=int(os.environ["LAMBDA_CACHESIZE"]), ttl=int(os.environ["LAMBDA_CACHETTL"])))
def geturl(url):
    dynamodb_response = url_table.query(
        IndexName='LongURLIndex',
        KeyConditionExpression=Key('url').eq(url)
    )

    if dynamodb_response['Count'] > 0:
        return dynamodb_response['Items'][0]['shorturl']
    else:
        return None

def generate_token(value, length = 9):
    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    random.seed(value)
    return ''.join(random.choice(chars) for _ in range(length))

def lambda_handler(event, context):
    try:
        basepath = 'https://' + event['headers']['Host'] + '/' + event['requestContext']['stage']
        logging.info(event['headers'])
        if 'url' not in event['body']:
            return {'statusCode': 400,'body': json.dumps({'error': "No 'url' provided has been provided."})}
        url = json.loads(event['body'])['url']

        # prevention of spams for non url request
        if not validators.url(url):
            return {'statusCode': 400, 'body': json.dumps({'error': "Invalid url format provided"})}

        # check if the dynamodb already exists the records
        timestamp = int(datetime.utcnow().timestamp())

        # dynamodb_response = url_table.query(
        #     IndexName='LongURLIndex',
        #     KeyConditionExpression=Key('url').eq(url)
        # )
        #
        # if dynamodb_response['Count'] > 0:
        #     shorturl = basepath + "/" + dynamodb_response['Items'][0]['shorturl']
        # else:
        #     token = generate_token(url)
        #     shorturl = basepath + "/" + token
        #     dynamodb_response = url_table.put_item(
        #         Item={
        #             "url": url,
        #             "shorturl": token,
        #             "created": timestamp
        #         }
        #     )

        shorturl = geturl(url)

        if shorturl != None:
            shorturl = basepath + "/" + shorturl
        else:
            token = generate_token(url)
            shorturl = basepath + "/" + token
            dynamodb_response = url_table.put_item(
                Item={
                    "url": url,
                    "shorturl": token,
                    "created": timestamp
                }
            )

        return {'statusCode': 200,'body': json.dumps({'shortenUri': shorturl, 'url': url})}
    except Exception as e:
        logging.error(e)
        return {'statusCode': 500, 'body': json.dumps({"status": "Server error"})}