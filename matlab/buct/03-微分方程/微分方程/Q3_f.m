%% Q3_f
% didt =  lambda*s*i - mu*i
% dsdt = -lambda*s*i + 0.1
% i=y(1)
% s=y(2)
function dydt=Q3_f(t,y)
lambda=0.5; mu=0.1;
dydt=[
    lambda*y(2)*y(1)-mu*y(1),
    -lambda*y(2)*y(1)+0.1
    ];