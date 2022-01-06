homegarden_barcode = "homegarden1"

import cv2
import datetime as dt
import os

# Module not found err: pip install opencv-python
# print(cv.__version__)
# 홈가든 장치 바코드를 갖는 폴더 생성
def createFolder(directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print('Error: Creating directory. ' + directory)
createFolder("./" + homegarden_barcode)


record = False
#now는 사진이 저장될 이름 ex)2022-01-04+04-05-50.jpeg
now = dt.datetime.now().strftime("%Y-%m-%d %H-%M-%S")
#print(now)

"""while True:
    if (capture.get(cv2.CAP_PROP_POS_FRAMES) == capture.get(cv2.CAP_PROP_FRAME_COUNT)):
        capture.open("/Image/Star.mp4")

    ret, frame = capture.read()
    cv2.imshow("VideoFrame", frame)

    now = datetime.datetime.now().strftime("%d_%H-%M-%S")
    key = cv2.waitKey(33)

    if key == 27:
        break
    elif key == 26:
        print("캡쳐")
        cv2.imwrite("./"+ homegarden_barcode + str(now) + ".png", frame)


capture.release()
cv2.destroyAllWindows()
"""
