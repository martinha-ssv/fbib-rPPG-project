function v = getSkinVector(img, faceRect, det) % Outputs image which has the same size as 
    % the original image but only the ROI 
    shape = detector('fit', det, img, faceRect);
    
    mask = face.getMask(shape, img);
    mask3d = repmat(mask, [1, 1, 3]);
    mask3d = mask3d > 0;
    v = img(mask3d);
    v = reshape(v, [], 3);
end

