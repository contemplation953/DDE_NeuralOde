clc;clear;close all;


dt=1e-2;
t_pred_end=134;
t_pred=dt:dt:t_pred_end;

data_path=sprintf('%s/Zn/data',pwd);
res_path=sprintf('%s/Zn/res',pwd);

X=load(sprintf('%s/Zn_kw.mat',data_path)).X;
x_test=load(sprintf('%s/origin_data.mat',data_path)).x;
y_test=load(sprintf('%s/origin_data.mat',data_path)).y;

sgf_x_min=load(sprintf('%s/Zn_kw.mat',data_path)).sgf_x_min;
sgf_y_min=load(sprintf('%s/Zn_kw.mat',data_path)).sgf_y_min;


x0=X(:,1);

neuralOdeParameters=load(sprintf('%s/neuralOdeParameters.mat',data_path)).neuralOdeParameters;
y_pred= dlode45(@odeModel,t_pred,dlarray(x0),neuralOdeParameters,DataFormat="CB");

KW_N=4;

y_pred = extractdata(y_pred(:,1,:));
y_pred = reshape(y_pred,size(y_pred,1),size(y_pred,3));

y_pred_2_org1=sum(y_pred(KW_N*(1-1)+1:KW_N*1,:));
y_pred_2_org1=[sum(x0(1:4)),y_pred_2_org1];
y_pred_2_org1=sgf_x_min*y_pred_2_org1;

y_pred_2_org2=sum(y_pred(KW_N*(2-1)+1:KW_N*2,:));
y_pred_2_org2=[sum(x0(5:8)),y_pred_2_org2];
y_pred_2_org2=sgf_y_min*y_pred_2_org2;


learn_begin_index=30*60;
learn_end_index=((length(x_test)-10))*5*60+1;

%预测数据对应时间 s
t_org=t_pred/dt+1800;

%实验数据对应的时间 s
t_exp=(1:length(x_test))*300;

figure(1);

plot(t_exp,x_test,'r+',t_org,y_pred_2_org1,"r-");
hold on;
plot(t_exp,y_test,'b+',t_org,y_pred_2_org2,"b-")
hold on;
plot(t_org(1),y_pred_2_org1(1),'rO','LineWidth',5)
hold on;
plot(t_org(1),y_pred_2_org2(1),'bO','LineWidth',5)
hold on;

xline(learn_end_index,'r--','LineWidth',2);
xlabel("t (s)",'FontSize',16)
ylabel("GFP",'FontSize',16)
grid on;

p_x = [0 learn_end_index learn_end_index 0];
p_y = [0 0 5e4 5e4 ];
patch(p_x,p_y,[108,137,3]/256,'FaceAlpha',0.2,'EdgeColor','none');
hold on
p_x = [learn_end_index 1.6e4 1.6e4  learn_end_index];
p_y = [0 0 5e4 5e4 ];
patch(p_x,p_y,[43,105,10]/256,'FaceAlpha',0.2,'EdgeColor','none');

legend('Experimental of x(t)','Predicted results of x(t)','Experimental of y(t)','Predicted results of y(t)','Location','northwest');

validate_num=10;
x_pre=x_test(end-10+1:end);
y_pre=y_test(end-10+1:end);

t=t_exp-1800;
t=t(end-10+1:end);
x_validate=y_pred_2_org1(t);
y_validate=y_pred_2_org2(t);
error=[(x_pre'-x_validate)./x_pre';(y_pre'-y_validate)./y_pre'];
error=max(max(abs(error)));

function y = odeModel(~,y,theta)

    y = tanh(theta.fc1.Weights*y + theta.fc1.Bias);
    y = tanh(theta.fc2.Weights*y + theta.fc2.Bias);
    y = theta.fc3.Weights*y + theta.fc3.Bias;

end
