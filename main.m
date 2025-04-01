% Read video
video = VideoReader('media/subject_1.avi');
fs = video.FrameRate; % Sampling frequency
ls = 1.6; % Interval containing 1 cardiac cycle

numFrames = floor(video.Duration * video.FrameRate); % Number of frames in video

% Initialize detector
det = detector('new', 'shape_predictor_68_face_landmarks.dat');

% Initialize raw signal buffer

mu_n_1 = 0;
mu_s_n_1 = 0;
sigma_s_n_1 = 0;

% Initialize BPV signal buffer
Hs = BufferWithStorage(10);

% Initialize filtered BPV signal buffer
bpvSignalFilteredWindow = Buffer(10);

% Initialize HR signal buffer
hrSignal = Buffer(10);


% videoFrames = zeros(video.Height, video.Width, 3, numFrames, 'uint8'); % 4D tensor to store video (maybe not needed, only if we want to save the video)



for i=1:numFrames
    % Get new frame
    frame = readFrame(video);

    % Get ROI from frame
    faces = detector('detect', det, frame);
    shape = detector('fit', det, frame, faces(1,:));

    % Get signal from face
    c = signal.getSignalFromFace(frame, faces(1,:), det);

    % Calculate bpv signal from raw signal
    [H_n, mu_n_1, mu_s_n_1, sigma_s_n_1, h_n] = signal.processWindow(fs, ls, c, mu_n_1, mu_s_n_1, sigma_s_n_1, hs);
    Hs.enqueue(H_n);


    % Store frame (debugging purposes)
    % videoFrames(:, :, :, i) = frame;

    % 
end

plot(Hs.getStorage()); 