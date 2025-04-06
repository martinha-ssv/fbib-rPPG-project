% Read video
video = VideoReader('media/subject_1.avi'); % Use video file
fs = video.FrameRate; % Sampling frequency
N = floor(video.Duration * video.FrameRate); % Number of frames in video

% % Live video feed
% cam = webcam; % Use webcam
% cam.Resolution = '640x480';
% fs = 20; % Sampling frequency (30 fps)

N = 1000; % Number of frames to process
ts = 1/fs; % Sampling period
ls = 1.6; % Interval containing 1 cardiac cycle


timestamps = zeros(1, N); % Timestamps for each frame


% Initialize detector
det = detector('new', 'shape_predictor_68_face_landmarks.dat');

% Initialize window variables. "Zero padding"
mu_n_1 = 0;
mu_s_n_1 = 0;
sigma_s_n_1 = 0;

% Initialize signal buffers
framesInCycle = ceil(fs * ls);
windowSize = ceil(fs); % Window size is enough to get 1 HR value/s
hopSize = ceil(fs); % Hop size is 1 window size

hs = Buffer(framesInCycle,1); % Window size is 1 cardiac cycle
Hs = Buffer(windowSize, 1, true); % Window of unfiltered BPV signal. Length is 3 times the length of a cardiac cycle, to avoid distortion.
filteredHs = zeros(1,1);
filteredHsDiff = zeros(1,1);
putativePeaks = []; % DEBUG
peaks = [];


% Initialize filter object
d = signal.filterObject(fs, [0.8 2.5]); % Butterworth bandpass filter with bandpass [0.8; 2.5]Hz (equivalent to human heart rate range of 48 to 150 bpm)
%zi = zeros(size(d.sosMatrix, 1), 2); % Initial conditions for the filter


% videoFrames = zeros(video.Height, video.Width, 3, numFrames, 'uint8'); % 4D tensor to store video (not needed, only if we want to save the video)
figure(1);
hold on;
y_data = plot(filteredHs);
y_data_deriv = plot(filteredHsDiff);
hold off;

for i=1:N
    % Get new frame

    % % Live video feed
    % frame = snapshot(cam);

    % tStart = tic;
    frame = readFrame(video); 
    timestamps(i) = i * ts;
    % timestamps(i) = toc(tStart);

    % Get ROI from frame
    faces = detector('detect', det, frame);
    %shape = detector('fit', det, frame, faces(1,:));

    % Get signal from face
    c = signal.getSignalFromFace(frame, faces(1,:), det);

    % Calculate bpv signal from raw signal
    [H_n, mu_n_1, mu_s_n_1, sigma_s_n_1, h_n] = signal.processWindow(fs, ls, c, mu_n_1, mu_s_n_1, sigma_s_n_1, hs);

    if i==1
        H_n = 0;
        h_n = 0;
    end

    Hs.enqueue(H_n);
    hs.enqueue(h_n);

    % Filter signal
    if mod(i, hopSize) == 0
        y = filter(d, Hs.toMatrix(), 2);

        if floor(i / hopSize) == 1 % On first iteration
            filteredHs = y;%(1:2 * hopSize);
            filteredHsDiff = diff(filteredHs);
        else
            filteredHs = [filteredHs, y];%(1:end - hopSize)];
            diffY = diff(y);
            filteredHsDiff = [filteredHsDiff, diffY, diffY(end) ];
            
            possiblePeaks = postProcessing.getPossiblePeaks(fs, ls, y);
            putativePeaks = [putativePeaks, possiblePeaks]; % DEBUG
            
            if floor(i / hopSize) > 1
                starti = 1;
            else
                starti = postProcessing.getFirstPeakParams()
            end

            actualPeaks = postProcessing.getActualPeaks(starti, timestamps, possiblePeaks);
            peaks = [peaks, actualPeaks];
        end
    end

    
    set(y_data, 'YData', filteredHs(max(end-3*framesInCycle, 1):end));
    %set(y_data_deriv, 'YData', filteredHsDiff(max(end-3*framesInCycle, 1):end));

    drawnow limitrate;

    %elapsed = toc(tStart);
    % if elapsed < ts
    %     pause(ts - elapsed);
    % else 
    %     disp('Frame processing time exceeded sampling period');
    % end

    % Store frame (debugging purposes / if we want to save the video)
    % videoFrames(:, :, :, i) = frame;

end

figure(2);
subplot(3,1,1);
plot(Hs.getStorage()); 
subplot(3,1,2);
plot(filteredHs);