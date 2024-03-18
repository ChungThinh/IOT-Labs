import os
from keras.models import load_model  # TensorFlow is required for Keras to work
import cv2  # Install opencv-python
import numpy as np

HTTP = 'http://'
IP_ADDRESS = '192.168.126.69' #Device IP
URL =  HTTP + IP_ADDRESS + ':4747/video'

#Get the current path for reading file in same direct
file_path = os.path.dirname(__file__)

# Disable scientific notation for clarity
np.set_printoptions(suppress=True)

# Load the model
model = load_model(os.path.join(file_path, "keras_model.h5"), compile=False)

# Load the labels
class_names = open(os.path.join(file_path, "labels.txt"), "r", encoding="utf-8").readlines()

# CAMERA can be 0 or 1 based on default camera of your computer
# camera = cv2.VideoCapture(0)

# CAMERA is URL when running on Linux
camera = cv2.VideoCapture(URL)

def image_detertor():
    # Grab the webcamera's image.
    ret, image = camera.read()

    # if camera.isOpened() is not True:
    #     print ('Cam Not opened.')
    #     print ('Please ensure the following:')
    #     print ('1. DroidCam is not running in your app.')
    #     print ('2. The IP address given is correct.')
    #     return


    # Resize the raw image into (224-height,224-width) pixels
    image = cv2.resize(image, (224, 224), interpolation=cv2.INTER_AREA)

    # Show the image in a window
    cv2.imshow("Webcam Image", image)

    # Make the image a numpy array and reshape it to the models input shape.
    image = np.asarray(image, dtype=np.float32).reshape(1, 224, 224, 3)

    # Normalize the image array
    image = (image / 127.5) - 1

    # Predicts the model
    prediction = model.predict(image)
    index = np.argmax(prediction)
    class_name = class_names[index]
    confidence_score = prediction[0][index]

    # Print prediction and confidence score
    print("Class:", class_name[2:])
    print("Confidence Score:", str(np.round(confidence_score * 100))[:-2], "%")
    # For show image on laptop
    keyboard_input = cv2.waitKey(1)
    return class_name[2:]