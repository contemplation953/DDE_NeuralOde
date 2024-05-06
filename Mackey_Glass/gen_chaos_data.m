clc;clear;close all;

demo_index=3;
tau_list=[0.2,0.5,1];
%dt取得越细越精确
tau=tau_list(demo_index);
dt=1e-3;

t_end_test=100;

tau_T=dt:dt:tau;
tau_val=ones(1,tau/dt)*0.3;

t_test=dt:dt:t_end_test;
y_test=Delay_Runge_Kutta(dt,tau,t_end_test,tau_val);


save(sprintf('%s/Mackey_Glass/data/chaos.mat',pwd),'t_test','y_test');