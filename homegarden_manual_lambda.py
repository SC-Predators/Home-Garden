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
    event_body = event['body']
    parsedBody = event_body.split(":")

    print(parsedBody)
    userSelected_clitentId = parsedBody[1].split("\"")
    print("clientID: " + userSelected_clitentId[1])

    userSelected_light: str = parsedBody[2].split(",")
    print("light: " + userSelected_light[0])

    userSelected_water = parsedBody[3][:-1].replace("\n", "")
    print("water: " + str(userSelected_water))

    payload = """{"state":{"reported":{"manual_light":""" + str(userSelected_light[0]) + """, "manual_water": """ + str(userSelected_water) + """}}}"""
    print(payload)
    original = """{"state":{"reported":{"manual_light":"on", "manual_water":"off"}}}"""

    _return_body_result = json.dumps(event_body)
    return {
        'statusCode': 200,
        'body': _return_body_result,
        "headers": {
            "content-type": "application/json"
        }
    }

print(lambda_handler(event, context))