function possiblePeaks = getPossiblePeaks(fs, ls, signalWindow)
    possiblePeaks = zeros(1,length(signalWindow));
    [~, peaksLocs] = findpeaks(signalWindow);
    possiblePeaks(peaksLocs) = 1;
end