clear;
t = [1900  1910 1920   1930  1940  1950 1960   1970  1980];
p = [76.0  92.0 106.5 123.2 131.7 150.7 179.3 204.0 226.5];
plot(t,p,'b*')
pause

p1 = log(p);
aa = polyfit(t,p1,1)
y = polyval(aa,t);
plot(t,log(p),'b *', t,y, 'g -')
pause

r(1) = (-3*p(1)+4*p(2)-p(4))/20/p(1);
r(9) = (p(7)-4*p(8)+3*p(9))/20/p(9);
for k = 2:1:8
    r(k) = (p(k+1)-p(k-1))/2/p(k);
end
r
r1 = sum(r)/9
plot(t(2:8),r(2:8),'r +')
pause

bb = polyfit(p,r,1);
r2 = bb(2)