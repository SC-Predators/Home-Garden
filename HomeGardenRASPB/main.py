import logging
import sys

homegarden_barcode = "homegarden1"

import boto3
from botocore.client import Config
import configKey as ck
import cv2 
import datetime as dt
import os
import base64
import requests
import random as rd
import pymysql

pymysql.install_as_MySQLdb()
import serial
import json
import time, json, ssl
import paho.mqtt.client as mqtt

from awscrt import io, mqtt, auth, http
from awsiot import mqtt_connection_builder
import time as t
import json

ENDPOINT = ck.iot_host
CLIENT_ID = "testDevice"
PATH_TO_CERTIFICATE = "aws_connect_config/2e4af4d2ef608636a26f102467b5e4b1e522087ca24bef950db9de311e8eec05-certificate.pem.crt"
PATH_TO_PRIVATE_KEY = "aws_connect_config/2e4af4d2ef608636a26f102467b5e4b1e522087ca24bef950db9de311e8eec05-private.pem.key"
PATH_TO_AMAZON_ROOT_CA_1 = "aws_connect_config/AmazonRootCA1.cer"
MESSAGE = "Hello World"
TOPIC = "$aws/things/Homegarden/shadow/update/delta"
RANGE = 20
received_count = 0

ser = serial.Serial('/dev/ttyACM0', 9600)

# pip install boto3
# Module not found err: pip install opencv-python

# --------------------------------AWS
def connect_RDS(host, port, username, password, database):
    try:
        conn = pymysql.connect(host=host, user=username, passwd=password, db=database, port=port, use_unicode=True,
                               charset='utf8')
        cursor = conn.cursor()
    except:
        logging.error("RDS에 연결되지 않았습니다.")
        sys.exit(1)
    return conn, cursor

# Callback when the subscribed topic receives a message
def on_message_received(topic, payload, **kwargs):
    print("Received message from topic '{}': {}".format(topic, payload))
    jsonObject = json.loads(payload)
    state = jsonObject.get("state")
    desired = state.get("desired")
    manual_water = desired.get("manual_water")
    if(manual_water == "on"):
        print("manual_water: " + manual_water)
        ser.write(b'w')
    elif(manual_water == "off"):
        print("manual_water: " + manual_water)
        ser.write(b'n')
        
#IoT Core에 연결! 
# Spin up resources
event_loop_group = io.EventLoopGroup(1)
host_resolver = io.DefaultHostResolver(event_loop_group)
client_bootstrap = io.ClientBootstrap(event_loop_group, host_resolver)
mqtt_connection = mqtt_connection_builder.mtls_from_path(
            endpoint=ENDPOINT,
            cert_filepath=PATH_TO_CERTIFICATE,
            pri_key_filepath=PATH_TO_PRIVATE_KEY,
            client_bootstrap=client_bootstrap,
            ca_filepath=PATH_TO_AMAZON_ROOT_CA_1,
            client_id=CLIENT_ID,
            clean_session=False,
            keep_alive_secs=6
            )
print("Connecting to {} with client ID '{}'...".format(
        ENDPOINT, CLIENT_ID))
# Make the connect() call
connect_future = mqtt_connection.connect()
# Future.result() waits until a result is available
connect_future.result()
print("Connected!")
print("Subscribing to topic '{}'...".format(TOPIC))
subscribe_future, packet_id = mqtt_connection.subscribe(
    topic=TOPIC,
    qos=mqtt.QoS.AT_LEAST_ONCE,
    callback=on_message_received)

subscribe_result = subscribe_future.result()
print("Subscribed with {}".format(str(subscribe_result['qos'])))
    
# Callback when the subscribed topic receives a message
def on_message_received(topic, payload, dup, qos, retain, **kwargs):
    print("Received message from topic '{}': {}".format(topic, payload))
    global received_count
    received_count += 1
    if received_count == args.count:
        received_all_event.set()

# --------------------------------

