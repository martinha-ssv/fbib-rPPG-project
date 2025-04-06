function [H_n, mu_n, mu_s_n, sigma_s_n, h_n] = recursiveWindow(fs, ls, c, mu_n_1, mu_s_n_1, sigma_s_n_1, hs)
    %PROCESSFRAME Inputs the mean color vector of a frame and the temporal mean
    %of the rest of the window, as well as extra parameters, and outputs the
    %window's heart signal.

    % windowSignals: c(n) column vectors from each frame. Most recent vector corresponds to current frame.
    % mus: mean vector of each window
    % fs: sampling frequency (aka video frames per second)
    % ls: (optional, defaults to 1.6) interval containing 1 cardiac cycle


    % Constants
    P = [0 1 -1; -2 1 1]; % 2x3 projection matrix
    lf = fs * ls; % Length of frame
    mu_frac = 1/lf; % Parameter that weighs previous mean and current window's signal
    
    
    % Color vector mean and normalization
    mu_n = signal.temporalMean(c, mu_n_1, mu_frac); % Current window mean
    c_norm = (c ./ mu_n)'; % Normalized frame mean color vector (to window)

    % Projection
    S = P * c_norm;

    % Alpha tuning parameters calculation
    mu_s_n = signal.temporalMean(S, mu_s_n_1, mu_frac);
    delta_s = S - mu_s_n;

    var_s = signal.temporalMean(delta_s.^2, sigma_s_n_1.^2, mu_frac);
    var_s = max(var_s, 1e-7);

    sigma_s_n = sqrt(var_s);

    % Alpha tuning
    if sigma_s_n(2) == 0
        alpha = 1e-2; 
    else
        alpha = sigma_s_n(1)/sigma_s_n(2);
    end
    h_n = S(1) + alpha * S(2);

    
    % Normalisation
    hs = hs.toMatrix();

    sigma_h = std(hs); % hs is a vector of scalars
    if sigma_h < 1e-6
        sigma_h = 1;
    end

    H_n = (h_n - mean(hs)) / sigma_h;
end