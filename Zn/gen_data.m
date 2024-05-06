clc;clear;


%save(sprintf('%s/Zn/data/origin_data.mat',pwd),'x','y');

x=load(sprintf('%s/Zn/data/origin_data.mat',pwd)).x;
y=load(sprintf('%s/Zn/data/origin_data.mat',pwd)).y;

order=3;
framelen=11;
sgf_x=sgolayfilt(x,order,framelen);
sgf_y=sgolayfilt(y,order,framelen);

%消除量纲，为了训练NN
sgf_x_min=min(sgf_x);
sgf_y_min=min(sgf_y);

sgf_x=sgf_x/sgf_x_min;
sgf_y=sgf_y/sgf_y_min;

t=0:length(x)-1;
%插值到s
t=t*300;

t1=1:t(end);
vx1=interp1(t,sgf_x,t1,'cubic');
vy1=interp1(t,sgf_y,t1,'cubic');

figure(2);
plot(t,sgf_x,'k+',t1,vx1,'r.');
hold on;
plot(t,sgf_y,'b+',t1,vy1,'b.');

%从第30分钟,此时y开始表达,即30*60s
learn_begin_index=30*60+1;

%最后10个数据点作为测试集，即保留最后10*5*60个点
learn_end_index=t(end)-10*5*60;

x=vx1(learn_begin_index+1-100:learn_end_index);
y=vy1(learn_begin_index+1-100:learn_end_index);

tau=1;
dt=1e-2;
dim=1;
N=4;
X=fun_to_kw(tau,dt,x,dim,N); 
Y=fun_to_kw(tau,dt,y,dim,N); 

X_to_origin=sum(X);
Y_to_origin=sum(Y);

figure(3)
subplot(1,2,1);
step=100;
plot(t1(learn_begin_index-100+1:learn_end_index),x,'b-',t1(learn_begin_index+1:step:learn_end_index),X_to_origin(1:step:end),'ro');

subplot(1,2,2);
plot(t1(learn_begin_index-100+1:learn_end_index),y,'b-',t1(learn_begin_index+1:step:learn_end_index),Y_to_origin(1:step:end),'ro');

X=[X;Y];
save(sprintf('%s/Zn/data/Zn_kw.mat',pwd),'x','y','X','sgf_x_min','sgf_y_min');