%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MAIN PROGRAM FOR ANALYZING TRANSIENT ABSORPTION MAPS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ADD OPTION FOR THE NAME OF X AXIS SO I CAN PLOT FFT PROPERLY

close all;

readNewSample = 0; % 0/samesample, 1/newsample
dechirpSample = 0; % 0/no, 1/dechirping of current sample
smoothSample = 0;
dechirpType = 2; % 0/no, 1/solvent, 2/clicking 

fileLocation = 'C:\PhD\UV TA\samples\aminoacids\tryptophan\tryptophan VIS magic angle 284 nm 70 nJ 21.01.2020\d200121_01_tryptophan_VIS_magic_284nm_185mg_25ml_70nJ_1';

% plotting parameters
delayRange = [0 1000];
lambdaRange = [310 400];
dynamicsLambdas = [330 348 370];
spectraDelays = [50 200 500 1000 3000];
timeZero = 0;
lambdaShift = 370; % REMEMBER TO CHOOSE SUITABLE LAMBDA HERE
smoothWindowDelayFS = 15;  % [fs] % maybe I should avoid smoothing time to see oscillations in fft better
smoothWindowLambdaNM = 3;  % [nm]
cmap = 'jet';
numColor = 1024;
legendLocation = 'best';
linewidth = 2;
mainFontsize = 20;
legendFontsize = 14;
plusName = ['_' 'submission35' '_' cmap '_' num2str(numColor)];
intensityAxis = '\DeltaA [mOD]';
intensityOffset = 0;
intensityRange = [-1 1];

xAxis = 'delay [fs]';
if readNewSample == 1
    [allScans, delays, lambdas, fileLocation] = readScans(readNewSample, 'sample');
    
    % interpolate scans to the smallest delay step
%     [allScans, delays] = interpolateDelays(allScans, delays);
    % interpolate scans to the smallest delay step
    
    [~, allScans] = shiftZero(allScans, lambdas, lambdaShift, fileLocation);    
    [chirpedTAmap, allScans, lambdas] = rejectScans(allScans, lambdas, lambdaRange, fileLocation);
    saveMap(chirpedTAmap, delays, lambdas, fileLocation, '_shifted_rejected');
    
end

if dechirpSample == 1
    if dechirpType == 1
        [TAmapDechirped, delays] = dechirpFitting(chirpedTAmap, delays, lambdas, lambdaRange);
    elseif dechirpType == 2
        [TAmapDechirped, delays] = dechirpClicking(chirpedTAmap, delays, lambdas, delayRange, lambdaRange, [-1 5], intensityAxis, xAxis, linewidth, mainFontsize, fileLocation);
    end
        saveMap(TAmapDechirped, delays, lambdas, fileLocation, '_dechirped');
end

if smoothSample == 1
    TAmapSmoothed = smoothMap(TAmapDechirped, delays, lambdas, smoothWindowDelayFS, smoothWindowLambdaNM);
    saveMap(TAmapSmoothed, delays, lambdas, fileLocation, '_smoothed');
end

[TAmapSmoothed, delays, lambdas] = readMap(fileLocation, '_smoothed');
delays = delays - timeZero; % for shifting to zero time
% intensityRange = [min(min(TAmapSmoothed)) max(max(TAmapSmoothed))];

% uncomment for converting to mDeltaOD
TAmapSmoothed = -log10(TAmapSmoothed/100 + 1) * 1000;

% subtract here the spectrum at specific delay from the whole map
% TAmapSmoothed = TAmapSmoothed - TAmapSmoothed(:, find(delays >= 50, 1));


