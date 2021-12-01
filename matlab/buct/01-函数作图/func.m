%% 等高线投影
clear;

x = -3:0.5:3;
y = -4:0.5:4;
[X,Y] = meshgrid(x,y);
Z = X.^2+X.*Y.^2;

subplot(1,3,1),meshc(X,Y,Z)
subplot(1,3,2),surfc(X,Y,Z)
subplot(1,3,3),contour(X,Y,Z,16)