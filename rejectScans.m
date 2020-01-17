% rejecet scans that have low correlation with first scan


function [TAmap, cutScans, newlambdas] = rejectScans(allScans, lambdas, lambdaRange, fileLocation)
    
    scanNumber = size(allScans);
    scanNumber = scanNumber(3);
    
    cutScans = [];
    for ll = 1:scanNumber
        tempTAmap = allScans(:,:,ll);
        [tempTAmap, newlambdas] = cutMap(tempTAmap, lambdas, lambdaRange);
        
        % this is done to remove the edges which may not be true after
        % shifting the zeros in a shiftZero() function
        % THIS DEPENDING ON THE DATA SOMETIMES CUTS A LOT OF POINTS
        % SO FOR NOW IT IS OUT
%         tempTAmap(:, 1:30) = 0;
%         tempTAmap(:, end-30:end) = 0;
%         
        cutScans = cat(3, cutScans, tempTAmap);
    end
    
    
    % uncomment for plotting the decays before removing
%     lambdaIndex = 150;
%     figure()
%     for jj = 1:scanNumber
%         hold on
%         plot(cutScans(lambdaIndex,:,jj));
%     end
%     TAmap = mean(cutScans, 3);
%     plot(TAmap(lambdaIndex, :), 'Linewidth', 3)
%     hold off
    
    % calculate a matrix of dot products between scans
    dotMatrix = zeros(scanNumber-1, length(newlambdas));
    for kk = 1:length(newlambdas)
        for ii = 2:scanNumber
            dotScans = dot(cutScans(kk,:,1)/norm(cutScans(kk,:,1)), cutScans(kk,:,ii)/norm(cutScans(kk,:,ii)));
            
            % version witout normalizing
%                         dotScans = dot(cutScans(kk,:,1), cutScans(kk,:,ii));
                        
                        % subtraction instead of dot product? seems to work
                        % a bit???
%                                                 dotScans = sum(abs(cutScans(kk,:,1) - cutScans(kk,:,ii)));


            dotMatrix(ii-1, kk) = dotMatrix(ii-1, kk) + dotScans;
        end
    end

    dotMatrix = dotMatrix';
    dotSum = sum(dotMatrix,1);
    
    % since I normalize the sum anyway, maybe I could let the dot product
    % be not normalized sometimes? then the correlation map would show
    % gradual drop, but the rejection mechanism would still go from 0 to 1
    dotSum = dotSum/max(dotSum);
    dotSum = exp(-(15 .* (1 - dotSum).^2).^4);
    
    threshold = 0.9;
    
    scanAxis = 2:scanNumber;
    
    correlationPlot = figure('Name', 'Correlation map', 'NumberTitle', 'off');
    
    % plot correlation matrix
    subplot(2,1,1)
    pcolor(scanAxis, newlambdas, dotMatrix);
%     intensityRange = [0.5 1];
%     caxis(intensityRange);
    colormap(jet(1024));
    shading interp
    box on
    xlabel('Scan number');
    ylabel('Wavelength');
    title('Correlation map');
    ylim(lambdaRange);
    
    % plot rejection of scans
    subplot(2,1,2)
    hold on
    plot(scanAxis, dotSum, 'o', 'MarkerFaceColor', 'b');
    plot(scanAxis, threshold * ones(length(scanAxis)), 'Color', 'red');
    hold off
    box on
    ylim([0 1.5]);
    xlim([1 max(scanNumber)+1]);
    title(['Points below ' num2str(threshold) ' are rejected scans']);
    xlabel('Scan number');
    
    leftScans = 0;
    A = size(cutScans);
    TAmap = zeros(A(1), A(2));
    dotSum = [1 dotSum];
    for jj = 1:scanNumber        
        if dotSum(jj) > threshold
            TAmap = TAmap + cutScans(:,:,jj);
            leftScans = leftScans + 1;
        end
    end

    TAmap = TAmap./leftScans;
    
    % uncomment for plotting the decays before removing
%     lambdaIndex = 150;
%     figure()
%     for jj = 1:scanNumber
%         hold on
%         plot(cutScans(lambdaIndex,:,jj));
%     end
%     TAmap = mean(cutScans, 3);
%     plot(TAmap(lambdaIndex, :), 'Linewidth', 3)
%     hold off

    printPlots('', correlationPlot, fileLocation);

end