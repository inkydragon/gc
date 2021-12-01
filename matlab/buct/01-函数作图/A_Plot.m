%% 普通作图  
clear;
% % 线型     - 实线    : 点线	  -. 虚点	  -- 波折线
% %          . 圆点	 + 加号	*  星号	x x型	 o 小圆
% %--------------------------------------------------------
% % 颜色     y 黄    r 红    g 绿	b 蓝
% %          k 黑    m 紫    c 青    w 白
%% 注释和标记
% xlabel('x'),ylabel('Y')             % x,y 轴标签
% title('graphics of sin, cos')       % 图表标题
% gtext('sinx'),gtext('cosx')         % (手工)放置曲线标签(名称)
% legend('sinx','cosx')               % 图例
%% MxN 图形矩阵显示
% x1 = 1:6;y1 = 2*x1-5;
% subplot(3,1,1),plot(x1,y1),axis([1 6 1 8])
% x2 = 2:8;y2 = -x2;
% subplot(3,1,2),plot(x2,y2),axis([2 8 -8 -2])
% x3 = 2:7;y3 = sqrt(x3.^2-2);
% subplot(3,1,3),plot(x3,y3),axis([2 7 1 7])
%% Q1 Fplot精确绘图
% fplot(@(x)[tan(x),sin(x),cos(x)])
%% Q3 三维作图 surf mesh plot3+grid
%% plot3d 空间曲线曲面参数绘图 
% u = 0:0.5:5;v = 0:0.1*pi:2*pi;
% [U,V] = meshgrid(u,v);
% X = U.*sin(V);
% Y = U.*cos(V);
% Z = 0.5*U;
% subplot(1,2,1),mesh(X,Y,Z)       %% 网格曲面绘制
% t = 0:pi/15:8*pi;  
% y1 = sin(t); 
% y2 = cos(t);
% subplot(1,2,2),plot3(y1,y2,t),grid %%空间曲线绘制
%% func 等高线作图
% x = -3:0.5:3;
% y = -4:0.5:4;
% [X,Y] = meshgrid(x,y);
% Z = X.^2+X.*Y.^2;
% subplot(1,3,1),meshc(X,Y,Z)
% subplot(1,3,2),surfc(X,Y,Z)
% subplot(1,3,3),contour(X,Y,Z,16)
%% Ex1 利用逻辑表达式实现短路求值
% x=-4:0.25:4;y=-4:0.25:4;
% [X,Y] = meshgrid(x,y);
% Z=(X+Y-1).*(X+Y>1)+exp(X+Y-1).*((X+Y)>-1&(X+Y)<=1)+exp(2*X+Y).*((X+Y)<=-1);
% Z2=exp(X+Y-1).*((X+Y)>-1&(X+Y)<=1);
% Z3=exp(2*X+Y).*((X+Y)<=-1);
% subplot(1,3,1),surf(X,Y,Z);
% subplot(1,3,2),surf(X,Y,Z2);axis([-5 5 -5 5 0 8])
% subplot(1,3,3),surf(X,Y,Z3);
%% rang_eps 避免顶点缺失
% [X,Y]=meshgrid(-5:5);    
% R = sqrt(X.^2+Y.^2); 
% R2 =R++eps;             %%% +eps 避免顶点缺失
% Z = sin(R)./R;
% Z2= sin(R2)./R2;
% subplot(1,2,1),surfc(X,Y,Z);
% subplot(1,2,2),surfc(X,Y,Z2);
