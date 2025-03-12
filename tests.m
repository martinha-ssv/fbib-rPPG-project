% Display only the ROI from video
video = VideoReader('media/subject_1.avi');
numFrames = floor(video.Duration * video.FrameRate);
videoFrames = zeros(video.Height, video.Width, 3, numFrames, 'uint8');

det = detector('new', 'shape_predictor_68_face_landmarks.dat');


for i=1:numFrames
    frame = readFrame(video);
    faces = detector('detect', det, frame);
    shape = detector('fit', det, frame, faces(1,:));
    frame = face.getRoiImg(frame, faces(1,:), det);
    videoFrames(:, :, :, i) = frame;
    imshow(frame);
end
%%
% Get average color vector time series (1 per frame)
video = VideoReader('media/subject_1.avi');
numFrames = floor(video.Duration * video.FrameRate);
videoFrames = zeros(video.Height, video.Width, 3, numFrames, 'uint8');

det = detector('new', 'shape_predictor_68_face_landmarks.dat');

meanColorVs = zeros(numFrames, 3);

for i=1:numFrames
    frame = readFrame(video);
    faces = detector('detect', det, frame);
    faceRect = faces(1, :);
    meanColorVs(i, :) = signal.getSignalFromFace(frame, faceRect, det);
end

%%
test_img = imread('media/test_image.png');
size(test_img)

faces = detector('detect', det, test_img);
shape = detector('fit', det, test_img, faces(1,:));

%%
figure(1);
imshow(test_img); hold on;
for i=1:68
    plot(shape(i, 1), shape(i, 2), 'ro');
    text(shape(i, 1)+5, shape(i, 2), string(i), 'Color', 'r');
end

hold off;

forehead_h = (shape(20,2)-shape(9,2))/3; % a good heuristic for the height of the forehead is 1/4 of face height

pos_forehead = 18:27;
polyCoords_forehead = shape(pos_forehead, :);
FL = [shape(25,1) shape(25,2)+forehead_h]; 
FR = [shape(20,1) shape(20,2) + forehead_h];
polyCoords_forehead = cat(1, polyCoords_forehead, FL, FR);
mask_forehead = poly2mask(polyCoords_forehead(:, 1), polyCoords_forehead(:, 2), size(test_img,1), size(test_img,2));



pos_cheeks = [37 42:-1:40 28 43 48:-1:46 17:-1:14 55:-1:49 4:-1:1]; % indexes of the landmarks in the shape tensor that represent points of interest (cheeks)
polyCoords_cheeks = shape(pos_cheeks, :);
mask_cheeks = poly2mask(polyCoords_cheeks(:, 1), polyCoords_cheeks(:, 2), size(test_img,1), size(test_img,2));

mask = mask_cheeks + mask_forehead;

se = strel('disk', 7); % fix ("trim") edges
mask = imerode(mask, se);
mask3d = repmat(mask, [1, 1, 3]);

extractedRoi = test_img .* uint8(mask3d);
figure(2);
imagesc(extractedRoi);

%extractedRoi = cat(3, imerode(extractedRoi(:,:,1), se), imerode(extractedRoi(:,:,2),se), imerode(extractedRoi(:,:,3),se));
%imagesc(extractedRoi);

%%

for i=1:numFrames
    frame = readFrame(video);
    videoFrames(:, :, :, i) = frame;
    faces = detector('detect', det, frame);
    shape = detector('fit', det, frame, faces(1,:));
end

%%
img = imread('media/test_image.png');
det = detector('new', 'shape_predictor_68_face_landmarks.dat');
figure(1);
faces = face.getFacesInFrame(img, det);
faces_base = uint8(zeros(size(img)));

for i=1:size(faces,1)
    facee = face.getRoiImg(img, faces(i,:), det);
    facev = face.getSkinVector(img, faces(i,:), det);
    faces_base = faces_base + facee;
    imshow(faces_base);
end
%%
