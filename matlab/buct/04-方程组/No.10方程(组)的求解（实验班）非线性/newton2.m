%% 牛顿割线法
function [xm,i]=newton2(fun,x01,x02,n,eps)
x(1)=x01;x(2)=x02;
b=1;
i=2;
while(abs(b)>eps*abs(x(i)))
    x(i+1)=x(i)-fun(x(i))*(x(i)-x(i-1))/(fun(x(i))-fun(x(i-1)));
    b=x(i+1)-x(i);
    i=i+1;
    if(i>n)
        error('n is full');
        return;
    end   
end
xm=x(i);