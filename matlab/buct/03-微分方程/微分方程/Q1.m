%% Q1
ts=0:0.01:20;
y0=1;

[x,y]=ode23('Q1_f',ts,y0);
plot(x,y,'r -')
xlabel('x(t)')
ylabel('y(t)')
title('phase of equation dy/dx=x^2+y^2')