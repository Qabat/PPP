clc;
close all;

delayRange = [-100 1000];
lambdaRange = [320 650];

normDelay = 0; % fs

% max 4 dynamics and spectra to compare
dynamicsLambdas = [320 350 400 600];
spectraDelays = [100 200 300 500];
% spectraDelays = [1000 2000 3000 5000];
% spectraDelays = [10000 20000 30000 50000];


cmap = 'jet';
legendLocation = 'best';
linewidth = 2;
mainFontsize = 20;
legendFontsize = 8;
plusName = '_Comparison';


if ~exist('file1','var')
    [file1, path1] = uigetfile('C:\PhD\UV TA\*.dat');
end

if ~exist('file2','var')
    [file2, path2] = uigetfile('C:\PhD\UV TA\*.dat');
end

TA1 = dlmread([path1 file1]);
TA2 = dlmread([path2 file2]);

delays1 = TA1(1,2:end);
lambdas1 = TA1(2:end,1);
delays2 = TA2(1,2:end);
lambdas2 = TA2(2:end,1);
TA1 = TA1(2:end,2:end);
TA2 = TA2(2:end,2:end);

% intensityRange = [min(min(TA1)) max(max(TA1))];
intensityRange = [-0.25 2];

dynamicsComp = compareDynamics(normDelay, TA1, TA2, delays1, delays2, lambdas1, lambdas2, delayRange, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, file1, file2);
spectraComp = compareSpectra(TA1, TA2, delays1, delays2, lambdas1, lambdas2, intensityRange, lambdaRange, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, file1, file2);

printPlots(plusName, [dynamicsComp, spectraComp], [path1 file1]);
printPlots(plusName, [dynamicsComp, spectraComp], [path2 file2]);