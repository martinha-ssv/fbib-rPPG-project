function getFrameFromCamera(D,freq)
    cam = webcam;
    while true
        img = snapshot(cam);
       
        send(D,img);
        pause(1/freq);
    end
end