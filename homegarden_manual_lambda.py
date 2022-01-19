import json
import boto3
import configKey as ck


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
import json
import boto3

def lambda_handler(event, context):
    #event_body = json.load(event)
    #event = json.load(event)
    event = json.dumps(event['body'])
    event = event.replace(" ", "")
    event = event.replace("\\n", "")
    event = event.replace("\\", "")

    print(event)
    parsedBody = event.split(":")

    print(parsedBody)
    userSelected_clitentId = parsedBody[1].split("\"")
    print("clientID: " + userSelected_clitentId[1])

    userSelected_light: str = parsedBody[2].split(",")
    print("light: " + userSelected_light[0])

    userSelected_water = parsedBody[3][:-1].replace("\n", "")
    userSelected_water = userSelected_water.replace("}", "")
    print("water: " + str(userSelected_water))

    payload = """{"state":{"reported":{"manual_light":""" + str(userSelected_light[0]) + """, "manual_water": """ + str(userSelected_water) + """}}}"""
    print(payload)

    ########## 토픽 발행
    """
    client = boto3.client('iot-data', region_name='ap-northeast-2')
    response = client.publish(
        topic='$aws/things/Homegarden/shadow/update',
        qos=1,
        payload=json.dumps(payload)
    )
    response
    """
    ########## 토픽 발행
    _return_body_result = json.dumps("Sent: OK")
    return {
        'statusCode': 200,
        'body': _return_body_result,
        "headers": {
            "content-type": "application/json"
        }
    }

print(lambda_handler(event, context))