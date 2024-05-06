function p = in_pr_koorn(t,x,n)
%此函数将[-tau,0]上的函数与第n个tau尺度化Koornwinder多项式作内积
%输入为时间向量t，对应函数值向量x，
%输出为积分值
tau=t(end)-t(1);
re_koo=rescaled_koornwinder(tau,n,t);
p=0;
for k=1:length(t)-1
    p=p+(t(k+1)-t(k))*re_koo(k)*x(k);
end
p=1/tau*p;
p=p+x(end);