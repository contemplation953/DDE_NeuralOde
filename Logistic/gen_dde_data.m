function [t,y]=gen_dde_data(tau,dt,t_end)
    tspan=[0 t_end];
    
    
    options = ddeset('MaxStep',dt);
    sol = dde23(@ddex1de,tau,@ddex1hist,tspan,options);
    t=sol.x;
    y=sol.y;
    % --------------------------------------------------------------------------
    
    function s = ddex1hist(t)
        s = [0.8,0.8];
    end
    
    % --------------------------------------------------------------------------
    
    function res = ddex1de(t,y,Z)
        x_t=y(1);
        y_t=y(2);
        
        x_lag=Z(1,1);
        
        dxdt=x_t*(1-2*x_lag-y_t);
        dydt=x_t-y_t;

        res=[dxdt;dydt];
    end
end