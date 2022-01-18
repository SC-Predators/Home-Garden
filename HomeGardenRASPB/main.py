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

ENDPOINT = ck.homegarden_endpint
THING_NAME = 'Homegarden'


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

def iot_on_connect(mqttc, obj, flags, rc):
    if rc == 0:  # 연결 성공
        print('connected!!')
        mqttc.subscribe('$aws/things/Homegarden/shadow/update/delta', qos=0)  # 구독

def iot_on_message(mqttc, obj, msg):
    if msg.topic == '$aws/things/Homegarden/shadow/update/delta':
        payload = msg.payload.decode('utf-8')
        j = json.loads(payload)
        print(j['message'])

def connect_iotCore():
    mqtt_client = mqtt.Client(client_id=THING_NAME)
    mqtt_client.on_connect = iot_on_connect
    mqtt_client.on_message = iot_on_message
    mqtt_client.tls_set('./connect_device_package/Homegarden.cert.pem', certfile='./connect_device_package/root-CA.pem',
                        keyfile='./connect_device_package/HomeGarden.private.key', tls_version=ssl.PROTOCOL_TLSv1_2, ciphers=None)
    mqtt_client.connect(ENDPOINT, port=8883)
    mqtt_client.loop_start()  # threaded network loop




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


def update_with_imgurl(conn, cursor, file_name, now):
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


def get_desired_state(conn, cursor):
    get_desired_state_query = f"SELECT desired_humidity, desired_light FROM Desired_state where homegardenID = \"{homegarden_barcode}\" "
    print(get_desired_state_query)
    cursor.execute(get_desired_state_query)
    result = cursor.fetchall()
    conn.close()
    return (result[0][0], result[0][1])

def mainloop():
    conn, cursor = connect_RDS(ck.host, ck.port, ck.username, ck.password, ck.database)
    ser = serial.Serial('/dev/ttyACM0', 9600)
    data = ser.readline();

    parsing = json.loads(data);
    print(parsing);

    while 1:
        now = dt.datetime.now().strftime("%Y-%m-%d %H-%M-%S");
        present_light = parsing["light"];
        present_humidity = parsing['soil_humid'];

        present_ph = parsing["ph"];
        present_depth = 200
        # 산성도, 물높이 등도 다 가져오기
        if dt.datetime.now().minute % 10 == 0:
            file_name = capture(0, now)
            update_with_imgurl(conn, cursor, file_name, now)
            desired_light, desired_humidity = get_desired_state(conn, cursor)
            if present_light < desired_light:
                # do someThing
                print("#do something - light")
            if present_humidity < desired_humidity:
                # do someThing
                print("#do something - humidity")


if __name__ == '__main__':
    connect_iotCore()
    iot_on_connect()
    createFolder("./" + homegarden_barcode)
    mainloop()
