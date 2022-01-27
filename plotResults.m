function plotResults(fileLocation, rangeVector, plottingVector, dynamicsLambdas, spectraDelays, plusName)
    
    mapVector = readMap(fileLocation, '_smoothed');
    
%     [TAmapDechirped, ~, ~] = readMap(fileLocation, '_dechirped');
%     mapVector{1} = mapVector{1}.*1.2; %1.2 for NADH in water, 1.8 for NADH in PBS
    
%     mapVector{1} = mapVector{1}./100.*1.2;
    
    mapPlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    dynamicsPlot = plotDynamics(mapVector, rangeVector, plottingVector, dynamicsLambdas, fileLocation);
    spectraPlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation);

    printPlots(plusName, [mapPlot, dynamicsPlot, spectraPlot], fileLocation);
    
%     rawPlot = plotMap(cmap, delays, lambdas, TAmapDechirped, delayRange, lambdaRange, intensityRange,  intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
%     noisePlot = plotMap(cmap, delays, lambdas, TAmapDechirped-TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
%     printPlots([plusName '_residualMap'], [noisePlot], fileLocation);
%     printPlots([plusName '_rawMap'], [rawPlot], fileLocation);
    
end