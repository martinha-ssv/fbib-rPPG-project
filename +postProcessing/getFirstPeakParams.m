function [t_exp, last_t, mu_T, i] = getFirstPeakParams(possiblePeaks, timestamps, mu_T_start)
    i = find(possiblePeaks, 1, 'first');
    if isempty(i)
        i = floor(length(timestamps)/2); % HACK
    end
    t_exp = timestamps(i) + mu_T_start;
    last_t = timestamps(i);
    mu_T = mu_T_start;
end

