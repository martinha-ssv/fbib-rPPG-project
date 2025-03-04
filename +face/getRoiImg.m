function extractedRoi = getRoiImg(img, faceRect, det)
    % Outputs image which has the same size as 
    % the original image but only the ROI 
    shape = detector('fit', det, img, faceRect);
    
    mask = face.getMask(shape, img);
    mask3d = repmat(mask, [1, 1, 3]);
    extractedRoi = img .* uint8(mask3d);
end



