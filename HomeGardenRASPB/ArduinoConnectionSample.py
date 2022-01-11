import serial
ser = serial.Serial(port = '/dev/cu.usbmodem11201', baudrate=9600)
if ser.readable():
    res = ser.readline()
    print(res.decode()[:len(res)-1])
