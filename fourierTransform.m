function [TAmapFFT, TAmapPhase, frequencyFFT, lambdasFFT] = fourierTransform(delays, lambdas, TAmapOscillation, rangeStart, rangeStop)

	rangeStart = find(delays >= rangeStart, 1);
	rangeStop = find(delays >= rangeStop, 1);

    TAmapOscillation = TAmapOscillation(:,rangeStart:rangeStop);
    delaysFFT = delays(rangeStart:rangeStop);
    lambdasFFT = lambdas;
    
    % 60 THz is 2000 cm-1      1/fs is PHz
    frequencyFFT = linspace(0, 0.06, 2000);

    TAmapFFTfull = TAmapOscillation * exp(-1i * 2*pi * frequencyFFT .* delaysFFT');
    
    TAmapFFT = abs(TAmapFFTfull);
    TAmapPhase = angle(TAmapFFTfull);
    
    % change to cm-1
    frequencyFFT = frequencyFFT * 33357;
    
    % normalize fft amplitude
    TAmapFFT = TAmapFFT / max(max(TAmapFFT));
end