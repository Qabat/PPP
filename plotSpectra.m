% This function plots cuts through the map showing spectra for specific
% delays.

function spectraPlot = plotSpectra(TAmap, delays, lambdas, lambdaRange, intensityRange, intensityAxis, intensityOffset, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, fileLocation)
    spectraPlot = figure('Position', [1075 75 650 357], 'Name', 'Spectra', 'NumberTitle', 'off');
    hold all
    
    colSpectra = hsv(length(spectraDelays));
    clear spectraLegend
    set(findall(spectraPlot,'-property','TickLength'),'LineWidth',linewidth/1.5)
    set(findall(spectraPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)

    for i = 1:length(spectraDelays)
       indexDelays = find(delays >= spectraDelays(i), 1);
       spectra = TAmap(:, indexDelays);
       plot(lambdas, spectra, 'Color', colSpectra(i,:), 'Linewidth', linewidth); 
       spectraLegend{i} = strcat(num2str(spectraDelays(i)), ' fs');
    end

    plot(lambdas, zeros(1,length(lambdas)), '--', 'Color', 'k', 'Linewidth', linewidth);

    legend(spectraLegend, 'Location', legendLocation, 'FontSize', legendFontsize)
%     legend('boxoff') 
    xlim(lambdaRange);
    ylim([intensityRange(1)-intensityOffset intensityRange(2)+intensityOffset]);
    xticks([310 350 400 450 500 550 600 650]);
%             xticks([290 300 310 320 330 340 350]);

    xlabel('wavelength [nm]');
    ylabel(intensityAxis);
    
    sampleName = cellstr(fileLocation);
    sampleName = sampleName{1};
    [~, sampleName] = strtok(sampleName, '1');
    [~, sampleName] = strtok(sampleName, 'd');
    sampleName = erase(sampleName, '.dat');
    sampleName = strrep(sampleName, '_', ' ');
    sampleName = strcat('\fontsize{14}', sampleName);
    title({'Spectra', sampleName});
    box on

    hold off
    
end