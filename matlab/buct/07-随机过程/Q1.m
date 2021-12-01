%% Q1
clear;
num=200;
A=rand(num,1);
B=exp_fun(A);
%plot(B,A,'r .')
x=B;
y=A;

figure
histogram(B)
hold on
scale = 100/max(y);
plot((x),(y.*scale),'r .')
hold off