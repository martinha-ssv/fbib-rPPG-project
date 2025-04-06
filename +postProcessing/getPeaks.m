function peaks = getPeaks(signalWin, timestamps, last_t, mu_T)
    alpha = 0.7;
    peaks = false(1, length(signalWin));
    [peakValues, locs, ~] = findpeaks(signalWin); % starting assumption of peaks
    rris = diff(locs);
    potential_fp = rris < (0.7 * mean(rris));
    cluster = false;
    
    potential_fp = [0, potential_fp] | [potential_fp, 0];
    if any(potential_fp)
        for i=1:length(potential_fp)-1
            if potential_fp(i) && potential_fp(i+1)
                if peakValues(i) > peakValues(i+1)
                    potential_fp(i) = 0;
                end
            end
        end
    end

    locs(potential_fp) = [];
    peaks(locs) = true;
end
           