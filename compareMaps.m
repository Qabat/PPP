clc;
close all;

delayRange = [-100 800];
lambdaRange = [310 640];

normDelay = 800; % fs

% max 4 dynamics and spectra to compare
dynamicsLambdas = [315 350 400 600];
spectraDelays = [100 200 300 500];
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

% WHEN THIS IS USED, Y AXIS TITLE NEEDS TO BE CHANGED TOO
% uncomment for converting to mDeltaOD
% TA1 = -log10(TA1/100 + 1) * 1000;
% TA2 = -log10(TA2/100 + 1) * 1000;

% intensityRange = [min(min(TA1)) max(max(TA1))];
intensityRange = [-0.5 0.5];

dynamicsComp = compareDynamics(normDelay, TA1, TA2, delays1, delays2, lambdas1, lambdas2, delayRange, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, file1, file2);
spectraComp = compareSpectra(TA1, TA2, delays1, delays2, lambdas1, lambdas2, intensityRange, lambdaRange, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, file1, file2);

printPlots(plusName, [dynamicsComp, spectraComp], [path1 file1]);
printPlots(plusName, [dynamicsComp, spectraComp], [path2 file2]);