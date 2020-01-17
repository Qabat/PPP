% This function cuts the map at specific wavelengths.

function [TAmap, lambdas] = cutMap(TAmap, lambdas, lambdaRange)

    [~,firstLambdaIndex] = min(abs(lambdas-lambdaRange(1)));
    [~,secondLambdaIndex] = min(abs(lambdas-lambdaRange(2)));

    lambdas = lambdas(firstLambdaIndex:secondLambdaIndex);
    TAmap = TAmap(firstLambdaIndex:secondLambdaIndex,:);
    
end