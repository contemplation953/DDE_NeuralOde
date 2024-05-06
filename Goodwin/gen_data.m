clc;clear;close all;

demo_index=1;
%[tau2,tau3,tau1,tau1+tau2]
tau_matrix=[2.25,6.15,4.35;12.25,10.15,9.35];
dt=5e-3;
t_end_train=400;
t_end_test=800;

t_tau=tau_matrix(demo_index,:);
tau_val=[0.10;0.90;0.5].*ones(3,ceil((t_tau(1)+t_tau(3))/dt));

t=dt:dt:t_end_train;
y=Delay_Runge_Kutta(dt,t_tau,t_end_train,tau_val);

t_test=dt:dt:t_end_test;
y_test=Delay_Runge_Kutta(dt,t_tau,t_end_test,tau_val);


subplot(2,2,1)
plot(t,y(1,:),'b-')
xlabel('t');
ylabel('x(t)');

subplot(2,2,2)
plot(t,y(2,:),'b-')
xlabel('t');
ylabel('y(t)');

subplot(2,2,3)
plot(t,y(3,:),'b-')
xlabel('t');
ylabel('z(t)');

subplot(2,2,4)
plot3(y(1,:),y(2,:),y(3,:),'b-')
xlabel('x(t)');
ylabel('y(t)');
zlabel('z(t)');

save(sprintf('%s/Goodwin/data/gd_origin_%d.mat',pwd,demo_index),'t','y','t_test','y_test');
%y=load(sprintf('%s/Goodwin/data/gd_origin_%d.mat',pwd,demo_index)).y;
N=4;
dim=3;
tau=1;
X1=fun_to_kw(tau,dt,y,dim,N); 
save(sprintf('%s/Goodwin/data/gd_%d_kw.mat',pwd,demo_index),'X1');