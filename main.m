% Read video
video = VideoReader('media/subject_1.avi');
numFrames = floor(video.Duration * video.FrameRate); % Number of frames in video

% Initialize detector
det = detector('new', 'shape_predictor_68_face_landmarks.dat');

% Initialize raw signal buffer
rawSignalWindow = Buffer(2);

% Initialize BPV signal buffer
bpvSignalWindow = Buffer(10);

% Initialize filtered BPV signal buffer
bpvSignalFilteredWindow = Buffer(10);

% Initialize HR signal buffer
hrSignal = Buffer(10);


videoFrames = zeros(video.Height, video.Width, 3, numFrames, 'uint8'); % 4D tensor to store video (maybe not needed, only if we want to save the video)



for i=1:numFrames
    % Get new frame
    frame = readFrame(video);

    % Get ROI from frame
    faces = detector('detect', det, frame);
    shape = detector('fit', det, frame, faces(1,:));

    % Get signal from face
    rawSignal = signal.getSignalFromFace(frame, faces(1,:), det);
    rawSignalWindow.enqueue(rawSignal);

    % Calculate bpv signal from raw signal
    if ~rawSignalWindow.isFull()
        [h_n, mu_n_1, mu_s_1, sigma_s_1] = signal.firstWindow(rawSignalWindow.toMatrix());
    else
        [h_n, mu_n_1, mu_s_1, sigma_s_1] = signal.processWindow(rawSignalWindow.toMatrix(), mu_n_1, mu_s_1, sigma_s_1);
        bpvSignalWindow.enqueue(h_n);
    end

    % Store frame (debugging purposes)
    videoFrames(:, :, :, i) = frame;

    % 
end
