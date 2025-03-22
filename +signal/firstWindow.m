function [mu_n_1, mu_s_1, sigma_s_1] = firstWindow(fs, ls, windowSignals)
    %FIRSTWINDOW This function takes the mean color vectors of the first window and outputs the parameters for the recursive window processing.
    %   windowSignals: 2D - size = (3, windowLen) - array containing the mean color vectors of the first window.
    lf = fs * ls;
    mu_frac = 1/lf;
    P = [0 1 -1; -2 1 1];
    projectedChannels = size(P, 1);


    [numChannels, windowLen] = size(windowSignals);
    
    mus = zeros(numChannels, windowLen);
    mus(:, 1) = windowSignals(:, 1);
    for i = 2:windowLen
        mus(:, i) = signal.temporalMean(windowSignals(:, i-1), windowSignals(:, i), mu_frac);
    end
    
    c_norms = windowSignals ./ mus;
    Ss = P * c_norms;

    mu_Ss = zeros(projectedChannels, windowLen);
    mu_Ss(:, 1) = Ss(:, 1);
    for i=2:windowLen
        mu_Ss(:, i) = signal.temporalMean(Ss(:, i-1), Ss(:, i), mu_frac);
    end

    sigma_Ss = zeros(projectedChannels, windowLen);
    sigma_Ss(:, 1) = std(Ss(:, 1), 0, 2);
    for i=1:windowLen
        sigma_Ss(:, i) = std(Ss(:, 1:i), 0, 2);
    end

    mu_n_1 = mus(:, end);
    mu_s_1 = mu_Ss(:, end);
    sigma_s_1 = sigma_Ss(:, end);




end