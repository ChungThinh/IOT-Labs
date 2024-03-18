from adafruit_mqtt import Adafruit_MQTT
import time
from uart import *

client = Adafruit_MQTT()

while True:
    readSerial(client)
    time.sleep(1)