function [TAmapFFT, TAmapPhase, frequencyFFT, lambdasFFT] = ftMap(delays, lambdas, TAmapOscillation)

    % for FFT
%     N = 512;
    
    % URI
%     rangeStart = 70;
%     rangeStop = 130;
%         
    % MTU
%     rangeStart = 70;
%     rangeStop = 300;
    
%     
%     % MTU DUV
%     rangeStart = 70;
%     rangeStop = 170;
%     

    % tryptophan VIS
    rangeStart = 70;
    rangeStop = 350;

    TAmapOscillation = TAmapOscillation(:,rangeStart:rangeStop);
    delaysFFT = delays(rangeStart:rangeStop);
    lambdasFFT = lambdas;
    
    % 60 THz is 2000 cm-1      1/fs is PHz
    frequencyFFT = linspace(0, 0.06, 2000);

    TAmapFFTfull = TAmapOscillation * exp(-1i * 2*pi * frequencyFFT .* delaysFFT');
    
    TAmapFFT = abs(TAmapFFTfull);
    TAmapPhase = angle(TAmapFFTfull);
    
    % change to cm-1
    frequencyFFT = frequencyFFT * 33000;
    
    % normalize fft amplitude
    TAmapFFT = TAmapFFT / max(max(TAmapFFT));
end