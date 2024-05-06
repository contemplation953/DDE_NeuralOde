clc;clear;close all;

demo_index=3;

dt=1e-3;
t_pred_end=30;


data_path=sprintf('%s/Mackey_Glass/data',pwd);
t_test=load(sprintf('%s/mg_origin_%d.mat',data_path,demo_index)).t_test;
y_test=load(sprintf('%s/mg_origin_%d.mat',data_path,demo_index)).y_test;
neuralOdeParameters=load(sprintf('%s/neuralOdeParameters_%d.mat',data_path,3)).neuralOdeParameters;
X1=load(sprintf('%s/mg_origin_%d_kw.mat',data_path,demo_index)).X1;

chaos_t_test=load(sprintf('%s/chaos.mat',data_path)).t_test;
chaos_y_test=load(sprintf('%s/chaos.mat',data_path)).y_test;

t=dt:dt:t_pred_end;
res=Delay_NN(dt,t_pred_end,X1(:,1),neuralOdeParameters);
y_pred=[0.3,res];

figure(1)
plot(t_test,y_test,'b-');
hold on;
plot(t(2:100:end),y_pred(1:100:end),'ro');
xline(10);
grid on;
xlabel('t','FontSize',16);
ylabel('x(t)','FontSize',16);
legend('Ground Truth','Predicted results');

tau=1;
begin=tau/dt;

figure(2)
plot(y_test(1:end-begin),y_test(begin+1:end),'b-')
xlabel('x(t-\tau)','FontSize',16);
ylabel('x(t)','FontSize',16);
title('Ground Truth','FontSize',16);
xlim([0.3,1.4]);
ylim([0.3,1.4]);
grid on;

figure(3)
plot(y_pred(1:end-begin),y_pred(begin+1:end),'r-');
xlabel('x(t-\tau)','FontSize',16);
ylabel('x(t)','FontSize',16);
title('Predicted Results','FontSize',16);
xlim([0.3,1.4]);
ylim([0.3,1.4]);
grid on;

figure(4)
plot(chaos_y_test(1:end-begin),chaos_y_test(begin+1:end),'b-');
xlabel('x(t-\tau)','FontSize',16);
ylabel('x(t)','FontSize',16);
title('Ground Truth','FontSize',16);
xlim([0.3,1.4]);
ylim([0.3,1.4]);
grid on;

t_pred_end2=100;
t2=dt:dt:t_pred_end2;
res2=Delay_NN(dt,t_pred_end2,X1(:,1),neuralOdeParameters);
y_pred2=[0.3,res2];
figure(5)
plot(y_pred2(1:end-begin),y_pred2(begin+1:end),'r-');
xlabel('x(t-\tau)','FontSize',16);
ylabel('x(t)','FontSize',16);
title('Predicted Results','FontSize',16);
xlim([0.3,1.4]);
ylim([0.3,1.4]);
grid on;


