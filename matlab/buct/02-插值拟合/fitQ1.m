%% Q4 多项式拟合
clear
x=[1 2 4 7 9 12 13 15 17];
F=[1.5 3.9 6.6 11.7 15.6 18.8 19.6 20.6 21.1];

aa= polyfit(x,F,5);
y=polyval(aa,x);
plot(x,F,'r +',x, y, 'b -')
xlabel('x'),ylabel('F')
legend('原始数据点','拟合曲线')

F_16=polyval(aa,16)