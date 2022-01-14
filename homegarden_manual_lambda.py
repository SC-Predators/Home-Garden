import json

#################################개발단지
context = 0
with open('./sampleEvent.json', 'r') as f:
    event = json.load(f)

"""
print(json.dumps(event, indent="\t") )
print("############################BODY")
event_body = event['body']
print(event_body)
print("############################")
"""

################################

def lambda_handler(event, context):
    #print(event.type())
    print(json.dumps(event, indent="\t"))
    print("############################BODY")
    event_body = event['body']
    print(event_body)
    print("############################")

    _return_body_result = json.dumps(event_body)
    return {
        'statusCode': 200,
        'body': _return_body_result,
        "headers": {
            "content-type": "application/json"
        }
    }

print(lambda_handler(event, context))