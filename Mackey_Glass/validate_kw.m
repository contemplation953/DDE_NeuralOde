clc;clear;close all;
%验证相同tau是否一致

demo_index=3;
tau_list=[0.2,0.5,1];

tau=tau_list(demo_index);
dt=1e-3;

X1=load(sprintf('%s/Mackey_Glass/data/mg_origin_%d_kw.mat',pwd,demo_index)).X1;
X1_to_origin=sum(X1);

x=load(sprintf('%s/Mackey_Glass/data/mg_origin_%d.mat',pwd,demo_index)).y;
x=x(tau/dt+1:end);

step=100;

plot(1:length(x),x,'b-',1:step:length(X1_to_origin),X1_to_origin(1:step:end),'ro');

