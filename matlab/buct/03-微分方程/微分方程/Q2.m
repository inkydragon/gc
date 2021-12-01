%% Q2
clear
ts=0:0.01:50;
y0=[0,1];

[x,y]=ode45('Q2_f',ts,y0);
plot(x,y,'r -')
xlabel('x(t)')
ylabel('y(t)')
title('phase of equation')