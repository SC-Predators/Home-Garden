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

def get_desired_state(conn, cursor):
    get_desired_state_query = f"SELECT desired_humidity, desired_light FROM Desired_state where homegardenID = \"{homegarden_barcode}\" "
    print(get_desired_state_query)
    cursor.execute(get_desired_state_query)
    result = cursor.fetchall()
    conn.close()
    return (result[0][0], result[0][1])

def connect_RDS(host, port, username, password, database):
    try:
        conn = pymysql.connect(host=host, user=username, passwd=password, db=database, port=port, use_unicode=True, charset='utf8')
        cursor = conn.cursor()

    except:
        logging.error("RDS에 연결되지 않았습니다.")
        sys.exit(1)
    return conn, cursor

conn, cursor = connect_RDS(ck.host, ck.port, ck.username, ck.password, ck.database)
desired_light, desired_humidity = get_desired_state(conn, cursor)
print(desired_light)
print(desired_humidity)