% for switching the intensity axis from differential transmission
% to absorption

[file, path] = uigetfile('C:\PhD\UV TA\samples\nucleosides\*.dat');        
fileLocation = [path file];

[TAmap, delays, lambdas] = readMap(fileLocation, '');

TAmap = -log10(TAmap/100 + 1);

appendText = '_absorption';

saveMap(TAmap, delays, lambdas, fileLocation, appendText)