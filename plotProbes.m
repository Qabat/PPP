
close all

    fileExists = 0;
    measurement = 'probe';

    if fileExists == 1
        [file, path] = uigetfile('C:\PhD\UV TA\samples\nucleosides\*.dat');        
        fileLocation = [path file];

        % save path to file
        fid = fopen([measurement '_path.txt'],'wt');
        fprintf(fid, '%s', fileLocation);
        fclose(fid);
    else
        % read file from path
        fileLocation = fileread([measurement '_path.txt']);
    end
    
    scanNumber = 0;  
    stopReading = false;
    
    % loop for counting the scans
	while stopReading == false
        
        scan = [erase(fileLocation, '.dat'), num2str(scanNumber), '.dat'];
        
        if exist(scan, 'file') == 2 % 2 is for the file type
            scanNumber = scanNumber + 1;
        else
            stopReading = true;
        end
        
    end

        h = waitbar(0, 'Loading Map # ');
    
        
        linabsmap = [];
        
        % it took 5.326 mins/scan
        scans = linspace(1, 183, 183) * 5.326 / 60;
        
        figure()
    hold on
    xlim([300 650]);
%     ylim([0 20000]);
    % loop for reading the scans
    for ii = 1:scanNumber
        
        waitbar(ii/scanNumber, h, strcat('Loading Map # ', num2str(ii)));
        scan = [erase(fileLocation, '.dat'), num2str(ii-1), '.dat'];

        
        if ii == 1
            probe0 = load(scan);
        end
        
        probeII = load(scan);
        
        absorption = - (probeII(:,2) - probe0(:,2));
        
        plot(probeII(:,1), probeII(:,2))
        
        absorption = movmean(absorption, 20);
        linabsmap = [linabsmap absorption];
    end
    
            close(h);

    xlabel('wavelength [nm]')
    title('change of probe spectra over 180 scans of phenylalanine');
    box on
    grid on
    hold off
    
        linabsmap = movmean(linabsmap, 10, 2);
    
    
    figure()
    pcolor(scans, probe0(:,1), linabsmap)
    pbaspect([1 1 1]);
    caxis([0 20000]);
    colormap((jet(1024)));
    colorbar
    shading interp
    
    title('difference of probe spectrum from the reference probe spectrum');
    xlabel('hours');
    ylabel('wavelength [nm]');
    ylim([300 650]);
    

