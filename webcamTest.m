clear cam
cam = webcam;
nnet = gestureResNet;
preview(cam)
label = 'start';
while(strcmp(char(label),'land') == 0)
    img = imresize(cam.snapshot,[224,224]);
    
    label = classify(nnet, img);
    
    title(char(label));
end