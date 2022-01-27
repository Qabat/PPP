% This function reads a raw transient absorption map from measurement.

function mapVector = readMap(fileLocation, appendText)

    TAmap = dlmread([erase(fileLocation, '.dat') appendText '.dat']);
    
    delays = TAmap(1,2:end);
    lambdas = TAmap(2:end,1);
    TAmap = TAmap(2:end,2:end);
    
    % for debugging
%     TAmap = real(TAmap);
    
    mapVector = {TAmap, delays, lambdas};
end