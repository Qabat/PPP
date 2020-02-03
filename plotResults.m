function plotResults(fileLocation, rangeVector, plottingVector, dynamicsLambdas, spectraDelays, plusName)
    
    mapVector = readMap(fileLocation, '_smoothed');
%     [TAmapDechirped, ~, ~] = readMap(fileLocation, '_dechirped');
        
    mapPlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    dynamicsPlot = plotDynamics(mapVector, rangeVector, plottingVector, dynamicsLambdas, fileLocation);
    spectraPlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation);

    printPlots(plusName, [mapPlot, dynamicsPlot, spectraPlot], fileLocation);
    
%     rawPlot = plotMap(cmap, delays, lambdas, TAmapDechirped, delayRange, lambdaRange, intensityRange,  intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
%     noisePlot = plotMap(cmap, delays, lambdas, TAmapDechirped-TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
%     printPlots([plusName '_residualMap'], [noisePlot], fileLocation);
%     printPlots([plusName '_rawMap'], [rawPlot], fileLocation);
    
end