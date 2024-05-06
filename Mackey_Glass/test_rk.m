clc;clear;

clc;clear;close all;

demo_index=3;

dt=1e-3;
t_pred_end = 30;

data_path=sprintf('%s/Mackey_Glass/data',pwd);
t_test=load(sprintf('%s/mg_origin_%d.mat',data_path,demo_index)).t_test;
y_test=load(sprintf('%s/mg_origin_%d.mat',data_path,demo_index)).y_test;
neuralOdeParameters=load(sprintf('%s/neuralOdeParameters_%d.mat',data_path,3)).neuralOdeParameters;
X1=load(sprintf('%s/mg_origin_%d_kw.mat',data_path,demo_index)).X1;
t=-1+dt:dt:0;

kw_max=zeros(size(X1,1),1000);
for i=1:size(X1,1)
    kw_max(i,:)=rescaled_koornwinder(1,i-1,t);
end

plot(t_test(1001:2000),y_test(1001:2000),'b--');
hold on;
plot(dt+1:dt:2,sum(X1(:,2001).*kw_max),'r-');