mapPlot = plotMap(cmap, delays, lambdas, TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
rawPlot = plotMap(cmap, delays, lambdas, TAmapDechirped, delayRange, lambdaRange, intensityRange,  intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
noisePlot = plotMap(cmap, delays, lambdas, TAmapDechirped-TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
dynamicsPlot = plotDynamics(TAmapSmoothed, delays, lambdas, delayRange, intensityRange, intensityAxis, xAxis, intensityOffset, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraPlot = plotSpectra(TAmapSmoothed, delays, lambdas, lambdaRange, intensityRange, intensityAxis, intensityOffset, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

oscLambdas = [310 330 360];
oscIntensityRange = [-0.25 0.25];
TAmapSmoothedMore = smoothMap(TAmapSmoothed, delays, lambdas, smoothWindowDelayFS*5, 0);
TAmapOscillation = TAmapSmoothed - TAmapSmoothedMore;
TAmapOscillation = smoothMap(TAmapOscillation, delays, lambdas, smoothWindowDelayFS/10, smoothWindowLambdaNM);
oscillationPlot = plotMap('bwr', delays, lambdas, TAmapOscillation, delayRange, lambdaRange, oscIntensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
dynamicsOscPlot = plotDynamics(TAmapOscillation, delays, lambdas, delayRange, oscIntensityRange, intensityAxis, xAxis, intensityOffset, oscLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

xAxis = 'frequency [cm^{-1}]';
[TAmapFFT, TAmapPhase, frequencyFFT, lambdasFFT] = ftMap(delays, lambdas, TAmapOscillation);
TAmapFFT = smoothMap(TAmapFFT, delays, lambdas, smoothWindowDelayFS, smoothWindowLambdaNM);

% size(frequencyFFT)
% size(lambdasFFT)
% size(TAmapFFT)

% make the phase zero where the intensity is too low
% TAmapPhase(TAmapFFT < 0.05) = 0;

% make the phase zero outside bounds
% frequencyMask = frequencyFFT .* ones(size(lambdasFFT));
% TAmapPhase(frequencyMask < 650) = 0;
% TAmapPhase(frequencyMask > 950) = 0;

frequencyRange = [600 800];  
intensityRangeFFT = [0 1];
intensityRangePhase = [-pi pi];
FFTlambdas = [320 360 460 500 570];
FFTPlot = plotMap('jet', frequencyFFT, lambdasFFT, TAmapFFT, frequencyRange, lambdaRange, intensityRangeFFT, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
PhasePlot = plotMap('bwr', frequencyFFT, lambdasFFT, TAmapPhase, frequencyRange, lambdaRange, intensityRangePhase, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);

FFTfrequencies = [715 600];
dynamicsFFTPlot = plotDynamics(TAmapFFT, frequencyFFT, lambdasFFT, frequencyRange, intensityRangeFFT, intensityAxis, xAxis, intensityOffset, FFTlambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraFFTPlot = plotSpectra(TAmapFFT, frequencyFFT, lambdasFFT, lambdaRange, intensityRangeFFT, intensityAxis, intensityOffset, FFTfrequencies, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraPhasePlot = plotSpectra(unwrap(TAmapPhase,[],1)-1.85, frequencyFFT, lambdasFFT, lambdaRange, intensityRangePhase, intensityAxis, intensityOffset, FFTfrequencies, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

% sOsc = sOsc(2)

% oscillationPlot2 = plotMap(cmap, 1:sOsc, lambdasFFT, TAmapOscillation2, [-1000 10000], lambdaRange, intensityRange/10, linewidth, mainFontsize, fileLocation, numColor);

% 
% printPlots(plusName, [mapPlot, dynamicsPlot, spectraPlot], fileLocation);
% printPlots([plusName '_residualMap'], [noisePlot], fileLocation);
% printPlots([plusName '_rawMap'], [rawPlot], fileLocation);
printPlots([plusName '_oscillationMap'], [oscillationPlot, dynamicsOscPlot], fileLocation);
printPlots([plusName '_FFTMap'], [FFTPlot, dynamicsFFTPlot, spectraFFTPlot], fileLocation);
printPlots([plusName '_PhaseMap'], [PhasePlot, spectraPhasePlot], fileLocation);


% % temporary for fitting with toolbox
timeStart = 70;
timeStop = 450;
fitDelays = delays(timeStart:timeStop);

lambda330Decay = TAmapSmoothed(20, timeStart:timeStop);
lambda330DecayOsc = TAmapOscillation(20, timeStart:timeStop);
% % lambda320Decay = TAmapSmoothed(20, timeStart:226);
% lambda350Decay = TAmapSmoothed(80, timeStart:timeStop);
% % lambda380Decay = TAmapSmoothed(140, timeStart:226);
% lambda425Decay = TAmapSmoothed(205, timeStart:timeStop);
% % lambda500Decay = TAmapSmoothed(370, timeStart:226);
% % lambda345355Decay = mean(TAmapSmoothed(70:90, timeStart:226)) + 0.035 ;
% % lambda340360Decay = mean(TAmapSmoothed(60:100, timeStart:226)) + 0.035 ;
% 
% fun1 = @(x,xdata) x(1)*exp(x(2)*xdata);
% fun2 = @(x,xdata) x(1)*exp(x(2)*xdata) + x(3)*exp(x(4)*xdata);
% fun3 = @(x,xdata) x(1)*exp(x(2)*xdata) + x(3)*exp(x(4)*xdata) + x(5)*exp(x(6)*xdata);
% 
% fun4 = @(x,xdata) x(1)*exp(x(2)*xdata) * sin(x(3)*xdata);
% 
% % x0 = [0.35, -0.01, 0.12, -0.0008];
% x04 = [-1.6,-0.0025, 0.1];
% [fitted,resnorm,residual,exitflag,output] = lsqcurvefit(fun4, x04, fitDelays, lambda330DecayOsc);
% % fitfun2 = fitted(1) .* exp(fitted(2).*fitDelays) + fitted(3) .* exp(fitted(4).*fitDelays);
% % % fitfun3 = fitted(1) .* exp(fitted(2).*fitDelays) + fitted(3) .* exp(fitted(4).*fitDelays) + fitted(5) .* exp(fitted(6).*fitDelays);
% %
% fitfun4 = fitted(1) .* exp(fitted(2).*fitDelays) .*sin(fitted(3).*fitDelays);
% 
% figure()
% times = linspace(fitDelays(1),fitDelays(end));
% hold on
% plot(fitDelays, lambda330DecayOsc,'ko');
% plot(fitDelays, fitfun4,'b-')
% hold off
% 
% disp(fitted)
% disp(resnorm)

% to be done later: fitting and FFT
% fitMap();
% TAmapResidual = TAmap - TAmapSmoothed;
% mapResidualPlot = plotMap(delays, lambdas, TAmapResidual, delayRange, lambdaRange, intensityRange, linewidth, mainFontsize, units);
% fftMap();