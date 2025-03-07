clear; close all;clc;
N=4; %设定逼近阶数
dim=2; %设定原始方程维数
h=0.001;
t=-1:h:0; tau=t(end)-t(1);%设定时滞
alpha1 = 0.3; 
lambda1 = 0.05; lambda2 = 0.05;
gamma1 = 0.3; gamma2 = 0.3; 
k = 0.05; %参数
alpha2 = -0.3;
L=[0,1; -k-1, -alpha1];
B=[0,0;gamma1,0];
C=[0,0;0,0];
GN = generate_gammaN(dim,N,tau,L,B,C);
x_0=[t*0+0;t*0+2];
y_0=vec_re_koorn_approx(t,x_0,dim,N); %设定初值
tspan=[0 100];
[t1,y] = ode45(@(t,y) GN*y+func_vdp(dim,N,alpha1,alpha2,y), tspan, y_0); %求解GK-ODE
x = gk_sol_to_origin(dim,y);

history=[0;2];
sol = dde23(@(t, x, Z) ddefunc(t, x, Z, L, B), 1, history, tspan);
plot(sol.y(1,:),sol.y(2,:))
hold on;
plot(x(1,:),x(2,:),'bo')

xlabel('x_1',FontSize=16);
ylabel('x_2',FontSize=16);
grid on;
legend('Numerical solution', 'Approximate solution');



function dxdt = ddefunc(t, x, Z, L, B)
    dxdt = L*x+B*Z+[0;-x(1)^2*x(2)];
end
