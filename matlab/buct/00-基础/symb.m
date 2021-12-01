%%  函数与极限
clear;

syms a b x;
f = b^2*sin(a*x)/x;
L = limit(f,x,0,'left')

L1 = limit(exp(x),-inf)

g = (1+1/x)^x;
a1 = limit(g,x,inf)
a2 = limit(g,x,0)

%% 导数和积分
d1 = diff(f,x)
d2 = diff(diff(f,x),a)
d3 = diff(f,x,3)

I1 = int(x*exp(x),x)
ID = int(x*log(x),x,0,1)

%%  幂级数
x0_3 = taylor(exp(x),x,0,'Order', 3)    %%% 在x=0处3阶展开
x1_3 = taylor(exp(x),x,1,'Order', 3)    %%% 在x=1处3阶展开
