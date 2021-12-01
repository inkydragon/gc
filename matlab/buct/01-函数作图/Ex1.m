%% 分段函数的短路求值
clear,
x=-4:0.25:4;y=-4:0.25:4;
[X,Y] = meshgrid(x,y);

Z=(X+Y-1).*(X+Y>1)+exp(X+Y-1).*((X+Y)>-1&(X+Y)<=1)+exp(2*X+Y).*((X+Y)<=-1);
Z2=exp(X+Y-1).*((X+Y)>-1&(X+Y)<=1);
Z3=exp(2*X+Y).*((X+Y)<=-1);

subplot(1,3,1),surf(X,Y,Z);
subplot(1,3,2),surf(X,Y,Z2);axis([-5 5 -5 5 0 8])
subplot(1,3,3),surf(X,Y,Z3);

