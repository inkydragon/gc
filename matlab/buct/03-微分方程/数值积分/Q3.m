%% Q3
t = [1900 1910 1920  1930  1940  1950  1960  1970  1980  1990];
p = [76.0 92.0 106.5 123.2 131.7 150.7 179.3 204.0 226.5 251.4];

logp=log(p);
r(1) = (-3*logp(1)+4*logp(2)-logp(4))/20/logp(1);
r(10) = (logp(8)-4*logp(9)+3*logp(10))/20/logp(10);
for k = 2:1:9
    r(k) = (logp(k+1)-logp(k-1))/20/logp(k);
end
ans = polyfit(t,logp,1);
r=ans(2)
x_m=-r/ans(1)