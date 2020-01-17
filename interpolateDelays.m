% interpolate the whole map to the lowest step
% so that other operations make sense

function [allScans, delays] = interpolateDelays(allScans, delays)
    
    startDelay = abs(delays(2) - delays(1));
    endDelay = abs(delays(end) - delays(end-1));
    
    scanNumber = size(allScans);
    lengthLambdas = scanNumber(1);
    scanNumber = scanNumber(3);
    
    if startDelay ~= endDelay 
        
        newDelays = delays(1):startDelay:delays(end);
        newAllScans = [];
        
        for ii = 1:scanNumber

            tempTAmap = [];
            
            for k = 1:lengthLambdas
                
                tempTAscan = interp1(delays, allScans(k,:,ii), newDelays, 'linear', 0);
                tempTAmap = cat(1, tempTAmap, tempTAscan);
                
            end
            
        newAllScans = cat(3, newAllScans, tempTAmap);
        
        end
      
        delays = newDelays;
        allScans = newAllScans;
        
    end
    
end