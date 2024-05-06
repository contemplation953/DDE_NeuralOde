clc;clear;close all;

dt=1e-3;
f=@(x_tau,x,t) 4*x_tau/(1+x_tau.^9.65)-2*x;
t_tau=1;
t_end=30;
T=dt:dt:t_end;


data_path=sprintf('%s/Mackey_Glass/data',pwd);
res_path=sprintf('%s/Mackey_Glass/res',pwd);
X1=load(sprintf('%s/mg_origin_%d_kw.mat',data_path,3)).X1;
neuralOdeParameters=load(sprintf('%s/neuralOdeParameters_%d.mat',data_path,3)).neuralOdeParameters;

%0.3初值展开
tau_val=X1(:,1);
res=Delay_NN(dt,t_end,tau_val,neuralOdeParameters);
Y=[0.3,res];

t=-1+dt:dt:0;
kw_max=zeros(size(X1,1),1000);
for i=1:size(X1,1)
    kw_max(i,:)=rescaled_koornwinder(1,i-1,t);
end

d0=1e-3;
y_org=sum(tau_val.*kw_max);
y_org(1)=y_org(1)+d0;
tau_val1=vec_re_koorn_approx(t,y_org,1,4);
tau_val1=tau_val1';

lsum=0;
for i=1:t_end  
    Y1=Delay_NN(dt,1,tau_val1,neuralOdeParameters);
    d1=abs(Y1(end)-Y(i/dt));     
    % #新的偏离点在上一次计算的两轨迹末端的连线上，且距离仍等于d0
    Y1(1)=Y1(1)+(d0/d1)*(Y1(1)-Y((i-1)/dt+1));   
    tau_val1=vec_re_koorn_approx(t,Y1,1,4);
    tau_val1=tau_val1';
   
    % #舍弃暂态过程的数据，因为初始基准点不一定在吸引子上
    if i> 10
        lsum=lsum+log(d1/d0);  
    end  
end  

%ans=98.4541
