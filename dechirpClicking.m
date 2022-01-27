function [TAmap, delays] = dechirpClicking(mapVector, rangeVector, plottingVector, fileLocation)

    hold on

    rangeVector{1} = [-100 700];
    rangeVector{3} = [-1 1];

%     mapVector{1} = real(mapVector{1});
    
    TAmap = mapVector{1};
    delays = mapVector{2};
    lambdas = mapVector{3};
    
    dechirpPlot = plotMap(mapVector, rangeVector, plottingVector, fileLocation);
    
    for ii = 1:8
        coords(ii,:) = ginputCustom(1, [0 0 0]);
        set(gcf, 'pointer', 'arrow');
        plot(coords(ii,1),coords(ii,2),'wx')
    end

    xi = coords(:,1);
    yi = coords(:,2);
    x_spline = spline(yi,xi,lambdas);

    plot(x_spline, lambdas, 'w--', xi, yi, 'w*');

    hold off

    printPlots('_dechirpPlot', [dechirpPlot], fileLocation);
    
    temp = TAmap;
    
    for k=1:length(lambdas)
        temp(k,:) = interp1(delays - x_spline(k), TAmap(k,:), delays, 'linear', 0);
    end
  
    TAmap = temp;

end