function [X1,Y1] = Delay_Runge_Kutta(h,t_tau,t_end,tau_val,y_init)

%%单时滞DDE
% h\[LongDash]\[LongDash]步长
% t_tau\[LongDash]\[LongDash]tau长度
% t_end\[LongDash]\[LongDash模拟时长
% f\[LongDash]\[LongDash]待计算函数
% tau_val\[LongDash]\[LongDash]初值

n=t_tau/h;
N=t_end/h;

assert(length(tau_val)==n);

X1=ones(1,N)*tau_val(end);
Y1=ones(1,N)*y_init;
f=@(x_tau,x,y,t) 201-1.08*1e-3*y;
g=@(x_tau,x,y,t) 117+4.28*1e-7*x_tau.^2;
% Runge-Kutta 4
for i = 1:N-1
    if i <= n
        x1tau = tau_val(i);
    else
        x1tau = X1(i-n);
    end

    x1=X1(i);
    y1=Y1(i);
    t=i*h;
    Kf1 = f(x1tau,x1,y1,t);
    Kg1 = g(x1tau,x1,y1,t);

    Kf2 = f(x1tau,x1+Kf1*h/2,y1+Kg1*h/2,t);
    Kg2 = g(x1tau,x1+Kf1*h/2,y1+Kg1*h/2,t);
    
    Kf3 = f(x1tau,x1+Kf2*h/2,y1+Kg2*h/2,t);
    Kg3 = g(x1tau,x1+Kf2*h/2,y1+Kg2*h/2,t);

    Kf4 = f(x1tau,x1+Kf3*h,y1+Kg3*h,t);
    Kg4 = g(x1tau,x1+Kf3*h,y1+Kg3*h,t);

    X1(i+1) = X1(i) + (Kf1 + 2*Kf2 + 2*Kf3 + Kf4)*h / 6;
    Y1(i+1) = Y1(i) + (Kg1 + 2*Kg2 + 2*Kg3 + Kg4)*h / 6;
end
