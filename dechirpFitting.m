% This function removes the chirp based on fitting a polynomial to the
% minimum of the XPM from a map measured on pure solvent.

% or bsed on clicking, depending on the input

function [TAmap, delays] = dechirpFitting(TAmap, delays, lambdas, lambdaRange)
    warning('off','all')
    
    if dechirping == 1
        [allScans, delaysSolvent, lambdasSolvent, ~] = readScans(dechirping, 'solvent');
        [TAmapSolvent, ~] = shiftZero(allScans, lambdas);
        [TAmapSolvent, lambdasSolvent] = cutMap(TAmapSolvent, lambdasSolvent, lambdaRange);
        saveMap(TAmapSolvent, delaysSolvent, lambdasSolvent, 'solvent.dat');
    end
    
    [TAmapSolvent, ~, lambdasSolvent] = readMap('solvent.dat');
    

    % find minimum of the artifact = time zero
    [~,XPMposition] = min(TAmapSolvent.^3,[],2);
%     [~,XPMposition] = min(TAmapSolvent,[],2);

    % fit polynomial to the minima of artifact
    XPMfit = polyval(polyfit(lambdasSolvent, XPMposition, 6), lambdas);
    
    % shift the polynomial to (0,0)
    XPMfit = XPMfit - XPMfit(1);

    % this is how it was done in original pump-probe dechirping
    % at some point try to do fourier shift and compare

    for i = 1:length(lambdas)
        TAmap(i,:) = interp1(delays - XPMfit(i) * (delays(2)-delays(1)), TAmap(i,:), delays, 'linear', 0);
    end
    
    % cut the long delays where there is no real data after shifting
    TAmap = TAmap(:,1:length(delays)-round(XPMfit(end)));
    delays = delays(1:length(delays)-round(XPMfit(end)));
    
    warning('on','all')
end