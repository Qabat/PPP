function [TAmap, delays] = dechirpClicking(TAmap, delays, lambdas, delayRange, lambdaRange, intensityRange, intensityAxis, linewidth, mainFontsize, fileLocation)

    hold on
    dechirpPlot = plotMap('bwr', delays, lambdas, TAmap, [0 1800], lambdaRange, intensityRange, intensityAxis, linewidth, mainFontsize, fileLocation, 16);

    for ii = 1:8
        coords(ii,:) = ginputCustom(1, [1 0 0]);
        set(gcf, 'pointer', 'arrow');

        plot(coords(ii,1),coords(ii,2),'rx')
    end

    xi = coords(:,1);
    yi = coords(:,2);
    x_spline = spline(yi,xi,lambdas);

    plot(x_spline, lambdas, 'w--', xi, yi, 'r*');

    hold off   

    printPlots('_dechirpPlot', [dechirpPlot], fileLocation);
    
    temp = TAmap;
    
    for k=1:length(lambdas)
    
        temp(k,:) = interp1(delays-x_spline(k),TAmap(k,:),delays, 'linear', 0);
    
    end
  
    TAmap = temp;

end