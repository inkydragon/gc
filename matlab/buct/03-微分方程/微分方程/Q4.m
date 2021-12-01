clear
ts=0:0.01:200;
y0=[0.0;0.0; 1.0e-8];
[t,y]=ode45('Q4_Lorenz',ts,y0);

subplot(1,3,1),plot(y(:,2),y(:,1),'r -'),grid
xlabel('x(t)')
ylabel('y(t)')
title('x-y相图')

subplot(1,3,2),plot(y(:,1),y(:,3),'b -'),grid
xlabel('x(t)')
ylabel('z(t)')
title('x-z相图')

subplot(1,3,3),plot3(y(:,1),y(:,2), y(:,3),'b -'),grid
xlabel('x(t)')
ylabel('y(t)')
zlabel('z(t)')
title('x-y-z三维相图')