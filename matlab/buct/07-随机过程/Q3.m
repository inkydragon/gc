%% Q3
clear;
num=500;
f=@(x)60.*power(x,3).*power((1-x),2);
c=2.0736;

A=rand(num,1);
B=rand(num,1);
ff=f(A)./c;
i=1;
while(i<=num)
    if any(B(i) < ff(i))
        zeta(i) = A(i);
    else
        zeta(i) = NaN; 
    end
i=i+1;
end
%plot(A,ff,'r *',A,zeta,'b .')

x=A;
y=ff;

figure
histogram(zeta)
hold on
scale = (num/10)/max(y);
plot((x),(y.*scale),'r .')
hold off