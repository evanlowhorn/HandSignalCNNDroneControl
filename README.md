# HandSignalCNNDroneControl

This project contains all source code needed to recreate this application with a user-provided dataset to control a Ryze Tello drone.

The imageTaker.m script uses MATLAB to automatically capture images with a webcam for the dataset. Examples from the dataset that are labeled by the CNN are shown below

![testImages_Figure](https://user-images.githubusercontent.com/83368831/116753744-90f47480-a9d5-11eb-9efc-db56728e22d7.png)

MyTest.py is an alternative control method with Python to setup a Wifi connection and iterate through a pre-defined array of commands to control the drone.

A Convolutional Nueral Network (ResNet-18 Classification) was developed and trained using MATLAB which also allowed for interfacing with the drone.

The MATLAB script gestureCNNResNet.m uses the function findLayersToReplace.m to redefine classification layers to match the dataset being used. This script augments the training images from the dataset and uses the new network to begin training. The overall process for training and application is shown below.

![Flow Chart](https://user-images.githubusercontent.com/83368831/116750683-d2ceec00-a9d0-11eb-9621-51e15faf318d.png)

The webcamTest.m script can be used to test the newly trained network without controlling the drone.

Lastly, the DroneControl.m script loads the network, shows the webcam feed and displays the CNN output in the MATLAB command prompt for the user while controlling the drone.
