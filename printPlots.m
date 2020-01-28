function printPlots(plusName, plots, fileLocation)

    for k = 1:length(plots)
        print(plots(k), '-dpng', '-r300', [erase(fileLocation, '.dat') '_' plots(k).Name plusName]);
%         if k == 1
%             set(0, 'defaultAxesNextPlot', 'replace')
%         	vecrast(plots(k), [erase(fileLocation, '.dat') '_' plots(k).Name plusName], 900, 'bottom', 'svg')
%         end
    end

end