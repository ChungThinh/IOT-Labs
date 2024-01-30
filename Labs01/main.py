from adafruit_mqtt import Adafruit_MQTT
import time
import random

test = Adafruit_MQTT()
counter = 30
sensor_type = 0
while True:
    counter = counter - 1
    if counter <= 0:
        counter = 30
        if sensor_type == 0:
            temp = random.randint(10,60)
            print("Publishing temp value: " + str(temp))
            test.publish_data("labs01.temp", temp)
            sensor_type = 1
        if sensor_type == 1:
            humidity = random.randint(30,90)
            print("Publishing humidity value: " + str(humidity))
            test.publish_data("labs01.humidity", humidity)
            sensor_type = 2
        if sensor_type == 2:
            light = random.randint(300,1600)
            print("Publishing light value: " + str(light))
            test.publish_data("labs01.light", light)
            sensor_type = 0
    time.sleep(1)