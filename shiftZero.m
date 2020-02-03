% This function shifts relative zeros between all measured scans to the
% same position, if zero delay was changing during measurement, e.g. due to
% changing jet thickness.

function [TAmap, allScans] = shiftZero(allScans, lambdas, lambda, fileLocation)
    
	scanNumber = size(allScans);
    
    % find index of set lambda
    [~,lambdaIndex] = min(abs(lambdas - lambda));

    shiftPlot = figure('Position', [175 75 1600 800], 'Name', 'ShiftScans', 'NumberTitle', 'off');
    subplot(1,2,1)
    for jj = 1:scanNumber(3)
        hold on
        plot(allScans(lambdaIndex,:,jj));
    end
    
    box on
    grid on
    xlim([0 200]);
    title('Before shifting');
    hold off

    % shifting for selected lambda
    firstScan = allScans(lambdaIndex,:,1);
    [firstScan,~] = smoothdata(firstScan, 'movmean', 10);
    for ii = 1:scanNumber(3)
        nScan = allScans(lambdaIndex,:,ii);
        [nScan,~] = smoothdata(nScan, 'movmean', 10);
        [~,relativeDelay] = max(xcorr(firstScan, nScan));
        
    	allScans(:,:,ii) = circshift(allScans(:,:,ii), relativeDelay, 2);
    end

%     % version for shifting for selected lambda just around zero
%     % this version should only be used if no suitable wavelength can be
%     % found, such that the signal is sharp enough to do proper shift
%     t1 = 1;
%     t2 = 140;
%     firstScan = allScans(lambdaIndex,t1:t2,1);
%     [firstScan,~] = smoothdata(firstScan, 'movmean', 10);
%     for ii = 1:scanNumber(3)
%         nScan = allScans(lambdaIndex,t1:t2,ii);
%         [nScan,~] = smoothdata(nScan, 'movmean', 10);
%         [~,relativeDelay] = max(xcorr(firstScan, nScan));
%         relativeDelay = relativeDelay - (t2-t1);
%     	allScans(:,:,ii) = circshift(allScans(:,:,ii), relativeDelay, 2);
%     end

    subplot(1,2,2)
    for jj = 1:scanNumber(3)
        hold on
        plot(allScans(lambdaIndex,:,jj));
    end
    
    box on
    grid on
    xlim([0 200]);
    title('After shifting');
    hold off
    
    printPlots('shiftPlot', [shiftPlot], fileLocation)
    
    decayMap = [];
    figure()
    
    for jj = 1:scanNumber(3)
        intDecay = sum(allScans(lambdaIndex,:,jj),2);
        decayMap = [decayMap intDecay];
    end   
    
    figure()
    plot(decayMap)
    
	TAmap = mean(allScans, 3);
    
end