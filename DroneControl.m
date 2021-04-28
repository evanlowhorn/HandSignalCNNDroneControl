clear cam drone
cam = webcam(2);
nnet = gestureResNet;
drone = ryze()
preview(cam)
droneCam = camera(drone);
preview(droneCam)
label = ' ';
x = ' ';
takeoff(drone);
while(strcmp(label,'land') == 0)
    img = imresize(cam.snapshot,[224,224]);
    
    label = char(classify(nnet, img));
    
    if(strcmp(label,x)==0)
        clc
        disp(label)
        x = label;
    end
    
    if (strcmp(label,'forward'))
        forward(drone);
    elseif (strcmp(label,'backward'))
        backward(drone);
    elseif (strcmp(label,'left'))
        left(drone);
    elseif (strcmp(label,'right'))
        right(drone);
    elseif (strcmp(label,'idle'))
        idle();
    elseif (strcmp(label,'flip'))
        Flip(drone);
    else
        Land(drone);
    end
end

closePreview(droneCam)
closePreview(cam)

function forward(x)
    moveforward(x,'Speed',.5,'WaitUntilDone',false)
end

function backward(x)
    moveback(x,'Speed',.5,'WaitUntilDone',false)
end

function left(x)
    moveleft(x,'Speed',.5,'WaitUntilDone',false)
end

function right(x)
    moveright(x,'Speed',.5,'WaitUntilDone',false)
end

function idle()
    pause(.5);
end

function Flip(x)
    flip(x,'back')
    land(x)
end
function Land(x)
    land(x)
end
