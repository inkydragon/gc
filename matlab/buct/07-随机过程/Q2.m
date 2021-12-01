%% Q2
clear;
num=500;
lamuda=2;
num_end=10;
% If m == positive integer
% 	  returns factorial(m)
% If m == 0
%     returns 1
% If m == (real or complex) floating-point number
%     returns gamma(m+1)
% ――Maple_factorial()
f=@(x)power(lamuda,x).*exp(-lamuda)./gamma(x+1);
f_max=0.2879811366;

A=rand(num,1);
Y=A.*num_end;
B=rand(num,1);
ff=f(Y)./f_max;

i=1;
while(i<=num)
    if any(B(i) < ff(i))
        zeta(i) = Y(i);
    else
        zeta(i) = NaN; 
    end
i=i+1;
end
%plot(A,ff,'r *',A,zeta,'b .')

x=Y;
y=ff;

figure
histogram(zeta)
hold on
scale = (num/10)/max(y);
plot((x),(y.*scale),'r .')
hold off
