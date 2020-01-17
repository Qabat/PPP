
function dynamicsPlot = compareDynamics(normDelay, TA1, TA2, delays1, delays2, lambdas1, lambdas2, delayRange, dynamicsLambdas, mainFontsize, linewidth, legendLocation, legendFontsize, file1, file2)
    dynamicsPlot = figure('Position', [100 75 850 850], 'Name', 'Dynamics', 'NumberTitle', 'off');

    clear dynamicsLegend
    set(findall(dynamicsPlot,'-property','TickLength'),'LineWidth',linewidth/1.5)
    set(findall(dynamicsPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)
    
    for i = 1:length(dynamicsLambdas)
        subplot(2,2,i);
        hold on 
        indexLambdas = find(lambdas1 >= dynamicsLambdas(i),1);
        normIndex1 = find((delays1 - normDelay) >= 0);
        normIndex2 = find((delays2 - normDelay) >= 0);
        dynamics1 = TA1(indexLambdas,:);
        dynamics2 = TA2(indexLambdas,:);
        dynamics1 = dynamics1/max(abs(dynamics1(normIndex1:normIndex1)));
        dynamics2 = dynamics2/max(abs(dynamics2(normIndex2:normIndex2)));
        plot(delays1, dynamics1, 'Color', 'r', 'Linewidth', linewidth);
        plot(delays2, dynamics2, 'Color', 'b', 'Linewidth', linewidth); 
%         dynamicsLegend{i} = strcat(num2str(dynamicsLambdas(i)), ' nm');
        plot(delays1, zeros(1,length(delays1)), '--', 'Color', 'k', 'Linewidth', linewidth);
        
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



    intensityRange = [min([min(dynamics1), min(dynamics2)]) max([max(dynamics1), max(dynamics2)])];

    xlim(delayRange);
    ylim([intensityRange(1)-1 intensityRange(2)+1]);
    xlabel('delay [fs]');
    ylabel('Normalized \DeltaT');
        title(strcat(num2str(dynamicsLambdas(i)), ' nm'));
    box on
    hold off
    end


    




end