% just for quickly plotting TA map

close all
clc

[file, path] = uigetfile('C:\PhD\UV TA\samples\nucleosides\*.dat');        
fileLocation = [path file];

[TAmap, delays, lambdas] = readMap(fileLocation, '');

delayRange = [0 1000];
lambdaRange = [310 650];
dynamicsLambdas = [320 350 400 500 600];
spectraDelays = [50 100 150 300 500];
cmap = 'bwrjet';
numColor = 64;
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
intensityRange = [-0.5 0.25];

mapPlot = plotMap(cmap, delays, lambdas, TAmap, delayRange, lambdaRange, intensityRange, intensityAxis, linewidth, mainFontsize, fileLocation, numColor);
dynamicsPlot = plotDynamics(TAmap, delays, lambdas, delayRange, intensityRange, intensityAxis, intensityOffset, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraPlot = plotSpectra(TAmap, delays, lambdas, lambdaRange, intensityRange, intensityAxis, intensityOffset, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);


printPlots(plusName, [mapPlot, dynamicsPlot, spectraPlot], fileLocation);
