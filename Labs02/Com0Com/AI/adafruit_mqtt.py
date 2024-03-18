import sys
from Adafruit_IO import MQTTClient

class Adafruit_MQTT:
    AIO_FEED_IDs = ["labiot.lamp", "labiot.pump"]
    AIO_USERNAME = ""
    AIO_KEY = ""
    client = MQTTClient(AIO_USERNAME , AIO_KEY)
    def connected(self, client):
        print("Connected ...")
        for feed in self.AIO_FEED_IDs:
            self.client.subscribe(feed)

    def subscribe(self, client , userdata , mid , granted_qos):
        print("Subscribeb...")

    def disconnected(self, client):
        print("Disconnected...")
        sys.exit (1)

    def message(self, client, feed_id , payload):
        print("Feed_id: " + feed_id + " received: " + payload)
        

    def publish_data(self, feed, data):
        self.client.publish(feed, data)

    def __init__(self):
        self.client.on_connect = self.connected
        self.client.on_disconnect = self.disconnected
        self.client.on_message = self.message
        self.client.on_subscribe = self.subscribe
        self.client.connect()
        self.client.loop_background()