close all
global x_data y_data XRI
pat='C:\Users\matti\Desktop\Dottorato di ricerca\software\PumpProbe_Programs\Data\d20022601_real.dat';
file =dir(pat);
a=regexp(pat,'\');
ind=pat(1:a(end));
pati=[ind,file.name];
dass=dlmread(pati);
wl=dass(2:end,1);
time=dass(1,2:end);
pp=dass(2:end,2:end);

%% cut time

t1_cut=-500;
t2_cut=90000;
i_t1=find(time>=t1_cut,1);
i_t2=find(time>=t2_cut,1);
time=time(i_t1:i_t2);
pp=pp(:,i_t1:i_t2);

x_data=time;
pos_w=find(wl>=587,1);
y_data=pp(pos_w,:)./100;
y_data=-1*y_data;
%% set to zer the negative points
neg_pos=find(y_data<=0);
y_data(neg_pos)=0;
A1=0.05; %ampiezza prima componente

A2=0.05; %decadimento 1

tau1=100;  %fs build-up
tau2=200000;
 %fs decadimento 1a

C=0.1;

x0=0; %zero
A0=2;

%%%%%risposta strumentale%%%%%%%%%

sigma0=40;
figure(1)
hold on
plot(x_data,y_data,'ok','Color','b')
xlabel('Time Delay [fs]')
ylabel('\Delta T/T')




options = optimset('MaxFunEvals',10000,'MaxIter',10000,'Tolfun',1e-18,'TolX',1e-18); %questi sono le opzioni per fermare il fit
par=  [A1 A2 tau1 tau2 C x0];
lower=[0.0001 0.0001  150 150000 -0.0001 -50];
upper=[2 2  700 300000  0.0001 50];

 step=(x_data(2)-x_data(1))/2;
  newtimeaxis=([-x_data(end):step:x_data(end)+step]);
  XRI=newtimeaxis';

[var_fit,resnorm,residual,exitflag,output,lambda,Jacobian]=lsqnonlin(@Exp_decay,par,lower,upper,options);

Jacobian = full(Jacobian); %lsqnonlin returns the Jacobian as a sparse
varp = resnorm*inv(Jacobian'*Jacobian)/length(newtimeaxis);
stdp = sqrt(diag(varp)); %standard deviation is square root of variance
variance=stdp.^2;
conf_interval = nlparci(var_fit,residual,'jacobian',Jacobian);

%err = nlparci(var_fit,residual,'Jacobian',jacobian);
%errore=(err(:,2)-err(:,1))/2/1.96; %confidenza al 95%
%tau=var_fit(4:6);
%Er_tau=errore(3:4);
%param(:,i)=var_fit;

figure(1)
hold on
plot(x_data,curvefit,'LineWidth',2,'Color','g')
set(gca,'FontSize',14,'LineWidth',1.5,'Box','on')

%xlim([-500 5000])
%ylim([-0.1 1.05])
