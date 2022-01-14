context = 0
import json

def lambda_handler(event, context):
    tempStr = json.dumps(event)
    return {
        'statusCode': 200,
        'body': tempStr,
        "headers": {
            "content-type": "application/json"
        }
    }

#lambda_handler(event, context)