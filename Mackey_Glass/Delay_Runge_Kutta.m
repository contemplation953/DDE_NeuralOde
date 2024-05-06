function X1 = Delay_Runge_Kutta(h,t_tau,t_end,tau_val)

%%单时滞DDE
% h\[LongDash]\[LongDash]步长
% t_tau\[LongDash]\[LongDash]tau长度
% t_end\[LongDash]\[LongDash模拟时长
% f\[LongDash]\[LongDash]待计算函数
% tau_val\[LongDash]\[LongDash]初值

n=t_tau/h;
N=t_end/h;

assert(length(tau_val)==n);

X1 = ones(1,N)*tau_val(end);
f=@(x_tau,x,t) 4*x_tau/(1+x_tau.^9.65)-2*x;
% Runge-Kutta 4
for i = 1:N-1

    if i <= n
        x1tau = tau_val(i);%初值函数系统的影响。
    else
        x1tau = X1(i-n);
    end

    x1 = X1(i);
    t=i*h;
    Kf1 = f(x1tau,x1,t);
    Kf2 = f(x1tau,x1+Kf1*h/2,t);
    Kf3 = f(x1tau,x1+Kf2*h/2,t);
    Kf4 = f(x1tau,x1+Kf3*h,t);
    X1(i+1) = X1(i) + (Kf1 + 2*Kf2 + 2*Kf3 + Kf4)*h / 6;
end
