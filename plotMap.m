% This function plots the transient absorption map.

function mapPlot = plotMap(cmap, delays, lambdas, TAmap, delayRange, lambdaRange, intensityRange, intensityAxis, xAxis, linewidth, mainFontsize, fileLocation, numColor)

    mapPlot = figure('Position', [175 75 900 800], 'Name', 'TAmap', 'NumberTitle', 'off');
%         mapPlot = figure('Position', [1075 518 650 500], 'Name', 'TAmap', 'NumberTitle', 'off');

    hold all

    set(findall(mapPlot,'-property','TickLength'),'LineWidth',linewidth)
    set(findall(mapPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)

    pcolor(delays, lambdas, TAmap)
    
%     contours = [-0.85 -0.7 -0.45];
%     contour(delays, lambdas, TAmap, contours, 'k')
    
    
% 	contours = [-0.05 0.05];
%     contour(delays, lambdas, TAmap, contours, 'k')
    
%     contours = [1.95 2.75 3.75];
%     contour(delays, lambdas, TAmap, contours, 'k')
    
%     contours = [0.01 0.03 0.05];
%     contour(delays, lambdas, TAmap, contours, 'r', 'LineWidth', 2)
%     
    pbaspect([1 1 1]);
    caxis(intensityRange);
    if strcmp(cmap, 'jet')
        colormap((jet(numColor)));
    elseif strcmp(cmap, 'gray')
        colormap('gray');
    elseif strcmp(cmap, 'flipudjet')
        colormap(flipud(jet(numColor)));
    elseif strcmp(cmap, 'bwr')
        colormap((bluewhitered(numColor)));
    elseif strcmp(cmap, 'bwre')
        colormap((bluewhitered_enhanced(numColor)));
    elseif strcmp(cmap, 'bwrjet')
        colormap((bluewhitered_jet(numColor)));
    elseif strcmp(cmap, 'mattia')
        colormap(MattiaMap(intensityRange(1), intensityRange(2)))
    elseif strcmp(cmap, 'andrea')
        colormap(NegativeEnhancingColormap(numColor, intensityRange, [0 0 102]/255, [153 0 0]/255, 1));
    end
    colorbarHandle = colorbar;
            set(colorbarHandle, 'position', [.9 .12 .04 .72])
        set(get(colorbarHandle, 'Title'), 'String', {'\DeltaA','[mOD]'});
    shading interp
 
    xlim(delayRange);
    ylim(lambdaRange);

    xlabel(xAxis);
    ylabel('probe wavelength [nm]');
    yticks([310 350 400 450 500 550 600 650]);
%         yticks([290 300 310 320 330 340 350]);
%     xticks([50 200 400 600 1000]);
%     yticks([310 320 330 340 350 360 370 380 390 400]);
    xticks([100 500 1000]);


    sampleName = cellstr(fileLocation);
    sampleName = sampleName{1};
    [~, sampleName] = strtok(sampleName, '1');
    [~, sampleName] = strtok(sampleName, 'd');
    sampleName = erase(sampleName, '.dat');
    sampleName = strrep(sampleName, '_', ' ');
    sampleName = strcat('\fontsize{14}', sampleName);
%     title({intensityAxis, sampleName});
%         title(intensityAxis);

    box on

%     hold off
    
end