clear; close all;clc;
N=6; %设定逼近阶数
dim=4; %设定原始方程维数
h=0.001;
t=-1:h:0; tau=t(end)-t(1);%设定时滞
alpha1 = 0.3; 
lambda1 = 0.05; lambda2 = 0.05;
gamma1 = 0.3; gamma2 = 0.3; 
k = 0.05; %参数
for alpha2 = -0.3:0.01:-0.3
    L=[0,1,0,0 ; -k-1,-alpha1,k,0 ; 0,0,0,1 ; k,0,-k-1,-alpha2];
    B=[0,0,0,0;gamma1,0,0,0;0,0,0,0;0,0,gamma2,0];
    C=[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0];
    GN = generate_gammaN(dim,N,tau,L,B,C);
    x_0=[t*0+0;t*0+2;t*0+0;t*0+2];
    y_0=vec_re_koorn_approx(t,x_0,dim,N); %设定初值
    tspan=[0 100];
    [t1,y] = ode45(@(t,y) GN*y+func_vdp(dim,N,alpha1,alpha2,y), tspan, y_0); %求解GK-ODE
    x = gk_sol_to_origin(dim,y);
    subplot(2,3,1)
    plot(t1,x(1,:),'k') , axis([0 300 -2 2])
    grid on
    subplot(2,3,2)
    plot(t1,x(2,:),'k') , axis([0 300 -2 2]) ,title(sprintf('alpha1 = %d, alpha2 = %d,', alpha1, alpha2));
    grid on
    subplot(2,3,3)
    plot(x(1,:),x(2,:),'k') , axis([-1 2 -1 2])
    grid on
    subplot(2,3,4)
    plot(t1,x(3,:),'k') , axis([0 300 -2 2])
    grid on
    subplot(2,3,5)
    plot(t1,x(4,:),'k') , axis([0 300 -2 2])
    grid on
    subplot(2,3,6)
    plot(x(3,:),x(4,:),'k') , axis([-1 2 -1 2])
    grid on
    drawnow
end