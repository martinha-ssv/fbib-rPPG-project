function v = getSignalFromFace(img, faceRect, det)
% This function takes a video frame - an image (2d array) -, a line vector 
% with coordinates for face bounding box vertices, and a detector object, 
% and outputs the mean RGB vector (as a column)
 facev = face.getSkinVector(img, faceRect, det);
 v = mean(facev, 1);
end