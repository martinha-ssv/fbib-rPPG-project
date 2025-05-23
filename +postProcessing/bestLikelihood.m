function [k, lik] = bestLikelihood(putatives, signalWindow, timestamps, t_exp)
    if isempty(putatives)
        [~, k] = min(timestamps - t_exp) % k is the index of the timestamp closest to t_exp
        lik = exp((timestamps(k) - t_exp).^2) .* signalWindow(k);
    elseif length(putatives) == 1
        k = putatives(1);
        lik = exp((timestamps(k) - t_exp).^2) .* signalWindow(k);
    else
        likelihoods = exp((timestamps(putatives) - t_exp).^2) .* signalWindow(putatives);
        [lik, k] = max(likelihoods);
        k = putatives(k);
    end
end

