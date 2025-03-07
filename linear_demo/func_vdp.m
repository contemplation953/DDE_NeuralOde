function dG = func_vdp(dim,N,alpha1,alpha2,dy)
%FUNC_VDP 此处显示有关此函数的摘要
%   此处显示详细说明
dG=zeros(N*dim,1);
tmp=zeros(dim,1);
for j=1:N*dim
    jq1=jq(dim,j); jr1=jr(dim,j);
    tmp(jr1)=tmp(jr1)+dy(dim*jq1+jr1);
end
tmp2=func_F(alpha1,alpha2,tmp);
for j=1:N*dim
    jq1=jq(dim,j); jr1=jr(dim,j);
    dG(j)=1/K_norm(jq1)^2*tmp2(jr1);
end