
% Filtering the raw pulse signal using a second order IIR bandpass
% butterworth filter with bandpass [0.8; 2.5]Hz (equivalent to human heart
% rate range od 48 to 150 bpm)
% (difference equation in the paper)

function H_filtered = signalFiltration(H)
    br = [0.020 0 -0.040 0 0.020]; % br coefficients (x) (numerator)
    ak = [1 -3.411 4.497 -2.723 0.639]; % ak coefficients (y) (denominator)
    H_filtered = filter(br, ak, H);
end
