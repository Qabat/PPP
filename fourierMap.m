function fourierMap(fileLocation, rangeVector, plottingVector, spectraDelays, dynamicsLambdas, alpha, tau, smoothWindowDelayFS, plusName)
    
    mapVector = readMap(fileLocation, '_smoothed');
    TAmap = mapVector{1};
    delays = mapVector{2};
    lambdas = mapVector{3};
    
    timeStart = 75; % fs % min 75 fs for tryptophan
    timeStop = 1200; % fs
    smoothingFactor = 5; % max 10

    TAmapOscillation = TAmap - smoothMap(TAmap, delays, lambdas, smoothWindowDelayFS*smoothingFactor, 0);
    TAmapOscillation = smoothMap(TAmapOscillation, delays, lambdas, 0, 5);
    saveMap(TAmapOscillation, delays, lambdas, fileLocation, '_oscillations')
    
    % gaussian gating for Gabor transform
    TAmapOscillation = TAmapOscillation .* exp(- ((delays - tau).^2) ./ (0.361 * alpha.^2));
    
    [TAmapFFT, TAmapPhase, frequencyFFT, lambdasFFT] = fourierTransform(delays, lambdas, TAmapOscillation, timeStart, timeStop);
        TAmapFFT = smoothMap(TAmapFFT, frequencyFFT, lambdasFFT, 10, 10);
        TAmapFFT = TAmapFFT / max(max(TAmapFFT));

%     % normalize the oscillations to their sign
%     TAmapOscillation(TAmapOscillation < 0) = -0.2;
%     TAmapOscillation(TAmapOscillation > 0) = 0.2;
%     
%     % normalize the oscillations to 0 if less than half of max and 1 if more than half of max
%     TAmapOscillation = TAmapOscillation./max(TAmapOscillation,[],1);
%     TAmapOscillation(TAmapOscillation < -0.05) = -1;
%     TAmapOscillation(TAmapOscillation > 0.05) = 1;
%     TAmapOscillation(TAmapOscillation < 0.05 & TAmapOscillation > -0.05) = 0;
% %     TAmapOscillation = TAmapOscillation./5;
    
        % normalize the oscillations to 0 if less than half of max and 1 if more than half of max
% 
%     TAmapOscillation(TAmapOscillation < 0.5*TAmapOscillation) = -1;
%     TAmapOscillation(TAmapOscillation > 0.5*TAmapOscillation) = 1;


    mapVector{1} = TAmapOscillation;
    plottingVector{8} = 'bwr';
    rangeVector{1} = [timeStart timeStop];
    oscillationPlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    dynamicsOscPlot = plotDynamics(mapVector, rangeVector, plottingVector, dynamicsLambdas, fileLocation);
    spectraOscPlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation);

    rangeVector{1} = [250 1250];
%         rangeVector{1} = [500 1000];

% plot log scale
%     TAmapFFT = 1-abs(log10(TAmapFFT));

    

    rangeVector{3} = [0 0.3];
%     rangeVector{3} = [0 0.2];
    plottingVector{8} = 'inferno';
    mapVector = {(TAmapFFT), frequencyFFT, lambdasFFT};
    FFTPlot = plotMapFT(mapVector, rangeVector, plottingVector, fileLocation, tau);
    dynamicsFFTPlot = plotDynamics(mapVector, rangeVector, plottingVector, dynamicsLambdas, fileLocation);
    spectraFFTPlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation);
 
    mapVector{1} = TAmapPhase;
    plottingVector{8} = 'bwr';
    rangeVector{3} = [-pi pi];
%     PhasePlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    spectraPhasePlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation);

    printPlots([plusName '_oscillationMap'], [oscillationPlot, dynamicsOscPlot], fileLocation);
    printPlots([plusName '_FFTMap'], [FFTPlot, dynamicsFFTPlot, spectraFFTPlot], fileLocation);
%     printPlots([plusName '_PhaseMap'], [PhasePlot, spectraPhasePlot], fileLocation);

end