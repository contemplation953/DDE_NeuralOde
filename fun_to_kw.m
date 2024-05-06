function X1=fun_to_kw(tau,dt,x,dim,N)
    
    %此函数计算用前N个tau尺度化Koornwinder多项式（即K_0,...,K_N-1）逼近[-tau,0]上的函数x所得到的系数
    %输入为时间向量t，对应函数值向量x，多项式个数N
    %输出为系数向量
    %这个函数把所有分解的小函数写在一起，减少重复计算，提高计算效率
    
    nq_list_v=(1:N)-1;
    nr_list_v=1:dim;
    nq_list=reshape(repmat(nq_list_v,dim,1),1,N*dim);
    nr_list=repmat(nr_list_v,1,N);

    t=-tau:dt:0;
    t_len=tau/dt;

    %这个函数实际上只有n种取值，只需要算一遍即可
    re_koo_matrix=rescaled_koornwinder_matrix(tau,N,t);
    
    X1=zeros(N*dim,size(x,2)-t_len);
    for index = 1:size(x,2)-t_len
        x_index=x(:,index:index+t_len);
        y=zeros(1,N*dim);
        for n=1:N*dim
            nq=nq_list(n);nr=nr_list(n);
            y(n)=koorn(tau,re_koo_matrix(nq+1,:),t,x_index(nr,:))/K_norm(nq)^2;
        end
        
        y_coeff=zeros(N*dim,1);
        for i=1:dim
            y_coeff(N*(i-1)+1:N*i)=y(i:dim:end);
        end
        X1(:,index)=y_coeff';
    end
end

function p=koorn(tau,re_koo,t,x)
    %此函数将[-tau,0]上的函数与第n个tau尺度化Koornwinder多项式作内积
    %输入为时间向量t，对应函数值向量x，
    %输出为积分值

    %梯形法计算积分，可以更精确或者更快
    step=t(2:end)-t(1:end-1);
    p=sum(step.*re_koo(1:length(step)).*x(1:length(step)));
    p=1/tau*p;
    p=p+x(end);
end

function res=rescaled_koornwinder_matrix(tau,N,t)
    res=zeros(N,length(t));
    for i=1:N
        res(i,:)=rescaled_koornwinder(tau,i-1,t);
    end 
end