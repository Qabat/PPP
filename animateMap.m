close all

TAmap = dlmread('TA.dat');

    delays = TAmap(1,2:end);
    lambdas = TAmap(2:end,1);
    TAmap = TAmap(2:end,2:end);

files = dir('*.dat') ;

writerObj = VideoWriter('methyluridine_magicangle.avi');
writerObj.FrameRate = 10;

% open the video writer
open(writerObj);

mapPlot = figure('units','pixels','position',[0 0 1000 1000]);
set(gcf,'color','w');
        set(findall(mapPlot,'-property','TickLength'),'LineWidth',1.5)
set(findall(mapPlot,'-property','TickLength'),'TickLength',[0.02,0.035])
set(findall(mapPlot,'-property','FontSize'),'FontName','Arial','FontSize',24)

for n = 1:300

%         hold on
        plot(lambdas, TAmap(:,n), 'r', 'LineWidth', 5);
%         plot(time(1:n),surf2Energy(1:n), 'b', 'LineWidth', 2)
%         plot(time(1:n),surf3Energy(1:n), 'g', 'LineWidth', 2)
        hold on
        plot(lambdas, zeros(length(lambdas)), 'k--', 'LineWidth', 3);
hold off
        box on
        grid on 
        pbaspect([1 1 1])
        
%         plot(time(1:n),potentialEnergy(1:n), 'k', 'LineWidth', 3)
        xlim([310 650]);
        ylim([-0.1 0.1]);
        xticks([310 350 400 450 500 550 600 650]);
        set(findall(mapPlot,'-property','TickLength'),'LineWidth',1.5)
set(findall(mapPlot,'-property','TickLength'),'TickLength',[0.02,0.035])
set(findall(mapPlot,'-property','FontSize'),'FontName','Arial','FontSize',24)
        
        xlabel('wavelength [nm]');
    ylabel('\DeltaT/T [%]');
       
        title(['t = ', num2str(round(delays(n))), ' fs']);
        
%         legend('ground state','first excited state','second excited state', 'current state', 'Location', 'northwest');
        
        drawnow
    
    % write the frames to the video
	F = getframe(gcf) ;
	writeVideo(writerObj, F);
end

% close the writer object
close(writerObj);
fprintf('Sucessfully generated the video\n')