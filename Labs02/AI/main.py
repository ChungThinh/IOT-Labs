from adafruit_mqtt import Adafruit_MQTT
from simple_ai import *
import time

client = Adafruit_MQTT()
counter = 20
sensor_type = 0
while True:
    counter = counter - 1
    if counter <= 0:
        counter = 20
        ai_result = image_detertor()
        print("AI Output: " + ai_result)
        client.publish_data("labiot.ai", ai_result)
    time.sleep(1)
