clc;clear

demo_index=3;

dt=1e-3;
t_test_end=100;

data_path=sprintf('%s/Mackey_Glass/data',pwd);
chaos_t_test=load(sprintf('%s/chaos.mat',data_path)).t_test;
chaos_y_test=load(sprintf('%s/chaos.mat',data_path)).y_test;

neuralOdeParameters=load(sprintf('%s/neuralOdeParameters_%d.mat',data_path,3)).neuralOdeParameters;
X1=load(sprintf('%s/mg_origin_%d_kw.mat',data_path,demo_index)).X1;
res=Delay_NN(dt,t_test_end,X1(:,1),neuralOdeParameters);

y_pred=[0.3,res];

chaos_y_test=chaos_y_test(20/dt:end);
y_pred=y_pred(20/dt:end);

x=chaos_y_test;
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

plot(freq,pow2db(psdx),'LineWidth',4)
hold on;

x=y_pred;
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

plot(freq,pow2db(psdx),'LineWidth',4)

grid on
xlabel("Frequency (Hz)",'FontSize',16)
ylabel("Power/Frequency (dB/Hz)",'FontSize',16)
legend("Ground Truth","Predicted Results");
