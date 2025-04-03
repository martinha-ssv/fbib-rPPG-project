function processImg(frame, Hs, hs)
    % Get ROI from frame
    faces = detector('detect', det, frame);
    shape = detector('fit', det, frame, faces(1,:));

    % Get signal from face
    c = signal.getSignalFromFace(frame, faces(1,:), det);

    % Calculate bpv signal from raw signal
    [H_n, mu_n_1, mu_s_n_1, sigma_s_n_1, h_n] = signal.processWindow(fs, ls, c, mu_n_1, mu_s_n_1, sigma_s_n_1, hs);
    Hs.enqueue(H_n);
    hs.enqueue(h_n);

    % Filter signal
    if mod(i, hopSize) == 0 && i > Hs.getCapacity()
        y = filter(d, Hs.toMatrix(), 2);
        if floor(i / hopSize) == 1 % On first iteration
            filteredHs = y;%(1:2 * hopSize);
        else
            filteredHs = [filteredHs, y];%(1:end - hopSize)];
            % cross fade?
        end
    end

    set(y_data, 'YData', filteredHs(max(end-3*framesInCycle, 1):end));

    drawnow limitrate;
end