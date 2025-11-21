import boto3
import os
import json

sns = boto3.client("sns")
topic_arn = os.environ["SNS_TOPIC_ARN"]

def handler(event, context):
    record = event["Records"][0]
    message = {
        "event": record["eventName"],
        "bucket": record["s3"]["bucket"]["name"],
        "file": record["s3"]["object"]["key"]
    }

    sns.publish(
        TopicArn=topic_arn,
        Message=json.dumps(message),
        Subject="S3 Event Notification"
    )

    print(f"Published message to SNS: {message}")
    return {"status": "success"}
