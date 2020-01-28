% just for quickly plotting TA map

close all
clc

[file, path] = uigetfile('C:\PhD\UV TA\samples\nucleosides\*.dat');        
fileLocation = [path file];

[TAmap, delays, lambdas] = readMap(fileLocation, '');

delayRange = [0 1000];
lambdaRange = [290 350];
dynamicsLambdas = [290 300 320 350];
spectraDelays = [50 100 200 300 500 1000];
cmap = 'bwrjet';
numColor = 1024;
legendLocation = 'best';
linewidth = 2;
mainFontsize = 20;
legendFontsize = 10;
plusName = ['_' '' cmap '_' num2str(numColor)];

intensityAxis = '\DeltaA [mOD]';
% for having mOD on the intensity axis, multiply by 1000
TAmap = TAmap * 1000;

intensityOffset = 0.1;
% intensityRange = [min(min(TAmap))*1.1 max(max(TAmap))*1.1];
intensityRange = [-2.5 2];

mapPlot = plotMap(cmap, delays, lambdas, TAmap, delayRange, lambdaRange, intensityRange, intensityAxis, linewidth, mainFontsize, fileLocation, numColor);
dynamicsPlot = plotDynamics(TAmap, delays, lambdas, delayRange, intensityRange, intensityAxis, intensityOffset, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraPlot = plotSpectra(TAmap, delays, lambdas, lambdaRange, intensityRange, intensityAxis, intensityOffset, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

% % get data from spectra plot
% D=get(gca,'Children'); %get the handle of the line object
% XData=get(D,'XData'); %get the x data
% YData=get(D,'YData'); %get the y data
% Data=[XData' YData']; %join the x and y data on one array nx2

printPlots(plusName, [mapPlot, dynamicsPlot, spectraPlot], fileLocation);
