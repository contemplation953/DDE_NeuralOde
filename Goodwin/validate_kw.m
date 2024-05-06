clc;clear;close all;
%验证相同tau是否一致

demo_index=1;
dt=5e-3;
N=4;

y=load(sprintf('%s/Goodwin/data/gd_origin_%d.mat',pwd,demo_index)).y;
t=load(sprintf('%s/Goodwin/data/gd_origin_%d.mat',pwd,demo_index)).t;

X1=load(sprintf('%s/Goodwin/data/gd_%d_kw.mat',pwd,demo_index)).X1;
t1=t(1/dt+1:end);

x1=sum(X1(N*(1-1)+1:N*1,:));
x2=sum(X1(N*(2-1)+1:N*2,:));
x3=sum(X1(N*(3-1)+1:N*3,:));

subplot(1,3,1)
plot(t,y(1,:),'b--',t1,x1,'r-')
xlabel('t');
ylabel('x(t)');

subplot(1,3,2)
plot(t,y(2,:),'b--',t1,x2,'r-')
xlabel('t');
ylabel('y(t)');

subplot(1,3,3)
plot(t,y(3,:),'b--',t1,x3,'r-')
xlabel('t');
ylabel('z(t)');
