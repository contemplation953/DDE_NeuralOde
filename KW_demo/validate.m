clc;clear;close all;

X1=load(sprintf('%s/vdp_demo/data/vdp_KW.mat',pwd)).X1;
X2=load(sprintf('%s/vdp_demo/data/vdp_KW.mat',pwd)).X2;
X3=load(sprintf('%s/vdp_demo/data/vdp_KW.mat',pwd)).X3;
X4=load(sprintf('%s/vdp_demo/data/vdp_KW.mat',pwd)).X4;

X1_to_origin=sum(X1);
X2_to_origin=sum(X2);
X3_to_origin=sum(X3);
X4_to_origin=sum(X4);

x=load(sprintf('%s/vdp_demo/data/vdp_origin.mat',pwd)).y;

subplot(2,2,1)
plot(x(1,:),x(2,:),'b-',X1_to_origin(1:10:end),X2_to_origin(1:10:end),'ro')
xlabel('x(1)');
ylabel('x(2)');

subplot(2,2,2)
plot(x(3,:),x(4,:),'b-',X3_to_origin(1:10:end),X4_to_origin(1:10:end),'ro')
xlabel('x(4)');
ylabel('x(4)');

tau = 1;
dt=1e-2;
x=x(:,tau/dt+1:end);
subplot(2,2,3)
plot(1:length(x(1,:)),x(1,:),'b-',1:10:length(X1_to_origin),X1_to_origin(1:10:end),'ro')
xlabel('t');
ylabel('x(1)');

subplot(2,2,4)
plot(1:length(x(3,:)),x(3,:),'b-',1:10:length(X3_to_origin),X3_to_origin(1:10:end),'ro')
xlabel('t');
ylabel('x(3)');

