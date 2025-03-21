function [mu_n, H_n] = recursiveWindow(frameSignal, mu_n_1, mu_s_1, sigma_s_1, fs, ls)
    %PROCESSFRAME Inputs the mean color vector of a frame and the temporal mean
    %of the rest of the window, as well as extra parameters, and outputs the
    %window's heart signal.

    % frameSignal: c(n) column vector from current frame
    % mu_n_1: mu(n-1), mean vector of previous window
    % fs: sampling frequency (aka video frames per second)
    % ls: (optional, defaults to 1.6) interval containing 1 cardiac cycle


    lf = fs * ls; % Length of frame

    % Constants
    P = [0 1 -1; -2 1 1]; % 2x3 projection matrix
    mu_frac = 1/lf; % Parameter that weighs previous mean and current window's signal

    % Color vector mean and normalization
    mu_n = signal.temporalMean(frameSignal, mu_n_1, mu_frac); % Current window mean
    c_norm = diag(c ./ mu_n); % Normalized frame mean color vector (to window)

    % Projection
    S = P * c_norm;

    % Alpha tuning parameters calculation
    mu_s = signal.temporalMean(S, mu_s_1, mu_frac);
    dev_s = S - mu_s;
    var_s = signal.temporalMean(dev_s.^2, sigma_s_1.^2);
    sigma_s = sqrt(var_s);

    % Alpha tuning
    alpha = sigma_s(1)/sigma_s(2);
    h_n = S(1) + alpha * S(s);

    % Normalisation
    H_n = (h_n - mu_h) / stdev_h;
end