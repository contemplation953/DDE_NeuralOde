clc;clear;close all;

%% 搜索合适的tau值

demo_index=1;
tau_list=[0.2,0.5,1];

%设定时滞
tau = tau_list(demo_index);
tau_v=1.2;
dt = 1e-3;
dim = 1;
N = 4;

x=load(sprintf('%s/Mackey_Glass/data/mg_origin_%d.mat',pwd,demo_index)).y;

X1=fun_to_kw(tau_v,dt,x,dim,N);
x=x(tau/dt+1:end);
X1_to_origin=sum(X1);
step=10;

subplot(1,2,1);
plot(1:length(x),x,'b-',1:step:length(X1_to_origin),X1_to_origin(1:step:end),'ro');

subplot(1,2,2);
plot(1:length(x),x,'b-',1/dt:step:1/dt+length(X1_to_origin),X1_to_origin(1:step:end),'ro');
