
function fileLocation = prepareMap(parametersPreparation, rangeVector, plottingVector, lambdaShift, smoothWindowDelayFS, smoothWindowLambdaNM)

    readNewSample = parametersPreparation(1);
    dechirpSample = parametersPreparation(2);
    smoothSample = parametersPreparation(3);

    lambdaRange = rangeVector{2};
    
    if readNewSample == 1
        [allScans, delays, lambdas, fileLocation] = readScans(readNewSample, 'sample');
        [~, allScans] = shiftZero(allScans, lambdas, lambdaShift, fileLocation);    
        [chirpedTAmap, ~, lambdas] = rejectScans(allScans, lambdas, lambdaRange, fileLocation);
        chirpedTAmap = -1000*log10(chirpedTAmap/100 + 1);
        saveMap(chirpedTAmap, delays, lambdas, fileLocation, '_shifted');
    end

    if dechirpSample == 1
        mapVector = {chirpedTAmap, delays, lambdas};
        [TAmapDechirped, delays] = dechirpClicking(mapVector, rangeVector, plottingVector, fileLocation);
        saveMap(TAmapDechirped, delays, lambdas, fileLocation, '_dechirped');
    end

    if smoothSample == 1
        TAmapSmoothed = smoothMap(TAmapDechirped, delays, lambdas, smoothWindowDelayFS, smoothWindowLambdaNM);
        saveMap(TAmapSmoothed, delays, lambdas, fileLocation, '_smoothed');
    end

end