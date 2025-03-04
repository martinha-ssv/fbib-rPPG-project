function mask = getCheeksMask(shape, img)
    % Calculates an image mask over the subject's cheeks.
    pos = [37 42:-1:40 28 43 48:-1:46 17:-1:14 55:-1:49 4:-1:1]; % indexes of the landmarks in the shape tensor that represent points of interest (cheeks)
    polyCoords = shape(pos, :);

    mask = poly2mask(polyCoords(:, 1), polyCoords(:, 2), size(img,1), size(img,2));
end