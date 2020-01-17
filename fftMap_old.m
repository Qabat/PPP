function [TAmapFFTabs, TAmapOscillation2, frequencies, delaysFFT, lambdasFFT] = fftMap(delays, lambdas, TAmapOscillation)
    
    rangeStart = 100;
    rangeStop = 400;
        
    TAmapFFT = TAmapOscillation(:,rangeStart:rangeStop);
    delaysFFT = delays(rangeStart:rangeStop);
    lambdasFFT = lambdas;
    
%     TAmapFFT = padarray(TAmapFFT, [0 50]);
%     delaysFFT = padarray(delaysFFT, [0 50]);

    lengthDelays = length(delaysFFT);
    
    TAmapFFT = fft((TAmapFFT), lengthDelays, 2);
    TAmapFFTabsRAW = abs(TAmapFFT);
    TAmapFFTabs = TAmapFFTabsRAW(:, 1:lengthDelays/2);

    TAmapFFTangle = angle(TAmapFFT);
        TAmapFFTangle = TAmapFFTangle(:, 1:lengthDelays/2);

    delaysFFT = delaysFFT(:, 1:lengthDelays/2);
    TAmapFFTabsCopy = TAmapFFTabs;
    TAmapFFTabsCopy(1:150, 30:40) = 0;
    TAmapFFTabs = TAmapFFTabs - TAmapFFTabsCopy;
    
    
    frequencies = linspace(0, 1000, length(TAmapFFTabs(1,:)));

    TAmapOscillation2 = abs(ifft(TAmapFFTabs .* exp(1i .* TAmapFFTangle .* frequencies), lengthDelays, 2));
    
    % frequencies = delaysFFT(1:length(delaysFFT)/2);


    
    
    % cut the low frequencies so that real oscillations looks better on map
    TAmapFFTabs(:,1:5) = [];
    frequencies(:,1:5) = [];

    TAmapFFTabs = TAmapFFTabs / max(max(TAmapFFTabs));


end