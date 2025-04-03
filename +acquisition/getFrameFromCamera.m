function getFrameFromCamera(D, fs, cam)
    while true
        img = snapshot(cam);
       
        send(D,img);
        pause(1/freq);
    end
end

