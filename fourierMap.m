function fourierMap(fileLocation, rangeVector, plottingVector, dynamicsLambdas, spectraDelays, smoothWindowDelayFS, plusName)
    
    mapVector = readMap(fileLocation, '_smoothed');
    TAmap = mapVector{1};
    delays = mapVector{2};
    lambdas = mapVector{3};
    
    timeStart = 100; % fs
    timeStop = 1000; % fs
    smoothingFactor = 5; % max 10

    TAmapOscillation = TAmap - smoothMap(TAmap, delays, lambdas, smoothWindowDelayFS*smoothingFactor, 0);
    [TAmapFFT, TAmapPhase, frequencyFFT, lambdasFFT] = fourierTransform(delays, lambdas, TAmapOscillation, timeStart, timeStop);

    mapVector{1} = TAmapOscillation;
    oscillationPlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    
    mapVector = {TAmapFFT, frequencyFFT, lambdasFFT};
    FFTPlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    dynamicsFFTPlot = plotDynamics(mapVector, rangeVector, plottingVector, dynamicsLambdas, fileLocation);
    spectraFFTPlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation);
 
    mapVector{1} = TAmapPhase;
    plottingVector{8} = 'bwr';
    rangeVector{3} = [-pi pi];
    PhasePlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    spectraPhasePlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation);

    printPlots([plusName '_oscillationMap'], [oscillationPlot], fileLocation);
    printPlots([plusName '_FFTMap'], [FFTPlot, dynamicsFFTPlot, spectraFFTPlot], fileLocation);
    printPlots([plusName '_PhaseMap'], [PhasePlot, spectraPhasePlot], fileLocation);

end