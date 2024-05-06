function GammaN=generate_gammaN(d,N,tau,L,B,C)
%本函数在相空间维数为d，Koornwinder逼近阶数为N情形下，对线性部分矩阵GammaN进行生成，其维数为Nd*Nd
%\left[\Gamma_N(\tau)\right]_{j, n}=\frac{1}{\left\|\mathcal{K}_{j_q}\right\|_{\mathcal{E}}^2}\left[\frac{2}{\tau}\left[P_N\right]_{j, n}+L_{j_r, n_r}+K_{n_q}(-1) B_{j_r, n_r}+\tau\left(2 \delta_{n_q, 0}-1\right) C_{j_r, n_r}\right]
GammaN=zeros(N*d);
PN=generate_pN(d,N);
for j=1:N*d
    for n=1:N*d
        jq1=jq(d,j);jr1=jr(d,j);nq1=jq(d,n);nr1=jr(d,n);
        GammaN(j,n)=GammaN(j,n)+1/K_norm(jq1)^2*(2/tau*PN(j,n)+L(jr1,nr1)+koornwinder(nq1,-1)*B(jr1,nr1)+tau*(2*(nq1==0)-1)*C(jr1,nr1));
    end
end

