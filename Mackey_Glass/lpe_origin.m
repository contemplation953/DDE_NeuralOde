clc;clear;close all;

dt=1e-3;
t_tau=1;
t_end=30;
T=dt:dt:t_end;
tau_val=ones(1,t_tau/dt)*0.3;
Y = Delay_Runge_Kutta(dt,t_tau,t_end,tau_val);


d0=1e-5;
tau_val1=tau_val;
tau_val1(1)=tau_val1(1)+d0;
lsum=0;
for i=1:t_end  
    Y1 = Delay_Runge_Kutta(dt,t_tau,t_tau,tau_val1);
    tau_val1=Y1; 
    d1=abs(tau_val1(end)-Y(i/dt));     
    % #新的偏离点在上一次计算的两轨迹末端的连线上，且距离仍等于d0
    tau_val1(1)=tau_val1(1)+(d0/d1)*(tau_val1(1)-Y((i-1)/dt+1));   
   
    % #舍弃暂态过程的数据，因为初始基准点不一定在吸引子上
    if i> 10
        lsum=lsum+log(d1/d0);  
    end  
end  

%ans=91.36770   d0=1e-5;