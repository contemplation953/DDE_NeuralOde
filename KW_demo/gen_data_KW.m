clc;clear;

%设定时滞
tau = 1;
dt = 1e-2;
end_tspan = 50;
dim = 4;
N = 6;
t=-tau:dt:0;
t_len=tau/dt;

x=load(sprintf('%s/vdp_demo/data/vdp_origin.mat',pwd)).y;

X1=zeros(N,end_tspan/dt);
X2=X1;
X3=X1;
X4=X1;

for index = 1:end_tspan/dt
    x_0=x(:,index:index+t_len);
    y_0=vec_re_koorn_approx(t,x_0,dim,N);
    X1(:,index)=y_0(1:dim:end)';
    X2(:,index)=y_0(2:dim:end)';
    X3(:,index)=y_0(3:dim:end)';
    X4(:,index)=y_0(4:dim:end)';
end
save(sprintf('%s/vdp_demo/data/vdp_KW.mat',pwd),'X1','X2','X3','X4');
