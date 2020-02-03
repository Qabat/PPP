close all

% dynamicsFFTPlot = plotDynamics(TAmapFFT, frequencyFFT, lambdasFFT, frequencyRange, intensityRangeFFT, intensityAxis, xAxis, intensityOffset, FFTlambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);


centralFreq = 720;
widthFreq = 700;

fitFreqs = frequencyFFT(centralFreq-widthFreq:centralFreq+widthFreq);
lambda = 380;
lambdaIndex = find(lambdasFFT >= lambda, 1);
lambdaPeaks = TAmapFFT(lambdaIndex, centralFreq-widthFreq:centralFreq+widthFreq);

fun = @(x,xdata) x(1) * exp(-0.5 * ((xdata - x(2))/x(3)).^2) + x(4) * exp(-0.5 * ((xdata - x(5))/x(6)).^2) +  x(7) * exp(-0.5 * ((xdata - x(8))/x(9)).^2);
x0 = [1, 700, 20, 0.3, 700, 100, 0.5, 700, 200];
[fitted,resnorm,residual,exitflag,output] = lsqcurvefit(fun, x0, fitFreqs, lambdaPeaks);
fitfun = fitted(1) * exp(-0.5 * ((fitFreqs - fitted(2))/fitted(3)).^2) + fitted(4) * exp(-0.5 * ((fitFreqs - fitted(5))/fitted(6)).^2) + fitted(7) * exp(-0.5 * ((fitFreqs - fitted(8))/fitted(9)).^2);



figure()
% times = linspace(fitDelays(1),fitDelays(end));
hold on
plot(fitFreqs, lambdaPeaks,'r-', 'LineWidth',5);
plot(fitFreqs, fitfun,'b-', 'LineWidth', 3)
ylim([0 1]);
xlim([500 1000]);
title(['wavelength ' num2str(lambda) ' nm']);

% legend({'experiment', 'fit'});

hold off

disp(['amp1     ' 'freq1     ' 'width1']);
disp([fitted(1) fitted(2) fitted(3)]);

disp(['amp2     ' 'freq2     ' 'width2']);
disp([fitted(4) fitted(5) fitted(6)]);

disp(['amp3     ' 'freq3     ' 'width3']);
disp([fitted(7) fitted(8) fitted(9)]);

 