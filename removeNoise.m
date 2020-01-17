% This function removes the noise of the map based on noise for negative
% delays.

function TAmap = removeNoise(TAmap, delays)
    
    % find index of 0 fs
    [~,zeroIndex] = min(abs(delays));

    % average the negative delays map
    noise = mean(TAmap(:, 1:zeroIndex), 2);
    
    % subtract the noise from the original array
    TAmap = TAmap - noise;

end