function [TAmap, TAmapSmoothed, delays, lambdas] = prepareMap(fileExists, lambdaRange)

% smoothing windows
smoothWindowDelayFS = 15;   % [fs]
smoothWindowLambdaNM = 1;  % [nm]

% shiftZero(); % this should save a new map after shifting
[TAmap, delays, lambdas] = readMap(fileExists, 'sample');
TAmap = removeNoise(TAmap, delays);
[TAmap, lambdas] = cutMap(TAmap, lambdas, lambdaRange);
[TAmap, delays] = dechirpMap(0, TAmap, lambdaRange);
TAmapSmoothed = smoothMap(TAmap, smoothWindowDelayFS, smoothWindowLambdaNM, delays, lambdas);
% saveMap()

end