def createFolder(directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print('Error: Creating directory. ' + directory)


def upload_img_to_s3(file_name):  # f = 파일명
    # data = open('plist/static/plist/img/artist/'+f+'.jpg', 'rb')
    # '로컬의 해당파일경로'+ 파일명 + 확장자

    data = open(file_name, 'rb')
    s3 = boto3.resource(
        's3',
        aws_access_key_id=ck.ACCESS_KEY_ID,
        aws_secret_access_key=ck.ACCESS_SECRET_KEY,
        config=Config(signature_version='s3v4')
    )
    s3.Bucket(ck.BUCKET_NAME).put_object(
        Key=file_name, Body=data, ContentType='image/jpg')


def capture(camid, now):
    cam = cv2.VideoCapture(camid)
    if cam.isOpened() == False:
        print('cant open the cam (%d)' % camid)
        return None

    ret, frame = cam.read()
    if frame is None:
        print('frame is not exist')
        return None

    file_name = homegarden_barcode + "/" + now + '.jpg'
    cv2.imwrite(file_name, frame, params=[cv2.IMWRITE_JPEG_QUALITY, 60])
    upload_img_to_s3(file_name)
    cam.release()
    return file_name


def update_with_imgurl(file_name, now):
    conn, cursor = connect_RDS(ck.host, ck.port, ck.username, ck.password, ck.database)
    updateQuery = """INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus, img)
                     VALUES ("{0}", {1}, {2}, {3}, {4}, {5}, "{6}")""".format(
        homegarden_barcode,
        rd.randint(10, 100),
        rd.randint(10, 100),
        rd.randint(10, 100),
        rd.randint(10, 100),
        rd.randint(10, 100),
        ck.homegarden_bucket + now + ".jpg"
    )
    print("Query Updated: " + updateQuery)

    cursor.execute(updateQuery)
    conn.commit()
    os.remove(file_name)

def update_without_img(present_humidity, present_light, present_depth, present_ph):
    conn, cursor = connect_RDS(ck.host, ck.port, ck.username, ck.password, ck.database)
    updateQuery = """INSERT INTO Present_state (homegardenID, humidity, light, water_level, phStatus)
                     VALUES ("{0}", {1}, {2}, {3}, {4})""".format(
        homegarden_barcode,
        present_humidity,
        present_light,
        present_depth,
        present_ph
    )
    print("Query Updated: " + updateQuery)

    cursor.execute(updateQuery)
    conn.commit()

def get_desired_state():
    conn, cursor = connect_RDS(ck.host, ck.port, ck.username, ck.password, ck.database)
    get_desired_state_query = f"SELECT desired_humidity, desired_light FROM Desired_state where homegardenID = \"{homegarden_barcode}\" "
    print(get_desired_state_query)
    cursor.execute(get_desired_state_query)
    result = cursor.fetchall()
    conn.close()
    return (result[0][0], result[0][1])



def mainloop():
    conn, cursor = connect_RDS(ck.host, ck.port, ck.username, ck.password, ck.database)

    while 1:
        # 시리얼 포트 내용 가져와 JSON파싱
        data = ser.readline();
        data = data.decode()[:len(data)-1]           
        print("data: " + data)
        if data[0] == "=":
            continue
        parsing = json.loads(data);
        now = dt.datetime.now().strftime("%Y-%m-%d %H-%M-%S");
        present_depth = parsing["depth"]; # 물 깊이
        present_ph = parsing["ph"]; # 토양 산성도
        present_humidity = parsing['soil_humid']; # 토양 습도
        present_light = parsing["light"]; # 조도
        # 아두이노에서 센서 값 가져오기
        if dt.datetime.now().second % 10 == 0:
            #desired_State 가져오기
            desired_humidity, desired_light = get_desired_state()
            update_without_img(present_humidity, present_light, present_depth, present_ph)
            if present_light < desired_light:
                # do someThing
                print("#do something - light")
            if present_humidity < desired_humidity:
                # do someThing
                print("Desired Humid: " + str(desired_humidity) + "but " + str(present_humidity) + " given.")
                ser.write(b'w')
            else:
                ser.write(b's')
            time.sleep(1.5)
        # 산성도, 물높이 등도 다 가져오기
        if dt.datetime.now().minute % 10 == 0 & dt.datetime.now().second % 60 == 0:
            file_name = capture(0, now)
            update_with_imgurl(file_name, now)
            desired_humidity, desired_light = get_desired_state()
            if present_light < desired_light:
                # do someThing
                print("#do something - light")
            if present_humidity < desired_humidity:
                # do someThing
                print("Desired Humid: " + desired_humidiry + "but " + present_humidity + " given.")


if __name__ == '__main__':
    #connect_iotCore()
    createFolder("./" + homegarden_barcode)
    mainloop()
 