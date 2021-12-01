%% 参数绘制 三维曲线or曲面图
clear,
u = 0:0.5:5;
v = 0:0.1*pi:2*pi;
[U,V] = meshgrid(u,v);

%% 参数作图
X = U.*sin(V);
Y = U.*cos(V);
Z = 0.5*U;
subplot(1,2,1),mesh(X,Y,Z)
title('参数作图')

%% 直接作图
x = -5:0.5:5;
y = -5:0.5:5;
[X,Y] = meshgrid(x,y);
Z = 0.5*sqrt(X.^2+Y.^2);
subplot(1,2,2),mesh(X,Y,Z)
title('z=1/2*(x^2+y^2)^(1/2)')

