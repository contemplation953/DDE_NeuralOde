function X1 = Delay_Runge_Kutta(h,t_tau,t_end,tau_val)

    %%多时滞DDE
    % h\[LongDash]\[LongDash]步长
    % t_tau\[LongDash]\[LongDash]tau长度
    % t_end\[LongDash]\[LongDash模拟时长
    % f\[LongDash]\[LongDash]待计算函数
    % tau_val\[LongDash]\[LongDash]初值
    
    N=t_end/h;
    t_tau=[t_tau,t_tau(1)+t_tau(3)];
    %时滞的个数
    n=length(t_tau);
    
    X1=ones(size(tau_val,1),N).*tau_val(:,end);
    xtau=zeros(n,1);
    % Runge-Kutta 4
    for i = 1:N-1
        for j=1:n
            tau_n=ceil(t_tau(j)/h);
            if i <= tau_n
                if j==n
                    xtau(j)=tau_val(j-1,i);
                else
                    xtau(j)=tau_val(j,i);
                end
                
            else
                if j==n
                    xtau(j)=X1(j-1,i-tau_n);
                else
                    xtau(j)=X1(j,i-tau_n);
                end 
            end
        end
    
        x1 = X1(:,i);
        Kf1 = f(xtau,x1);
        Kf2 = f(xtau,x1+Kf1*h/2);
        Kf3 = f(xtau,x1+Kf2*h/2);
        Kf4 = f(xtau,x1+Kf3*h);
        X1(:,i+1) = X1(:,i) + (Kf1 + 2*Kf2 + 2*Kf3 + Kf4)*h / 6;
    end
end

function res=f(xtau,x)
    x_t=x(1);
    y_t=x(2);
    z_t=x(3);
    
    x_lag=xtau(1);
    y_lag=xtau(2);
    z_lag1=xtau(3);
    z_lag2=xtau(4);
    
    dxdt=-x_t+0.25./(1+z_lag1.^2);
    dydt=-0.25*y_t+x_lag+0.1./(1+0.5*z_lag2.^2);
    dzdt=-0.5*z_t+y_lag;
    res=[dxdt;dydt;dzdt];
end