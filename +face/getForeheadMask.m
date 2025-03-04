function mask = getForeheadMask(shape, img)
    % Calculates an image mask over the subject's forehead
    pos = 18:27;
    polyCoords = shape(pos, :);

    forehead_h = face.foreheadH(shape);
    FL = [shape(25,1) shape(25,2)+ forehead_h]; 
    FR = [shape(20,1) shape(20,2) + forehead_h];

    polyCoords = cat(1, polyCoords, FL, FR);
    mask = poly2mask(polyCoords(:, 1), polyCoords(:, 2), size(img,1), size(img,2));
end