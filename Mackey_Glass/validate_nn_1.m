clc;clear;close all;
demo_index=1;

dt=1e-3;
t_learn_end=10;
t_pred_end = 30;
t_learn = dt:dt:t_learn_end;
t_pred = t_learn_end+dt:dt:30;

data_path=sprintf('%s/Mackey_Glass/data',pwd);
res_path=sprintf('%s/Mackey_Glass/res',pwd);

X1=load(sprintf('%s/mg_origin_%d_kw.mat',data_path,demo_index)).X1;
t_test=load(sprintf('%s/mg_origin_%d.mat',data_path,demo_index)).t_test;
y_test=load(sprintf('%s/mg_origin_%d.mat',data_path,demo_index)).y_test;

x0_learn = X1(:,1);
x0_pred = X1(:,end);


neuralOdeParameters=load(sprintf('%s/neuralOdeParameters_%d.mat',data_path,demo_index)).neuralOdeParameters;
y_learn = dlode45(@odeModel,t_learn,dlarray(x0_learn),neuralOdeParameters,DataFormat="CB");
y_pred= dlode45(@odeModel,t_pred,dlarray(x0_pred),neuralOdeParameters,DataFormat="CB");

y_learn_to_origin=sum(y_learn(:,:));
y_pred_to_origin=sum(y_pred(:,:));


step=800;
plot(t_test,y_test,'b-','LineWidth',1)
hold on;
plot(t_learn(2:step:end),y_learn_to_origin(1:step:end),'ro');
grid on;
plot(t_pred(2:2*step:end),y_pred_to_origin(1:2*step:end),'ko');
xline(t_learn_end,'r--','LineWidth',2);
xlabel('t','FontSize',16);
ylabel('x(t)','FontSize',16);

hold on;
plot(0,y_learn_to_origin(1),'rO','LineWidth',5)
hold on;
plot(t_learn_end,y_pred_to_origin(1),'kO','LineWidth',5)

p_x = [0 t_learn_end t_learn_end 0];
p_y = [0.2 0.2 1.3 1.3];
patch(p_x,p_y,[108,137,3]/256,'FaceAlpha',0.2,'EdgeColor','none');
hold on

p_x = [t_learn_end t_pred_end t_pred_end t_learn_end];
p_y = [0.2 0.2 1.3 1.3];
patch(p_x,p_y,[43,105,10]/256,'FaceAlpha',0.2,'EdgeColor','none');

ylim([0.2,1.3]);
legend('Ground Truth','Predicted results I','Predicted results II');
saveas(gcf, sprintf('%s/tau_%d.png',res_path,demo_index));


function y = odeModel(~,y,theta)

    y = tanh(theta.fc1.Weights*y + theta.fc1.Bias);
    y = tanh(theta.fc2.Weights*y + theta.fc2.Bias);
    y = theta.fc3.Weights*y + theta.fc3.Bias;

end