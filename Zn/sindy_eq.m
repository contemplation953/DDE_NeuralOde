clc;clear;close all;

x=load(sprintf('%s/Zn/data/origin_data.mat',pwd)).x;
y=load(sprintf('%s/Zn/data/origin_data.mat',pwd)).y;
t=(1:length(x))*5;

order=3;
framelen=11;
%去噪
sgf_x=sgolayfilt(x,order,framelen);
sgf_y=sgolayfilt(y,order,framelen);

%从30分钟开始，之前的作为初值
tau_val=sgf_x(1:6);
y_init=sgf_y(6);

h=5;
t_tau=30;
t_end=210;
[X1,Y1]=Delay_Runge_Kutta(h,t_tau,t_end,tau_val,y_init);

t1=(1:6)*5;
t2=(1:length(X1))*5+30;

plot(t,x,'r+',t2,X1,'r-');
hold on;
plot(t,y,'b+',t2,Y1,'b-');
xline(160,'r--','LineWidth',2);
xlabel("t (min)",'FontSize',16)
ylabel("GFP",'FontSize',16)
grid on;

p_x = [0 160 160 0];
p_y = [0 0 9e4 9e4];
patch(p_x,p_y,[108,137,3]/256,'FaceAlpha',0.2,'EdgeColor','none');
hold on
p_x = [160 250 250  160];
p_y = [0 0 9e4 9e4];
patch(p_x,p_y,[43,105,10]/256,'FaceAlpha',0.2,'EdgeColor','none');
legend('Experimental of x(t)','SINDy model of x(t)','Experimental of y(t)','SINDy model of y(t)','Location','northwest');

figure(2)
t3=(1:33)*5;
t4=(7:33)*5;
plot(t3,x(1:33),'r+',t3,y(1:33),'b+');
hold on;
plot(t4,X1(1:27),'r-',t4,Y1(1:27),'b-');

save(sprintf('%s/Zn/data/sindy_data.mat',pwd),'X1','Y1','t1','t2');