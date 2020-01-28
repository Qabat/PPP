% This function shifts relative zeros between all measured scans to the
% same position, if zero delay was changing during measurement, e.g. due to
% changing jet thickness.

function [TAmap, allScans] = shiftZero(allScans, lambdas, lambda, fileLocation)
    
	scanNumber = size(allScans);
    
    % find index of set lambda
    [~,lambdaIndex] = min(abs(lambdas - lambda));

    % uncomment for showing the plot before shifting
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
    
	% shift dynamics for all wavelengths, based on maximum of
	% cross-correlation for one wavelength between all smoothed scans
    
    % here I can add option to shift based only on one dynamic or on many
    % dynamics, sometimes where the signal is very low, the shifting
    % distorts the signal more than it helps, so I could be shifting based
    % only on one strong short signal dynamic and see what happens
    
    % change kk to lambdaIndex in nScan to correlate just to one delay
    % maybe correlating to an average around lambda makes sense?
    % to lower the noise for this procedure
    
    % added also normalizing the scans for better shifting, now commented out
    
%     % version for shifting for separate lambdas
%     for kk = 1:length(lambdas)
%         
%         firstScan = allScans(kk,:,1);
%         [firstScan,~] = smoothdata(firstScan, 'movmean', 10);
% %         firstScan = firstScan / max(abs(firstScan));
%         
%         for ii = 1:scanNumber(3)
%             
%             nScan = allScans(kk,:,ii);
%             [nScan,~] = smoothdata(nScan, 'movmean', 10);
% %             nScan = nScan / max(abs(nScan));
% 
%             [~,relativeDelay] = max(xcorr(firstScan, nScan));
%                
%             allScans(kk,:,ii) = circshift(allScans(kk,:,ii), relativeDelay, 2);
%             
%         end
%     end

    % version for shifting for selected lambda
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
%     
    % uncomment for showing the plot after shifting
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
    
    plot(decayMap)
    
	TAmap = mean(allScans, 3);
    
end