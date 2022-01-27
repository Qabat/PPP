

function zero=Exp_decay(par)
global x_data y_data XRI

A = par(1:2);
tau = par(3:4);
C = par(5);
x0 = par(6);

sigma0 = 20/1.76;
%%%%%%%area costante
% wo = par(2:8);
% lc = par(9:15);T1
Gauss0 = (sech((XRI-x0)/sigma0).^2);
Gauss0 = Gauss0./trapz(XRI,Gauss0);
funh = zeros(1,length(XRI));
x0pos = find(XRI>=x0,1);
funh(x0pos:end) = 1;
%modello=(A(1)*(1-exp(-(XRI-x0)./tau(1)))+A(2)*exp(-(XRI-x0)./tau(2))+A(3)*exp(-(XRI-x0)./tau(3))).*funh';
modello = (A(1)*(1-exp(-(XRI-x0)./tau(1)))+A(2)*exp(-(XRI-x0)./tau(2))).*funh';
H1 = interp1(XRI,conv(modello,Gauss0,'same'),x_data)+C;

assignin('base','curvefit',H1)
%figure(31)
%plot(x_dat,y_dat,'ok',x_dat,H1,'-r','LineWidth',2)

zero=(H1-y_data);
end