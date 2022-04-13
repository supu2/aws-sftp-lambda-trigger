import json
import urllib.parse
import boto3

print('Loading function')

s3 = boto3.client('s3')


def lambda_handler(event, context):
    # Get the bucket, object, event_type  from the event 
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    event_type = event["Records"][0]["eventName"]

    try:
        print(event_type)
        #Trigger when event_type ObjectCreated:Put
        if event_type == "ObjectCreated:Put" and "f20-" not in key and "incoming" in key:
            # Get object content
            response = s3.get_object(Bucket=bucket, Key=key)
            # Read first 20 bytes
            content = response['Body'].read(20).decode('utf-8')
            # Store first 20 bytes of content to new filename with start "f20-"
            s3.put_object(Body="", Bucket=bucket, Key='incoming/f20-' + content)
            # Delete orginal file
            s3.delete_object(Bucket=bucket, Key=key)
            
    except Exception as e:
        print(e)
        raise e
