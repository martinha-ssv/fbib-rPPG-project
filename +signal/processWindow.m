function [H_n, mu_n, mu_s_n, sigma_s_n, h_n] = processWindow(fs, ls, c, mu_n_1, mu_s_n_1, sigma_s_n_1, hs)
    %PROCESSFRAME Inputs the mean color vector of a frame and the temporal mean
    %of the rest of the window, as well as extra parameters, and outputs the
    %window's heart signal.

    % windowSignals: 3xN matrix containing the mean color vectors of the window
    % mu_n_1: mu(n-1), mean vector of previous window
    % fs: sampling frequency (aka video frames per second)
    % ls: (optional, defaults to 1.6) interval containing 1 cardiac cycle

    if ~hs.isFull()
        hs.pad(0, "left");
    end

    [H_n, mu_n, mu_s_n, sigma_s_n, h_n] = signal.recursiveWindow(fs, ls, c, mu_n_1, mu_s_n_1, sigma_s_n_1, hs);
%{
 if windowSignals.isFull()
        [H_n, mu_n, mu_s_n, sigma_s_n, h_n] = signal.recursiveWindow(fs, ls, windowSignals, ...
                                                                                            mus, ...
                                                                                            mu_ss, ...
                                                                                          sigma_ss, ...
                                                                                            hs);
    else
        [H_n, mu_n, mu_s_n, sigma_s_n, h_n] = signal.recursiveWindow(fs, ls, windowSignals.pad(0, "left"), ...
                                                                                            mus.pad(0, "left"), ...
                                                                                            mu_ss.pad(0, "left"), ...
                                                                                            sigma_ss.pad(0, "left"), ...
                                                                                            hs.pad(0, "left"));
    end 
%}
