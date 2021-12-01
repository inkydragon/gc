%% Ex1
clear
ts=0:1:50;
x0=[10 8];

[x,y]=ode45('exf',ts,x0);
plot(x,y,'r -'),xlabel('x1(t)'),ylabel('x2(t)'),
title('x1-x2相图')