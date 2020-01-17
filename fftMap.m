function [TAmapFFT, frequencyFFT, lambdasFFT] = fftMap(delays, lambdas, TAmapOscillation)

    % for FFT
%     N = 512;
    
    % URI
%     rangeStart = 60;
%     rangeStop = 120;
        
    % MTU
%     rangeStart = 140;
%     rangeStop = 400;
%     
%     
%     % MTU DUV
%     rangeStart = 70;
%     rangeStop = 170;
%     
    % URI DUV
%     rangeStart = 65;
%     rangeStop = 100;   
%     

    % tryptophan VIS
    rangeStart = 200;
    rangeStop = 435;

    TAmapOscillation = TAmapOscillation(:,rangeStart:rangeStop);
    delaysFFT = delays(rangeStart:rangeStop);
    lambdasFFT = lambdas;
    
    
    stepDelay = delaysFFT(2) - delaysFFT(1); % fs
    samplingFreq = 1./stepDelay; % PHz
    
    % zero padding
    numberZeros = 1000;
    TAmapOscillation = padarray(TAmapOscillation, [0 numberZeros], 0, 'both');
    delaysFFT = (delaysFFT(1) - numberZeros * stepDelay):stepDelay:(delaysFFT(end) + numberZeros * stepDelay);
    
    lenDelay = length(delaysFFT); % number of points to FFT
    N = lenDelay;
%     stepFrequency = samplingFreq ./ N; % PHz
    
    frequencyFFT = samplingFreq/2 * [-1:2/N:1-2/N]; % PHz
    frequencyFFT = frequencyFFT * 1000; % THz
    frequencyFFT = 33 .* frequencyFFT;% cm^-1
    
    
    TAmapFFT = abs(fftshift(fft(TAmapOscillation, [], 2), 2));
    
    %normalize
    TAmapFFT = TAmapFFT/max(max(TAmapFFT));
    
    %     % cut the low frequencies so that real oscillations looks better on map
    
% %     TAmapFFT = padarray(TAmapFFT, [0 50]);
% %     delaysFFT = padarray(delaysFFT, [0 50]);
% 
%     vectDelay = delaysFFT;
%     vectLambda = lambdasFFT;
%     
%     vectOmega = 2*pi*c./vectLambda;
%     vectOmega = vectOmega - mean(vectOmega);
%     TAmapFFT = TAmapOscillation./(2*pi*c) .* (vectLambda'.^2) ;
% 
%     % set new spacing satisfying FFT 
%     temporalSpan = max(vectDelay) - min(vectDelay);
%     newDelay = linspace(0, temporalSpan, N);
%     newDelay = fftshift(newDelay);
%     newDelay = fftshift(newDelay - newDelay(1));
%     newOmega = linspace(2*pi*N./temporalSpan, 0, N);
%     newOmega = fftshift(newOmega);
%     newOmega = fftshift(newOmega - newOmega(1));
% 
%     % interpolate to new data points
%     [XIn, YIn] = meshgrid(vectDelay,vectOmega);
%     [XOut, YOut] = meshgrid(newDelay, newOmega);
%     omegaFROG = interp2(XIn, YIn, omegaFROG, XOut, YOut,'spline', 0);
%     omegaFROG(omegaFROG<0) = 0;
% 
%     % shift maximum of autocorrelation to 0 delay
%     temporalMarginal = sum(omegaFROG, 1);
%     [~, maxIndex] = max(temporalMarginal);
%     omegaFROG = circshift(omegaFROG, [0 -abs(N/2-maxIndex)]);


%     
%     % cut the low frequencies so that real oscillations looks better on map
%     TAmapFFTabs(:,1:5) = [];
%     frequencies(:,1:5) = [];
% 
%     TAmapFFTabs = TAmapFFTabs / max(max(TAmapFFTabs));


end