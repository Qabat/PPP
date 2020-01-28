function vecrast(figureHandle, filename, resolution, stack, exportType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Theodoros Michelis, 6 October 2017
% TUDelft, Aerospace Engineering, Aerodynamics
% t.michelis@tudelft.nl
%
% v. 1.4
% 25th October 2019
%
% D E S C R I P T I O N:
% vecrast is a function that allows to automatically save a figure with
% mixed vector and raster content. More specifically, two copies of the
% figure of interest are created, rasterFigure and vectorFigure. Patches,
% surfaces, contours, images, and lights are kept in rasterFigure but
% removed from vectorFigure. rasterFigure is then saved as a temporary
% .png image with the required resolution. The .png file is subsequently
% inserted into the vectorFigure, and the result is saved in a single
% vector file.
%
%
% I N P U T:
% vecrast(figureHandle, filename, resolution, stack, exportType)
%   figureHandle:   Handle of the figure of interest
%   filename:       Baseline name string of output file WITHOUT the extension.
%   resolution:     Desired resolution of rasterising in dpi
%   stack:          'top' or 'bottom'. Stacking of raster image with
%                   respect to axis in vector figure, see examples below.
%   exportType:     'pdf', 'eps' or 'svg'. Export file type for the output file.
%
%
% N O T E S:
% - The graphics smoothing (anti-aliasing) is turned off for the raster
%   figure. This improves sharpness at the borders of the image and at the
%   same time greatly reduces file size. You may change this option in the
%   script by setting 'GraphicsSmoothing', 'on' (line 97).
% - A resolution of no less than 300 dpi is advised. This ensures that
%   interpolation at the edges of the raster image does not cause the image
%   to bleed outside the prescribed axis (make a test with 20dpi on the
%   first example and you will see what I mean).
% - The stacking option has been introduced to accomodate 2D and 3D plots
%   which require the image behind or in front the axis, respectively. This
%   difference can be seen in the examples below.
% - I strongly advise to take a look at the tightPlots function that allows
%   setting exact sizes of figures.

% E X A M P L E   1:
%   clear all; close all; clc;
%   Z = peaks(40);
%   ha(1) = subplot(1, 2, 1);
%   contourf(ha(1), Z, 10)
%   ha(1).XGrid = 'on'; ha(1).YGrid = 'on';
%   axis square; colorbar;
%   ha(2) = subplot(1, 2, 2);
%   h = pcolor(ha(2), Z);
%   h.EdgeColor = 'none';
%   ha(2).XGrid = 'on'; ha(2).YGrid = 'on';
%   ha(2).Layer = 'top';
%   axis square; colorbar;
%   colormap('jet');
%   vecrast(gcf, 'example1', 300, 'bottom', 'pdf');

% E X A M P L E   2:
%   clear all; close all; clc;
%   [X,Y] = meshgrid(1:0.4:10, 1:0.4:20);
%   Z = sin(X) + cos(Y);
%   surf(X,Y,Z)
%   vecrast(gcf, 'example2', 300, 'top', 'pdf');

% Thanks to:
% Jonathan Kohler, Kerry, Bob DA, Bryan Lougheed, Jonas Krimmer.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Some checks of the input ------------------------------------------------
if strcmp(stack, 'top') + strcmp(stack, 'bottom') == 0
    error('Stack must be ''top'' or ''bottom''');
end
if strcmp(exportType, 'pdf') + strcmp(exportType, 'eps') + strcmp(exportType, 'svg') == 0
    error('Stack must be ''pdf'', ''eps'' or ''svg''');
end

% Ensure figure has finished drawing
drawnow;

% Set figure units to points
set(figureHandle, 'units', 'points');

% Ensure figure size and paper size are the same
figurePosition = get(figureHandle, 'Position');
set(figureHandle, 'PaperUnits', 'points', 'PaperSize', [figurePosition(3) figurePosition(4)])
set(figureHandle, 'PaperPositionMode', 'manual', 'PaperPosition', [0 0 figurePosition(3) figurePosition(4)]);

% Create a copy of the figure and remove smoothness in raster figure
rasterFigure = copyobj(figureHandle, groot);
vectorFigure = copyobj(figureHandle, groot);
set(rasterFigure, 'GraphicsSmoothing', 'on');
set(vectorFigure, 'GraphicsSmoothing', 'off', 'color', 'w');

% Fix vector image axis limits based on the original figure
% (this step is necessary if these limits have not been defined)
axesHandle = findall(vectorFigure, 'type', 'axes');
for i = 1:length(axesHandle)
    xlim(axesHandle(i), 'manual');
    ylim(axesHandle(i), 'manual');
    zlim(axesHandle(i), 'manual');
end

% Create axis in vector figure to fill with raster image
rasterAxis = axes(vectorFigure, 'color', 'none', 'box', 'off', 'units', 'points');
set(rasterAxis, 'position', [0 0 figurePosition(3) figurePosition(4)]);
uistack(rasterAxis, stack);

% Ensure fontsizes are the same in all figures
figText = findall(figureHandle, 'type', 'text');
rastText = findall(rasterFigure, 'type', 'text');
vecText = findall(vectorFigure, 'type', 'text');
for i=1:length(figText)
    set(rastText(i), 'FontSize', get(figText(i), 'FontSize'));
    set(vecText(i), 'FontSize', get(figText(i), 'FontSize'));
end

% Raster Figure ----------------------------------------------------------
% Select what to remove from raster figure
axesHandle = findall(rasterFigure, 'type', 'axes');
set(axesHandle, 'color', 'none');
for i = 1:length(axesHandle)
    axesPosition{i} = get(axesHandle(i), 'position'); % Fix: get axes size
    contents = findall(axesHandle(i));
    toKeep = [...
        findall(axesHandle(i), 'type', 'patch');...
        findall(axesHandle(i), 'type', 'surface');...
        findall(axesHandle(i), 'type', 'contour')...
        findall(axesHandle(i), 'type', 'image');...
        findall(axesHandle(i), 'type', 'light')];
    toRemove = setxor(contents, toKeep);
    set(toRemove, 'visible', 'off');
end

% Switch transparency of figure if a surface object is found in the figure.
% (This fix solves the raster print black edge lines of pcolor)
if isempty(findall(rasterFigure, 'type', 'surface'))
    set(rasterFigure, 'GraphicsSmoothing', 'off', 'color', 'none');
else
    set(rasterFigure, 'GraphicsSmoothing', 'off', 'color', 'w');
end

% Restore original axes size
for i = 1:length(axesHandle)
	set(axesHandle(i), 'position', axesPosition{i});
end

% Remove all annotations, colorbars and legends from raster figure
annotations = findall(rasterFigure, 'Tag', 'scribeOverlay');
% colorbarHandle = findall(rasterFigure, 'type', 'colorbar');
legendHandle = findall(rasterFigure, 'type', 'legend');
set([annotations; legendHandle], 'visible', 'off');

% Print rasterFigure on temporary .png
% ('-loose' ensures that the bounding box of the figure is not cropped)
print(rasterFigure, [filename 'Temp.png'], '-dpng', ['-r' num2str(resolution) ], '-loose', '-opengl');
close(rasterFigure);

% Vector Figure -----------------------------------------------------------
% Select what to keep in vector figure
axesHandle = findall(vectorFigure, 'type', 'axes');
set(axesHandle, 'color', 'none');
for i = 1:length(axesHandle)
    axesPosition{i} = get(axesHandle(i), 'position'); % Fix: get axes size
    toRemove = [...
        findall(axesHandle(i), 'type', 'patch');...
        findall(axesHandle(i), 'type', 'surface');...
        findall(axesHandle(i), 'type', 'contour');...
        findall(axesHandle(i), 'type', 'image');...
        findall(axesHandle(i), 'type', 'light');...
        ];
    set(toRemove, 'visible', 'off');
end

% Restore original axes size
for i = 1:length(axesHandle) 
	set(axesHandle(i), 'position', axesPosition{i});
end

% Ensure Caxis limits match the original figure ---------------------------
figureAxesHandle = findall(figureHandle, 'type', 'axes');
for i = 1:length(figureAxesHandle)
    climOriginal = figureAxesHandle(i).CLim;
    axesHandle(i).CLim = climOriginal;
    
    zlimOriginal = figureAxesHandle(i).ZLim;
    axesHandle(i).ZLim = zlimOriginal;
end

% Insert Raster image into the vector figure
[A, ~, alpha] = imread([filename 'Temp.png']);

if isempty(alpha)==1
    imagesc(rasterAxis, A);
else
    imagesc(rasterAxis, A, 'alphaData', alpha);
end
axis(rasterAxis, 'off');

% Bring all annotations on top
annotations = findall(vectorFigure, 'Tag', 'scribeOverlay');
for i = 1:length(annotations)
    uistack(annotations(i), 'top');
end
% Ensure figure has finished drawing
drawnow;

% Finalise ----------------------------------------------------------------
% Remove raster image from directory
delete([filename 'Temp.png']); % COMMENT THIS IF YOU WANT TO KEEP PNG FILE

% Print and close the combined vector-raster figure
if strcmp(exportType, 'pdf') == 1
    print(vectorFigure, [filename '.pdf'], '-dpdf', '-loose', '-painters', ['-r' num2str(resolution) ]);
elseif strcmp(exportType, 'eps') == 1
    print(vectorFigure, [filename '.eps'], '-depsc2', '-loose', '-painters');
elseif strcmp(exportType, 'svg') == 1
    print(vectorFigure, [filename '.svg'], '-dsvg', '-loose', '-painters');
end

close(vectorFigure);

end