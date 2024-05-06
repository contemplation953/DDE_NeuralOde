clc;clear;close all;


demo_index=2;
tau_list=[2.3,2.8];
%dt取得越细越精确
%tau=0.2 mg_origin.mat;tau=0.5 mg_origin_2.mat;tau=1 mg_origin_3.mat
tau=tau_list(demo_index);
dt=1e-2;
t_end_train=100;
t_end_test=400;

tic;
[t,y] = gen_dde_data(tau,dt,t_end_train);
toc;
tic;
[t_test,y_test] = gen_dde_data(tau,dt,t_end_test);
toc;

subplot(1,2,1)
plot(t,y(1,:),'b-')
xlabel('t');
ylabel('x(t)');

subplot(1,2,2)
plot(t,y(2,:),'b-')
xlabel('t');
ylabel('y(t)');


save(sprintf('%s/Logistic/data/gd_origin_%d.mat',pwd,demo_index),'t','y','t_test','y_test');
%y=load(sprintf('%s/Logistic/data/gd_origin_%d.mat',pwd,demo_index)).y;
N=4;
dim=2;
tau=1;
X1=fun_to_kw(tau,dt,y,dim,N); 
save(sprintf('%s/Logistic/data/gd_%d_kw.mat',pwd,demo_index),'X1');