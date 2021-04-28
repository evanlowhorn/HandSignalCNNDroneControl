cam = webcam(2);

preview(cam);

a = 1;
disp('3')
pause(1);
disp('2')
pause(1);
disp('1')
pause(1);
while (a <= 2000)
    image = snapshot(cam);
    imwrite(image,sprintf('%d.png',a));
    a= a+1;
end

closePreview(cam)
    