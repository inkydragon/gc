%% Q3 三维组图1-3  参数作图3
clear,
% 1
x1 = -5:0.5:5;
y1 = -5:0.5:5;
[X1,Y1] = meshgrid(x1,y1);
Z1 = sin(X1).*sin(Y1);
subplot(1,3,1),surf(X1,Y1,Z1)
title('z=sin(x)*cos(x)')

% 2
x2 = -5:0.5:5;
y2 = -5:0.5:5;
[X2,Y2] = meshgrid(x2,y2);
Z2 = 3.*Y2./(X2.^2+Y2.^2);
subplot(1,3,2),surf(X2,Y2,Z2)
title('z=3*y/(x^2+y^2)')

% (2)
u = 0:0.5:5;
v = 0:0.1*pi:2*pi;
[U,V] = meshgrid(u,v);
X = (2+0.2.*cos(U)).*cos(V);
Y = (2+0.2.*cos(U)).*sin(V);
Z = 0.2.*sin(V);
subplot(1,3,3),mesh(X,Y,Z)
title('参数作图')
