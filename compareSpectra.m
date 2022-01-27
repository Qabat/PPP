function spectraPlot = compareSpectra(TA1, TA2, delays1, delays2, lambdas1, lambdas2, intensityRange, lambdaRange, spectraDelays, mainFontsize, linewidth, legendLocation, legendFontsize, file1, file2)
    
    spectraPlot = figure('Position', [950 75 850 850], 'Name', 'Spectra', 'NumberTitle', 'off');

    clear spectraLegend
    set(findall(spectraPlot,'-property','TickLength'),'LineWidth',linewidth/1.5)
    set(findall(spectraPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)
    
    for i = 1:length(spectraDelays)
        subplot(2,2,i);
        hold on 
        indexLambdas1 = find(delays1 >= spectraDelays(i),1);
        spectra1 = TA1(:,indexLambdas1);
        indexLambdas2 = find(delays2 >= spectraDelays(i),1);
        spectra2 = TA2(:,indexLambdas2);
%         spectra1 = spectra1/max(abs(spectra1(564:end)));
%         spectra2 = spectra2/max(abs(spectra2(564:end)));
        plot(lambdas1, spectra1, 'Color', 'r', 'Linewidth', linewidth);
        plot(lambdas2, spectra2, 'Color', 'b', 'Linewidth', linewidth); 
%         dynamicsLegend{i} = strcat(num2str(dynamicsLambdas(i)), ' nm');
        plot(lambdas1, zeros(1,length(lambdas1)), '--', 'Color', 'k', 'Linewidth', linewidth);
        
        
        grid on
        
        sampleName1 = cellstr(file1);
    sampleName1 = sampleName1{1};
    [~, sampleName1] = strtok(sampleName1, '_');
    [~, sampleName1] = strtok(sampleName1, '_');
    [sampleName1, ~] = strtok(sampleName1, 'J');
    sampleName1 = erase(sampleName1, '.dat');
    sampleName1 = strrep(sampleName1, '_', ' ');
    sampleName1 = strcat(sampleName1, 'J');
%     sampleName = strcat('\fontsize{14}', sampleName);
        
        
    sampleName2 = cellstr(file2);
    sampleName2 = sampleName2{1};
    [~, sampleName2] = strtok(sampleName2, '_');
    [~, sampleName2] = strtok(sampleName2, '_');
    [sampleName2, ~] = strtok(sampleName2, 'J');
    sampleName2 = erase(sampleName2, '.dat');
    sampleName2 = strrep(sampleName2, '_', ' ');
    sampleName2 = strcat(sampleName2, 'J');

            legend({sampleName1, sampleName2}, 'Location', legendLocation, 'FontSize', legendFontsize)
    legend('boxoff') 

%     intensityRange = [min([min(spectra1), min(spectra2)]) max([max(spectra1), max(spectra2)])];

    xlim(lambdaRange);
    ylim([intensityRange(1) abs(intensityRange(2))]);
    xlabel('wavelength [nm]');
    ylabel('\DeltaA [mOD]');
        title(strcat(num2str(spectraDelays(i)), ' fs'));
    box on
    hold off
    end
    
end