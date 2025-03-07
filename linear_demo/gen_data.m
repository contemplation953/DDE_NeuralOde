clc;clear;

%设定时滞
tau = 1;

dt=1e-2;
tspan=[0 50];
options = ddeset('MaxStep',dt);
sol = dde23(@ddex1de,tau,@ddex1hist,tspan,options);

subplot(1,2,1)
plot(sol.y(1,:),sol.y(2,:))
xlabel('x(1)');
ylabel('x(2)');

subplot(1,2,2)
plot(sol.y(3,:),sol.y(4,:))
xlabel('x(3)');
ylabel('x(4)');

init_val=[0;2;0;2];
init_tau=repmat(init_val,1,tau/dt);

y=[init_tau,sol.y];
save(sprintf('%s/vdp_demo/data/vdp_origin.mat',pwd),'y');

% --------------------------------------------------------------------------

function s = ddex1hist(t)
    s = [0;2;0;2];
end

% --------------------------------------------------------------------------

function dydt = ddex1de(t,y,Z,L,B,C)
    %参数
    alpha1 = 0.3; alpha2 = -0.3; 
    gamma1 = 0.3; gamma2 = 0.3; 
    k = 0.05; 
    
    L=[0,1,0,0 ; -k-1,-alpha1,k,0 ; 0,0,0,1 ; k,0,-k-1,-alpha2];
    B=[0,0,0,0;gamma1,0,0,0;0,0,0,0;0,0,gamma2,0];
    C=[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0];
    dydt = L*y+B*Z+[0;-y(1).^2*y(2);0;-y(3).^2*y(4)];
end