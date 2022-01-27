% This function plots the transient absorption map.

function mapPlot = plotMapFT(mapVector, rangeVector, plottingVector, fileLocation, tau)

    TAmap = mapVector{1};
    delays = mapVector{2};
    lambdas = mapVector{3};
%     disp(lambdas)
    delayRange = rangeVector{1};
    lambdaRange = rangeVector{2};
    intensityRange = rangeVector{3};

%     delays = delays/1000;
%     delayRange = delayRange/1000;
    
    xAxis = plottingVector{2};
    mainFontsize = plottingVector{4};
    linewidth = plottingVector{7};
    cmap = plottingVector{8};
    
    mapPlot = figure('Position', [175 75 900 800], 'Name', 'TAmap', 'NumberTitle', 'off');

    hold all

    set(findall(mapPlot, '-property', 'TickLength'), 'LineWidth', linewidth)
    set(findall(mapPlot, '-property', 'FontSize'), 'FontName', 'Arial', 'FontSize', mainFontsize)

%     TAmap = real(TAmap);

%      disp(size(delays));
%      disp(size(lambdas));
%      disp(size(TAmap));
    pcolor(delays, lambdas, TAmap)
    hold on
    contour(delays, lambdas, TAmap, 10, 'Color', 'white', 'Linewidth', 2)

    
    pbaspect([1 1 1]);
    caxis(intensityRange);
    numColor = 1024;
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
    elseif strcmp(cmap, 'inferno')
        colormap(inferno(64));
	elseif strcmp(cmap, 'finferno')
        colormap(flipud(inferno(32)));
    end
    colorbarHandle = colorbar;
    set(colorbarHandle, 'position', [.9 .12 .04 .72])
    set(get(colorbarHandle, 'Title'), 'String', {'\DeltaA','[mOD]'});
    shading interp
 
    % plot bandgap level
%     plot([-100 100000], [3.43, 3.43], 'k--', 'Linewidth', 2);
    
%     for i = 0:22.5:1000
%         plot([90 90] + i, [0 1000], 'w-', 'Linewidth', 2);
%     end

% %     contour(delays, lambdas, TAmap, 5)
%     TAmap(delays < 400) = 0;
%     TAmap(delays > 1000) = 0;

%     % find center of the fourer peak and mark it
% sumTAmap = sum(TAmap);
% sumTAmap(delays < 600) = 0;
% sumTAmap(delays > 1000) = 0;
%     [~, max_id] = max(sumTAmap);
    
        [~, max_id] = max(max(TAmap));

    
% %     disp(delays(max_id))
%     plot([delays(max_id) delays(max_id)], [-10000 10000], 'k-', 'Linewidth', 3);

%     % line at 330 nm
%     plot([-10000 10000], [330 330], 'k-', 'Linewidth', 3);

%     
%     % plot position of the node
% %                 figure()
% %                 hold on
%     node_spectrum = TAmap(:, max_id);
% %         plot(node_spectrum)
%         
%     shift = 40;
%     [~, maxl_id_1] = max(node_spectrum);
%     disp(lambdas(maxl_id_1))
%     [~, up_maxl_id_2] = max(node_spectrum((maxl_id_1+shift):end));
%         [~, dn_maxl_id_2] = max(node_spectrum(1:(maxl_id_1-shift)));
%         
%             up_maxl_id_2 = up_maxl_id_2 + maxl_id_1 + shift;
%  disp(up_maxl_id_2)
%   disp(dn_maxl_id_2)
% 
%     maxl_id_2 = max(up_maxl_id_2, dn_maxl_id_2);
%     
%     disp(maxl_id_2)
%         
% %     maxl_id_2 = maxl_id_2 + maxl_id_1 + shift;
% %         disp(lambdas(maxl_id_2))
%         
%     id_1 = min([maxl_id_1, maxl_id_2]);
%     id_2 = max([maxl_id_1, maxl_id_2]);
%             
% %     plot(node_spectrum((maxl_id_1+shift):end))
% 
% figure()
% plot(node_spectrum(id_1, id_2))
% 
%     node_id = min(node_spectrum(id_1, id_2));
%     disp((node_id))
%     node_id = 100;
%     lambdas(node_id)
%     plot([-10000 10000], [lambdas(node_id) lambdas(node_id)], 'k--', 'Linewidth', 3);
    
    xlim(delayRange);
    ylim(lambdaRange);

    xlabel(xAxis);
    ylabel('Probe wavelength [nm]');
    
    title([num2str(tau), ' fs   ', num2str(round(delays(max_id))), ' cm-1   ']);
%         title([num2str(tau), ' fs   ', num2str(round(delays(max_id))), ' cm-1   ', num2str(round(lambdas(node_id))), ' nm']);

%         ylabel('Photon energy [eV]');

%     yticks([310 350 400 450 500 550 600 650]);
% 
%     sampleName = cellstr(fileLocation);
%     sampleName = sampleName{1};
%     [~, sampleName] = strtok(sampleName, '1');
%     [~, sampleName] = strtok(sampleName, 'd');
%     sampleName = erase(sampleName, '.dat');
%     sampleName = strrep(sampleName, '_', ' ');
%     sampleName = strcat('\fontsize{14}', sampleName);
%     title(sampleName);

    box on

%     hold off
    
end