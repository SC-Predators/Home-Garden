import serial
ser = serial.Serial("/dev/usb 1-1.2")
while 1:
    print(ser.readlines())
    