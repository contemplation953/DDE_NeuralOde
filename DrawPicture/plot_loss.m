clc;clear;
Goodwin_loss1=sqrt(load(sprintf('%s/Goodwin/data/neuralOdeParameters_%d.mat',pwd,1)).loss_list);
Goodwin_loss2=sqrt(load(sprintf('%s/Goodwin/data/neuralOdeParameters_%d.mat',pwd,2)).loss_list);
Logistic_loss1=sqrt(load(sprintf('%s/Logistic/data/neuralOdeParameters_%d.mat',pwd,1)).loss_list);
Logistic_loss2=sqrt(load(sprintf('%s/Logistic/data/neuralOdeParameters_%d.mat',pwd,2)).loss_list);
MG_loss1=sqrt(load(sprintf('%s/Mackey_Glass/data/neuralOdeParameters_%d.mat',pwd,1)).loss_list);
MG_loss2=sqrt(load(sprintf('%s/Mackey_Glass/data/neuralOdeParameters_%d.mat',pwd,2)).loss_list);
MG_loss3=sqrt(load(sprintf('%s/Mackey_Glass/data/neuralOdeParameters_%d.mat',pwd,3)).loss_list);
Zn_loss=sqrt(load(sprintf('%s/Zn/data/neuralOdeParameters.mat',pwd)).loss_list);


steps=1:1000;
figure(1)
plot(steps,log(MG_loss1),steps,log(MG_loss2),steps,log(MG_loss3))
yline(0,'LineWidth', 1.5)

xlabel('steps','FontSize',16)
ylabel('Log(RMSE)','FontSize',16)
ax = gca;
ax.FontSize = 14;
legend('Mackey Glass \tau=0.2','Mackey Glass \tau=0.5','Mackey Glass \tau=1');
grid on;
saveas(gcf, sprintf('%s/DrawPicture/MG_loss.png',pwd));

figure(2)
plot(steps,log(Goodwin_loss1),steps,log(Goodwin_loss2))
yline(0,'LineWidth', 1.5)

xlabel('steps','FontSize',16)
ylabel('Log(RMSE)','FontSize',16)
ax = gca;
ax.FontSize = 14;
legend('Goodwin parameter sets 1','Goodwin parameter sets 2');
grid on;
saveas(gcf, sprintf('%s/DrawPicture/Goodwin_loss.png',pwd));

figure(3)
plot(steps,log(Logistic_loss1),steps,log(Logistic_loss2))
yline(0,'LineWidth', 1.5)

xlabel('steps','FontSize',16)
ylabel('Log(RMSE)','FontSize',16)
ax = gca;
ax.FontSize = 14;
legend('Logistic parameter sets 1','Logistic parameter sets 2');
grid on;
saveas(gcf, sprintf('%s/DrawPicture/Logistic_loss.png',pwd));

figure(4)
plot(steps,log(Zn_loss))
yline(0,'LineWidth', 1.5)

xlabel('steps','FontSize',16)
ylabel('Log(RMSE)','FontSize',16)
ax = gca;
ax.FontSize = 14;
legend('Bacterium Pseudomonas aeruginosa');
plot(steps,log(Goodwin_loss1),steps,log(Goodwin_loss2))
grid on;
saveas(gcf, sprintf('%s/DrawPicture/Zn_loss.png',pwd));

figure(5)
plot(steps,log(MG_loss1),steps,log(MG_loss2),steps,log(MG_loss3),steps,log(Goodwin_loss1),steps,log(Goodwin_loss2),steps,log(Logistic_loss1),steps,log(Logistic_loss2),steps,log(Zn_loss))
yline(0,'LineWidth', 1.5)

xlabel('steps','FontSize',16)
ylabel('Log(RMSE)','FontSize',16)
ax = gca;
ax.FontSize = 14;
legend('Mackey Glass \tau=0.2','Mackey Glass \tau=0.5','Mackey Glass \tau=1','Goodwin parameter sets 1','Goodwin parameter sets 2','Logistic parameter sets 1','Logistic parameter sets 2','Bacterium Pseudomonas aeruginosa');

grid on;
saveas(gcf, sprintf('%s/DrawPicture/loss.png',pwd));

