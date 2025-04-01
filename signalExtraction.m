
% POS method: 
% 1) temporal normalization  
% 2) orthogonal projection onto a plane orthogonal to the skin  
% 3) alpha.tuning to produce a 1D pulse signal  
% 4) filtering of the pulse signal

% lf = fs * ls  fs- sampling frequency (constant over time), ls- interval
% that contains 1 cardiac cycle, reccomended is 1.6s

% algorithm: 1) input: video with N frames lf=48 (fs = 30 fps video)  
% 2) output: extracted pulse signal H

% should we use fs as an input so that we can easily change fps ?
function H = signalExtraction(meanColorVs, numFrames)
    ls = 1.6; 
    lf = 48;
    fs = lf/ls;

    N =  numFrames;

    P = [0 1 -1; -2 1 1]; % 2x3 projection matrix

    mu_n = zeros(N, 3); % temporal mean
    c_norm = zeros(N, 3); % temporal normalization
    s = zeros(N, 2); % matrix containing 2 antiphase signals
    mu_s1 = 0; mu_s2 = 0; % s1 and s2 mean
    delta1 = 0; delta2 = 0; % delta i
    var_s1 = 0; var_s2 = 0; % variance
    h = zeros(N, 1); % pulse signal before normalization
    H = zeros(N, 1); % pulse signal after normalization

    % HAD TO START IN 2 DUE TO MU_N-1 (CHECK THIS AGAIN)
    for n = 2 : N
        % RGB pixel average (column vector)
        c = meanColorVs(n, :)';
        
        % Temporal Mean of the last lf frames 
        % c as line vector again ??
        mu_n(n, :) = ((lf - 1)/lf) * mu_n(n - 1, :) + (1 / lf) * c'; % --> zero padding

        % 1) Temporal Normalization
        % EXISTS inv() FUNCTION BUT MATLAB SUGGESTED ME TO USE DIAG \ C
        % (SUPPOSEDLY FASTER)
        c_norm(n, :) = (diag(mu_n(n, :))) \ c;

        % 2) Orthogonal projection
        % C COLUMN OR LINE VECTOR?
        s(n, :) = (P * c_norm(n, :)')'; 

        % s1 and s2 mean 
        % NOT SURE ABOUT mu_s1 BECAUSE IT NEEDS mu_si-1??? (assuming its 0)
        mu_s1 = ((lf - 1)/lf) * mu_s1 + (1/lf) * s(n, 1); % --> zero padding
        mu_s2 = ((lf - 1)/lf) * mu_s2 + (1/lf) * s(n, 2); % --> zero padding

        % delta i calculation: delta i = (si - mu_si)
        delta1 = s(n, 1) - mu_s1;
        delta2 = s(n, 2) - mu_s2;

        % variance calculation 
        % SAME PROBLEM WITH var_si-1 ???
        if n > 2
            var_s1 = (1/lf) * (delta1^2) + ((lf - 1)/lf) * var_s1;
            var_s2 = (1/lf) * (delta2^2) + ((lf - 1)/lf) * var_s2;
        else 
            % to avoid by zero division on alpha calculations
            var_s1 = max(var(s(1:n, 1), 1), 1e-6); 
            var_s2 = max(var(s(2:n, 2), 1), 1e-6);
        end

        % 3) Alpha tuning
        alpha = sqrt(var_s1 / var_s2);
        h(n) = s(n, 1) + alpha * s(n, 2);
        
        % 4) Normalisation
        if n > 2 
            H(n) = (h(n) - mean(h(1:n))) / std(h(1:n)); % std- standard deviation
        else
            H(n) = h(n); % avoids division by zero
        end
    end
end
