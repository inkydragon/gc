%% Q1
h=2/20;
x=1:h:3;
y1=exp(-3.*x).*sin(2.*x);
trapz1=trapz(x,y1)*h
quad1=quad('Q1_f1',1,3)

h2=pi/20;
t=0:h2:pi/2;
y2=7782.5^2.*sin(t).^2+7721.5^2.*cos(t).^2;
trapz2=4*trapz(t,y2)*h2
quad2=4*quad('Q1_f2',1,3)
