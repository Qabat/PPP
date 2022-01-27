function fitMap(fileLocation, rangeVector, plottingVector, dynamicsLambdas, curvefit)
    global x_data y_data XRI curvefit
    mapVector = readMap(fileLocation, '_smoothed');
    
    TAmap = mapVector{1};
    delays = mapVector{2};
    lambdas = mapVector{3};
    
    delayRange = rangeVector{1};
    intensityRange = rangeVector{3};

    intensityAxis = plottingVector{1};
    xAxis = plottingVector{2};
    intensityOffset = plottingVector{3};
    mainFontsize = plottingVector{4};
    legendFontsize = plottingVector{5};
    legendLocation = plottingVector{6};
    linewidth = plottingVector{7};

    fitPlot = figure('Position', [200 100 1000 600], 'Name', 'Dynamics', 'NumberTitle', 'off');
    hold all
    
    colDynamics = hsv(length(dynamicsLambdas));
    clear dynamicsLegend
    set(findall(fitPlot,'-property','TickLength'),'LineWidth',linewidth/1.5)
    set(findall(fitPlot,'-property','FontSize'),'FontName','Arial','FontSize',mainFontsize)

    for i = 1:length(dynamicsLambdas)
        indexLambdas = find(lambdas >= dynamicsLambdas(i),1);
        dynamics = TAmap(indexLambdas,:);

        plot(delays, dynamics, 'o', 'Color', colDynamics(i,:), 'Linewidth', linewidth); 
        dynamicsLegend{i} = strcat(num2str(dynamicsLambdas(i)), ' nm');
        
        t1_cut=-100;
        t2_cut=8000;
        i_t1=find(delays>=t1_cut,1);
        i_t2=find(delays>=t2_cut,1);
%         pp=pp(:,i_t1:i_t2);

        x_data=delays(i_t1:i_t2);
        y_data=dynamics(i_t1:i_t2);
       
%         x_data=delays;
%         y_data=dynamics;
        
        % fitting for a specific dynamicLambda
        A1 = 1;
        A2 = 1;
        tau1 = 100;
        tau2 = 10000;
        C = 0; % offset
        x0 = 0; % zero
%         sigma0 = 40;

        step = (x_data(2)-x_data(1))/2;
        newtimeaxis = ([-x_data(end):step:x_data(end)+step]);
        XRI = newtimeaxis';
        
        options = optimset('MaxFunEvals',10000,'MaxIter',10000,'Tolfun',1e-18,'TolX',1e-18);
        parameters =  [A1 A2 tau1 tau2 C x0];
        lower = [0.0001 0.0001  10 50 -0.1 -50];
        upper = [10 10 1000 50000  0.1 50];

        [var_fit,resnorm,residual,exitflag,output,lambda,Jacobian] = lsqnonlin(@Exp_decay,parameters,lower,upper,options);

        Jacobian = full(Jacobian); %lsqnonlin returns the Jacobian as a sparse
        varp = resnorm*inv(Jacobian'*Jacobian)/length(newtimeaxis);
        stdp = sqrt(diag(varp)); %standard deviation is square root of variance
        variance = stdp.^2;
        conf_interval = nlparci(var_fit,residual,'jacobian',Jacobian);

        plot(x_data, curvefit, 'Color', colDynamics(i,:), 'Linewidth', linewidth); 

    end
    plot(delays, zeros(1,length(delays)), '--', 'Color', 'k', 'Linewidth', linewidth);

    legend(dynamicsLegend, 'Location', legendLocation, 'FontSize', legendFontsize)
    xlim(delayRange);
    ylim([intensityRange(1)-intensityOffset intensityRange(2)+intensityOffset]);
    xlabel(xAxis);
    ylabel(intensityAxis);
    box on
    
    hold off
end