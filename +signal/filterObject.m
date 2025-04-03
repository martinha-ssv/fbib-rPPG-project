function d = filterObject(fs, cutoffs)
    %FILTEROBJECT Creates a filter object for the given sampling frequency
    %and cutoff frequency.
    %
    %   d = FILTEROBJECT(fs, d, cutoff) creates a filter object for the
    %   given sampling frequency fs and cutoff frequency cutoff. The filter
    %   object is used to filter the input signal d.
    %
    %   Inputs:
    %       fs: Sampling frequency (Hz)
    %       cutoffs: Cutoff frequencies (Hz)
    %
    %   Outputs:
    %       d: Filtered signal (vector)
    
    [br, ak] = butter(2, cutoffs/(fs/2), 'bandpass');
    d = dfilt.df2t(br, ak);
    d.PersistentMemory = true; % Use persistent memory for the filter object

end