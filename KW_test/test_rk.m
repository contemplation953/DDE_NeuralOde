clc;clear;

dt=1e-3;
t=dt:dt:5;
x=sin(5*t)+cos(3*t);

t1=-1+dt:dt:5;
x1=sin(5*t1)+cos(3*t1);



dim=1;
tau=1;
X1=fun_to_kw(tau,dt,x1,dim,1);

X2=fun_to_kw(tau,dt,x1,dim,2);

X3=fun_to_kw(tau,dt,x1,dim,3);

X4=fun_to_kw(tau,dt,x1,dim,4);

plot(t,x,'b-','LineWidth',3);
hold on;

step=100;
plot(t(1:step:end),sum(X1(:,1:step:end),1),'g--+','LineWidth',1);
hold on;
plot(t(1:step:end),sum(X2(:,1:step:end)),'c--*','LineWidth',1);
hold on;
plot(t(1:step:end),sum(X3(:,1:step:end)),'m--^','LineWidth',1);
hold on;
plot(t(1:step:end),sum(X4(:,1:step:end)),'r--o','LineWidth',1);
grid on;
legend('Ground Truth','N=1','N=2','N=3','N=4');
xlabel('t','FontSize',16);
ylabel('f(t)','FontSize',16);