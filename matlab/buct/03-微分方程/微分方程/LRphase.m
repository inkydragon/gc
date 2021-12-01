ts=0:0.01:200;
x0=[0.0;0.0; 1.0e-8];

%%%%%     solve the initial problem
[t,x]=ode45('LR',ts,x0);

%%%%  plot the curve of the solution
plot(x(:,2),x(:,1),'r -')
xlabel('x(t)')
ylabel('y(t)')
title('phase of Lorenz equation')
pause

plot(x(:,1),x(:,3),'b -')
xlabel('x(t)')
ylabel('z(t)')
title('phase of Lorenz equation')
pause

plot3(x(:,1),x(:,2), x(:,3),'b -')
xlabel('x(t)')
ylabel('y(t)')
zlabel('z(t)')
title('phase of Lorenz equation')