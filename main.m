close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameters for plotting %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 0/1 same/new sample; 0/1 nodechirp/dechirp; 0/1 nosmooth/smooth
parametersPreparation = [1 1 1];

delayRange = [-100 1500];
lambdaRange = [315 650];
% lambdaRange = [295 365];
intensityRange = [0.5 4.5];

dynamicsLambdas = [325 370 425 525];
spectraDelays = [50 100 200 500 1000];
% spectraDelays = [1000 2000 3000 4000 5000];
% spectraDelays = [10000 20000 50000 100000];
% spectraDelays = [500 1000 2000 5000 10000 30000 100000];
% spectraDelays = [10000 50000 100000];
% spectraDelays = [500 1000 2000 5000 10000 30000 100000];

% dynamicsLambdas = [295 300 320 350];
% spectraDelays = [150 300 500 1000];
% spectraDelays = [1000 2000 3000 5000];
% spectraDelays = [5000 10000 20000 30000 50000 100000 150000];

lambdaShift = 370; % REMEMBER TO CHOOSE SUITABLE LAMBDA HERE

smoothWindowDelayFS = 15;  % [fs]
% smoothWindowDelayFS = 30;  % [fs]
% smoothWindowDelayFS = 150;  % [fs]
smoothWindowLambdaNM = 1;  % [nm]

cmap = 'inferno'; % use bwrjet for pos/neg maps, and inferno for pure PA
xAxisTA = 'Time delay [fs]';
% intensityAxis = '\DeltaT/T [%]';
intensityAxis = '\DeltaA [mOD]';
intensityOffset = 0;

frequencyRange = [500 1000];  
intensityRangeFT = [-0.05 0.05];
intensityRangePhase = [-pi pi];
% FFTlambdas = [340 450 600];
FFTlambdas = [315 355];
% FFTlambdas = [315 355 450 500 550];


% FFTfrequencies = [720 950];

FFTfrequencies = [720 950];
% FFTfrequencies = [664 688 711 734 756 804 827 850 873 896 919 940 965 989 1009 1032 1054];

% FFTfrequencies = [88.5 112 134 156 180 204 226 250 273 296 320 341 364 388 411 434 457 480 503 525 550 572 596 619 641 664 688 711 734 756 804 827 850 873 896 919 940 965 989 1009 1032 1054];
% FFTfrequencies = [300 710];

    % gaussian gating for Gabor transform
    alpha = 200; % fs
    tau = 1000; % fs

cmapFFT = 'inferno';
xAxisFFT = 'frequency [cm^{-1}]';

legendLocation = 'best';
linewidth = 2;
mainFontsize = 20;
legendFontsize = 14;
plusName = ['264nm fourier2'];
% plusName = ['_new_' 'gabor_alpha30000_tau' num2str(tau)];

rangeVectorTA = {delayRange, lambdaRange, intensityRange};
rangeVectorFT = {frequencyRange, lambdaRange, intensityRangeFT};
plottingVectorTA = {intensityAxis, xAxisTA, intensityOffset, mainFontsize, legendFontsize, legendLocation, linewidth, cmap};
plottingVectorFT = {intensityAxis, xAxisFFT, intensityOffset, mainFontsize, legendFontsize, legendLocation, linewidth, cmapFFT};

%%%%%%%%%%%%%%%%%%
% main functions %
%%%%%%%%%%%%%%%%%%

fileLocation = 'C:\Users\Piotr\OneDrive - Politecnico di Milano\PhD\papers\ultrafast tryptophan paper\vishal magic noise removal\SVD_1_6_264_dechirped';

% fileLocation = 'C:\Users\Piotr\OneDrive - Politecnico di Milano\PhD\papers\ultrafast tryptophan paper\experimental data\final data\d200122_01_tryptophan_VIS_magic_264nm_185mg_25ml_32nJ_1';
% fileLocation = 'C:\Users\Piotr\OneDrive - Politecnico di Milano\PhD\papers\ultrafast tryptophan paper\experimental data\full 285 nm measurement\d200121_01_tryptophan_VIS_magic_284nm_185mg_25ml_70nJ_1';
% fileLocation = prepareMap(parametersPreparation, rangeVectorTA, plottingVectorTA, lambdaShift, smoothWindowDelayFS, smoothWindowLambdaNM);
% plotResults(fileLocation, rangeVectorTA, plottingVectorTA, dynamicsLambdas, spectraDelays, plusName);
fourierMap(fileLocation, rangeVectorFT, plottingVectorFT, FFTfrequencies, FFTlambdas, alpha, tau, smoothWindowDelayFS, plusName);

% fitMap(fileLocation, rangeVectorTA, plottingVectorTA, dynamicsLambdas, curvefit);


% % this should be based on Rocio's program that fits iteratively to selected
% % wavelegngths on the map
% % is it possible to do several wavelengths fit in parallel?
% fitMap()
