function mean = temporalMean(currentValue,previousMean, weight)
    mean = (1 - weight) * previousMean + weight * currentValue;
end