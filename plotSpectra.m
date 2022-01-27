% This function plots cuts through the map showing spectra for specific
% delays.

function spectraPlot = plotSpectra(mapVector, rangeVector, plottingVector, spectraDelays, fileLocation)

    TAmap = mapVector{1};
    delays = mapVector{2};
    lambdas = mapVector{3};
    
    lambdaRange = rangeVector{2};
    intensityRange = rangeVector{3};
    
%     delays = delays/1000;
%     spectraDelays = spectraDelays/1000;
    
    intensityAxis = plottingVector{1};
    xAxis = plottingVector{2};
    intensityOffset = plottingVector{3};
    mainFontsize = plottingVector{4};
    legendFontsize = plottingVector{5};
    legendLocation = plottingVector{6};
    linewidth = plottingVector{7};

    spectraPlot = figure('Position', [1075 75 650 357], 'Name', 'Spectra', 'NumberTitle', 'off');
    hold all
    
    colSpectra = hsv(length(spectraDelays));
    clear spectraLegend
    ticksSpectra = findall(spectraPlot,'-property','TickLength');
    set(ticksSpectra,'LineWidth',linewidth/1.5)
    set(findall(spectraPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)

    for i = 1:length(spectraDelays)
       indexDelays = find(delays >= spectraDelays(i), 1);
       spectra = TAmap(:, indexDelays);
       plot(lambdas, spectra, 'Color', colSpectra(i,:), 'Linewidth', linewidth); 
       spectraLegend{i} = strcat(num2str(spectraDelays(i)), ' fs');
       
%        dlmwrite(spectraLegend{i}, [lambdas spectra]);
    end

    plot(lambdas, zeros(1,length(lambdas)), '--', 'Color', 'k', 'Linewidth', linewidth);
%     plot(lambdas, zeros(1,length(lambdas)) + pi/2, '--', 'Color', 'k', 'Linewidth', linewidth);
%     plot(lambdas, zeros(1,length(lambdas)) - pi/2, '--', 'Color', 'k', 'Linewidth', linewidth);

    % plot bandgap level
%     plot([3.43, 3.43], [-100 100], 'k--', 'Linewidth', 2);

    legend(spectraLegend, 'Location', legendLocation, 'FontSize', legendFontsize)
%     legend({'amplitude', 'phase'}, 'Location', legendLocation, 'FontSize', legendFontsize)

    xlim(lambdaRange);
    ylim([intensityRange(1)-intensityOffset intensityRange(2)+intensityOffset]);
%     xticks([310 350 400 450 500 550 600 650]);
    yticks([-pi -pi/2 0 pi/2 pi]);
    yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});

    xlabel('Probe wavelength [nm]');
%             xlabel('Photon energy [eV]');

    ylabel(intensityAxis);
    
%     sampleName = cellstr(fileLocation);
%     sampleName = sampleName{1};
%     [~, sampleName] = strtok(sampleName, '1');
%     [~, sampleName] = strtok(sampleName, 'd');
%     sampleName = erase(sampleName, '.dat');
%     sampleName = strrep(sampleName, '_', ' ');
%     sampleName = strcat('\fontsize{14}', sampleName);
%     title({'Spectra', sampleName});
    box on

    hold off
    
end