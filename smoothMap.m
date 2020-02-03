% This function smooths the map in both directions for a set windows.

function TAmap = smoothMap(TAmap, delays, lambdas, smoothWindowDelayFS, smoothWindowLambdaNM)
    
    % smooth delay axis
    smoothWindowDelay = round(smoothWindowDelayFS / (delays(2)-delays(1)));
    if mod(smoothWindowDelay, 2) == 0
        smoothWindowDelay = smoothWindowDelay + 1;
    end
    
    for ii = 1:1
        [TAmap, ~] = smoothdata(TAmap', 'movmean', smoothWindowDelay);
    	TAmap = TAmap';
    end

    TAmap = TAmap';
    
    % smooth wavelength axis
    smoothWindowLambda = round(smoothWindowLambdaNM / (lambdas(2)-lambdas(1)));
    if mod(smoothWindowLambda, 2) == 0
        smoothWindowLambda = smoothWindowLambda + 1;
    end
    
    for ii = 1:4 % number of times the lambda smooth is applied
    	[TAmap, ~] = smoothdata(TAmap', 'movmean', smoothWindowLambda);
        TAmap = TAmap';
    end
        
    TAmap = TAmap';

end