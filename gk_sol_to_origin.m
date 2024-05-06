function x = gk_sol_to_origin(dim,y)
%GK_SOL_TO_ORIGIN 将Galerkin近似方程的解整理后化为原方程的解
%注意本函数的输入y以不同的列作为不同的分量，以不同的行表示不同的时间节点；但输出x恰好相反，每行为一分量，不同的列表示不同时间
tmp=size(y);
x=zeros(dim,tmp(1));
for j=1:tmp(1)
    for k=1:tmp(2)
        x(jr(dim,k),j)=x(jr(dim,k),j)+y(j,k);
    end
end
end

