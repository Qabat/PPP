function [allScans, delays, lambdas, fileLocation] = readScans(fileExists, measurement)

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
        
        scan = [erase(fileLocation, '.dat'), '_', num2str(scanNumber), '.dat'];
        
        if exist(scan, 'file') == 2 % 2 is for the file type
            scanNumber = scanNumber + 1;
        else
            stopReading = true;
        end
        
	end

    h = waitbar(0, 'Loading Map # ');

    % loop for reading the scans
    for ii = 1:scanNumber
        
        waitbar(ii/scanNumber, h, strcat('Loading Map # ', num2str(ii)));
        scan = [erase(fileLocation, '.dat'), '_', num2str(ii-1), '.dat'];

        tempMap = load(scan);

        delays = tempMap(1,2:end);
        lambdas = tempMap(2:end,1);
        
        allScans(:,:,ii) = removeNoise(tempMap(2:end,2:end), delays) * 100;
        
    end

    close(h);

end