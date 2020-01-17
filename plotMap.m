% This function plots the transient absorption map.

function mapPlot = plotMap(cmap, delays, lambdas, TAmap, delayRange, lambdaRange, intensityRange, intensityAxis, linewidth, mainFontsize, fileLocation, numColor)

    mapPlot = figure('Position', [175 75 900 800], 'Name', 'TAmap', 'NumberTitle', 'off');
    hold all

    set(findall(mapPlot,'-property','TickLength'),'LineWidth',linewidth)
    set(findall(mapPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)

    pcolor(delays, lambdas, TAmap)

    pbaspect([1 1 1]);
    caxis(intensityRange);
    if strcmp(cmap, 'jet')
        colormap((jet(numColor)));
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
    colorbar
    shading interp
 
    xlim(delayRange);
    ylim(lambdaRange);

    xlabel('delay [fs]');
    ylabel('wavelength [nm]');
    yticks([310 350 400 450 500 550 600 650]);
%         yticks([290 300 310 320 330 340 350]);

    sampleName = cellstr(fileLocation);
    sampleName = sampleName{1};
    [~, sampleName] = strtok(sampleName, '1');
    [~, sampleName] = strtok(sampleName, 'd');
    sampleName = erase(sampleName, '.dat');
    sampleName = strrep(sampleName, '_', ' ');
    sampleName = strcat('\fontsize{14}', sampleName);
    title({intensityAxis, sampleName});
    box on

%     hold off
    
end