function faces = getFacesInFrame(img, det)
% Wrapper for detector call which returns face bounding boxes
    faces = detector('detect', det, img);
end