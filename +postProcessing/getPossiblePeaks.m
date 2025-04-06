function possiblePeaks = getPossiblePeaks(fs, ls, signalWindow)
    r = floor(fs/8); % Length of window for smoothing 2nd derivative -
    % approx. 1/8 of window - visual data exploration shows approximately 3-4
    % peaks per window
    kernel = ones(1,r)/r;
    signalDerivative = diff(signalWindow);
    secDeriv = diff(signalWindow, 2); 
    secDeriv = filter(kernel, 1, signalDerivative);
    possiblePeaks = abs(signalDerivative) < 0.1 & secDeriv > 0; possiblePeaks(end + 1) = 0;
end