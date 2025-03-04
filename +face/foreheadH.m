function h = foreheadH(shape)
% Calculates forehead height by assuming it is 1/4 of total face height.
%
% Subtracts y coordinate of chin from y coordinate of 
% right eyebrow to get total face height (minus forehead).

    h = (shape(20,2) - shape(9,2)) / 3;
end