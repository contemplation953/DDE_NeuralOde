function u=rescaled_koornwinder(tau,n,t)
%该函数生成n阶重尺度化Koornwinder多项式在t处的值
%输入参数为尺度参数（时滞）tau、非负整数n和向量t
%x中元素的取值范围为[-tau,0]
%输出为向量Kn(x)
z=1+t*2/tau; 
T=length(z);
if n==0
    for i=1:T
        y(i)=1;
    end
else
    for i=1:T
        tmp=(n^2+1)*legendre(n,z(i));
        y(i)=tmp(1);
        for j=0:n-1
            tmp=(2*j+1)*legendre(j,z(i));
            y(i)=y(i)-tmp(1);
        end
    end
end
u=y;