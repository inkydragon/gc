h=pi/20;
x=0:h:pi/2;
y=sin(x);
z1=sum(y(1:10))*h,
z2=sum(y(2:11))*h,
%z=cumsum(y);
%z11=z(10)*h,
%z12=(z(11)-z(1))*h,
z3=trapz(y)*h,

%%integrate x^2 over [1,3]
x1=1:0.1:3;
y1=x1.^2;
z4=trapz(xint1,y1)