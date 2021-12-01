%% 牛顿切线法
function [xm,i]=newton1(fun,dfun,x0,n,tol)
x(1)=x0;
c=1;
i=1;
while(abs(c)>tol*x(i))
    x(i+1)=x(i)-fun(x(i))/dfun(x(i));
    c=x(i+1)-x(i);
    i=i+1;
    if(i>n)
        error('n is full');
        return;
    end
end
xm=x(i);