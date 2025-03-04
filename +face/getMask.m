function mask = getMask(shape, img)
% Creates a mask on the face's ROIs
    forehead_mask = face.getForeheadMask(shape, img);
    cheeks_mask = face.getCheeksMask(shape, img);
    mask = forehead_mask + cheeks_mask;

    se = strel('disk', 7); 
    mask = imerode(mask, se); % Fix ("trim") mask edges
end