%% 
%% 分段线性插值
% clear,
% x0=[1790 1800 1810 1820 1830 1840 1850 1860 1870 1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980 1990];
% y0=[3.9 5.3 7.2 9.6 12.9 17.1 23.2 31.4 38.6 50.2 62.9 76.0 92.0 106.5 123.2 131.7 150.7 179.3 204.0 226.5 251.4];
% x_int=1790:5:1990;
% 
% x_1=interp1(x0, y0, x_int);
% plot(x0,y0,'r +',x_int,x_1,'b -'),
% title('分段线性插值')
%% 拉格朗日多项式插值
% clear
% x0 = [0 3 5 7 9 11 12 13 14 15];
% y0 = [0 1.2 1.7 2.0 2.1 2.0 1.8 1.2 1.0 1.6];
% x  = 0:0.1:15;
% y2 = lagr1(x0,y0,x);          %% 自定义函数  需复制lagr1.m到运行目录下
% plot(x0,y0,'r +',x,y2,'b :');
% title('Largrange interpolation');
%% 样条差值
% clear
% x0=[20.5 32.5 51 73 95.7];
% y0=[765 826 873 942 1032];
% x=20:1:100;
% y3=spline(x0,y0,x)
% plot(x0,y0,'r +',x,y3,'b :'),
% title('Spline interpolation')
%% 二元插值
% clear
% [x0,y0]=meshgrid(-3:0.2:3,-2:0.2:2);
% z0=(x0.^2-x0).*exp(-x0.^2-y0.^2-x0.*y0);
% [x,y]=meshgrid([-3:0.1:3],-2:0.1:2);
% %z = interp2(x0,y0,z0,x,y),
% %z = interp2(x0,y0,z0,x,y,'cubic'),
% z = interp2(x0,y0,z0,x,y,'spline'),
% surf(x0,y0,z0),pause
% surf(x,y,z);
% title('2-dimensional interpolation')