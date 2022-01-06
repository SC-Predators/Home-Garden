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
import pymysql

# pip install boto3
# Module not found err: pip install opencv-python

#--------------------------------rds연결 설정
def connect_RDS(host, port, username, password, database):
    try:
        conn = pymysql.connect(ck.host, user=username, passwd=password, db=database, port=port, use_unicode=True, charset= 'utf8')
        cursor = conn.cursor()

    except:
        logging.error("RDS에 연결되지 않았습니다.")
        sys.exit(1)
    return conn, cursor
#--------------------------------

def createFolder(directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print('Error: Creating directory. ' + directory)

def upload_img_to_s3(file_name): # f = 파일명
    #data = open('plist/static/plist/img/artist/'+f+'.jpg', 'rb')
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

def capture(camid):
    now = dt.datetime.now().strftime("%Y-%m-%d %H-%M-%S")
    cam = cv2.VideoCapture(camid)
    if cam.isOpened() == False:
        print('cant open the cam (%d)' % camid)
        return None

    ret, frame = cam.read()
    if frame is None:
        print('frame is not exist')
        return None

    file_name = homegarden_barcode +"/"+now+'.jpg'
    cv2.imwrite(file_name, frame, params=[cv2.IMWRITE_JPEG_QUALITY, 60])
    upload_img_to_s3(file_name)
    os.remove(file_name)


    cam.release()

def mainloop():
    while 1:
        now = dt.datetime.now().strftime("%Y-%m-%d %H-%M-%S")
        if dt.datetime.now().second%10 == 0:
            capture(0)

if __name__ == '__main__':
    createFolder("./" + homegarden_barcode)
    mainloop()
    conn, cursor = connect_RDS(ck.host, ck.port, ck.username, ck.password, ck.database)