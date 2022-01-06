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

    cv2.imwrite( "./" + homegarden_barcode +"/"+now+'.jpg', frame, params=[cv2.IMWRITE_JPEG_QUALITY, 60])
    cam.release()

def mainloop():
    while 1:
        now = dt.datetime.now().strftime("%Y-%m-%d %H-%M-%S")
        if dt.datetime.now().second%10 == 0:
            capture(0)

if __name__ == '__main__':
    createFolder("./" + homegarden_barcode)
    mainloop()