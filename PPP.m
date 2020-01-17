%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MAIN PROGRAM FOR ANALYZING TRANSIENT ABSORPTION MAPS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

readNewSample = 0; % 0/samesample, 1/newsample
dechirpSample = 0; % 0/no, 1/dechirping of current sample
smoothSample = 1;
dechirpType = 2; % 0/no, 1/solvent, 2/clicking 

delayRange = [-100 1000];
lambdaRange = [310 650];
dynamicsLambdas = [350 400 600];
spectraDelays = [50 100 250 500 1000];
timeZero = 0;
lambda = 340;
smoothWindowDelayFS = 15;  % [fs] % maybe I should avoid smoothing time to see oscillations in fft better
smoothWindowLambdaNM = 3;  % [nm]
cmap = 'bwr';
numColor = 1024;
legendLocation = 'northeast';
linewidth = 2;
mainFontsize = 20;
legendFontsize = 10;
plusName = ['_' 'fftfull' cmap '_' num2str(numColor)];

intensityAxis = '\DeltaT/T [%]';

if readNewSample == 1
    [allScans, delays, lambdas, fileLocation] = readScans(readNewSample, 'sample');
    
    % interpolate scans to the smallest delay step
%     [allScans, delays] = interpolateDelays(allScans, delays);
    % interpolate scans to the smallest delay step
    
    [~, allScans] = shiftZero(allScans, lambdas, lambda, fileLocation);    
    [chirpedTAmap, allScans, lambdas] = rejectScans(allScans, lambdas, lambdaRange, fileLocation);
    saveMap(chirpedTAmap, delays, lambdas, fileLocation, '_shifted_rejected');
    
end

if dechirpSample == 1
    if dechirpType == 1
        [TAmapDechirped, delays] = dechirpFitting(chirpedTAmap, delays, lambdas, lambdaRange);
    elseif dechirpType == 2
        [TAmapDechirped, delays] = dechirpClicking(chirpedTAmap, delays, lambdas, delayRange, lambdaRange, [-0.1 0.1], intensityAxis, linewidth, mainFontsize, fileLocation);
    end
        saveMap(TAmapDechirped, delays, lambdas, fileLocation, '_dechirped');
end

if smoothSample == 1
    TAmapSmoothed = smoothMap(TAmapDechirped, delays, lambdas, smoothWindowDelayFS, smoothWindowLambdaNM);
    saveMap(TAmapSmoothed, delays, lambdas, fileLocation, '_smoothed');
end

[TAmapSmoothed, delays, lambdas] = readMap(fileLocation, '_smoothed');
delays = delays - timeZero; % for shifting to zero time

% uncomment for converting to DeltaOD
% TAmapSmoothed = -log10(TAmapSmoothed/100 + 1);

intensityOffset = 0.01;
intensityRange = [min(min(TAmapSmoothed)) max(max(TAmapSmoothed))];
% intensityRange = [-0.03 0];

mapPlot = plotMap(cmap, delays, lambdas, TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, linewidth, mainFontsize, fileLocation, numColor);
rawPlot = plotMap(cmap, delays, lambdas, TAmapDechirped, delayRange, lambdaRange, intensityRange,  intensityAxis, linewidth, mainFontsize, fileLocation, numColor);
noisePlot = plotMap(cmap, delays, lambdas, TAmapDechirped-TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, linewidth, mainFontsize, fileLocation, numColor);
dynamicsPlot = plotDynamics(TAmapSmoothed, delays, lambdas, delayRange, intensityRange, intensityAxis, intensityOffset, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraPlot = plotSpectra(TAmapSmoothed, delays, lambdas, lambdaRange, intensityRange, intensityAxis, intensityOffset, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

TAmapSmoothedMore = smoothMap(TAmapSmoothed, delays, lambdas, smoothWindowDelayFS*5, smoothWindowLambdaNM);
TAmapOscillation = TAmapDechirped-TAmapSmoothedMore;
TAmapOscillation = smoothMap(TAmapOscillation, delays, lambdas, smoothWindowDelayFS/10, smoothWindowLambdaNM);
oscillationPlot = plotMap(cmap, delays, lambdas, TAmapOscillation, delayRange, lambdaRange, intensityRange/10, intensityAxis, linewidth, mainFontsize, fileLocation, numColor);

[TAmapFFT, frequencyFFT, lambdasFFT] = fftMap(delays, lambdas, TAmapOscillation);
TAmapFFT = smoothMap(TAmapFFT, delays, lambdas, smoothWindowDelayFS, smoothWindowLambdaNM);

% size(frequencyFFT)
% size(lambdasFFT)
% size(TAmapFFT)

frequencyRange = [0 2000];  
intensityRangeFFT = [0 0.4];
FFTlambdas = [320 340 360 380];
FFTPlot = plotMap('jet', frequencyFFT, lambdasFFT, TAmapFFT, frequencyRange, lambdaRange, intensityRangeFFT, intensityAxis, linewidth, mainFontsize, fileLocation, numColor);
dynamicsFFTPlot = plotDynamics(TAmapFFT, frequencyFFT, lambdasFFT, frequencyRange, intensityRangeFFT, intensityAxis, intensityOffset, FFTlambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);


% sOsc = sOsc(2)

% oscillationPlot2 = plotMap(cmap, 1:sOsc, lambdasFFT, TAmapOscillation2, [-1000 10000], lambdaRange, intensityRange/10, linewidth, mainFontsize, fileLocation, numColor);


printPlots(plusName, [mapPlot, dynamicsPlot, spectraPlot], fileLocation);
printPlots('_residualMap', [noisePlot], fileLocation);
printPlots('_rawMap', [rawPlot], fileLocation);
printPlots('_oscillationMap', [oscillationPlot], fileLocation);
printPlots('_FFTMap', [FFTPlot, dynamicsFFTPlot], fileLocation);



% temporary for fitting with toolbox
% timeStart = 70;
% fitDelays = delays(timeStart:226);
% lambda320Decay = TAmapSmoothed(20, timeStart:226);
% lambda350Decay = TAmapSmoothed(80, timeStart:226) + 0.035 ;
% lambda380Decay = TAmapSmoothed(140, timeStart:226);
% lambda425Decay = TAmapSmoothed(225, timeStart:226);
% lambda500Decay = TAmapSmoothed(370, timeStart:226);
% lambda345355Decay = mean(TAmapSmoothed(70:90, timeStart:226)) + 0.035 ;
% lambda340360Decay = mean(TAmapSmoothed(60:100, timeStart:226)) + 0.035 ;


% to be done later: fitting and FFT
% fitMap();
% TAmapResidual = TAmap - TAmapSmoothed;
% mapResidualPlot = plotMap(delays, lambdas, TAmapResidual, delayRange, lambdaRange, intensityRange, linewidth, mainFontsize, units);
% fftMap();