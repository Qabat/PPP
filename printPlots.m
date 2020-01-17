function printPlots(plusName, plots, fileLocation)

    for k = 1:length(plots)
        print(plots(k), '-dpng', '-r300', [erase(fileLocation, '.dat') '_' plots(k).Name plusName]);
    end

end