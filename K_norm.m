function norm=K_norm(n)
%该函数生成n阶Koornwinder多项式的（带点质量测度下的）模
%输入参数为非负整数n
norm=sqrt((n^2+1)*((n+1)^2+1)/(2*n+1));