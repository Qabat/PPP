function saveMap(TAmap, delays, lambdas, fileLocation, appendText)
    
    TAmap = [lambdas TAmap];
    delays = [0 delays];
    TAmap = [delays; TAmap];

    dlmwrite([erase(fileLocation, '.dat') appendText '.dat'], TAmap, '\t');
    
end