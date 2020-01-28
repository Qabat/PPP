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
delayRange = [50 1500];
lambdaRange = [310 450];
dynamicsLambdas = [330 348 370];
spectraDelays = [50 100 200 300 500 1000 2000 3000];
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
plusName = ['_' 'submission41' '_' cmap '_' num2str(numColor)];
intensityAxis = '\DeltaA [mOD]';
intensityOffset = 0;
intensityRange = [-2.5 2.5];
% intensityRange = [0 5];

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
TAmapSmoothed = TAmapSmoothed - TAmapSmoothed(:, find(delays >= 50, 1));

% map of just 50 fs dynamics, to show what signals we have below the
% evolving signals, the instantaneous signals that are long lasting
% for k = 1:length(delays)
%     TAmapSmoothed(:, k, 1) = TAmapSmoothed(:, find(delays >= 50, 1));
% end
% TAmapSmoothed = TAmapSmoothed - TAmapSmoothed(:, find(delays >= 50, 1));


mapPlot = plotMap(cmap, delays, lambdas, TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
rawPlot = plotMap(cmap, delays, lambdas, TAmapDechirped, delayRange, lambdaRange, intensityRange,  intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
noisePlot = plotMap(cmap, delays, lambdas, TAmapDechirped-TAmapSmoothed, delayRange, lambdaRange, intensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
dynamicsPlot = plotDynamics(TAmapSmoothed, delays, lambdas, delayRange, intensityRange, intensityAxis, xAxis, intensityOffset, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraPlot = plotSpectra(TAmapSmoothed, delays, lambdas, lambdaRange, intensityRange, intensityAxis, intensityOffset, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

TAmapSmoothedMore = smoothMap(TAmapSmoothed, delays, lambdas, smoothWindowDelayFS*5, 0);
TAmapOscillation = TAmapDechirped-TAmapSmoothedMore;
TAmapOscillation = smoothMap(TAmapOscillation, delays, lambdas, smoothWindowDelayFS/10, smoothWindowLambdaNM);
oscillationPlot = plotMap('bwr', delays, lambdas, TAmapOscillation, delayRange, lambdaRange, intensityRange/10, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);

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

frequencyRange = [500 1000];  
intensityRangeFFT = [0.01 0.9];
intensityRangePhase = [-pi pi];
FFTlambdas = [320 360 460 500 570];
FFTPlot = plotMap('jet', frequencyFFT, lambdasFFT, TAmapFFT, frequencyRange, lambdaRange, intensityRangeFFT, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);
PhasePlot = plotMap('bwr', frequencyFFT, lambdasFFT, TAmapPhase, frequencyRange, lambdaRange, intensityRangePhase, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor);

FFTfrequencies = [700 710 720 830 930];
dynamicsFFTPlot = plotDynamics(TAmapFFT, frequencyFFT, lambdasFFT, frequencyRange, intensityRangeFFT, intensityAxis, xAxis, intensityOffset, FFTlambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraPhasePlot = plotSpectra(TAmapFFT, frequencyFFT, lambdasFFT, lambdaRange, intensityRangeFFT, intensityAxis, intensityOffset, FFTfrequencies, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);
spectraFFTPlot = plotSpectra(unwrap(TAmapPhase,[],1), frequencyFFT, lambdasFFT, lambdaRange, intensityRangePhase, intensityAxis, intensityOffset, FFTfrequencies, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

% sOsc = sOsc(2)

% oscillationPlot2 = plotMap(cmap, 1:sOsc, lambdasFFT, TAmapOscillation2, [-1000 10000], lambdaRange, intensityRange/10, linewidth, mainFontsize, fileLocation, numColor);


printPlots(plusName, [mapPlot, dynamicsPlot, spectraPlot], fileLocation);
printPlots([plusName '_residualMap'], [noisePlot], fileLocation);
printPlots([plusName '_rawMap'], [rawPlot], fileLocation);
printPlots([plusName '_oscillationMap'], [oscillationPlot], fileLocation);
printPlots([plusName '_FFTMap'], [FFTPlot, dynamicsFFTPlot, spectraFFTPlot], fileLocation);
printPlots([plusName '_PhaseMap'], [PhasePlot, spectraPhasePlot], fileLocation);


% % temporary for fitting with toolbox
timeStart = 70;
% timeStop = 500; % till 5000 fs
% timeStop = 450; % till 3000 fs
timeStop = 350; % till 1500 fs
% timeStop = 300; % till 1000 fs
% timeStop = 150; % till 500 fs
    
lambda330Decay = TAmapSmoothed(40, timeStart:timeStop);
lambda360Decay = TAmapSmoothed(100, timeStart:timeStop);
lambda370Decay = TAmapSmoothed(120, timeStart:timeStop);
lambda380Decay = TAmapSmoothed(140, timeStart:timeStop);

% fitDelays = delays(timeStart:timeStop);
% % lambda320Decay = TAmapSmoothed(20, timeStart:226);
% lambda350Decay = TAmapSmoothed(80, timeStart:timeStop);
% % lambda380Decay = TAmapSmoothed(140, timeStart:226);
% lambda425Decay = TAmapSmoothed(205, timeStart:timeStop);
% % lambda500Decay = TAmapSmoothed(370, timeStart:226);
% % lambda345355Decay = mean(TAmapSmoothed(70:90, timeStart:226)) + 0.035 ;
% % lambda340360Decay = mean(TAmapSmoothed(60:100, timeStart:226)) + 0.035 ;
% 
% fun1 = @(x,xdata) x(1)*exp(x(2)*xdata);
fun2 = @(x,xdata) x(1)*exp(x(2)*xdata) + x(3)*exp(x(4)*xdata);
% fun3 = @(x,xdata) x(1)*exp(x(2)*xdata) + x(3)*exp(x(4)*xdata) + x(5)*exp(x(6)*xdata);
% 
% % x01 = [0.35, 0.05];
x02 = [1.53, 8.48e-05, -1.629, -0.002377];
% x03 = [2.335, -1.11e-05, -0.8254, -0.02354, 0.1, -0.002];
[fitted,resnorm,residual,exitflag,output] = lsqcurvefit(fun2, x02, fitDelays, lambda370Decay);
fitfun2 = fitted(1) .* exp(fitted(2).*fitDelays) + fitted(3) .* exp(fitted(4).*fitDelays);
% % fitfun3 = fitted(1) .* exp(fitted(2).*fitDelays) + fitted(3) .* exp(fitted(4).*fitDelays) + fitted(5) .* exp(fitted(6).*fitDelays);
% 
figure()
times = linspace(fitDelays(1),fitDelays(end));
hold on
plot(fitDelays, lambda370Decay,'ko');
plot(fitDelays, fitfun2,'b-')
hold off

overFitted = 1./fitted;
disp(overFitted)
disp(resnorm)


% to be done later: fitting and FFT
% fitMap();
% TAmapResidual = TAmap - TAmapSmoothed;
% mapResidualPlot = plotMap(delays, lambdas, TAmapResidual, delayRange, lambdaRange, intensityRange, linewidth, mainFontsize, units);
% fftMap();