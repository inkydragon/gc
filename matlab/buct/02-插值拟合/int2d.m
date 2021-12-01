clear
[x0,y0]=meshgrid(-3:0.2:3,-2:0.4:2);
z0=(x0.^2-x0).*exp(-x0.^2-y0.^2-x0.*y0);
surf(x0,y0,z0),axis([-3,3,-2,2,-0.7,2])
pause

[x,y]=meshgrid(-3:0.1 :3,-2:0.1:2);
%z = interp2(x0,y0,z0,x,y),
%z = interp2(x0,y0,z0,x,y,'cubic'),
z = interp2(x0,y0,z0,x,y,'spline');
surf(x,y,z),axis([-3,3,-2,2,-0.7,2]),
title('2-dimensional interpolation')
