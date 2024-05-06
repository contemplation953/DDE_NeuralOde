function PN = generate_pN(d,N)
%本函数在相空间维数为d，Koornwinder逼近阶数为N情形下，对中间变量PN进行生成，其维数为Nd*Nd
%\left[P_N\right]_{j, n}=\left(\sum_{k=0}^{n_q-1} a_{n_q, k}\left(\delta_{j_q, k}\left\|\mathcal{K}_{j_q}\right\|_{\mathcal{E}}^2-1\right)\right) \delta_{n_r, j_r}
PN=zeros(N*d);
for j=1:N*d
    for n=d+1:N*d
        T=generate_T(jq(d,n));
        b=generate_b(jq(d,n));
        a=T\b;
        if jr(d,n)==jr(d,j)
            for k=0:jq(d,n)-1
                PN(j,n)=PN(j,n)+a(k+1)*((jq(d,j)==k)*K_norm(jq(d,j))^2-1);
            end
        end
    end
end
