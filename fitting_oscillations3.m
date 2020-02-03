close all

% delaysOsc = 

% delayRange = [100 1500];
% oscIntensityRange = [-0.25 0.25];
% oscLambdas = [360];
% dynamicsOscPlot = plotDynamics(TAmapOscillation, delays, lambdas, delayRange, oscIntensityRange, intensityAxis, xAxis, intensityOffset, oscLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation);

timeStart = 70;
timeStop = 350; % till 1500 fs
% timeStop = 250; % till 1000 fs

fitDelays = delays(timeStart:timeStop);
lambda = 380;
lambdaIndex = find(lambdas >= lambda, 1);
lambdaOscillation = TAmapOscillation(lambdaIndex, timeStart:timeStop);


fun = @(x,xdata) x(1).*exp(x(2)*xdata).*cos(x(3)*xdata + x(4)) + x(5).*exp(x(6)*xdata).*cos(x(7)*xdata + x(8)) + x(9).*exp(x(10)*xdata).*cos(x(11)*xdata + x(12));

x0 = [0.1, 0.01, 0.135, 0, 0.1, 0.001, 0.135, 0, 0.1, 0.003, 0.135, 0];
[fitted,resnorm,residual,exitflag,output] = lsqcurvefit(fun, x0, fitDelays, lambdaOscillation);
fitfun = fitted(1).*exp(fitted(2)*fitDelays).*cos(fitted(3)*fitDelays + fitted(4)) + fitted(5).*exp(fitted(6)*fitDelays).*cos(fitted(7)*fitDelays + fitted(8)) + fitted(9).*exp(fitted(10)*fitDelays).*cos(fitted(11)*fitDelays + fitted(12));

figure('Position', [575 18 650 357]);
times = linspace(fitDelays(1),fitDelays(end));
hold on
plot(fitDelays, lambdaOscillation,'r-', 'LineWidth',5);
plot(fitDelays, fitfun,'b-', 'LineWidth', 3)
ylim([-0.25 0.25]);
    pbaspect([1 0.5 1]);
legend({'experiment', 'fit'});
title(['wavelength ' num2str(lambda) ' nm']);

hold off
 


% overFitted = 1./fitted;
% disp(fitted)
% % disp(resnorm)
% disp('amp1 [fs]')
% disp(fitted(1))
% disp('decay1 [fs]')
% disp(1./fitted(2))
% disp('frequency1 [cm^-1]')
% disp(33000/(2 * pi ./fitted(3)))
% disp('amp22 [fs]')
% disp(fitted(5))
% disp('decay2 [fs]')
% disp(1./fitted(6))
% disp('frequency2 [cm^-1]')
% disp(33000/(2 * pi ./fitted(7)))

disp(['amp1     ' 'decay1     ' 'frequency1']);
disp([fitted(1) 1./fitted(2) 5252*fitted(3)]);

disp(['amp2     ' 'decay2     ' 'frequency2']);
disp([fitted(5) 1./fitted(6) 5252*fitted(7)]);

disp(['amp3     ' 'decay3     ' 'frequency3']);
disp([fitted(9) 1./fitted(10) 5252*fitted(11)]);