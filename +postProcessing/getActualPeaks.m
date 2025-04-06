function [peaks_actual, mu_T, t_exp, last_t, putatives] = getActualPeaks(signalWindow, possiblePeaks, timestamps, mu_T, t_exp, last_t, starti)
    alpha = 0.7;
    peaks_actual = zeros(size(timestamps));
    window_tmin = t_exp - 0.5 * mu_T;
    window_tmax = t_exp + 0.5 * mu_T;
    putatives = [];
    for j = starti:length(timestamps)
        if possiblePeaks(j)
            window_tmin = t_exp + 0.5 * mu_T;
            window_tmax = t_exp + 1.5 * mu_T;

            if (timestamps(j) >= window_tmin) && (timestamps(j) <= window_tmax)
                putatives(end + 1) = j;
            end
        elseif timestamps(j) > window_tmax
            k = postProcessing.bestLikelihood(putatives, signalWindow, timestamps, t_exp);
            peaks_actual(k) = 1;
            T = timestamps(k) - t_exp;
            mu_T = signal.temporalMean(T, mu_T, alpha);
            t_exp = last_t + mu_T;
            last_t = timestamps(k);
            putatives = [];
        end
    end

end