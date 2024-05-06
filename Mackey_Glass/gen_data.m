clc;clear;close all;

demo_index=3;
tau_list=[0.2,0.5,1];
mat_name_list=["mg_origin_1","mg_origin_2","mg_origin_3"];
%dt取得越细越精确
%tau=0.2 mg_origin.mat;tau=0.5 mg_origin_2.mat;tau=1 mg_origin_3.mat
tau=tau_list(demo_index);
dt=1e-3;

t_end_train=10;
t_end_test=30;

tau_T=dt:dt:tau;
tau_val=ones(1,tau/dt)*0.3;

t=dt:dt:t_end_train;
%f=@(x_tau,x,t) 4*x_tau/(1+x_tau.^9.65)-2*x;
y=Delay_Runge_Kutta(dt,tau,t_end_train,tau_val);

t_test=dt:dt:t_end_test;
y_test=Delay_Runge_Kutta(dt,tau,t_end_test,tau_val);

subplot(2,2,1)
begin=tau/dt;
plot(y(1:end-begin),y(begin+1:end),'b-')
xlabel('x(t-\tau)');
ylabel('x(t)');

subplot(2,2,2)
plot(t,y,'b-')
xlabel('x(t-\tau)');
ylabel('x(t)');

init_val=0.3;
init_tau=repmat(init_val,1,tau/dt);
y=[init_tau,y];
mat_name=mat_name_list(demo_index);

subplot(2,2,3)
begin=tau/dt;
plot(y_test(1:end-begin),y_test(begin+1:end),'b-')
xlabel('x(t-\tau)');
ylabel('x(t)');

subplot(2,2,4)
plot(t_test,y_test,'b-')
xlabel('x(t-\tau)');
ylabel('x(t)');

save(sprintf('%s/Mackey_Glass/data/%s.mat',pwd,mat_name),'t','y','t_test','y_test');
N=4;
dim=1;
X1=fun_to_kw(tau,dt,y,dim,N);
save(sprintf('%s/Mackey_Glass/data/%s_kw.mat',pwd,mat_name),'X1');