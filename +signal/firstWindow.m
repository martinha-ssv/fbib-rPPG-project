function [mu_n, mu_s, sigma_s] = firstWindow(windowSignals)
    %FIRSTWINDOW This function takes the mean color vectors of the first window and outputs the parameters for the recursive window processing.
    %   windowSignals: 2D - size = (3, windowLen) - array containing the mean color vectors of the first window.
    
    % Constants
    P = [0 1 -1; -2 1 1]; % 2x3 projection matrix

    % Calculations
    mu_n = mean(windowSignals, 2); % Mean of the first window

    c_norm = windowSignals ./ mu_n; % Normalized frame mean color vector (to window)
    Ss = P*c_norm;
    
    mu_s = mean(Ss, 2);
    sigma_s = std(Ss, 1, 2);
end