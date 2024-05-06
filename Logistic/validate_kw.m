clc;clear;close all;
%验证相同tau是否一致

demo_index=1;
dt=1e-2;
N=4;

y=load(sprintf('%s/Logistic/data/gd_origin_%d.mat',pwd,demo_index)).y;
t=load(sprintf('%s/Logistic/data/gd_origin_%d.mat',pwd,demo_index)).t;

X1=load(sprintf('%s/Logistic/data/gd_%d_kw.mat',pwd,demo_index)).X1;
t1=t(1/dt+1:end);

x1=sum(X1(N*(1-1)+1:N*1,:));
x2=sum(X1(N*(2-1)+1:N*2,:));

subplot(1,2,1)
plot(t,y(1,:),'b--',t1,x1,'r-')
xlabel('t');
ylabel('x(t)');

subplot(1,2,2)
plot(t,y(2,:),'b--',t1,x2,'r-')
xlabel('t');
ylabel('y(t)');

