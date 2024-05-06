clc;clear;close all;

demo_index=1;

dt=1e-2;
t_learn_end = 400;
t_pred_end = 800;
t_learn = dt:dt:t_learn_end;
t_pred = t_learn_end+dt:dt:t_pred_end;

data_path=sprintf('%s/Goodwin/data',pwd);
res_path=sprintf('%s/Goodwin/res',pwd);

X1=load(sprintf('%s/gd_%d_kw.mat',data_path,demo_index)).X1;
t_test=load(sprintf('%s/gd_origin_%d.mat',data_path,demo_index)).t_test;
y_test=load(sprintf('%s/gd_origin_%d.mat',data_path,demo_index)).y_test;

weight_v=max(y_test,[],2)-min(y_test,[],2);
weight_v=round(1./weight_v,2);

x0_learn = X1(:,1);
x0_pred = X1(:,end);


neuralOdeParameters=load(sprintf('%s/neuralOdeParameters_%d.mat',data_path,demo_index)).neuralOdeParameters;
y_learn = dlode45(@odeModel,t_learn,dlarray(x0_learn),neuralOdeParameters,DataFormat="CB");
y_pred= dlode45(@odeModel,t_pred,dlarray(x0_pred),neuralOdeParameters,DataFormat="CB");

KW_N=4;

y_learn = extractdata(y_learn(:,1,:));
y_learn = reshape(y_learn,size(y_learn,1),size(y_learn,3));
y_pred = extractdata(y_pred(:,1,:));
y_pred = reshape(y_pred,size(y_pred,1),size(y_pred,3));

y_learn_2_org1=sum(y_learn(KW_N*(1-1)+1:KW_N*1,:));
y_learn_2_org2=sum(y_learn(KW_N*(2-1)+1:KW_N*2,:));
y_learn_2_org3=sum(y_learn(KW_N*(3-1)+1:KW_N*3,:));

y_pred_2_org1=sum(y_pred(KW_N*(1-1)+1:KW_N*1,:));
y_pred_2_org2=sum(y_pred(KW_N*(2-1)+1:KW_N*2,:));
y_pred_2_org3=sum(y_pred(KW_N*(3-1)+1:KW_N*3,:));

step=100;
t_learn=(1:step:size(y_learn_2_org1,2))*dt;
t_pred=(1:step:size(y_pred_2_org1,2))*dt+t_learn_end;

figure(1);
plot(t_test,y_test(1,:),'b-',t_learn,y_learn_2_org1(1:step:end),"ro",t_pred,y_pred_2_org1(1:step:end),'ko')
hold on;
plot(0,y_test(1),'rO','LineWidth',5)
hold on;
plot(t_learn_end,y_pred_2_org1(1),'kO','LineWidth',5)
xline(t_learn_end,'r--','LineWidth',2);
xlabel("t",'FontSize',16)
ylabel("x(t)",'FontSize',16)

p_x = [0 t_learn_end t_learn_end 0];
p_y = [0 0 0.3 0.3];
patch(p_x,p_y,[108,137,3]/256,'FaceAlpha',0.2,'EdgeColor','none');
hold on
p_x = [t_learn_end t_pred_end t_pred_end t_learn_end];
p_y = [0 0 0.3 0.3];
patch(p_x,p_y,[43,105,10]/256,'FaceAlpha',0.2,'EdgeColor','none');
legend('Ground Truth','Predicted results I','Predicted results II');


figure(2);
plot(t_test,y_test(2,:),'b-',t_learn,y_learn_2_org2(1:step:end),"ro",t_pred,y_pred_2_org2(1:step:end),'ko');
hold on;
hold on;
plot(0,y_test(1),'rO','LineWidth',5)
hold on;
plot(t_learn_end,y_pred_2_org2(1),'kO','LineWidth',5)
xline(t_learn_end,'r--','LineWidth',2);
xlabel("t",'FontSize',16)
ylabel("y(t)",'FontSize',16)

p_x = [0 t_learn_end t_learn_end 0];
p_y = [0 0 1.2 1.2];
patch(p_x,p_y,[108,137,3]/256,'FaceAlpha',0.2,'EdgeColor','none');
hold on
p_x = [t_learn_end t_pred_end t_pred_end t_learn_end];
p_y = [0 0 1.2 1.2];
patch(p_x,p_y,[43,105,10]/256,'FaceAlpha',0.2,'EdgeColor','none');
legend('Ground Truth','Predicted results I','Predicted results II');

figure(3);
plot(t_test,y_test(3,:),'b-',t_learn,y_learn_2_org3(1:step:end),"ro",t_pred,y_pred_2_org3(1:step:end),'ko');
hold on;
plot(0,y_test(1),'rO','LineWidth',5)
hold on;
plot(t_learn_end,y_pred_2_org3(1),'kO','LineWidth',5)
xline(t_learn_end,'r--','LineWidth',2);
xlabel("t",'FontSize',16)
ylabel("z(t)",'FontSize',16)

p_x = [0 t_learn_end t_learn_end 0];
p_y = [0 0 2.5 2.5];
patch(p_x,p_y,[108,137,3]/256,'FaceAlpha',0.2,'EdgeColor','none');
hold on
p_x = [t_learn_end t_pred_end t_pred_end t_learn_end];
p_y = [0 0 2.5 2.5];
patch(p_x,p_y,[43,105,10]/256,'FaceAlpha',0.2,'EdgeColor','none');
legend('Ground Truth','Predicted results I','Predicted results II');

function y = odeModel(~,y,theta)

    y = tanh(theta.fc1.Weights*y + theta.fc1.Bias);
    y = tanh(theta.fc2.Weights*y + theta.fc2.Bias);
    y = theta.fc3.Weights*y + theta.fc3.Bias;

end
