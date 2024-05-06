function y = vec_re_koorn_approx(t,x,dim,N)
%此函数计算用前N个tau尺度化Koornwinder多项式（即K_0,...,K_N-1）逼近[-tau,0]上的函数x所得到的系数
%输入为时间向量t，对应函数值向量x，多项式个数N
%输出为系数向量
y=zeros(1,N*dim);

nq_list_v=(1:N)-1;
nr_list_v=1:dim;
nq_list=reshape(repmat(nq_list_v,dim,1),1,N*dim);
nr_list=repmat(nr_list_v,1,N);

for n=1:N*dim
    nq=nq_list(n);nr=nr_list(n);
    y(n)=in_pr_koorn(t,x(nr,:),nq)/K_norm(nq)^2;
end
