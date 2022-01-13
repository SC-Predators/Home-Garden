import serial
 
ser = serial.Serial('/dev/ttyACM0', 9600)

while(1):
    res = ser.readline()
    print(res)
    print(res.decode()[:len(res)-1])
