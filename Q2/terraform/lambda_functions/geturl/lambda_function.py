import json
import boto3
import os
import logging
from cachetools import cached, TTLCache
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb', region_name=os.environ['REGION'])
url_table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])

@cached(cache=TTLCache(maxsize=int(os.environ["LAMBDA_CACHESIZE"]), ttl=int(os.environ["LAMBDA_CACHETTL"])))
def geturl(shorturl):
    dynamodb_response = url_table.query(
        KeyConditionExpression=Key('shorturl').eq(shorturl)
    )
    if dynamodb_response['Count'] > 0:
        return dynamodb_response['Items'][0]['url']
    else:
        return None


def lambda_handler(event, context):

    try:
        shorturl = event['pathParameters']['shorturl']
        #if shorturl has invalid format [TODO]
        if len(shorturl) > 9:
            return {'statusCode': 400,'body': json.dumps({'error': "Invalid format"})}
        print("event ->" + str(event['pathParameters']))

        # check if the dynamdb already exists the records
        # dynamodb_response = url_table.query(
        #     KeyConditionExpression=Key('shorturl').eq(shorturl)
        # )
        # if dynamodb_response['Count'] > 0:
        #     return {'statusCode': 302, 'headers': {'Location': dynamodb_response['Items'][0]['url']}}
        # else:
        #     return {'statusCode': 404,'body': json.dumps({'status': "Record not found"})}

        url = geturl(shorturl)
        if url != None:
            return {'statusCode': 302, 'headers': {'Location': url}}
        else:
            return {'statusCode': 404,'body': json.dumps({'status': "Record not found"})}

    except Exception as e:
        logging.error(e)
        return {'statusCode': 500, 'body': json.dumps({"status": "Server error"})}