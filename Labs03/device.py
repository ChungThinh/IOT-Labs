import serial.tools.list_ports


def getPort2():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        if "USB Serial Device" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
    #Replace YOUR COM
    commPort = "/dev/pts/6"
    return commPort

if getPort2() != "None":
    ser = serial.Serial( port=getPort2(), baudrate=115200)
    print(ser)

def receive_data():    
    if ser.in_waiting > 0:
        received_data = ser.read_all().decode()  # Read all available data and decode it
        print(received_data)

