% This function plots cuts through the map showing dynamics for specific
% wavelengths.

function dynamicsPlot = plotDynamics(mapVector, rangeVector, plottingVector, dynamicsLambdas, fileLocation)
    
    TAmap = mapVector{1};
    delays = mapVector{2};
    lambdas = mapVector{3};
    
    delayRange = rangeVector{1};
    intensityRange = rangeVector{3};

    intensityAxis = plottingVector{1};
    xAxis = plottingVector{2};
    intensityOffset = plottingVector{3};
    mainFontsize = plottingVector{4};
    legendFontsize = plottingVector{5};
    legendLocation = plottingVector{6};
    linewidth = plottingVector{7};

    dynamicsPlot = figure('Position', [1075 518 650 357], 'Name', 'Dynamics', 'NumberTitle', 'off');
    hold all
    
    colDynamics = hsv(length(dynamicsLambdas));
    clear dynamicsLegend
    set(findall(dynamicsPlot,'-property','TickLength'),'LineWidth',linewidth/1.5)
    set(findall(dynamicsPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)

    for i = 1:length(dynamicsLambdas)
       indexLambdas = find(lambdas >= dynamicsLambdas(i),1);
       dynamics = TAmap(indexLambdas,:);
       plot(delays, dynamics, 'Color', colDynamics(i,:), 'Linewidth', linewidth); 
       dynamicsLegend{i} = strcat(num2str(dynamicsLambdas(i)), ' nm');
    end
    plot(delays, zeros(1,length(delays)), '--', 'Color', 'k', 'Linewidth', linewidth);

    legend(dynamicsLegend, 'Location', legendLocation, 'FontSize', legendFontsize)
    xlim(delayRange);
    ylim([intensityRange(1)-intensityOffset intensityRange(2)+intensityOffset]);
    xlabel(xAxis);
    ylabel(intensityAxis);
        
    sampleName = cellstr(fileLocation);
    sampleName = sampleName{1};
    [~, sampleName] = strtok(sampleName, '1');
    [~, sampleName] = strtok(sampleName, 'd');
    sampleName = erase(sampleName, '.dat');
    sampleName = strrep(sampleName, '_', ' ');
    sampleName = strcat('\fontsize{14}', sampleName);
    title({'Dynamics', sampleName});
    box on

    hold off
end