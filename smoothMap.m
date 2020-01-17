% This function smooths the map in both directions for a set windows.

function TAmap = smoothMap(TAmap, delays, lambdas, smoothWindowDelayFS, smoothWindowLambdaNM)
    
    % smooth delay axis
    smoothWindowDelay = round(smoothWindowDelayFS / (delays(2)-delays(1)));
    if mod(smoothWindowDelay, 2) == 0
        smoothWindowDelay = smoothWindowDelay + 1;
    end
    % MAYBE LETS TRY MOVING AVERAGE SEVERAL TIMES WITH SMALL WINDOW
    % IN THE PAST THAT WORKED WELL!
    
    % does it also work in time?
    
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
    % here the number of loops has to be odd to work
    for ii = 1:10
    	[TAmap, ~] = smoothdata(TAmap', 'movmean', smoothWindowLambda);
        TAmap = TAmap';
    end
        
    TAmap = TAmap';
    % low pass filter wavelength axis to try to remove noise oscillation
    % DOESNT WORK
%     [b, a] = butter(2, 0.02);
%     TAmap = filter(b, a, TAmap);
end