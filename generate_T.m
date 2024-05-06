function T=generate_T(n)
%该函数生成Tx=b中的n阶方阵T
%输入参数为自然数n
%输出为n阶方阵T

T=zeros(n);
for i=0:n-1
   for j=0:n-1
       if j<i
           T(i+1,j+1)=0;
       else 
           if j==i
               T(i+1,j+1)=i^2+1;
           else
               T(i+1,j+1)=-(2*i+1);
           end
       end
   end
end