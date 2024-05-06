function jq = jq(d,j)
%本函数对于给定的维数d和指标j生成对应的jq
%j=d*jq+jr,where jr={mod(j,d), if mod(j,d) is not zero; d, otherwise}
if mod(j,d)~=0
    jr=mod(j,d);
else 
    jr=d;
end
jq=(j-jr)/d;