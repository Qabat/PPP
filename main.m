close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameters for plotting %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 0/1 same/new sample; 0/1 nodechirp/dechirp; 0/1 nosmooth/smooth
parametersPreparation = [1 1 1];

delayRange = [-100 3000];
lambdaRange = [310 650];
intensityRange = [-4 4];

dynamicsLambdas = [330 370 600 640];
spectraDelays = [-50 0 50];

lambdaShift = 370; % REMEMBER TO CHOOSE SUITABLE LAMBDA HERE

smoothWindowDelayFS = 15;  % [fs]
smoothWindowLambdaNM = 3;  % [nm]

cmap = 'jet';
xAxisTA = 'Time delay [fs]';
intensityAxis = '\DeltaA [mOD]';
intensityOffset = 0;

frequencyRange = [0 2000];  
intensityRangeFT = [0.01 1];
intensityRangePhase = [-pi pi];
FFTlambdas = [320 360 460 500 570];
FFTfrequencies = [700 800];
cmapFFT = 'jet';
xAxisFFT = 'frequency [cm^{-1}]';

legendLocation = 'best';
linewidth = 2;
mainFontsize = 20;
legendFontsize = 14;
plusName = ['_' 'test'];

rangeVectorTA = {delayRange, lambdaRange, intensityRange};
rangeVectorFT = {frequencyRange, lambdaRange, intensityRangeFT};
plottingVectorTA = {intensityAxis, xAxisTA, intensityOffset, mainFontsize, legendFontsize, legendLocation, linewidth, cmap};
plottingVectorFT = {intensityAxis, xAxisFFT, intensityOffset, mainFontsize, legendFontsize, legendLocation, linewidth, cmapFFT};
    
%%%%%%%%%%%%%%%%%%
% main functions %
%%%%%%%%%%%%%%%%%%

fileLocation = prepareMap(parametersPreparation, rangeVector, plottingVectorTA, lambdaShift, smoothWindowDelayFS, smoothWindowLambdaNM);
plotResults(fileLocation, rangeVectorTA, plottingVectorTA, dynamicsLambdas, spectraDelays, plusName);
fourierMap(fileLocation, rangeVectorFT, plottingVectorFT, dynamicsLambdas, spectraDelays, smoothWindowDelayFS, plusName);





% % this should be based on Rocio's program that fits iteratively to selected
% % wavelegngths on the map
% % is it possible to do several wavelengths fit in parallel?
% fitMap()
