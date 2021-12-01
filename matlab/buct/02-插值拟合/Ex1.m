%% Ex1
clear,
t0=[0 0.5 1.0 1.5 2.0 2.5 3.0];
y0=[0 0.4794  0.8415  0.9975  0.9093  0.5985  0.1411];
t=0:0.1:3;

y2=spline(t0,y0,t);
subplot(1,2,1),plot(t0,y0,'r +',t,y2,'b -'),
title('样条插值')
aa= polyfit(t,y2,4);
F=polyval(aa,t);
subplot(1,2,2),plot(t0,y0,'r +',t, F, 'b -')
xlabel('t'),ylabel('y')
legend('原始数据点','多项式拟合曲线')

F_2=polyval(aa,2.25)