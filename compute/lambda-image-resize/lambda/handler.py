import boto3
import os
from PIL import Image
import io

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # Get bucket and object key from the event
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    destination_bucket = os.environ['DEST_BUCKET']
    
    # Download the image from S3
    download_path = f"/tmp/{os.path.basename(key)}"
    s3_client.download_file(source_bucket, key, download_path)
    
    # Resize the image
    with Image.open(download_path) as img:
        img.thumbnail((300, 300))
        buffer = io.BytesIO()
        img.save(buffer, 'JPEG')
        buffer.seek(0)
    
    # Upload to destination bucket
    resized_key = f"resized-{os.path.basename(key)}"
    s3_client.upload_fileobj(buffer, destination_bucket, resized_key)
    
    print(f"Image {key} resized and uploaded to {destination_bucket}/{resized_key}")
    return {"statusCode": 200, "body": "Success"}
