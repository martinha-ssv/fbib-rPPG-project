function [h_n, mu_n_1, mu_s_1, sigma_s_1] = processWindow(fs, ls, frameSignal, mu_n_1, mu_s_1, sigma_s_1)
    %PROCESSFRAME Inputs the mean color vector of a frame and the temporal mean
    %of the rest of the window, as well as extra parameters, and outputs the
    %window's heart signal.

    % frameSignal: c(n) column vector from current frame
    % mu_n_1: mu(n-1), mean vector of previous window
    % fs: sampling frequency (aka video frames per second)
    % ls: (optional, defaults to 1.6) interval containing 1 cardiac cycle

    if nargin == 3
        [mu_n_1, mu_s_1, sigma_s_1] = firstWindow(frameSignal);
        h_n = 0;
        return
    else
        
    end

    