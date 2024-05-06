clc;clear;


x=load(sprintf('%s/Zn/data/origin_data.mat',pwd)).x;
y=load(sprintf('%s/Zn/data/origin_data.mat',pwd)).y;

order=3;
framelen=11;
sgf_x=sgolayfilt(x,order,framelen);
sgf_y=sgolayfilt(y,order,framelen);


t=0:length(x)-1;
t=t*300;

t1=1:t(end);
vx1=interp1(t,sgf_x,t1,'cubic');
vy1=interp1(t,sgf_y,t1,'cubic');

plot(t,sgf_x,'r+',t1,vx1,'r-');
hold on;
plot(t,sgf_y,'b+',t1,vy1,'b-');

xlabel('t (s)','FontSize',16);
ylabel('GFP','FontSize',16);
grid on;
legend('Experimental of x(t)','Interpolation results of x(t)','Experimental of y(t)','Interpolation results of y(t)');
