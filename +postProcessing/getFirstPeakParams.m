function [t_exp, last_t, mu_T] = getFirstPeakParams(possiblePeaks, timestamps, mu_T_start)
    i = find(possiblePeaks, 1, 'first');
    t_exp = timestamps(i) + mu_T;
    t_n_1 = timestamps(i);
    mu_T = mu_T_start; 
end

