% This function reads a raw transient absorption map from measurement.

function [TAmap, delays, lambdas] = readMap(fileLocation, appendText)

    TAmap = dlmread([erase(fileLocation, '.dat') appendText '.dat']);
    
    % when reading simulated maps
%     TAmap = TAmap';
    
    delays = TAmap(1,2:end);
    lambdas = TAmap(2:end,1);
    TAmap = TAmap(2:end,2:end);
    
end