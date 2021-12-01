%% Q3
% i=y(1)
% s=y(2)
ts=0:0.01:200;

[t,y]=ode45('Q3_f',ts,[0.01,0]);
subplot(3,3,1),plot(t,y(:,1),'r -'),xlabel('t'),ylabel('i(t)');
subplot(3,3,2),plot(t,y(:,2),'r -'),xlabel('t'),ylabel('s(t)');
title('phase of equation {i(0)=0.05,s(0)=0}')
subplot(3,3,3),plot3(t,y(:,1),y(:,2),'r -'),xlabel('t'),ylabel('i(t)'),zlabel('s(t)');


[t2,y2]=ode45('Q3_f',ts,[0.02,0.01]);
subplot(3,3,4),plot(t2,y2(:,1),'r -'),xlabel('t'),ylabel('i(t)');
subplot(3,3,5),plot(t2,y2(:,2),'r -'),xlabel('t'),ylabel('s(t)');
title('phase of equation {i(0)=0.02,s(0)=0.05}')
subplot(3,3,6),plot3(t2,y2(:,1),y2(:,2),'r -'),xlabel('t'),ylabel('i(t)'),zlabel('s(t)');


[t3,y3]=ode45('Q3_f',ts,[0,0.01]);
subplot(3,3,7),plot(t3,y3(:,1),'r -'),xlabel('t'),ylabel('i(t)');
subplot(3,3,8),plot(t3,y3(:,2),'r -'),xlabel('t'),ylabel('s(t)');
title('phase of equation {i(0)=0,s(0)=0.01}')
subplot(3,3,9),plot3(t3,y3(:,1),y3(:,2),'r -'),xlabel('t'),ylabel('i(t)'),zlabel('s(t)');
